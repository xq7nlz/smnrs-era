--- @class Hero10007_BondEffect : BondEffect
Hero10007_BondEffect = Class(Hero10007_BondEffect, BondEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param isBuff boolean
function Hero10007_BondEffect:Ctor(initiator, target, isBuff)
    BondEffect.Ctor(self, initiator, target, isBuff)
    --- @type BaseHeroStat
    self.statChangerEffect = nil
end

--- @return void
--- @param effect BaseEffect
function Hero10007_BondEffect:SetStatChangerEffect(effect)
    self.statChangerEffect = effect
end

--- @return void
--- @param target BaseHero
--- call right before add effect to hero
function Hero10007_BondEffect:OnEffectAdd(target)
    BondEffect.OnEffectAdd(self, target)
    self:AddEffectStatChanger()
end

--- @return void
--- @param target BaseHero
--- call right before remove effect from hero
function Hero10007_BondEffect:OnEffectRemove(target)
    BondEffect.OnEffectRemove(self, target)
    if self.statChangerEffect ~= nil then
        self.myHero.effectController:ForceRemove(self.statChangerEffect)
    end
end

--- @return void
function Hero10007_BondEffect:AddEffectStatChanger()
    if self.statChangerEffect ~= nil then
        self.myHero.effectController:AddEffect(self.statChangerEffect)
    end
end