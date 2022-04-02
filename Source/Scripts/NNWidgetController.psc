Scriptname NNWidgetController extends SKI_WidgetBase
{Control Script: Frenzy System}

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
; have to manipulate alpha here, vanilla already makes use of _visible
float Property _magickaAlpha = 100.0 AutoReadOnly

; Variables for Frenzy Buff
NNLunarTransform Lunar
GlobalVariable IsWerewolf
Spell BloodFrenzySpell
Perk BloodFrenzyPerk
Perk Bloodlust

; called after each Game Reload
Event OnWidgetReset()
  WidgetName = "Nightmare Night"
  ; setup():Void
  UI.Invoke("HUD Menu", WidgetRoot + ".setup")
  ; Define Frenzy Variables
  Lunar = (Self as Quest) as NNLunarTransform
  BloodFrenzySpell = Game.GetFormFromFile(0x9EB, "NightmareNight.esp") as Spell
  BloodFrenzyPerk = Game.GetFormFromFile(0x9ED, "NightmareNight.esp") as Perk
  Bloodlust = Game.GetFormFromFile(0x8F5, "NightmareNight.esp") as Perk
  IsWerewolf = Lunar.WWQ.IsWerewolf

  Actor Player = Game.GetPlayer()
  If(Player.HasSpell(BloodFrenzySpell))
    ; While caching would certainly be interesting, its a lot of work as I had to properly store the
    ; current progression of the bar somewhere, which I do not and - to my knowledge - cannot, 
    ; thus simply resetting Frenzy should be the more reliable step to take
    FrenzyEnd("", "", 0, none)
  EndIf
  If(Player.HasKeyword(Lunar.WerebeastKeyword) || Player.HasMagicEffectWithKeyword(Lunar.WWQ.NightmareRequiem))
    DisplayMagicka(false)
  EndIf

  RegisterForModEvent("NightmareNightFrenzyStart", "FrenzyStart")
  RegisterForModEvent("NightmareNightFrenzyEnd", "FrenzyEnd")
  RegisterForModEvent("NightmareNightFrenzyKill", "FrenzyKill")
EndEvent

Event FrenzyStart(string asEventName, string asStringArg, float level, form akSender)
  Debug.Trace("NIGHTMARE NIGHT - " + akSender + " FrenzyStart() -> level = " + level)
  Actor Player = Game.GetPlayer()
  If(level < 11)
    If(!Player.HasSpell(BloodFrenzySpell))
      RegisterForMenu("StatsMenu")
      RegisterForMenu("Journal Menu")
      RegisterForMenu("Loading Menu")
      RegisterForMenu("FavoritesMenu")
      RegisterForMenu("ContainerMenu")
      RegisterForMenu("MessageBoxMenu")
      RegisterForMenu("Console")
      RegisterForMenu("Console Native UI Menu")
    EndIf
    ; Werebears gain 100% more damage with fully stacked Blood Frenzy. Werewolves 75%
    float damage = (0.1 - 0.025 * IsWerewolf.Value) * level
    ; Werebears gain 25% more movement speed with fully stacked Blood Frenzy. Werewolves 60%
    float speed = (0.025 + 0.035 * IsWerewolf.Value) * level
    ; Both Werebears and Werewolves take an additional 5% Damage with each Frenzy Level
    float defense = 0.05 * level
    ; Debug.Trace("NIGHTMARE NIGHT - Blood Frenzy Effect Start - damage = " + damage + "; speed = " + speed + "; defense = " + defense)

    BloodFrenzyPerk.SetNthEntryValue(0, 1, damage) ; Damage
    BloodFrenzyPerk.SetNthEntryValue(2, 1, speed) ; Speed
    BloodFrenzyPerk.SetNthEntryValue(4, 0, defense) ; Inc Dmg Physical
    BloodFrenzyPerk.SetNthEntryValue(5, 0, defense) ; Inc Dmg Magical
  EndIf

  float[] nf = new float[2]
  If(Player.HasPerk(Bloodlust))
    nf[0] = 30
  Else
    nf[0] = 15
  EndIf
  nf[1] = level
  Debug.Trace("NIGHTMARE NIGHT - Duration = " + nf[0] + " Level = " + nf[1])
  ; progressfrenzy(duration:Number, level:Number):Void
  UI.InvokeFloatA("HUD Menu", WidgetRoot + ".progressfrenzy", nf)

  Player.RemoveSpell(BloodFrenzySpell)
  Player.AddSpell(BloodFrenzySpell, false)
EndEvent

Event FrenzyEnd(string asEventName, string asStringArg, float afNumArg, form akSender)
  Debug.Trace("NIGHTMARE NIGHT - Frenzy End")
  Game.GetPlayer().RemoveSpell(BloodFrenzySpell)
  Lunar.WWQ.FrenzyStacks.SetValue(0)
EndEvent

Event FrenzyKill(string asEventName, string asStringArg, float afNumArg, form akSender)
  Debug.Trace("NIGHTMARE NIGHT - Frenzy Kill")
  ; endfrenzy():Void
  UI.Invoke("HUD Menu", WidgetRoot + ".endfrenzy")
  DisplayMagicka(afNumArg)
EndEvent

Event OnMenuOpen(string menuName)
  ; pausefrenzy(pause:Boolean):Void
  UI.InvokeBool("HUD Menu", WidgetRoot + ".pausefrenzy", true)
  Utility.Wait(0.05)
  UI.InvokeBool("HUD Menu", WidgetRoot + ".pausefrenzy", false)
EndEvent

Function DisplayMagicka(bool display)
  NNMCM MCM = (Self as Quest) as NNMCM
  If(!MCM.bHideMagicka && !display)
    return
  EndIf
  float set = 0
  If(display)
    set = _magickaAlpha
  EndIf
  UI.SetNumber("HUD Menu", "_root.HUDMovieBaseInstance.Magica._alpha", set)
EndFunction

