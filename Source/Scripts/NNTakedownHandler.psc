Scriptname NNTakedownHandler extends ActiveMagicEffect  

PlayerWerewolfChangeScript Property WWQ Auto
Perk Property NightmareNight Auto

GlobalVariable Property DLC1WerewolfFeedPoints Auto
{Num Takedowns since last Perk}
GlobalVariable Property DLC1WerewolfNextPerk Auto
{Takedowns required for next Perk}
GlobalVariable Property DLC1WerewolfPerkPoints Auto
{The current Number of Perks the Player has available (?)}
GlobalVariable Property DLC1WerewolfMaxPerks Auto
{Total Perks in the Skilltree (in Nightmare Night, this Number is 35, in Vanilla 11)}
GlobalVariable Property DLC1WerewolfTotalPerksEarned Auto
{Total Perks collected in this Playthrough}

Message Property DLC1FeedPointsMsg Auto
Message Property DLC1WerewolfPerkEarned Auto

Event OnDying(Actor akKiller)
  ; Debug.Trace("[NIGHTMARE NIGHT] Takedown handler kill registered, killer = " + akKiller)
  If(akKiller != Game.GetPlayer())
    return
  EndIf
  ;/ =======================================
    XP System
    Vanilla Xp Function is [5+2x] with x <= 11 -> 168 Feedings total
    Nightmare Night Xp Function will be [5+x] with x <= 35 -> 770 Kills total
    Consider that Killing is faster and easier to do than Feeding, I believe that despite the significant increase in required Points to collect, time spend on obtaining a new Perk wont be all too different to Vanilla
  ======================================= /;
  If(DLC1WerewolfTotalPerksEarned.Value < DLC1WerewolfMaxPerks.Value)
    DLC1WerewolfFeedPoints.Value += 1
    ; DLC1FeedPointsMsg.Show()
    If(DLC1WerewolfNextPerk.Value <= DLC1WerewolfFeedPoints.Value)
      DLC1WerewolfFeedPoints.Value -= DLC1WerewolfNextPerk.Value
      DLC1WerewolfPerkPoints.Value += 1
      DLC1WerewolfTotalPerksEarned.Value += 1
      DLC1WerewolfNextPerk.Value += 1 ; DLC1WerewolfNextPerk.Value + 2
      DLC1WerewolfPerkEarned.Show()
      ; Debug.Trace("NIGHTMARE NIGHT: New perk (Feed points " + DLC1WerewolfFeedPoints.Value +", Next perk " + DLC1WerewolfNextPerk.Value + ", Perk pionts " + DLC1WerewolfPerkPoints.value + ")")
    EndIf
  EndIf
  Game.GetPlayer().SetActorValue("WerewolfPerks", DLC1WerewolfFeedPoints.Value / DLC1WerewolfNextPerk.Value * 100)

  ;/ =======================================
    Blood Frenzy is a Buff the Player stacks whenever they kill something
    The purpose of this Block here is only the count up & maintain the Buff
    whenver something dies
  ======================================= /;
  WWQ.ApplyFrenzy(1 + akKiller.HasPerk(NightmareNight) as int)
EndEvent


;/ =======================================
  Vanilla XP Function:

  Event()
    DLC1WerewolfFeedPoints.Value += 1
    If(DLC1WerewolfTotalPerksEarned.Value < DLC1WerewolfMaxPerks.Value)
      DLC1FeedPointsMsg.Show()
      ; Debug.Trace("WEREWOLF: Feeding " + DLC1WerewolfFeedPoints.value)
      if DLC1WerewolfFeedPoints.Value >= DLC1WerewolfNextPerk.Value
        DLC1WerewolfFeedPoints.Value -= DLC1WerewolfNextPerk.Value
        DLC1WerewolfPerkPoints.Value += 1
        DLC1WerewolfTotalPerksEarned.Value += 1
        DLC1WerewolfNextPerk.Value = DLC1WerewolfNextPerk.Value + 2
        DLC1WerewolfPerkEarned.Show()
        ;	Debug.Trace("WEREWOLF: New perk (Feed points " + DLC1WerewolfFeedPoints.Value +", Next perk " + DLC1WerewolfNextPerk.Value + ", Perk pionts " + DLC1WerewolfPerkPoints.value + ")")
      endif
    endif
    Game.GetPlayer().SetActorValue("WerewolfPerks", DLC1WerewolfFeedPoints.Value / DLC1WerewolfNextPerk.Value * 100)				
    ; Debug.Trace("WEREWOLF: Actor value " + Game.GetPlayer().GetActorValue("WerewolfPerks") + ")")
  EndEvent()

  GlobalVariable Property DLC1WerewolfFeedPoints Auto
  GlobalVariable Property DLC1WerewolfNextPerk Auto
  GlobalVariable Property DLC1WerewolfPerkPoints Auto

  Message Property DLC1FeedPointsMsg Auto
  Message Property DLC1WerewolfPerkEarned Auto

  GlobalVariable Property DLC1WerewolfMaxPerks Auto  

  GlobalVariable Property DLC1WerewolfTotalPerksEarned Auto  
======================================= /;
