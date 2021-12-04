Scriptname PlayerWerewolfScript extends ReferenceAlias  

Race Property WerewolfBeastRace auto
Race Property WerebearBeastRace Auto
Quest owned


Event OnRaceSwitchComplete()
	Race myRace = GetActorReference().GetRace()
	if (myRace == WerewolfBeastRace || myRace == WerebearBeastRace)
; 		Debug.Trace("WEREWOLF: Getting notification that race swap TO werewolf is complete.")
		(GetOwningQuest() as PlayerWerewolfChangeScript).StartTracking()
		GoToState("NoEquipping")
	else
; 		Debug.Trace("WEREWOLF: Getting notification that race swap FROM werewolf is complete.")
		(GetOwningQuest() as PlayerWerewolfChangeScript).Shutdown()
		GoToState("")
	endif
EndEvent

State NoEquipping
	Event OnBeginState()
		owned = GetOwningQuest()
	EndEvent

	Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
		; Dont allow the Player to equip anything while in Beastform..
		Race myRace = GetActorReference().GetRace()
		If(myRace == WerewolfBeastRace || myRace == WerebearBeastRace)
			GetActorReference().UnequipItem(akBaseObject)
		EndIf
	EndEvent
EndState

Event OnPlayerLoadGame()
	(GetOwningQuest() as PlayerWerewolfChangeScript).PlayerReloadGame()
EndEvent