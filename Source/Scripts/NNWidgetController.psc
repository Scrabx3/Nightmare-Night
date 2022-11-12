Scriptname NNWidgetController extends SKI_WidgetBase
{Control Script: Frenzy System}

String Property MagicaAlpha = "_root.HUDMovieBaseInstance.Magica._alpha" AutoReadOnly

; Override SkyUI. This is legacy support; Abort if the dll is loaded
Event OnWidgetManagerReady(string asEventName, string asStringArg, float afNumArg, form akSender)
	If(SKSE.GetPluginVersion("NightmareNight") > -1)
    return
  EndIf
  Parent.OnWidgetManagerReady(asEventName, asStringArg, afNumArg, akSender)
endEvent

String Function GetWidgetSource()
  return "./../../NightmareNight.swf"
EndFunction

; called after each Game Reload
Event OnWidgetReset()
  WidgetName = "Nightmare Night"
  
  RegisterForMenu("HUD MENU")
  RegisterForMenu("ContainerMenu")
  RegisterForMenu("Loading Menu")

  ; RegisterForMenu("StatsMenu")
  ; RegisterForMenu("Journal Menu")
  ; RegisterForMenu("Loading Menu")
  ; RegisterForMenu("ContainerMenu")
  ; RegisterForMenu("FavoritesMenu")
  ; RegisterForMenu("MessageBoxMenu")
  ; RegisterForMenu("Console")
  ; RegisterForMenu("Console Native UI Menu")

  RegisterForModEvent("NightmareNightFrenzyStart", "FrenzyStart")
  RegisterForModEvent("NightmareNightFrenzyEnd", "FrenzyEnd")
EndEvent

; Called by the Papyrus source when the spell is applied
Event FrenzyStart(string asEventName, string asFrenzyLevel, float afDuration, form akSender)
  UI.SetNumber("HUD Menu", MagicaAlpha, 0)
  GoToState("Active")
  
  UI.InvokeFloat("HUD Menu", WidgetRoot + "legacy.updateMeterDuration", afDuration)
  UI.InvokeFloat("HUD Menu", WidgetRoot + "main.updateMeterPercent", asFrenzyLevel as int)

  RegisterForSingleUpdate(afDuration)
EndEvent

; Called by the swf once the effect ends
Event FrenzyEnd(string asEventName, string asFrenzyLevel, float afDuration, form akSender)
  GoToState("")
EndEvent

State Active
  Event OnMenuOpen(string menuName)
    If(menuName == "HUD MENU")
      SetPaused(false)
    Else
      SetPaused(true)
      Utility.Wait(0.1)
      SetPaused(false)
    EndIf
  EndEvent

  Event OnMenuClose(string menuName)
    If(menuName == "HUD MENU")
      SetPaused(true)
    EndIf
  EndEvent
EndState

Function SetPaused(bool abPaused)
  If(abPaused)
    UI.InvokeBool("HUD Menu", WidgetRoot + ".legacy.pauseMeter", true)
  Else
    UI.InvokeBool("HUD Menu", WidgetRoot + ".legacy.resumeMeter", true)
  EndIf
EndFunction

Function SetVisible(bool abVisible)
  UI.SetBool("HUD Menu", WidgetRoot + ".legacy._visible", abVisible)
  UI.SetBool("HUD Menu", WidgetRoot + ".main._visible", abVisible)
EndFunction
