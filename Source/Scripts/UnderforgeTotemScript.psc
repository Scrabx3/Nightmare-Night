Scriptname UnderforgeTotemScript extends ObjectReference  


Shout Property Howl auto
WordOfPower Property HowlWord1 auto
WordOfPower Property HowlWord2 auto
WordOfPower Property HowlWord3 auto

VisualEffect Property Effect01 auto
VisualEffect Property Effect02 auto

CompanionsHousekeepingScript Property chs auto

; ================== NIGHTMARE NIGHT
GlobalVariable Property ActiveTotem Auto
int Property TotemID Auto
{0 for none, 1 for Detect Life, 2 for Summon, 3 for Fear}

Event OnActivate(ObjectReference akActivator)
	if (Game.GetPlayer() == akActivator && chs.PlayerHasBeastBlood)
		; Debug.Trace("WEREWOLF: Learning " + Howl + " via " + HowlWord1 + ", " + HowlWord2 + ", " + HowlWord3)
		Effect01.Play(self, 2.0, Game.GetPlayer())
		Effect02.Play(Game.GetPlayer(), 2.0, self)
		; NIGHTMARE NIGHT
		ActiveTotem.Value = TotemID
		; VANILLA
		chs.CurrentHowl = Howl
		chs.CurrentHowlWord1 = HowlWord1
		chs.CurrentHowlWord2 = HowlWord2
		chs.CurrentHowlWord3 = HowlWord3
	endif
EndEvent
