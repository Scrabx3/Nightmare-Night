Scriptname WerewolfChangeEffectScript extends ActiveMagicEffect  
{Scripted effect for the werewolf change}

;/
	NOTE: This Spell is castet on any and all Werewolf Transformations
	If the Target of this Spell is the Player, it will start the WW Quest (or notifes the companions Quest),
	the Spell thus acts as the first Part of the Transformations

	This Spell has no further usage for Nightmare Night, thus no logic here is changed
	The Copy in Nightmare Night is for documentation and ensurance that Logic stays unchanged
/;

;======================================================================================;
;               PROPERTIES  /
;=============/

Quest Property PlayerWerewolfQuest auto
Quest Property C00 auto

Spell Property VFXSpell auto


;======================================================================================;
;               EVENTS                     /
;=============/

Event OnEffectStart(Actor Target, Actor Caster)
	;	Debug.Trace("WEREWOLF: Casting transformation spell on " + Target)

	; set up tracking
	if (Target == Game.GetPlayer())
		; Debug.Trace("WEREWOLF: Target is player.")
		; if this is the first time, don't actually do anything (transform handled in rampage script)
		if ( (C00 as CompanionsHousekeepingScript).PlayerIsWerewolfVirgin )
			;	Debug.Trace("WEREWOLF: Player's first time; bailing out.")
			(C00 as CompanionsHousekeepingScript).PlayerIsWerewolfVirgin = false
			Game.SetBeastForm(False)
			return
		endif
		; Debug.Trace("WEREWOLF: Starting player tracking.")
		PlayerWerewolfQuest.Start()
	endif

	; the Spell castet here calls the "WerewolfTransformVisual" Script for the second part of the Transformation
	VFXSpell.Cast(Target)
EndEvent

