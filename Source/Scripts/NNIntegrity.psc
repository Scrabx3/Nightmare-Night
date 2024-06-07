Scriptname NNIntegrity extends ReferenceAlias  

PlayerWerewolfChangeScript Property WWQ Auto

Race Property WerewolfRace Auto
Race Property WerebearRace Auto
Spell Property WerewolfTransformPassive Auto
{ Vanilla Race Ability Spell }
Spell Property WerebearTransformPassive Auto
{ Vanilla Race Ability Spell }
Spell Property abNightmare Auto
{ Spell present on all NN Races }
Keyword Property NNWereBeastKW Auto
{ Keyword present on all NN Races }
 
Spell Property WerewolfImmunity Auto
{ Human WW Ability Spell }
MagicEffect Property abRingOfHircineEff Auto
{ Human WW Ability, adds Hircine Transform }

Spell Property TransformDefault Auto
{ Vanilla Transform Spells, should contain at least WW + WB Mgeff }
Spell Property TransformRingOfHircine Auto
{ Vanilla Transform Spells, should contain at least WW + WB Mgeff }
MagicEffect Property TransformWolf Auto
MagicEffect Property TransformBear Auto

Event OnInit()
  OnPlayerLoadGame()
EndEvent

bool Function HasMgeff(Spell abSpell, MagicEffect abEff)
  return abSpell.GetMagicEffects().Find(abEff) > -1
EndFunction

bool Function ValidateTransform(Spell akTransformSpell)
  return HasMgEff(akTransformSpell, TransformWolf) && HasMgeff(akTransformSpell, TransformBear)
EndFunction

bool Function ValidateRace(Race akRace)
  If (!akRace.HasKeyword(NNWereBeastKW))
    Debug.MessageBox("[NIGHTMARE NIGHT]\nMissing 'NNWerebeastRace' Keyword on " + akRace.GetName() + ". NN will not be able to reliably identify this race.")
    Debug.Trace("[NIGHTMARE NIGHT] Missing Keyword on Race " + akRace)
    return false
  EndIf
  int i = akRace.GetSpellCount()
  While (i > 0)
    i -= 1
    Spell ith = akRace.GetNthSpell(i)
    If (ith == abNightmare)
      return true
    EndIf
  EndWhile
  Debug.MessageBox("[NIGHTMARE NIGHT]\nMissing one or more Abilitie Spells on " + akRace.GetName() + ".\nThis is likely due to a mod conflict.")
  Debug.Trace("[NIGHTMARE NIGHT] Missing Ability Spell on Race " + akRace)
  return false
EndFunction

Event OnPlayerLoadGame()
  If (WWQ.INTEGRITY_CHECK != 1)
    Debug.MessageBox("[NIGHTMARE NIGHT]\nSomething in your setup is overriding the Script \"PlayerWerewolfChangeScirpt\". Nightmare Night will NOT function correctly.")
    Debug.Trace("[NIGHTMARE NIGHT] Invalid Property \"INTEGRITY_CHECK\" in PlayerWerewolfChangeScirpt")
  ElseIf (!HasMgeff(WerewolfImmunity, abRingOfHircineEff))
    Debug.MessageBox("[NIGHTMARE NIGHT]\nHuman Werewolf Ability is missing one or more NN related effects. This is likely due to a mod conflict.")
    Debug.Trace("[NIGHTMARE NIGHT] Missing Ring of Hircine Effect on WerewolfImmunity Spell (human WW ability)")
  ElseIf (!ValidateTransform(TransformDefault))
    Debug.MessageBox("[NIGHTMARE NIGHT]\nDefault WW Transform is missing one or more transform spells. You may not be able to transform. This is likely due to a mod conflict.")
    Debug.Trace("[NIGHTMARE NIGHT] Missing Transform spell on Default Transform")
  ElseIf (!ValidateTransform(TransformRingOfHircine))
    Debug.MessageBox("[NIGHTMARE NIGHT]\nHircine WW Transform is missing one or more transform spells. You may not be able to transform. This is likely due to a mod conflict.")
    Debug.Trace("[NIGHTMARE NIGHT] Missing Transform spell on Hircine Transform")
  ElseIf(!ValidateRace(WerewolfRace))
    ; Msg printed in validate
  ElseIf(!ValidateRace(WerebearRace))
    ; Do nothing
  EndIf
  ; If (WerewolfTransformPassive.GetNumEffects() != 5)
  ;   Debug.MessageBox(msg)
  ;   Debug.Trace("[NIGHTMARE NIGHT] Invalid Number of Magic Effects on Transform Passive (Werewolf) Spell, Expecting 5 but got " + WerewolfTransformPassive.GetNumEffects())
  ;   return
  ; EndIf
  ; If (WerebearTransformPassive.GetNumEffects() != 6)
  ;   Debug.MessageBox(msg)
  ;   Debug.Trace("[NIGHTMARE NIGHT] Invalid Number of Magic Effects on Transform Passive (Werebear) Spell, Expecting 6 but got " + WerebearTransformPassive.GetNumEffects())
  ;   return
  ; EndIf
EndEvent

