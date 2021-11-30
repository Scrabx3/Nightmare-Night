Scriptname HowlSummonWolfFXSSCRIPT extends Actor  

Perk Property SpiritWolfPerk Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	If(akCaster.HasPerk(SpiritWolfPerk)) ; Make them inherit Stats
		akTarget.ModActorValue("UnarmedDamage", akCaster.GetActorValue("UnarmedDamage") * 0.5)
		; akTarget.ModActorValue("Health", akCaster.GetActorValue("Health") * 0.2)
		akTarget.ModActorValue("DamageResist", akCaster.GetActorValue("DamageResist") * 0.5)
		akTarget.ModActorValue("MagicResist", akCaster.GetActorValue("MagicResist") * 0.5)
	EndIf
EndEvent

Event OnLoad()
	RegisterForSingleUpdate(60)
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
;/ Since we no longer spawn them on top of the player itll feel more realistic to not
have them be Ghosts. That way it looks more like they are just running to the Player
from somewhere nearby(?)

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