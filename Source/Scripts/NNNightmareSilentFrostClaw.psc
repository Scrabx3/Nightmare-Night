Scriptname NNNightmareSilentFrostClaw extends ActiveMagicEffect  

Event OnEffectStart(Actor akTarget, Actor akCaster)
  ; The Effect is applied when you got Nightmare of the Silent Night or Nightmare Night. Nightmare Night only shreds half Stamina & Magicka though
  If(akTarget.IsDead())
    Debug.MessageBox("It ded m8")
    return
  ElseIf(akCaster.IsDetectedBy(akTarget))
    Debug.MessageBox("It see me m8")
    return
  EndIf
  akTarget.DamageActorValue("Stamina", akTarget.GetActorValue("Stamina"))
  akTarget.DamageActorValue("Magicka", akTarget.GetActorValue("Magicka"))
EndEvent