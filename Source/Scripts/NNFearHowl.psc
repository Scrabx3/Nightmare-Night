Scriptname NNFearHowl extends ActiveMagicEffect  

Perk Property SPDraugrReward  Auto  
GlobalVariable Property TotemType Auto
float HpCount

Event OnEffectStart(Actor akTarget, Actor akCaster)
  ; String st = ""
  If(akCaster.HasPerk(SPDraugrReward))
    GoToState("NoMove")
    akTarget.SetDontMove(true)
  EndIf
  ; If(TotemType.Value == 3)
  ;   st += "MoreDmg"
  ;   HpCount = akTarget.GetActorValue("Health")
  ; EndIf
  ; GoToState(st)
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

; Function DamageHealth()
;   Debug.Trace("NIGHTMARE NIGHT - HOWL FEAR - DAMAGE HEALTH")
;   Actor akTarget = GetTargetActor()
;   float newHp = akTarget.GetActorValue("Health")
;   float lostHp = HpCount - newHp
;   If(lostHp > 0)
;     float dmg = lostHp * 0.2
;     akTarget.DamageActorValue("Health", dmg)
;     newHp -= dmg
;   EndIf
;   HpCount = newHp
; EndFunction

; State NoMoveMoreDmg
;   Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
;     Debug.Trace("NIGHTMARE NIGHT - HOWL FEAR - NO MOVE MORE DMG HIT")
;     GetTargetActor().SetDontMove(false)
;     GoToState("MoreDmg")
;     DamageHealth()
;   EndEvent

;   Event OnEffectFinish(Actor akTarget, Actor akCaster)
;     akTarget.SetDontMove(false)
;   EndEvent
; EndState

; State MoreDmg
;   Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
;     Debug.Trace("NIGHTMARE NIGHT - HOWL FEAR - MORE DMG HIT")
;     DamageHealth()
;   EndEvent
; EndState