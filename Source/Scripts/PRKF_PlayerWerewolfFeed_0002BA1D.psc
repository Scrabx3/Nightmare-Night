;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 5
Scriptname PRKF_PlayerWerewolfFeed_0002BA1D Extends Perk Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akTargetRef, Actor akActor)
;BEGIN CODE
(PlayerWerewolfQuest as PlayerWerewolfChangeScript).Feed(akTargetRef as Actor)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4(ObjectReference akTargetRef, Actor akActor)
;BEGIN CODE
; Stop the Player from Lockpicking or apply the
; "Break Entry" Perk if possible
float lockLevel = akTargetRef.GetLockLevel() + 45.0
Debug.Trace("NIGHTMARE NIGHT - BREAK ENTRY -> locklevel = " + lockLevel)
If(lockLevel == 300)
  Debug.Notification("This Lock cannot be broken")
EndIf
float stamina = akActor.GetActorValue("Stamina")
float payment = lockLevel/299.0 * akActor.GetActorValueMax("Stamina")
Debug.Trace("NIGHTMARE NIGHT - BREAK ENTRY -> stamina = " + stamina + " // payment = " + payment)
If(stamina < payment)
  Debug.Notification("You don't have enough Stamina to break this Lock open")
Else
  Debug.SendAnimationEvent(akActor, "attackStartRight") ; AttackStartBackHand
  akActor.DamageActorValue("Stamina", payment)
  Utility.Wait(0.3)
  akTargetRef.Lock(false)
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Quest Property PlayerWerewolfQuest  Auto  

Perk Property BreakEntry  Auto  
