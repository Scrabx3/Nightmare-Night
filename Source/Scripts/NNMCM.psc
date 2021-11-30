Scriptname NNMCM extends SKI_ConfigBase  

; -- General
String[] WolfkinList
int wolfkinIndex = 1
; -- Lunar Transformation
String[] LunarPresets
int lunarIndex = 1
float[] Property LunarChances Auto Hidden
float[] Property Skinwalker Auto Hidden

; =============================================================
; =============================== INIT
; =============================================================
Event OnConfigInit()
  RegisterForSingleUpdateGameTime(1)

  Pages = new String[1]
  Pages[0] = "$NN_pConfig"

  WolfkinList = new String[3]
  WolfkinList[0] = "$NN_WolfkinList_0" ; No Alliance
  WolfkinList[1] = "$NN_WolfkinList_1" ; Werebeast only
  WolfkinList[2] = "$NN_WolfkinList_2" ; Always

  LunarPresets = new String[4]
  LunarPresets[0] = "$NN_LunarPreset_0" ; Warg
  LunarPresets[1] = "$NN_LunarPreset_1" ; Skinwalker
  LunarPresets[2] = "$NN_LunarPreset_2" ; Cursed Blood
  LunarPresets[3] = "$NN_LunarPreset_3" ; Custom



  LunarChances = new float[9]
  SetLunarChances()

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
  AddHeaderOption("$NN_LunarTransformation")
  AddMenuOptionST("LunarPreset", "$NN_LunarPreset", LunarPresets[lunarIndex])
  AddEmptyOption()
  int flag = getFlag(lunarIndex == 3)
  AddSliderOptionST("LunarChance_4", "$NN_LunarChance_4", LunarChances[4], "{1}%", flag)
  AddSliderOptionST("LunarChance_5", "$NN_LunarChance_5", LunarChances[5], "{1}%", flag)
  AddSliderOptionST("LunarChance_6", "$NN_LunarChance_6", LunarChances[6], "{1}%", flag)
  AddSliderOptionST("LunarChance_7", "$NN_LunarChance_7", LunarChances[7], "{1}%", flag)
  AddSliderOptionST("LunarChance_0", "$NN_LunarChance_0", LunarChances[0], "{1}%", flag)
  AddSliderOptionST("LunarChance_1", "$NN_LunarChance_1", LunarChances[1], "{1}%", flag)
  AddSliderOptionST("LunarChance_2", "$NN_LunarChance_2", LunarChances[2], "{1}%", flag)
  AddSliderOptionST("LunarChance_3", "$NN_LunarChance_3", LunarChances[3], "{1}%", flag)
  AddSliderOptionST("LunarChance_8", "$NN_LunarChance_8", LunarChances[8], "{1}%", flag)
  int i = 0
  While(i < LunarChances.Length)
    
    i += 1
  EndWhile
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
    SetSliderOptionValueST(LunarChances[i])
  EndIf
EndEvent

Event OnDefaultST()
  String[] option = StringUtil.Split(GetState(), "_")
  If(option[0] == "LunarChance")
    int i = option[1] as int
    LunarChances[i] = Skinwalker[i]
    SetSliderOptionValueST(LunarChances[i])
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

; =============================================================
; =============================== UTILITY & MISC
; =============================================================
Function SetLunarChances()
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
  int flag = getFlag(lunarIndex == 3)
  int i = 0
  While(i < LunarChances.Length)
    SetOptionFlagsST(flag, i != 8, "LunarChance_" + i)
    i += 1
  EndWhile
EndFunction

int Function getFlag(bool option)
  If(option)
    return OPTION_FLAG_NONE
  Else
    return OPTION_FLAG_DISABLED
  EndIf
EndFunction