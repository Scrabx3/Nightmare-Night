Scriptname NNIntegrity extends ReferenceAlias  

PlayerWerewolfChangeScript Property WWQ Auto
Spell Property TransformDefault Auto
Spell Property TransformRingOfHircine Auto
Spell Property WerewolfImmunity Auto
Spell Property WerewolfTransformPassive Auto
Spell Property WerebearTransformPassive Auto
Race Property WerewolfRace Auto
Race Property WerebearRace Auto
Keyword Property NNWereBeastKW Auto

Event OnInit()
  OnPlayerLoadGame()
EndEvent

Event OnPlayerLoadGame()
  If (WWQ.INTEGRITY_CHECK != 1)
    Debug.MessageBox("[NIGHTMARE NIGHT]\nSomething in your setup is overriding the Script \"PlayerWerewolfChangeScirpt\". Nightmare Night will NOT function correctly.")
    Debug.Trace("[NIGHTMARE NIGHT] Invalid Property \"INTEGRITY_CHECK\" in PlayerWerewolfChangeScirpt")
    return
  EndIf
  String msg = "[NIGHTMARE NIGHT]\nSomething in your setup is overriding one or more Werewolf-related Game objects."
  If (WerewolfImmunity.GetNumEffects() != 4)
    Debug.MessageBox(msg)
    Debug.Trace("[NIGHTMARE NIGHT] Invalid Number of Magic Effects on WW Immunity Spell, Expecting 4 but got " + WerewolfImmunity.GetNumEffects())
    return
  EndIf
  If (WerewolfTransformPassive.GetNumEffects() != 5)
    Debug.MessageBox(msg)
    Debug.Trace("[NIGHTMARE NIGHT] Invalid Number of Magic Effects on Transform Passive (Werewolf) Spell, Expecting 5 but got " + WerewolfTransformPassive.GetNumEffects())
    return
  EndIf
  If (WerebearTransformPassive.GetNumEffects() != 6)
    Debug.MessageBox(msg)
    Debug.Trace("[NIGHTMARE NIGHT] Invalid Number of Magic Effects on Transform Passive (Werebear) Spell, Expecting 6 but got " + WerebearTransformPassive.GetNumEffects())
    return
  EndIf
  If (TransformDefault.GetNumEffects() != 2)
    Debug.MessageBox(msg)
    Debug.Trace("[NIGHTMARE NIGHT] Invalid Number of Magic Effects on Transform Effect (Default) Spell, Expecting 2 but got " + TransformDefault.GetNumEffects())
    return
  EndIf
  If (TransformRingOfHircine.GetNumEffects() != 2)
    Debug.MessageBox(msg)
    Debug.Trace("[NIGHTMARE NIGHT] Invalid Number of Magic Effects on Transform Effect (Ring of Hircine) Spell, Expecting 2 but got " + TransformRingOfHircine.GetNumEffects())
    return
  EndIf
  If (WerewolfRace.GetSpellCount() != 7)
    Debug.MessageBox(msg)
    Debug.Trace("[NIGHTMARE NIGHT] Invalid Number of Magic Effects on Werewolf Race, Expeting 7 but got " + WerewolfRace.GetSpellCount())
    return
  ElseIf(!WerewolfRace.HasKeyword(NNWereBeastKW))
    Debug.MessageBox(msg)
    Debug.Trace("[NIGHTMARE NIGHT] Missing Keyword on Werewolf Race")
  EndIf
  If (WerebearRace.GetSpellCount() != 7)
    Debug.MessageBox(msg)
    Debug.Trace("[NIGHTMARE NIGHT] Invalid Number of Magic Effects on Werebear Race, Expeting 7 but got " + WerebearRace.GetSpellCount())
    return
  ElseIf(!WerebearRace.HasKeyword(NNWereBeastKW))
    Debug.MessageBox(msg)
    Debug.Trace("[NIGHTMARE NIGHT] Missing Keyword on Werebear Race")
  EndIf
EndEvent

