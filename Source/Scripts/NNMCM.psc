Scriptname NNMCM extends SKI_ConfigBase Conditional

Faction Property NightmareNightFaction Auto
Faction Property WerewolfFaction Auto
Faction Property WolfFaction Auto

PlayerVampireQuestScript Property VampireQ Auto
Keyword Property Vampire Auto
GlobalVariable Property PlayerIsWerewolf Auto ; Vanilla Flag
GlobalVariable Property IsWerewolf Auto ; Wolf or Bear?
Spell Property WerewolfTransform Auto
Spell Property WerewolfImmunity Auto
Spell Property CureDiseases Auto

GlobalVariable Property WerewolfPerks Auto
GlobalVariable Property WerewolfNextPerk Auto
Perk[] Property VanillaPerks Auto

; -- General
bool Property bWolfkinAlliance = false Auto Hidden Conditional
bool Property bTurnBackAnimation = true Auto Hidden
bool Property bTurnBackStagger = false Auto Hidden
bool Property bTurnBackNude = true Auto Hidden
; -- Spirit Prey
bool Property bDisableSpirit = false Auto Hidden
GlobalVariable Property gDisableHunters Auto
; -- NPC
String[] NPCTextures
int Property iNPCTex Auto Hidden
; -- Cosmetique
; String[] WolfTextures
; int Property WolfIndex = 0 Auto Hidden
String[] BearTextures
int Property BearIndex = 1 Auto Hidden
; -- UI
bool Property bHideMagicka = true Auto Hidden
; -- Debug
String[] Werebeasts
int iSetRace
; -- Lunar Transformation
bool Property bLunarEnable = true Auto Hidden
String[] LunarPresets
int lunarIndex = 1
float[] Property LunarChances Auto Hidden
float[] Property Skinwalker Auto Hidden

; =============================================================
; =============================== INIT
; =============================================================
Event OnConfigInit()
  RegisterForSingleUpdateGameTime(1)
  Actor Player = Game.GetPlayer()

  ; Set Wolves & Werewolves friendly to our own Faction for Kinship..
  WerewolfFaction.SetAlly(NightmareNightFaction, true, true)
  WolfFaction.SetAlly(NightmareNightFaction, true, true)
  ; If(Player.HasSpell(WerewolfTransform))
  ;   Debug.Notification("Wolves and Werewolves are now friendly towards you.")
  ; EndIf

  ; Reset Vanilla Perks..
  int incPerks = 0
  int i = 0
  While(i < VanillaPerks.Length)
    If(Player.HasPerk(VanillaPerks[i]))
      Player.RemovePerk(VanillaPerks[i])
      WerewolfPerks.Value += 1
      incPerks -= 1
    EndIf
    i += 1
  EndWhile
  Game.IncrementStat("NumWerewolfPerks", incPerks)
  WerewolfNextPerk.Value = WerewolfPerks.Value + 5

  ; Setup Menu
  Pages = new String[1]
  Pages[0] = "$NN_pConfig"

  LunarPresets = new String[4]
  LunarPresets[0] = "$NN_LunarPreset_0" ; Warg
  LunarPresets[1] = "$NN_LunarPreset_1" ; Skinwalker
  LunarPresets[2] = "$NN_LunarPreset_2" ; Cursed Blood
  LunarPresets[3] = "$NN_LunarPreset_3" ; Custom

  Werebeasts = new String[2]
  Werebeasts[0] = "$NN_Wererace_0" ; Werewolf
  Werebeasts[1] = "$NN_Wererace_1" ; Werebear

  BearTextures = new String[15]
  int s = 0
  While(s < BearTextures.Length)
    BearTextures[s] = "$NN_WerebearTex_" + s
    s += 1
  EndWhile

  NPCTextures = new String[3]
  NPCTextures[0] = "$NN_NPCText_0"
  NPCTextures[1] = "$NN_NPCText_1"
  NPCTextures[2] = "$NN_NPCText_2"

  LunarChances = new float[9]
  SetLunarChances(true)

  Skinwalker = new float[9]
  Skinwalker[0] = 100
  Skinwalker[1] = 45
  Skinwalker[2] = 20
  Skinwalker[3] = 5
  Skinwalker[4] = 0
  Skinwalker[5] = 10
  Skinwalker[6] = 25
  Skinwalker[7] = 50
  Skinwalker[8] = 15
EndEvent

