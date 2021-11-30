Scriptname HowlWerewolfSummonWolvesSCRIPT extends ActiveMagicEffect  

ActorBase Property wolf Auto
int Property numToPlace Auto

HowlSummonWolfFXSSCRIPT wolfStore1
HowlSummonWolfFXSSCRIPT wolfStore2
HowlSummonWolfFXSSCRIPT wolfStore3

; ================= NIGHTMARE NIGHT
GlobalVariable Property ActiveTotem Auto
Static Property xMarker Auto

EVENT onEffectStart(Actor akTarget, Actor akCaster)
	If(ActiveTotem.Value == 2) ; Totem summons 1 more Wolf
		numToPlace += 1
	EndIf

	; get angle
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

	If(numToPlace == 1)
		wolfStore1 = spot.PlaceAtMe(wolf) as HowlSummonWolfFXSSCRIPT
	ElseIf(numToPlace == 2)
		wolfStore1 = spot.PlaceAtMe(wolf) as HowlSummonWolfFXSSCRIPT
		wolfStore2 = spot.PlaceAtMe(wolf) as HowlSummonWolfFXSSCRIPT
	Else
		wolfStore1 = spot.PlaceAtMe(wolf) as HowlSummonWolfFXSSCRIPT
		wolfStore2 = spot.PlaceAtMe(wolf) as HowlSummonWolfFXSSCRIPT
		wolfStore3 = spot.PlaceAtMe(wolf) as HowlSummonWolfFXSSCRIPT
	EndIf

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

