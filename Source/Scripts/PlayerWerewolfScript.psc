Scriptname PlayerWerewolfScript extends ReferenceAlias  

Race Property WerewolfBeastRace auto
Race Property WerebearBeastRace Auto

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
	Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
		; Dont allow the Player to equip anything while in Beastform..
		Race myRace = GetActorReference().GetRace()
		If(myRace == WerewolfBeastRace || myRace == WerebearBeastRace)
			Armor ar = akBaseObject as Armor
			If(!ar || ar.GetName() == "" || Math.LogicalAnd(ar.GetSlotMask(), Math.LeftShift(1, 31)) > 0)
				return
			EndIf
			Keyword DD = Keyword.GetKeyword("zad_Lockable")
			Keyword DD2 = Keyword.GetKeyword("zad_InventoryDevice")
			If(DD && DD2)
				If(ar.HasKeyword(DD) || ar.HasKeyword(DD2))
					return
				EndIf
			EndIf
			GetActorReference().UnequipItem(akBaseObject)
		EndIf
	EndEvent
EndState

Event OnPlayerLoadGame()
	(GetOwningQuest() as PlayerWerewolfChangeScript).PlayerReloadGame()
EndEvent