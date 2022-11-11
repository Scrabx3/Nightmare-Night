Scriptname NNWidgetController extends SKI_WidgetBase
{Control Script: Frenzy System}

String Property MagicaAlpha = "_root.HUDMovieBaseInstance.Magica._alpha" AutoReadOnly

String Function GetWidgetSource()
  return "NightmareNight/Frenzy.swf"
EndFunction

; Widget should only be visible while Frenzy is active
bool Property visible
  bool Function Get()
    return UI.GetBool(HUD_MENU, WidgetRoot + "._visible")
  EndFunction
EndProperty

; Default Positions for the Base Widget
float Property __width = 292.75 AutoReadOnly
float Property __height = 31.1 AutoReadOnly
float Property __x = 56.95 AutoReadOnly
float Property __y = 648.35 AutoReadOnly

; called after each Game Reload
Event OnWidgetReset()
  WidgetName = "Nightmare Night"
  ; setup():Void
  UI.Invoke("HUD Menu", WidgetRoot + ".setup")
  
  RegisterForMenu("StatsMenu")
  RegisterForMenu("Journal Menu")
  RegisterForMenu("Loading Menu")
  RegisterForMenu("FavoritesMenu")
  RegisterForMenu("ContainerMenu")
  RegisterForMenu("MessageBoxMenu")
  RegisterForMenu("Console")
  RegisterForMenu("Console Native UI Menu")

  RegisterForModEvent("NightmareNightFrenzyStart", "FrenzyStart")
EndEvent

Event FrenzyStart(string asEventName, string asStringArg, float afDuration, form akSender)
  UI.SetNumber("HUD Menu", "_root.HUDMovieBaseInstance.Magica._alpha", 0)

  float[] nf = new float[2]
  nf[0] = afDuration
  nf[1] = 0.0
  ; progressfrenzy(duration:Number, level:Number):Void
  UI.InvokeFloatA("HUD Menu", WidgetRoot + ".progressfrenzy", nf)
EndEvent

Event OnMenuOpen(string menuName)
  ; pausefrenzy(pause:Boolean):Void
  UI.InvokeBool("HUD Menu", WidgetRoot + ".pausefrenzy", true)
  Utility.Wait(0.05)
  UI.InvokeBool("HUD Menu", WidgetRoot + ".pausefrenzy", false)
EndEvent
