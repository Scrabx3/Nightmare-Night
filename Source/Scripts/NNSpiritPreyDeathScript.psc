Scriptname NNSpiritPreyDeathScript extends Actor  

Sound PRoperty NPCDragonDeathSequenceWindMiraak Auto
EffectShader PRoperty SpiritPreyAbsorbSFX Auto
Message Property PerkDescriptor Auto
Perk Property SpiritPerk Auto


Event OnDying(Actor akKiller)
  Actor player = Game.GetPlayer()

  NPCDragonDeathSequenceWindMiraak.Play(player)
  SpiritPreyAbsorbSFX.Play(player, 4.3)

  Utility.Wait(5)
  player.AddPerk(SpiritPerk)
  PerkDescriptor.Show()
EndEvent