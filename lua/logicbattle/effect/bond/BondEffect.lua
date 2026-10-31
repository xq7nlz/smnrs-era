--- @class BondEffect
BondEffect = Class(BondEffect, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param isBuff boolean
function BondEffect:Ctor(initiator, target, isBuff)
    BaseEffect.Ctor(self, initiator, target, EffectType.BOND_EFFECT, isBuff)

    --- @type BaseBond
    self.bond = nil
end

--- @return void
--- @param bond BaseBond
function BondEffect:BindingWithBond(bond)
    self.bond = bond
end

---------------------------------------- Listeners ----------------------------------------
--- @return void
--- @param target BaseHero
--- call right before remove effect from hero
function BondEffect:OnEffectRemove(target)
    if self.bond.bondedHeroList:Count() > 1 then
        self.myHero.battle.bondManager:OnBondEffectRemove(self.bond, self.myHero)
    end
end

--- @return void
function BondEffect:UpdateBeforeRound()
    if self.myHero == self.bond.initiator then
        if self.bond.bondedHeroList:Count() < 1 then
            self.isShouldRemove = true
        end
    end
end

--- @return void
function BondEffect:UpdateAfterRound()
    if self.bond.bondedHeroList:Count() > 1 then
        BaseEffect.UpdateAfterRound(self)
    else
        self.isShouldRemove = true
    end

    if self:IsShouldRemove() then
        self.duration = -1
    end
end