--- @class BonusDamageExtraTurnAndCC :  BonusDamageExtraTurn
BonusDamageExtraTurnAndCC = Class(BonusDamageExtraTurnAndCC, BonusDamageExtraTurn)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function BonusDamageExtraTurnAndCC:Ctor(initiator, target)
    BaseEffect.Ctor(self, initiator, target, EffectType.BONUS_DAMAGE_EXTRA_TURN_AND_CC, true)

    --- @type EffectType
    self.effectType = nil

    --- @type number
    self.effectDuration = nil
end

--- @return void
--- @param effectType EffectType
--- @param effectDuration number
function BonusDamageExtraTurnAndCC:SetCCEffectInfo(effectType, effectDuration)
    self.effectType = effectType
    self.effectDuration = effectDuration
end

--- @return number
--- @param target BaseHero
--- @param damage number
--- @param numberExtraTurn number
function BonusDamageExtraTurnAndCC:OnExtraTurn(target, damage, numberExtraTurn)
    damage = BonusDamageExtraTurn.OnExtraTurn(self, target, damage, numberExtraTurn)
    ---@type BaseEffect
    local ccEffect = EffectUtils.CreateCCEffect(self.myHero, target, self.effectType, self.effectDuration)
    target.effectController:AddEffect(ccEffect)

    return damage
end