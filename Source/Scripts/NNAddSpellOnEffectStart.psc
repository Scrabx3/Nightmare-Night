Scriptname NNAddSpellOnEffectStart extends ActiveMagicEffect  

Spell Property AbToAdd Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
  akTarget.AddSpell(AbToAdd)
EndEvent