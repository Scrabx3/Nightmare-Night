Scriptname NNTurnScript extends ActiveMagicEffect  

NNMCM Property MCM Auto
Spell Property WerewolfTransform Auto
GlobalVariable Property IsWerewolf Auto

int Property wolf Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
  If(!akTarget.HasSpell(WerewolfTransform))
    IsWerewolf.Value = wolf
    
    MCM.TurnWerebeast()
  EndIf

  WerewolfTransform.Cast(akTarget)
EndEvent
