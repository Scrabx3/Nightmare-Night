Scriptname PlayerWerewolfScript extends ReferenceAlias  

Race Property WerewolfBeastRace auto
Race Property WerebearBeastRace Auto

Event OnRaceSwitchComplete()
	Race myRace = GetActorReference().GetRace()
	if (myRace == WerewolfBeastRace || myRace == WerebearBeastRace)
; 		Debug.Trace("WEREWOLF: Getting notification that race swap TO werewolf is complete.")
		(GetOwningQuest() as PlayerWerewolfChangeScript).StartTracking()
	else
; 		Debug.Trace("WEREWOLF: Getting notification that race swap FROM werewolf is complete.")
		(GetOwningQuest() as PlayerWerewolfChangeScript).Shutdown()
	endif
EndEvent

Event OnPlayerLoadGame()
	(GetOwningQuest() as PlayerWerewolfChangeScript).PlayerReloadGame()
EndEvent