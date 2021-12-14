Scriptname HowlWerewolfSummonWolvesSCRIPT extends ActiveMagicEffect  
{Howl of the Pack Spell Effect}
;/ ============================
	This one Script used to be placed on a total of 3 different Spells
	all summoning the appropriate Wolf Level. Since NN offers the
	Option to Rndize Wolf Spawns, I moved the entire Algorithm into
	Script. Meaning this Script is always called by a single Spell and
	handles the division based on Perks & MCM Settings entirely

	The Stages 1, 2 and 3 are divided through the Perks Totem & Aspect of the Moon
	Bear or Wolf depends on the Players own Race (Werebear or Werewolf)
	The Appearance (Van, Rnd, RnA) is decided through MCM
	*Van = Vanilla; Rnd = Random; RnA = All Random
	*All Random := Werebeasts mixed with regular Creatures
============================ /;
ActorBase Property wolf Auto Hidden 
{Redundant. This was used to divide the Spell into 3 Segments}

; --- Division
NNMCM Property MCM Auto
Perk Property TotemOfTheMoon Auto
Perk Property AspectOfTheMoon Auto
GlobalVariable Property IsWerewolf Auto

; --- Wolf Actor Bases
ActorBase Property Lv1VanWolf Auto
ActorBase Property Lv2VanWolf Auto
ActorBase Property Lv3VanWolf Auto

ActorBase Property Lv2RndWolf Auto
ActorBase Property Lv3RndWolf Auto

ActorBase Property Lv3RnAWolf Auto

; --- Bear Actor Bases
ActorBase Property Lv1VanBear Auto
ActorBase Property Lv2VanBear Auto
ActorBase Property Lv3VanBear Auto

ActorBase Property Lv2RndBear Auto
ActorBase Property Lv3RndBear Auto

ActorBase Property Lv3RnABear Auto

; --- Misc
GlobalVariable Property ActiveTotem Auto
Static Property xMarker Auto
int Property numToPlace Auto

HowlSummonWolfFXSSCRIPT wolfStore1
HowlSummonWolfFXSSCRIPT wolfStore2
HowlSummonWolfFXSSCRIPT wolfStore3


EVENT onEffectStart(Actor akTarget, Actor akCaster)
	If(ActiveTotem.Value == 2) ; Totem summons 1 more Wolf
		numToPlace += 1
	EndIf

	; Get Spawn Position
	float angle
	float aX = 90 + akCaster.GetAngleX() 
	float aZ = akCaster.GetAngleZ()
	If(aZ < 90)
		angle = 90 - aZ
	Else
		angle = 450 - aZ
	EndIf
	float d = -350.0

	ObjectReference spot = akCaster.PlaceAtMe(xMarker)
	spot.MoveTo(akCaster, d * Math.Sin(aX) * Math.Cos(aZ), d * Math.Sin(aX) * Math.Sin(aZ), akCaster.GetHeight() - 3)

	; Figure out who to spawn
	; I guess this couldve been prettier if I werent so lazy to do some math, eh
	ActorBase spawn
	If(akCaster.HasPerk(AspectOfTheMoon)) ; Lv3 Spawn
		If(IsWerewolf.Value == 0) ; Bear
			If(MCM.iNPCTex == 0) ; Vanilla
				spawn = Lv3VanBear
			ElseIf(MCM.iNPCTex == 1) ; Random
				spawn = Lv3RndBear
			Else ; Full Random
				spawn = Lv3RnABear
			EndIf
		Else ; Wolf
			If(MCM.iNPCTex == 0) ; Vanilla
				spawn = Lv3VanWolf
			ElseIf(MCM.iNPCTex == 1) ; Random
				spawn = Lv3RndWolf
			Else ; Full Random
				spawn = Lv3RnAWolf
			EndIf
		EndIf
	ElseIf(akCaster.HasPerk(TotemOfTheMoon)) ; Lv2 Spawn
		If(IsWerewolf.Value == 0) ; Bear
			If(MCM.iNPCTex == 0) ; Vanilla
				spawn = Lv2VanBear
			Else ; Random
				spawn = Lv2RndBear
			EndIf
		Else ; Wolf
			If(MCM.iNPCTex == 0) ; Vanilla
				spawn = Lv2VanWolf
			Else ; Random
				spawn = Lv2RndWolf
			EndIf
		EndIf
	Else ; Lv1 Spawn
		If(IsWerewolf.Value == 0) ; Bear
			spawn = Lv1VanBear
		Else
			spawn = Lv1VanWolf
		EndIf
	EndIf

	; Spawn em in
	If(numToPlace == 1)
		wolfStore1 = spot.PlaceAtMe(spawn) as HowlSummonWolfFXSSCRIPT
	ElseIf(numToPlace == 2)
		wolfStore1 = spot.PlaceAtMe(spawn) as HowlSummonWolfFXSSCRIPT
		wolfStore2 = spot.PlaceAtMe(spawn) as HowlSummonWolfFXSSCRIPT
	Else
		wolfStore1 = spot.PlaceAtMe(spawn) as HowlSummonWolfFXSSCRIPT
		wolfStore2 = spot.PlaceAtMe(spawn) as HowlSummonWolfFXSSCRIPT
		wolfStore3 = spot.PlaceAtMe(spawn) as HowlSummonWolfFXSSCRIPT
	EndIf

	; Cleanup
	spot.Delete()

	; IF(numToPlace == 1)
	; 	wolfStore1 = game.getPlayer().placeAtMe(wolf)
	; ELSEIF(numToPlace == 2)
	; 	wolfStore1 = game.getPlayer().placeAtMe(wolf)
	; 	wolfStore2 = game.getPlayer().placeAtMe(wolf)
	; ELSEIF(numToPlace == 3)
	; 	wolfStore1 = game.getPlayer().placeAtMe(wolf)
	; 	wolfStore2 = game.getPlayer().placeAtMe(wolf)
	; 	wolfStore3 = game.getPlayer().placeAtMe(wolf)
	; ENDIF
endEVENT 

EVENT onEffectFinish(Actor akTarget, Actor akCaster) 
	If(wolfStore1)
		wolfStore1.TurnOff()
	EndIf
	If(wolfStore2)
		wolfStore2.TurnOff()
	EndIf
	If(wolfStore3)
		wolfStore3.TurnOff()
	EndIf

	; (wolfStore1 as HowlSummonWolfFXSSCRIPT).TurnOff()
	; (wolfStore2 as HowlSummonWolfFXSSCRIPT).TurnOff()
	; (wolfStore3 as HowlSummonWolfFXSSCRIPT).TurnOff()

	; wolfStore1.disable()
	; wolfStore2.disable()
	; wolfStore3.disable()
endEVENT

