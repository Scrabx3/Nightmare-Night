Scriptname NNWidgetController extends SKI_WidgetBase
{ Control Script: Frenzy System }

Event OnWidgetManagerReady(string asEventName, string asStringArg, float afNumArg, form akSender)
	If(SKSE.GetPluginVersion("NightmareNight") > -1)
    return
  EndIf
  Debug.Trace("[NIGHTMARE NIGHT] OnWidgetManagerReady -> No dll found")
  Debug.MessageBox("[NIGHTMARE NIGHT] Loading Nightmare Night without its associated dll. This will create issues with frenzy mechanics")

  ; NOTE: This has scaling issues and Im too lazy to invest large amounts of time into figuering out how to fix it
  ; if you want to add legacy support for NN, feel free to uncomment and investiage and make PR on my github if you get it to work

  ; parent.OnWidgetManagerReady(asEventName, asStringArg, afNumArg, akSender)
EndEvent

String Function GetWidgetSource()
  return "NightmareNight_LEGACY.swf"
EndFunction

Event OnWidgetReset()
  Parent.OnWidgetReset()

  Debug.Trace("[NIGHTMARE NIGHT] On widget reset, loading HUD integrated Widget")
  WidgetName = "Nightmare Night"
  
  RegisterForMenu("HUD MENU")
  RegisterForMenu("ContainerMenu")
  RegisterForMenu("Loading Menu")
  RegisterForMenu("StatsMenu")
  RegisterForMenu("Journal Menu")
  RegisterForMenu("FavoritesMenu")
  RegisterForMenu("MessageBoxMenu")
  RegisterForMenu("Console Native UI Menu")
  RegisterForMenu("Console")

  RegisterForModEvent("NightmareNightFrenzyStart", "FrenzyStart")
  RegisterForModEvent("NightmareNightFrenzyEnd", "FrenzyEnd")
EndEvent

; Called by the Papyrus source when the spell is first applied
Event FrenzyStart(string asEventName, string asFrenzyLevel, float afDuration, form akSender)
  Debug.Trace("[NIGHTMARE NIGHT] Frenzy Start")
  Debug.Trace("[NIGHTMARE NIGHT] Invoking " + (WidgetRoot + ".main.show"))

  UI.Invoke("HUD MENU", WidgetRoot + ".main.show")
  UI.Invoke("HUD MENU", WidgetRoot + ".legacy.show")
  GoToState("Active")
  FrenzyStart(asEventName, asFrenzyLevel, afDuration, akSender)
EndEvent

State Active
  ; Called by the Papyrus source when the spell is reapplied
  Event FrenzyStart(string asEventName, string asFrenzyLevel, float afDuration, form akSender)
    UI.InvokeFloat("HUD Menu", WidgetRoot + ".legacy.updateMeterDuration", afDuration)
    UI.InvokeFloat("HUD Menu", WidgetRoot + ".main.updateMeterPercent", (asFrenzyLevel as int) * 10)
  EndEvent

  ; Called by the mod when frenzy ends by any means, including flash event
  Event FrenzyEnd(string asEventName, string asStringArg, float afNumArg, form akSender)
		UI.InvokeBool("HUD Menu", WidgetRoot + ".legacy.hide", false)
		UI.InvokeBool("HUD Menu", WidgetRoot + ".main.hide", false)
		UI.InvokeFloat("HUD Menu", WidgetRoot + ".main.updateMeterPercent", 0)
    GoToState("")
  EndEvent

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

Event FrenzyEnd(string asEventName, string asFrenzyLevel, float afDuration, form akSender)
EndEvent
Event FrenzyEndForce(string asEventName, string asStringArg, float afNumArg, form akSender)
EndEvent
