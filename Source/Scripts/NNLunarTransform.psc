Scriptname NNLunarTransform extends Quest
{Main Cycle Script for Hunger & Lunar Transformation}

;/
TODO:
- WW Hunters
- UI Stuff (FLASH YAY FINALLY)

- Wait for Feedback(?)
/;

NNMCM Property MCM Auto
PlayerWerewolfChangeScript Property WWQ Auto
Keyword Property WerebeastKeyword Auto

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

Actor[] Property SpiritPrey Auto
GlobalVariable Property WolfKillCount Auto

bool Property LunarTransform Auto Hidden
bool IsPreySpawned = false

Event OnUpdateGameTime()
  If(Game.GetPlayer().HasSpell(MCM.WerewolfImmunity) == false)
    ; Nothing to do if the Player isnt a Werebeast
    ; The cd will be enabled after changing once, so if the player turns through AP or the Companion Questline
    ; Their forced Transformation will do the starting here
    ; If he turns through NN, the Cd is started through there. Otherwise idk. Just transform I guess :<
    return
  EndIf

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
      ; Dont transform if were already shifted..
      If(Game.GetPlayer().HasKeyword(WerebeastKeyword))
        WWQ.ExtendToDawn()
        GoToState("SpawnSpirits")
      Else
        GoToState("Transform")
      EndIf
      return ; next Update is handled by Werewolf Quest
    ElseIf(!IsPreySpawned)
      GoToState("SpawnSpirits")
      return
    EndIf
  ElseIf(IsPreySpawned)
    DespawnSpiritPrey()
  EndIf

  CreateNextUpdate()
EndEvent

Function CreateNextUpdate()
  float g = GameHour.Value
  float update
  If(g < 5.0)
    update = 5.0 - g
  ElseIf(g > 19)
    update = 29.0 - g
  Else
    update = 19.0 - g
  EndIf
  If(update < 0.025)
    update = 0.025
  EndIf
  RegisterForSingleUpdateGameTime(update)
EndFunction

float Function TimeTill21()
  float gh = GameHour.Value
  If(gh < 21.00)
    ; If were below 21.00, figure out when 21.00 is
    float fg =  1 - gh + (gh as int)
    If(gh < 20)
      ; If below 20.00, (its til full hour + 1) until 21.00
      fg += 1
    ElseIf(fg < 0.03)
      fg = 0.03
    EndIf
    Debug.Trace("NIGHTMARE NIGHT - GameHour = " + gh + "TimeTill21 = " + fg)
    return fg
  Else
    ; 21.00 and 1.00
    Debug.Trace("NIGHTMARE NIGHT - GameHour = " + gh + "TimeTill21 = 0.025")
    return 0.025
  EndIf
EndFunction

State SpawnSpirits
  Event OnBeginState()
    ; Spirits spawn at 21.00
    RegisterForSingleUpdateGameTime(TimeTill21())
  EndEvent

  Event OnUpdateGameTime()
    SpawnSpiritPrey()
    GoToState("")
    CreateNextUpdate()
  EndEvent
EndState

State Transform
  Event OnBeginState()
    ; Earliest Time to transform is between 20 and 21
    float t = TimeTill21()
    If(t == 0.025)
      ; if past 21, spawn Spirit Prey & transform in the next hour
      SpawnSpiritPrey()
      t = Utility.RandomFloat(0.5, 1.0)
    ElseIf(t > 1)
      ; if still 19.xx, transform the player between 20.00 and 21.00
      t = Utility.RandomFloat(t - 1, t)
    Else
      ; if at 20.xx, transform the player between now and 21.00
      t = Utility.RandomFloat(0.025, t)
    EndIf
    Debug.Trace("NIGHTMARE NIGHT - Transformation in = " + t)
    RegisterForSingleUpdateGameTime(t)
    ; float gh = GameHour.Value
    ; float fg = 1 - gh + (gh as int)
    ; fg = Utility.RandomFloat(fg, fg + 1.0)
    ; ; Update will be somewhere within the next full hour (e.g. if cur time 19.xx transform is between 20.00 and 21.00)
    ; RegisterForSingleUpdateGameTime(fg)
    ; Debug.MessageBox("NIGHTMARE NIGHT - Update in " + fg)
  EndEvent

  Event OnUpdateGameTime()
    SpawnSpiritPrey()
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
  Spirit Prey
  Those are Bosses that spawn during the Night and vanish again at Dawn. Each of them grants
  the Player a special Perk. They can be hunted in either Beast or Human Form (though they are have
  fairly high stats which might make them feel unfair outside of beast form \o/)
  • Skeever: Scent of Blood differs between Friendly & Hostile
  • Deer: +10 Movement Speed out of Beast Form
  • Wolf: Howl of Pack inherits Stats from Player
  • Sabrecat: +15 Claw Damage, heal for 15 Hp with each Hit
  • Draugr: Howl of Terror +20 Magnitude & stops affected Enemies from moving until hit once
  • Dragon: Reduce Howl Cooldowns by 20%
======================================= /;
Function SpawnSpiritPrey()
  If(IsPreySpawned || MCM.bDisableSpirit)
    return
  EndIf
  IsPreySpawned = true
  int n = 0
  While(n < SpiritPrey.Length)
    If(!SpiritPrey[n].IsDead())
      SpiritPrey[n].Enable()
    ElseIf(n == 2 && WolfKillCount.Value < 32)
      SpiritPrey[n].Reset()
      WolfKillCount.Value = 0
    EndIf
    n += 1
  EndWhile
EndFunction

Function DespawnSpiritPrey()
  int i = 0
  While(i < SpiritPrey.Length)
    SpiritPrey[i].Disable(true)
    i += 1
  EndWhile
  IsPreySpawned = false
EndFunction
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

;/ =======================================
  Radiant Encounter Attacks from the Silverhand (IDEA: Add Vigilant Hunters?)
  Number of Silverhand Encounters will increase as the Player progresses through
  the Companions Questline. Once Kodlak dies, Encounters will be slightly less
======================================= /;
GlobalVariable Property NNWENextAttack Auto
Quest Property C04 Auto
Quest Property C06 Auto
Function SetNNWENextAttack()
	int DaysUntilNextAttack = 5 ;default value
  If(C06.IsCompleted())
    DaysUntilNextAttack += 1
  ElseIf(C04.IsCompleted())
    DaysUntilNextAttack -= 2
  EndIf
	NNWENextAttack.SetValue(GameDaysPassed.GetValue() + DaysUntilNextAttack)
	Debug.Trace(self + "SetNNWENextAttack() NNWENextAttack = " + NNWENextAttack.GetValue())
EndFunction