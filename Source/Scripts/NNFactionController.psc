Scriptname NNFactionController extends ActiveMagicEffect  

Faction Property NightmareNightFaction Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
  akTarget.AddToFaction(NightmareNightFaction)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
  akTarget.RemoveFromFaction(NightmareNightFaction)
EndEvent