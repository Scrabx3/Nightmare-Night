Scriptname NNNightEyeToggle extends ActiveMagicEffect  

Spell Property NightEye Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	If(akCaster.HasSpell(NightEye))
		akCaster.RemoveSpell(NightEye)
	Else
		akCaster.AddSpell(NightEye)
	EndIf
EndEvent