--- @class Hero40027_BondEffect : BondEffect
Hero40027_BondEffect = Class(Hero40027_BondEffect, BondEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function Hero40027_BondEffect:Ctor(initiator, target)
    BondEffect.Ctor(self, initiator, target, false)

    self:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL_UPDATABLE)
end

function Hero40027_BondEffect:SetDuration(duration)
    self.duration = duration
end

--- @return void
--- @param target BaseHero
--- call right before remove effect from hero
function Hero40027_BondEffect:OnEffectRemove(target)
    BondEffect.OnEffectRemove(self, target)
    if self.initiator == self.myHero then
        local i = 1
        while i <= self.bond.bondedHeroList:Count() do
            local bondedHero = self.bond.bondedHeroList:Get(i)
            if bondedHero ~= self.initiator then
                local bondEffectList = bondedHero.effectController:GetEffectWithType(EffectType.BOND_EFFECT)
                for j = 1, bondEffectList:Count() do
                    local bondEffect = bondEffectList:Get(j)
                    if bondEffect.initiator == self.initiator and bondEffect.myHero == bondedHero then
                        bondedHero.effectController:ForceRemove(bondEffect)
                    end
                end
            end

            i = i + 1
        end
    end
end




