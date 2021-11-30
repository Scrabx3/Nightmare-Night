Scriptname NNDefaultAttack extends ActiveMagicEffect  
{Default Script applied to every Werebeast Attack}

;/ NOTE: This Spell is applied only to living Actors, the final blow which kills the Actor is still recognized however.
This leaves to assume that the Spells & Magic Effects own Condition are checked as the Hit connects with an Actor but before the hit has been fully registered, this Script however is only called after the hit has already fully registered. The Reason why I stick with the Cloak is because this here even though extremely useful, wont recognize kills through Killmoves or Debuffs

; Event OnEffectStart(Actor akTarget, Actor akCaster)
;   Debug.Notification("He got hit, jim")
;   If(akTarget.IsDead())
;     Debug.MessageBox("Hes dead, jim")
;     return
;   EndIf
; EndEvent

;/ The Spell always seems to be applied AFTER the hit has been fully registered, so none of these Fire on the application hit

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
  Debug.MessageBox("Hit something")
EndEvent

Event OnDying(Actor akKiller)
  Debug.MessageBox("Dying Something")
EndEvent

Event OnDeath(Actor akKiller)
  Debug.MessageBox("Deathed something")
EndEvent
/;