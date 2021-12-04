Scriptname NNLunarTransform extends Quest
{Main Cycle Script for Hunger & Lunar Transformation}

;/
TODO:
- Test Spirit Prey Draugr
- Implement Spirit Prey Sabrecat, Dragon and Deer
- UI Stuff (FLASH YAY FINALLY)

- Leveled Actor Lists for Haul or the Pack
- MCM Options
-- (Check on Moonlight Tales MCM Options bttttw)

- Wait for Feedback(?)
/;

NNMCM Property MCM Auto
PlayerWerewolfChangeScript Property WWQ Auto

GlobalVariable Property GameHour Auto
GlobalVariable Property GameDaysPassed Auto

GlobalVariable Property HungerLevel Auto
GlobalVariable Property HungerFeedings Auto
GlobalVariable Property HungerLastFeed Auto

Message[] Property MoonPhaseNotifies Auto
Message Property LunarTransformNotify Auto
ImageSpaceModifier Property LunarTransformFlashImod Auto
ImageSpaceModifier[] Property LunarTransformWarnImod Auto
Spell Property LunarTransformSpell Auto

Keyword Property WerebeastKeyword Auto

bool Property LunarTransform Auto Hidden


Event OnUpdateGameTime()
  ; Debug.MessageBox("NIGHTMARE NIGHT - Update Game Time")
  float g = GameHour.Value

  ; float daysPassed = GameDaysPassed.Value
  ; float hoursTillHunger = ((HungerLastFeed.Value + 1) - daysPassed) * 24
  ; If(hoursTillHunger <= 0)
  ;   If(HungerLevel.Value > 0)
  ;     HungerLevel.Value -= 1
  ;     ManageHunger()
  ;   Else
  ;     HungerFeedings.Value = 0
  ;   EndIf
  ;   HungerLastFeed.Value = daysPassed
  ;   hoursTillHunger = 24
  ; EndIf

  If(MCM.bLunarEnable && g >= 19.00 || g < 1.00)
    float moonphase = GetMoonphase()
    int moonphaseINT = moonphase as int
    If(moonphase < 1 && !(moonphase > 0 && moonphase < 0.5))
      ; Fullmoon 1st or 3rd day
      moonphase = 8
    EndIf
    MoonPhaseNotifies[moonphaseINT].Show()
    If(Utility.RandomFloat(0, 99.9) < MCM.LunarChances[moonphaseINT])
      UnregisterForUpdateGameTime()
      ; Dont transform if were already shifted..
      If(Game.GetPlayer().HasKeyword(WerebeastKeyword))

      Else
        GoToState("Transform")
      EndIf
      return ; next Update is handled by Werewolf Quest
    EndIf
  EndIf

  float hoursTillNight = 19.0 - g
  If(hoursTillNight <= 0)
    hoursTillNight = 24.0 + hoursTillNight
  EndIf
  RegisterForSingleUpdateGameTime(hoursTillNight)
  ; If(hoursTillHunger < hoursTillNight)
  ;   RegisterForSingleUpdateGameTime(hoursTillHunger)
  ; Else
  ;   RegisterForSingleUpdateGameTime(hoursTillNight)
  ; EndIf
EndEvent

State Transform
  Event OnBeginState()
    float gh = GameHour.Value
    float fg = 1 - gh + (gh as int)
    fg = Utility.RandomFloat(fg, fg + 1.0)
    ; Update will be somewhere within the next full hour (e.g. if cur time 19.xx transform is between 20.00 and 21.00)
    RegisterForSingleUpdateGameTime(fg)
    ; Debug.MessageBox("NIGHTMARE NIGHT - Update in " + fg)
  EndEvent

  Event OnUpdateGameTime()
    LunarTransform = true
    int imod = 2 ; HungerLevel.GetValueInt()
    ;/ All Imods have a Rampup time which is dependend on the Hunger Stage which colors the Screen dark red over time
      After the Initial Rampup time theres a 1.5s delay for a quick Flash which stays active for 0.8. During this time
      the color will fade into a greyish black. Over the following 2.5 seconds the Imod will fade out and dispel
      (E.g. 10 Seconds => 0s -> [RAMP UP] -> 5.2s -> [+1.5s] -> 6.7s -> [+0.8s] -> 7.5s -> [+2.5s] -> 10s)
    /;
    LunarTransformWarnImod[imod].Apply()
    float time
    If(imod == 0) ; - ; 5.2 (Total Dur: 10)
      time = 4.5
    ElseIf(imod == 1) ; 13.2 (Total Dur: 18)
      time = 12.5
    ElseIf(imod == 2) ; 21.2 (Total Dur: 26)
      time = 20.5
    Else ; ---------- ; 28.2 (Total Dur: 33)
      time = 27.5
    EndIf
    Utility.Wait(time) ; Waiting the RampUp Time
    LunarTransformNotify.Show()
    LunarTransformSpell.Cast(Game.GetPlayer())
    ; Reenabling Polling after Transformation ends
    GoToState("")
  EndEvent
EndState

;/ =======================================
  Hunger System; For every so and so many Feedings gain a few buffs or debuffs. This essentially mimics the Vampire Thirst System.. just different
  Hunger defines the warn time before a Lunar Transformation happens and includes the following Buffs & Debuffs:
  === Stage 0
  Disease Resistance -100% (negated)
  -50 Max Stamina

  === Stage 1
  Disease Resistance -50%

  === Stage 2

  === Stage 3
  +10% Movement Speed in and out of beastform

======================================= /;
Function ManageHunger()
  ; int stage = HungerLevel.GetValueInt()
  ; TODO: define Hunger Stages here
  ; NOTE: prbly not going to implement this due to NNs dynamic usually trying to punish you for feeding 
  ; .. which contradicts with the Hunger Systems attempt to force you into feeding
  ; Im also not sure what exactly to do with it. I want to avoid exclusively granting Stat Buffs & Debuffs everywhere
  ; But since Werebeasts have no access to magic or any other traits beyond "incredible physical strength" my options here are somewhat limited
EndFunction

;/ =======================================
  The Lunar Cycle
  - A Lunar Cycle is divided in 8 Phases, all lasting 3 Days each (-> 24 Days for one entire Phase)
  - The first day in a new Game is the 3rd day of Waxing Gibbous (the next night will be a Fragmented Full Moon)
  - Masser isnt tied to Gamedays, manipulating the Time (Date) is not affecting its phases
  - In Skyrim, Secunda is mimicing Masser and can be ignored for any Interaction

  Defining IDs:
  0 = Full Moon
  1 = Waning Gibbous
  2 = Second Quarter
  3 = Waning Cresent
  4 = New Moon
  5 = Waxing Cresent
  6 = First Quarter
  7 = Waxing Gibbous
======================================= /;
float Function GetMoonPhase()
  int daysPassed = GameDaysPassed.GetValueInt()
  ; If we are before 12.00, calcuate Moonphase based on the previous Night
  If(GameHour.Value < 12)
    daysPassed -= 1
  EndIf
  return ((daysPassed % 24) as float) / 3.0
EndFunction
