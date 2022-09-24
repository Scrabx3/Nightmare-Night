Scriptname NNNightmareSilentFrostClaw extends ActiveMagicEffect  

Event OnEffectStart(Actor akTarget, Actor akCaster)
  If(akTarget.IsDead() || akCaster.IsDetectedBy(akTarget)) ; Script still triggers if attack kills target
    return
  EndIf
  akTarget.DamageActorValue("Stamina", 1000.0)
  akTarget.DamageActorValue("Magicka", 1000.0)
EndEvent