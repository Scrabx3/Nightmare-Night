Scriptname NNWerewolfFeed extends ActiveMagicEffect  

Perk[] Property Gorging Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
  float misHp = (1 - akTarget.GetActorValuePercentage("Health")) * akTarget.GetActorValueMax("Health")
  float heal = 0.3
  If(akTarget.HasPerk(Gorging[1]))
    heal += 0.4
  ElseIf(akTarget.HasPerk(Gorging[1]))
    heal += 0.2
  EndIf
  akTarget.RestoreActorValue("Health", misHp * heal)
EndEvent