Scriptname NNFearHowl extends ActiveMagicEffect  

Perk Property SPDraugrReward  Auto  

Event OnEffectStart(Actor akTarget, Actor akCaster)
  ; String st = ""
  If(akCaster.HasPerk(SPDraugrReward))
    GoToState("NoMove")
    akTarget.SetDontMove(true)
  EndIf
EndEvent

State NoMove
  Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
    ; Debug.Trace("NIGHTMARE NIGHT - HOWL FEAR - NO MOVE HIT")
    GetTargetActor().SetDontMove(false)
    GoToState("")
  EndEvent
EndState

Event OnEffectFinish(Actor akTarget, Actor akCaster)
  If(GetState() == "NoMove")
    GetTargetActor().SetDontMove(false)
    GoToState("")
  EndIf
EndEvent
