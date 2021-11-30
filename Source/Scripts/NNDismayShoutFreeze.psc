Scriptname NNDismayShoutFreeze extends ActiveMagicEffect  

Idle Property Covering Auto
bool idling

Event OnEffectStart(Actor akTarget, Actor akCaster)
  If(akTarget == Game.GetPlayer())
    Game.SetPlayerAIDriven(true)
  EndIf
  akTarget.PlayIdle(Covering)
  idling = true
EndEvent

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
  Actor akTarget = GetTargetActor()
  If(akTarget == Game.GetPlayer())
    Game.SetPlayerAIDriven(false)
  EndIf
  Debug.SendAnimationEvent(akTarget, "staggerStart")
  idling = false
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
  If(akTarget == Game.GetPlayer())
    Game.SetPlayerAIDriven(false)
  EndIf
  If(idling)
    Debug.SendAnimationEvent(akTarget, "staggerStart")
  EndIf
EndEvent