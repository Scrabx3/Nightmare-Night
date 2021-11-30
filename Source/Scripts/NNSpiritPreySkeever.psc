Scriptname NNSpiritPreySkeever extends Actor

ObjectReference[] Property SpawnLocation Auto
EffectShader Property Invisibility Auto

EffectShader Property pGhostDeathFXShader Auto
Activator Property pDefaultAshPileGhost Auto
LeveledItem Property pdefaultGhostLeveledList Auto

Perk Property SpiritPreySkeever Auto
EffectShader Property SpiritPreyAbsorb Auto
Sound Property NPCDragonDeathSequenceWind Auto
int hits

Event OnLoad()
  SetAlpha(0.1, false)
  ; Invisibility.Play(Self, -1)
  hits = 0
EndEvent

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
  If(akAggressor == Game.GetPlayer())
    If(hits == 3)
      Kill()
      return
    EndIf
    MoveTo(SpawnLocation[hits])
    StopCombat()
    StopCombatAlarm()
    hits += 1
  EndIf
EndEvent

Event OnDying(Actor akKiller)
  SetCriticalStage(Self.CritStage_DisintegrateStart)
  pGhostDeathFXShader.Play(Self)
  SetAlpha(0.0, True)

  Utility.Wait(0.7)
  AttachAshPile(pDefaultAshPileGhost)
  RemoveAllItems()
  AddItem(pdefaultGhostLeveledList)
  
  Utility.Wait(3)
  Actor player = Game.GetPlayer()
  NPCDragonDeathSequenceWind.Play(player)
  Utility.Wait(0.5)
  SpiritPreyAbsorb.Play(player, 4.3)
  player.AddPerk(SpiritPreySkeever)
  SetCriticalStage(Self.CritStage_DisintegrateEnd)
EndEvent