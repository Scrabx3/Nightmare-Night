Scriptname NNFactionController extends ActiveMagicEffect  

NNMCM Property MCM Auto
Faction Property NightmareNightFaction Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
  MCM.UpdateAlliance()
  akTarget.AddToFaction(NightmareNightFaction)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
  akTarget.RemoveFromFaction(NightmareNightFaction)
EndEvent