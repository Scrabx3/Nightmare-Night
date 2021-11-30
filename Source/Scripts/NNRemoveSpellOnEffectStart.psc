Scriptname NNRemoveSpellOnEffectStart extends ActiveMagicEffect  

Spell Property AbToAdd Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
  akCaster.RemoveSpell(AbToAdd)
EndEvent
