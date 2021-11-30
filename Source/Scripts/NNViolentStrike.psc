Scriptname NNViolentStrike extends ActiveMagicEffect  

Event OnEffectStart(Actor akTarget, Actor akCaster)
  Armor shield = akTarget.GetEquippedShield()
  If(shield)
    akTarget.RemoveItem(shield, abSilent = true)
  Else
    Weapon weap = akTarget.GetEquippedWeapon()
    If(weap)
      akTarget.RemoveItem(weap, abSilent = true)
    Else
      weap = akTarget.GetEquippedWeapon(true)
      If(weap)
        akTarget.RemoveItem(weap, abSilent = true)
      EndIf
    EndIf
  EndIf
EndEvent