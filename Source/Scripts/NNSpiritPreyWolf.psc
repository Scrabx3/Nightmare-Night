Scriptname NNSpiritPreyWolf extends Actor  
; Spirit Prey Wolves Spawn themselves with altered stats
; Content here is a mixture of my own Code, HowlsummonWolfFXSSCript & the default ghostshader script

EFFECTSHADER PROPERTY pGhostDeathFXShader AUTO
{the shader to play while dying}
float property ShaderDuration = 0.00 auto
{Duration of Effect Shader., default 0 (endless)}
Activator property pDefaultAshPileGhost auto
{The object we use as a pile.}
LEVELEDITEM PROPERTY pdefaultGhostLeveledList AUTO
SPELL[] PROPERTY pGhostAbilityNew AUTO
SPELL PROPERTY pGhostResistsAbility AUTO
float property fDelay = 0.75 auto
{time to wait before Spawning Ash Pile; default 0.75}
float property fDelayEnd = 1.65 auto
{time to wait before Removing Base Actor; default 1.65}
bool bFlash = false

VisualEffect Property SpiritPreyAbsorbEffect Auto ; Wind stuff
EffectShader Property SpiritPreyAbsorbSFX Auto ; Orange Glow - Recolored to be Blue White
Sound Property NPCDragonDeathSequenceWind Auto
GlobalVariable Property DeathCount Auto
Perk Property SpiritPreyWolfPerk Auto
int Property Level Auto Hidden
int maxLv = 5
int maxDeath = 32

EVENT onLoad()
	; add on the abilities
	; Debug.Trace("NIGHTMARE NIGHT - LEVEL " + Level + " GAINING VISUAL FX: " + pGhostAbilityNew[level])
	AddSpell(pGhostAbilityNew[level])
	AddSpell(pGhostResistsAbility)
ENDEVENT

EVENT onDYING(ACTOR killer)
	SetCriticalStage(SELF.CritStage_DisintegrateStart)
	pGhostDeathFXShader.play(Self, ShaderDuration)
	SetAlpha(0.0, True)
	
	If(Level == maxLv)
		DeathCount.Value += 1
		; Debug.Trace("NIGHTMARE NIGHT - DEATCH COUNT: " + DeathCount.Value)
		If(DeathCount.Value == maxDeath)
			; Is the last Wolf that leaves a Corpse behind
			utility.wait(fDelay)
			; //attach the ash pile
			AttachAshPile(pDefaultAshPileGhost)

			RemoveAllItems()
			AddItem(pdefaultGhostLeveledList)

			Utility.Wait(3)
			Actor player = Game.GetPlayer()
			; SpiritPreyAbsorbEffect.Play(self, 6.0, player)
			NPCDragonDeathSequenceWind.Play(player)
			SpiritPreyAbsorbSFX.Play(player, 4.3)
			; Utility.Wait(4)
			; SpiritPreyAbsorbSFX.Stop(player)
			; Utility.Wait(3)
			; SpiritPreyAbsorbEffect.Stop(player)

			player.AddPerk(SpiritPreyWolfPerk)
		EndIf
	Else ; Spawn in next Wolves
		NNSpiritPreyWolf wolf1 = PlaceAtMe(Self.GetActorBase(), 1) as NNSpiritPreyWolf
		wolf1.Level = Level + 1

		NNSpiritPreyWolf wolf2 = PlaceAtMe(Self.GetActorBase(), 1) as NNSpiritPreyWolf
  	wolf2.Level = Level + 1

		float myDamage = GetActorValueMax("UnarmedDamage")
		float myHp = GetActorValueMax("Health")
		float mySpeed = GetActorValueMax("SpeedMult")
		; Debug.Trace("NIGHTMARE NIGHT - STATS PARENT: DMG: " + myDamage + " | HP: " + myHp + " | Speed: " + mySpeed)

		float childDamage = myDamage * 1.1
		float childHp = myHp * 0.95
		float childSpeed = mySpeed * 1.2
		; Debug.Trace("NIGHTMARE NIGHT - STATS CHILD: DMG: " + childDamage + " | HP: " + childHp + " | Speed: " + childSpeed)

		wolf1.SetActorValue("UnarmedDamage", childDamage)
		wolf1.SetActorValue("Health", childHp)
		wolf1.SetActorValue("SpeedMult", childSpeed)
		wolf1.ModActorValue("CarryWeight", 0.1) ; To Confirm the Speed Mult Change
		wolf1.SetScale(1 - level * 0.1)

		wolf2.SetActorValue("UnarmedDamage", childDamage)
		wolf2.SetActorValue("Health", childHp)
		wolf2.SetActorValue("SpeedMult", childSpeed)
		wolf2.ModActorValue("CarryWeight", 0.1)
		wolf2.SetScale(1 - level * 0.1)
	EndIf
	utility.wait(fDelayEnd)
	pGhostDeathFXShader.stop(SELF)
	If(DeathCount.Value != maxDeath)
		SetAlpha(0.0, True)
	EndIf
	
	SetCriticalStage(SELF.CritStage_DisintegrateEnd)
ENDEVENT

; // play this to flash the ghost when hit or attacking
FUNCTION ghostFlash()
	IF(!bFlash)
		bFlash = TRUE
		SELF.setAlpha(0.5, TRUE)
		utility.wait(1)
		SELF.setAlpha(0.3)
		bFlash = FALSE
	ENDIF
ENDFUNCTION
