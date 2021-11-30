Scriptname WerewolfChangeEffectScript extends ActiveMagicEffect  
{Scripted effect for the werewolf change}

;/
NOTE:
This Spell is placed on any Target to change into the Werewolf Form
If this Target is the Player, it will set up the Werewolf Quest
Afterwards the VFX Spell is Cast which completes the Transformation & plays
the actual Animation + Screen Effects. In case of the Player it also sets the
Werewolf Quest to Stage 1
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
; 	Debug.Trace("WEREWOLF: Casting transformation spell on " + Target)

	; set up tracking
	if (Target == Game.GetPlayer())
; 		Debug.Trace("WEREWOLF: Target is player.")
		; if this is the first time, don't actually do anything (transform handled in rampage script)
		if ( (C00 as CompanionsHousekeepingScript).PlayerIsWerewolfVirgin )
; 			Debug.Trace("WEREWOLF: Player's first time; bailing out.")
			(C00 as CompanionsHousekeepingScript).PlayerIsWerewolfVirgin = false
			Game.SetBeastForm(False)
			return
		endif

; 		Debug.Trace("WEREWOLF: Starting player tracking.")

		PlayerWerewolfQuest.Start()
	endif

	VFXSpell.Cast(Target)
EndEvent