; =============================================================
; =============================== MENU
; =============================================================
Event OnPageReset(string a_page)
  SetCursorFillMode(TOP_TO_BOTTOM)
  AddHeaderOption("$NN_General")
  AddToggleOptionST("WolfkinAlliance", "$NN_WolfkinAlliance", bWolfkinAlliance)
  AddToggleOptionST("TurnBackAnimation", "$NN_TurnBackAnimation", bTurnBackAnimation)
  AddToggleOptionST("TurnBackStagger", "$NN_TurnBackStagger", bTurnBackStagger)
  AddToggleOptionST("TurnBackNude", "$NN_TurnBackNude", bTurnBackNude)
  AddHeaderOption("$NN_WorldEncounters")
  AddToggleOptionST("EnableHunters", "$NN_Hunters", gDisableHunters.Value)
  AddToggleOptionST("DisableSpiritPrey", "$NN_SpiritDisable", bDisableSpirit)
  AddHeaderOption("$NN_Cosmetique")
  ; AddMenuOptionST("WerewolfTex", "$NN_WerewolfTex", WolfTextures[WolfIndex]) ; Waiting for Perms on this one
  AddMenuOptionST("WerebearTex", "$NN_WerebearTex", BearTextures[BearIndex])
  AddEmptyOption()
  AddHeaderOption("$NN_UI")
  AddToggleOptionST("HideMagicka", "$NN_HideMagicka", bHideMagicka)
  AddEmptyOption()
  AddEmptyOption()
  AddEmptyOption()
  AddHeaderOption("$NN_Debug")
  AddTextOptionST("TurnWerebeast", "$NN_TurnWerebeast", "")
  AddTextOptionST("CureWerebeast", "$NN_CureWerebeast", "")
  SetCursorPosition(1)
  AddHeaderOption("$NN_NPC")
  AddMenuOptionST("NPCTex", "$NN_NPCTexture", NPCTextures[iNPCTex])
  AddEmptyOption()
  AddHeaderOption("$NN_LunarTransformation")
  AddToggleOptionST("LunarEnable", "$NN_LunarEnable", bLunarEnable)
  AddMenuOptionST("LunarPreset", "$NN_LunarPreset", LunarPresets[lunarIndex])
  AddEmptyOption()
  int flag = getFlag(lunarIndex == 3)
  int i = 0
  While(i < LunarChances.Length)
    int n = (4 + i) % 9
    AddSliderOptionST("LunarChance_" + n, "$NN_LunarChance_" + n, LunarChances[n], "{1}%", flag)
    i += 1
  EndWhile
  AddHeaderOption("$NN_Debug")
  iSetRace = Math.abs(IsWerewolf.GetValueInt() - 1) as int
  AddMenuOptionST("SetRace", "$NN_SetRace", Werebeasts[iSetRace])
EndEvent

; =============================================================
; =============================== EMPTY STATE
; =============================================================
Event OnSliderOpenST()
  String[] option = StringUtil.Split(GetState(), "_")
  If(option[0] == "LunarChance")
    int i = option[1] as int
    SetSliderDialogStartValue(LunarChances[i])
    SetSliderDialogDefaultValue(Skinwalker[i])
    SetSliderDialogRange(0, 100)
    SetSliderDialogInterval(0.5)
  EndIf
EndEvent

Event OnSliderAcceptST(Float afValue)
  String[] option = StringUtil.Split(GetState(), "_")
  If(option[0] == "LunarChance")
    int i = option[1] as int
    LunarChances[i] = afValue
    SetSliderOptionValueST(LunarChances[i], "{1}%")
  EndIf
EndEvent

Event OnDefaultST()
  String[] option = StringUtil.Split(GetState(), "_")
  If(option[0] == "LunarChance")
    int i = option[1] as int
    LunarChances[i] = Skinwalker[i]
    SetSliderOptionValueST(LunarChances[i], "{1}%")
  EndIf
EndEvent

Event OnHighlightST()
  String[] option = StringUtil.Split(GetState(), "_")
  If(option[0] == "LunarChance")
    int i = option[1] as int
    SetInfoText("$NN_LunarChanceHighlight_" + i)
  EndIf
EndEvent

; =============================================================
; =============================== STATES
; =============================================================
State WolfkinAlliance
  Event OnSelectST()
    bWolfkinAlliance = !bWolfkinAlliance
    SetToggleOptionValueST(bWolfkinAlliance)
  EndEvent
  Event OnDefaultST()
    bWolfkinAlliance = false
    SetToggleOptionValueST(bWolfkinAlliance)
  EndEvent
  Event OnHighlightST()
    SetInfoText("$NN_WolfkinAllianceHighlight")
  EndEvent
