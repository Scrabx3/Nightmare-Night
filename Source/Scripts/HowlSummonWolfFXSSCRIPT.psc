Scriptname HowlSummonWolfFXSSCRIPT extends Actor  

Perk Property SpiritWolfPerk Auto

Event OnLoad()
	Actor Player = Game.GetPlayer()
	If(Player.HasPerk(SpiritWolfPerk)) ; Make them inherit Stats if Player killed the Everdoubting
		ModActorValue("UnarmedDamage", Player.GetActorValue("UnarmedDamage") * 0.75)
		ModActorValue("Health", Player.GetActorValue("Health") * 0.2)
		ModActorValue("DamageResist", Player.GetActorValue("DamageResist") * 0.75)
		ModActorValue("MagicResist", Player.GetActorValue("MagicResist") * 0.75)
	EndIf
EndEvent

Event OnDying(Actor akKiller)
	TurnOff()
EndEvent

Function TurnOff()
	UnregisterForUpdate()
	Disable(true)
EndFunction



EFFECTSHADER PROPERTY ghostEffect AUTO
FLOAT PROPERTY ghostAlpha=0.1 AUTO

;/ Wolfies no longer ghosties

BOOL bFlash=FALSE

EVENT onLOAD()

	ghostEffect.play(SELF)
	SELF.SetAlpha(0.3)
	
	registerForAnimationEvent(SELF, "bowDraw")
	registerForAnimationEvent(SELF, "weaponSwing")
	registerForAnimationEvent(SELF, "arrowRelease")
	
	RegisterForSingleUpdate(60)

ENDEVENT

EVENT OnUpdate()
	TurnOff()
ENDEVENT

EVENT onHIT(OBJECTREFERENCE akAggressor, FORM akSource, Projectile akProjectile, BOOL abPowerAttack, BOOL abSneakAttack, BOOL abBashAttack, BOOL abHitBlocked)
	ghostFlash()
ENDEVENT

EVENT OnAnimationEvent(ObjectReference akSource, string EventName)
	ghostFlash()
ENDEVENT

EVENT onDYING(ACTOR killer)
	TurnOff()		
ENDEVENT

Function TurnOff()
	; SELF.setAlpha(0.3)
	UnregisterForUpdate()
	ghostEffect.stop(SELF)
	disable(true)
EndFunction

; //play this to flash the ghost when hit or attacking
FUNCTION ghostFlash()

	IF(!bFlash)
	
		bFlash = TRUE
	
		SELF.setAlpha(0.5, TRUE)
	
		utility.wait(1)
		
		SELF.setAlpha(0.3)
		
		bFlash = FALSE
	ENDIF
	
ENDFUNCTION
/;