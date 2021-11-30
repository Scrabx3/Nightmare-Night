;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 7
Scriptname QF_NN_SpiritPrey_0501EE10 Extends Quest Hidden

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN AUTOCAST TYPE NNSpiritPrey
Quest __temp = self as Quest
NNSpiritPrey kmyQuest = __temp as NNSpiritPrey
;END AUTOCAST
;BEGIN CODE
; Killed Sabrecat

SetObjectiveCompleted(40)

kmyQuest.CheckCompletionConditions()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN AUTOCAST TYPE NNSpiritPrey
Quest __temp = self as Quest
NNSpiritPrey kmyQuest = __temp as NNSpiritPrey
;END AUTOCAST
;BEGIN CODE
; Killed Skeever

SetObjectiveCompleted(10)

kmyQuest.CheckCompletionConditions()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN AUTOCAST TYPE NNSpiritPrey
Quest __temp = self as Quest
NNSpiritPrey kmyQuest = __temp as NNSpiritPrey
;END AUTOCAST
;BEGIN CODE
; Killed Wolfes

SetObjectiveCompleted(30)

kmyQuest.CheckCompletionConditions()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
SetObjectiveDisplayed(10)
SetObjectiveDisplayed(20)
SetObjectiveDisplayed(30)
SetObjectiveDisplayed(40)
SetObjectiveDisplayed(50)
SetObjectiveDisplayed(60)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN AUTOCAST TYPE NNSpiritPrey
Quest __temp = self as Quest
NNSpiritPrey kmyQuest = __temp as NNSpiritPrey
;END AUTOCAST
;BEGIN CODE
; Killed Draugr

SetObjectiveCompleted(50)

kmyQuest.CheckCompletionConditions()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_6
Function Fragment_6()
;BEGIN AUTOCAST TYPE NNSpiritPrey
Quest __temp = self as Quest
NNSpiritPrey kmyQuest = __temp as NNSpiritPrey
;END AUTOCAST
;BEGIN CODE
; Killed Dragon

SetObjectiveCompleted(60)

kmyQuest.CheckCompletionConditions()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN AUTOCAST TYPE NNSpiritPrey
Quest __temp = self as Quest
NNSpiritPrey kmyQuest = __temp as NNSpiritPrey
;END AUTOCAST
;BEGIN CODE
; Killed Deer

SetObjectiveCompleted(20)

kmyQuest.CheckCompletionConditions()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
