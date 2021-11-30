Scriptname NNNightmareSilentFrostClaw extends ActiveMagicEffect  

Perk Property NightmareNight Auto
GlobalVariable Property LunarPhase Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
  ; The Effect is applied when you got Nightmare of the Silent Night or Nightmare Night. Nightmare Night only shreds half Stamina & Magicka though
  If(akTarget.IsDead())
    Debug.MessageBox("It ded, m8")
    return
  EndIf
  If(akCaster.IsDetectedBy(akTarget))
    return
  EndIf
  float shred = 1.0
  If(LunarPhase.Value != 4 && akCaster.HasPerk(NightmareNight))
    shred = 0.5
  EndIf
  akTarget.DamageActorValue("Stamina", akTarget.GetActorValueMax("Stamina") * shred)
  akTarget.DamageActorValue("Magicka", akTarget.GetActorValueMax("Magicka") * shred)
EndEvent