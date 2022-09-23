Scriptname NNSpiritPreyDraugrFearCloak extends ActiveMagicEffect  

ImageSpaceModifier Property fearImod Auto
Keyword Property Werebeast Auto
Idle Property Covering Auto ; This causes the wolf to hooooooowl. Which is kinda cool. Write that down, write that down!
Idle Property Bleedout Auto ; ... but not really fitting for our purpose here. Falling back to a default bleedout. Player cant really see anyway
float waited = 0.0
bool break

Event OnEffectStart(Actor akTarget, Actor akCaster)
  Debug.Trace(self + " OnEffectStart()")
  ; Player has 5 seconds to stop looking
  break = false
  waited = 0.0
  While(waited < 1)
    Utility.Wait(0.25)
    waited += 0.05
    fearImod.Apply(waited)
    If(break)
      fearImod.Remove()
      return
    EndIf
  EndWhile
  ; If they didnt break LOS until then, freeze them in place
  ; Debug.Trace(self + " player looked at the everfeared for 5 sec. Knocking them down <> waited = " + waited)
  GoToState("Bleedout")
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
  Debug.Trace(self + " OnEffectFinish() in Empty State")
  fearImod.Remove()
  break = true
EndEvent

State Bleedout
  Event OnBeginState()
    ; Game.DisablePlayerControls()
    Game.SetPlayerAIDriven(true)
    Debug.SendAnimationEvent(GetTargetActor(), "bleedoutstart")
    ; Keep you locked for 5sec
    RegisterForSingleUpdate(3.7)
  EndEvent
  
  Event OnUpdate()
    Dispel()
  EndEvent
  
  ; OnHit doesnt really work too well, not sure why but the Animation doesnt play here
  ; Reducing the Duration of the fear debuff total to compensate from 5 to 3.7
  ; Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
  ;   Debug.Trace(self + " OnHit() in Bleedout")
  ;   ; Debug.SendAnimationEvent(GetTargetActor(), "bleedoutstop")
  ;   ; ; Game.EnablePlayerControls()
  ;   ; Game.SetPlayerAIDriven(false)
  ;   Dispel()
  ; EndEvent

  Event OnEffectFinish(Actor akTarget, Actor akCaster)
    Debug.Trace(self + " OnEffectFinish() in Bleedout")
    Debug.SendAnimationEvent(akTarget, "bleedoutstop")
    ; Game.EnablePlayerControls()
    Game.SetPlayerAIDriven(false)
    Utility.Wait(1.3)
    fearImod.Remove()
    GoToState("")
  EndEvent
EndState


