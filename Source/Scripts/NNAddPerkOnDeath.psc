Scriptname NNAddPerkOnDeath extends Actor  

Perk Property PerkToAdd Auto

Event OnDeath(Actor akKiller)
  Game.GetPlayer().AddPerk(PerkToAdd)
EndEvent