EndState

State TurnBackAnimation
  Event OnSelectST()
    bTurnBackAnimation = !bTurnBackAnimation
    SetToggleOptionValueST(bTurnBackAnimation)
  EndEvent
  Event OnDefaultST()
    bTurnBackAnimation = true
    SetToggleOptionValueST(bTurnBackAnimation)
  EndEvent
  Event OnHighlightST()
    SetInfoText("$NN_TurnBackAnimationHighlight")
  EndEvent
EndState

State TurnBackStagger
  Event OnSelectST()
    bTurnBackStagger = !bTurnBackStagger
    SetToggleOptionValueST(bTurnBackStagger)
  EndEvent
  Event OnDefaultST()
    bTurnBackStagger = false
    SetToggleOptionValueST(bTurnBackStagger)
  EndEvent
  Event OnHighlightST()
    SetInfoText("$NN_TurnBackStaggerHighlight")
  EndEvent
EndState

State TurnBackNude
  Event OnSelectST()
    bTurnBackNude = !bTurnBackNude
    SetToggleOptionValueST(bTurnBackNude)
  EndEvent
  Event OnDefaultST()
    bTurnBackNude = true
    SetToggleOptionValueST(bTurnBackNude)
  EndEvent
  Event OnHighlightST()
    SetInfoText("$NN_TurnBackNudeHighlight")
  EndEvent
EndState

; ================= World Encounters
State EnableHunters
  Event OnSelectST()
    gDisableHunters.Value = Math.abs(gDisableHunters.Value - 1)
    SetToggleOptionValueST(gDisableHunters.Value)
  EndEvent
  Event OnDefaultST()
    gDisableHunters.Value = 0
    SetToggleOptionValueST(gDisableHunters.Value)
  EndEvent
  Event OnHighlightST()
    SetInfoText("$NN_HuntersHighlight")
  EndEvent
EndState

State DisableSpiritPrey
  Event OnSelectST()
    bDisableSpirit = !bDisableSpirit
    SetToggleOptionValueST(bDisableSpirit)
  EndEvent
  Event OnDefaultST()
    bDisableSpirit = false
    SetToggleOptionValueST(bDisableSpirit)
  EndEvent
  Event OnHighlightST()
    SetInfoText("$NN_SpiritDisableHighlight")
  EndEvent
EndState

; ================= NPC
State NPCTex
  Event OnMenuOpenST()
    SetMenuDialogStartIndex(iNPCTex)
    SetMenuDialogDefaultIndex(1)
    SetMenuDialogOptions(NPCTextures)
  EndEvent
  Event OnMenuAcceptST(Int aiIndex)
    iNPCTex = aiIndex
    SetMenuOptionValueST(NPCTextures[iNPCTex])
  EndEvent
  Event OnDefaultST()
    iNPCTex = 1
    SetMenuOptionValueST(NPCTextures[iNPCTex])
  EndEvent
  Event OnHighlightST()
    SetInfoText("$NN_NPCTextureHighlight")
  EndEvent
EndState

; ================= Cosmetique
State WerebearTex
  Event OnMenuOpenST()
    SetMenuDialogStartIndex(BearIndex)
    SetMenuDialogDefaultIndex(1)
    SetMenuDialogOptions(BearTextures)
  EndEvent
  Event OnMenuAcceptST(Int aiIndex)
    BearIndex = aiIndex
    SetMenuOptionValueST(BearTextures[BearIndex])
  EndEvent
  Event OnDefaultST()
    BearIndex = 1
    SetMenuOptionValueST(BearTextures[BearIndex])
  EndEvent
  Event OnHighlightST()
    SetInfoText("$NN_WerebearTexHighlight")
  EndEvent
EndState

; ================= Lunar Transformation
State LunarEnable
  Event OnSelectST()
    bLunarEnable = !bLunarEnable
    SetToggleOptionValueST(bLunarEnable)
  EndEvent
  Event OnDefaultST()
    bLunarEnable = false
    SetToggleOptionValueST(bLunarEnable)
  EndEvent
  Event OnHighlightST()
    SetInfoText("$NN_LunarEnableHighlight")
  EndEvent
EndState

