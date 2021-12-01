Scriptname NNWerewolfFeed extends ActiveMagicEffect  

Perk[] Property Gorging Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
  float misHp = (1 - akTarget.GetActorValuePercentage("Health")) * akTarget.GetActorValueMax("Health")
  float heal = 0.2 ; No Perk heals 20%
  If(akTarget.HasPerk(Gorging[1])) ; Gorging Lv2 heals 70%
    heal += 0.5
  ElseIf(akTarget.HasPerk(Gorging[0])) ; Gorging Lv1 heals 50%
    heal += 0.3
  EndIf
  akTarget.RestoreActorValue("Health", misHp * heal)
EndEvent