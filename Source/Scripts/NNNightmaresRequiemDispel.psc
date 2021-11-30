Scriptname NNNightmaresRequiemDispel extends ActiveMagicEffect  

Spell Property Requiem Auto
Spell Property Dispel Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	akCaster.RemoveSpell(Requiem)
	akCaster.RemoveSpell(Dispel)
EndEvent