State LunarPreset
  Event OnMenuOpenST()
    SetMenuDialogStartIndex(lunarIndex)
    SetMenuDialogDefaultIndex(1)
    SetMenuDialogOptions(LunarPresets)
  EndEvent
  Event OnMenuAcceptST(Int aiIndex)
    lunarIndex = aiIndex
    SetMenuOptionValueST(LunarPresets[lunarIndex])
    SetLunarChances()
  EndEvent
  Event OnDefaultST()
    lunarIndex = 1
    SetMenuOptionValueST(LunarPresets[lunarIndex])
    SetLunarChances()
  EndEvent
  Event OnHighlightST()
    SetInfoText("$NN_LunarPresetHighlight")
  EndEvent
EndState

; ================= UI
State HideMagicka
  Event OnSelectST()
    bHideMagicka = !bHideMagicka
    SetToggleOptionValueST(bHideMagicka)
  EndEvent
  Event OnDefaultST()
    bHideMagicka = true
    SetToggleOptionValueST(bHideMagicka)
  EndEvent
  Event OnHighlightST()
    SetInfoText("$NN_HideMagickaHighlight")
  EndEvent
EndState

; ================= Debug
State SetRace
  Event OnMenuOpenST()
    SetMenuDialogStartIndex(iSetRace)
    SetMenuDialogDefaultIndex(0)
    SetMenuDialogOptions(Werebeasts)
  EndEvent
  Event OnMenuAcceptST(Int aiIndex)
    SetMenuOptionValueST(Werebeasts[aiIndex])
    IsWerewolf.Value = Math.abs(aiIndex - 1)
  EndEvent
  Event OnHighlightST()
    SetInfoText("$NN_SetRaceHighlight")
  EndEvent
EndState

State TurnWerebeast
  Event OnSelectST()
    If(ShowMessage("$NN_TurnWerebeastMsg"))
      TurnWerebeast()
    EndIf
  EndEvent
  Event OnHighlightST()
    SetInfoText("$NN_TurnWerebeastHighlight")
  EndEvent
EndState

State CureWerebeast
  Event OnSelectST()
    If(ShowMessage("$NN_CureWerebeastMsg"))
      CureWerebeast()
    EndIf
  EndEvent
  Event OnHighlightST()
    SetInfoText("$NN_CureWerebeastHighlight")
  EndEvent
EndState

; =============================================================
; =============================== UTILITY & MISC
; =============================================================
Function TurnWerebeast()
  Actor pl = Game.GetPlayer()

  If(pl.HasKeyword(Vampire))
    VampireQ.VampireCure(pl)
  EndIf
  CureDiseases.Cast(pl)
  pl.AddSpell(WerewolfTransform, false)
  pl.AddSpell(WerewolfImmunity, false)

  PlayerIsWerewolf.Value = 1

  RegisterForSingleUpdateGameTime(1)
EndFunction

Function CureWerebeast()
  Actor pl = Game.GetPlayer()

  pl.RemoveSpell(WerewolfTransform)
  pl.RemoveSpell(WerewolfImmunity)

  PlayerIsWerewolf.Value = 0

  UnregisterForUpdateGameTime()
EndFunction

Function SetLunarChances(bool abInitialize = false)
  If(lunarIndex == 0) ; Warg
    LunarChances[0] = 100
    LunarChances[1] = 13
    LunarChances[2] = 8
    LunarChances[3] = 1
    LunarChances[4] = 0
    LunarChances[5] = 3
    LunarChances[6] = 10
    LunarChances[7] = 15
    LunarChances[8] = 20
  ElseIf(lunarIndex == 1) ; Skinwalker
    LunarChances[0] = 100
    LunarChances[1] = 45
    LunarChances[2] = 20
    LunarChances[3] = 5
    LunarChances[4] = 0
    LunarChances[5] = 10
    LunarChances[6] = 25
    LunarChances[7] = 50
    LunarChances[8] = 60
  ElseIf(lunarIndex == 2) ; Cursed Blood
    LunarChances[0] = 100
    LunarChances[1] = 70
    LunarChances[2] = 65
    LunarChances[3] = 60
    LunarChances[4] = 5
    LunarChances[5] = 65
    LunarChances[6] = 70
    LunarChances[7] = 75
    LunarChances[8] = 80
  EndIf
  If(!abInitialize)
    int flag = getFlag(lunarIndex == 3)
    int i = 0
    While(i < LunarChances.Length)
      String l = "LunarChance_" + i
      SetOptionFlagsST(flag, i != 7, l)
      SetSliderOptionValueST(LunarChances[i], "{1}%", i != 7, l)
      i += 1
    EndWhile
  EndIf
EndFunction

int Function getFlag(bool option)
  If(option)
    return OPTION_FLAG_NONE
  Else
    return OPTION_FLAG_DISABLED
  EndIf
EndFunction
