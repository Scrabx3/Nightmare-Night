Scriptname NNSpiritPrey extends Quest  

Function CheckCompletionConditions()
  int allStages = 60 ; !IMPORTANT update this whenever a new Prey is added
  int c = 0
  int i = 0
  While(i < AllStages)
    i += 10
    If(GetStageDone(i))
      c += 1
    EndIf
  EndWhile
  Debug.Trace("[Nightmare Night] Completed hunts: " + c)
  If(c * 10 == AllStages)
    Stop()
  EndIf
EndFunction
