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
    Debug.Trace("[NIGHTMARE NIGHT] Invalid Number of Magic Effects on WW Immunity Spell")
    return
  EndIf
  If (WerewolfTransformPassive.GetNumEffects() != 5)
    Debug.MessageBox(msg)
    Debug.Trace("[NIGHTMARE NIGHT] Invalid Number of Magic Effects on Transform Passive (Werewolf) Spell")
    return
  EndIf
  If (WerebearTransformPassive.GetNumEffects() != 6)
    Debug.MessageBox(msg)
    Debug.Trace("[NIGHTMARE NIGHT] Invalid Number of Magic Effects on Transform Passive (Werebear) Spell")
    return
  EndIf
  If (TransformDefault.GetNumEffects() != 2)
    Debug.MessageBox(msg)
    Debug.Trace("[NIGHTMARE NIGHT] Invalid Number of Magic Effects on Transform Effect (Default) Spell")
    return
  EndIf
  If (TransformRingOfHircine.GetNumEffects() != 2)
    Debug.MessageBox(msg)
    Debug.Trace("[NIGHTMARE NIGHT] Invalid Number of Magic Effects on Transform Effect (Ring of Hircine) Spell")
    return
  EndIf
  If (WerewolfRace.GetSpellCount() != 7 || !WerewolfRace.HasKeyword(NNWereBeastKW))
    Debug.MessageBox(msg)
    Debug.Trace("[NIGHTMARE NIGHT] Invalid Number of Magic Effects on Werewolf Race")
    return
  EndIf
  If (WerebearRace.GetSpellCount() != 7 || !WerebearRace.HasKeyword(NNWereBeastKW))
    Debug.MessageBox(msg)
    Debug.Trace("[NIGHTMARE NIGHT] Invalid Number of Magic Effects on Werebear Race")
    return
  EndIf
EndEvent

