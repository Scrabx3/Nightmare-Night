Scriptname NNBloodFrenzy extends ActiveMagicEffect  

GlobalVariable Property IsWerewolf Auto
GlobalVariable Property FrenzyStacks Auto
Perk Property BloodFrenzy Auto

float frenzy

Event OnEffectStart(Actor akTarget, Actor akCaster)
  ;/ ==============================
  OnEffectStart updates magnitude of the Blood Frenzy
  Damage Taken is handled by a seperate Perk which is applied by this Magic Effect
  Index 0 - Speed
  • Speed is increased by 5% with each Stack
  • As Werebear, this is reduced to 2%
  Index 1 - Unarmed Damage
  • Unarmed Damage is increased by 10% with each Stack
  • As Werebear, this is increased to 15%

  Perk Entries top to bottom:
  • Set Magnitude Frenzy Damage
  • Add Frenzy Damage Spell
  • Set Magnitude Frenzy Speed
  • Add Frenzy Speed Spell
  • Set Damage Multiplier Phys 
  • Set Damage Multiplier Magic
  ============================== /;
  frenzy = FrenzyStacks.GetValue() + 1
  Debug.Trace("NIGHTMARE NIGHT - Blood Frenzy Effect Start - frenzy = " + frenzy + "(- 1)")
  If(frenzy > 10)
    return
  EndIf
  ; Script here sets the effects for Blood Frenzy Lv X + 1, where X is the current level. Reason for this being that the Blood Frenzy triggering this Script here is using the Stats set in the previous level and cant be altered here anymore (without recasting the Spell which would cause a loop), so we continue tradition and set the Stats for the yet again next level. OnEffectFinish() will restore the effects to Lv1

  ; Werebears gain 100% more damage with fully stacked Blood Frenzy. Werewolves 75%
  float damage = (0.1 - 0.025 * IsWerewolf.Value) * frenzy
  ; Werebears gain 25% more movement speed with fully stacked Blood Frenzy. Werewolves 60%
  float speed = (0.025 + 0.035 * IsWerewolf.Value) * frenzy
  ; Both Werebears and Werewolves take an additional 5% Damage with each Frenzy Level
  float defense = 0.05 * frenzy
  Debug.Trace("NIGHTMARE NIGHT - Blood Frenzy Effect Start - damage = " + damage + "; speed = " + speed + "; defense = " + defense)

  BloodFrenzy.SetNthEntryValue(0, 1, damage) ; Damage
  BloodFrenzy.SetNthEntryValue(2, 1, speed) ; Speed
  BloodFrenzy.SetNthEntryValue(4, 0, defense) ; Inc Dmg Physical
  BloodFrenzy.SetNthEntryValue(5, 0, defense) ; Inc Dmg Magical
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
  If(frenzy <= FrenzyStacks.GetValueInt())
    ; If this effect ended because Blood Frenzy has been reapplied, dont reset Level
    return
  EndIf
  Debug.Trace("NIGHTMARE NIGHT - Blood Frenzy Effect Stop - resetting damage = " + (0.15 - 0.05 * IsWerewolf.Value) + "; speed = " + (0.03 + 0.03 * IsWerewolf.Value) + "; defense = 0.05")

  BloodFrenzy.SetNthEntryValue(0, 1, 0.15 - 0.05 * IsWerewolf.Value) ; Damage
  BloodFrenzy.SetNthEntryValue(2, 1, 0.03 + 0.03 * IsWerewolf.Value) ; Speed
  BloodFrenzy.SetNthEntryValue(4, 0, 0.05) ; Inc Dmg Physical
  BloodFrenzy.SetNthEntryValue(5, 0, 0.05) ; Inc Dmg Magical

  FrenzyStacks.SetValue(0)
EndEvent