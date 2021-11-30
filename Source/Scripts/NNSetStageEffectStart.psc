Scriptname NNSetStageEffectStart extends ActiveMagicEffect  

int Property StageToSet Auto
Quest Property QuestToSet Auto

Event OnEffectStart(Actor a, Actor b)
	QuestToSet.SetStage(StageToSet)
EndEvent