Scriptname NNNightmaresRequiem extends ActiveMagicEffect  

PlayerWerewolfChangeScript Property WWQuest Auto

Spell Property RequiemDispel Auto
Spell Property BloodFrenzyLv5 Auto
Spell[] Property WWAbilities Auto
Formlist Property CrimeFactions Auto
GlobalVariable Property FrenzyStacks Auto
Keyword Property BloodFrenzyKW Auto
Perk Property Wrath Auto

ImageSpaceModifier Property NightmareRequiemIntroImod Auto
ImageSpaceModifier Property NightmareRequiemImod Auto
ImageSpaceModifier Property NightmareRequiemOutroImot Auto

;/ =======================================
  Nightmares Requiem
  This is supposed to be some kind of "inbetween" Lycan Transformation. This Script acts as the
  Main Controller
======================================= /;
Event OnEffectStart(Actor akTarget, Actor akCaster)
  ; Disallow the Player to access their Inventory & blah
  ; Game.SetBeastForm(True)
  Game.EnableFastTravel(False)
  Game.DisablePlayerControls(abMovement = false, abFighting = false, abCamSwitch = true, abMenu = false, abActivate = false, abJournalTabs = false, aiDisablePOVType = 0)
  NightmareRequiemIntroImod.Apply()
  Utility.Wait(0.5)
  NightmareRequiemIntroImod.PopTo(NightmareRequiemImod)
  ; Inherit WW Abilities
  akTarget.AddSpell(RequiemDispel)
  akTarget.EquipSpell(RequiemDispel, 2)
  int i = 0
  While(i < WWAbilities.Length)
    akTarget.AddSpell(WWAbilities[i], false)
    i += 1
  EndWhile

  ; Make everyone hate you & alert them that you are a Werewolf.
  ; Might be a lil abstract considireing that youre not actually shifting but youre still going rampage, huh.. ayah
  ; Unlike the real Transformation people will still report crimes against you though
  akTarget.SetAttackActorOnSight(true)
  Game.SendWereWolfTransformation()
  int cfIndex = 0
  while (cfIndex < CrimeFactions.GetSize())
    (CrimeFactions.GetAt(cfIndex) as Faction).SetPlayerEnemy()
    cfIndex += 1
  endwhile

  ; While in this State you cant use Spells
  Spell left = akTarget.GetEquippedSpell(0)
  Spell right = akTarget.GetEquippedSpell(1)
  If(left != none)
    akTarget.UnequipSpell(left, 0)
  EndIf
  If(right != none)
    akTarget.UnequipSpell(right, 1)
  EndIf

  ; Set up the polling. This is primarily to handle Blood Frenzy
  ; COMEBACK: Convert into Register for Event if I move this into AS2..
  RegisterForUpdate(5)

  ; Set up Frenzy if you got Wrath
  If(akTarget.HasPerk(Wrath))
    FrenzyStacks.Value = 5
    BloodFrenzyLv5.Cast(akTarget)
  EndIf
EndEvent

Event OnUpdate()
  If(Game.GetPlayer().HasMagicEffectWithKeyword(BloodFrenzyKW) == false)
    FrenzyStacks.Value = 0
  EndIf
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
  ; Stuff no longer hates you
  akTarget.SetAttackActorOnSight(false)
  int cfIndex = 0
  while (cfIndex < CrimeFactions.GetSize())
    (CrimeFactions.GetAt(cfIndex) as Faction).SetPlayerEnemy(false)
    cfIndex += 1
  endwhile

  ; No moar WW Ability inheritance
  int i = 0
  While(i < WWAbilities.Length)
    akTarget.RemoveSpell(WWAbilities[i])
    i += 1
  EndWhile

  ; misc stuff
  NightmareRequiemImod.PopTo(NightmareRequiemOutroImot)
  Game.EnableFastTravel(true)
  Game.EnablePlayerControls()
EndEvent

