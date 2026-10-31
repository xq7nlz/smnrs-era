--- @class BondManager
BondManager = Class(BondManager)

--- @return void
function BondManager:Ctor()
    --- @type List<BaseBond>
    self._bondList = List()

    --- @type List<BaseEffect>
    self._spreadedEffect = List()
end

---------------------------------------- Getters ----------------------------------------
--- @return List<BaseBond>
function BondManager:GetBondList()
    return self._bondList
end

---------------------------------------- Setters ----------------------------------------
--- @return void
--- @param bond BaseBond
function BondManager:AddBond(bond)
    self._bondList:Add(bond)
end

--- @return boolean
--- @param reason TakeDamageReason
function BondManager:CanSpreadDamage(reason)
    if DamageUtils.IsBondDamage(reason) or DamageUtils.IsInstantKillDamage() then
        return false
    end
    return true
end

--- @return boolean
--- @param effect BaseEffect
function BondManager:CanSpreadEffect(effect)
    if self._spreadedEffect:IsContainValue(effect) then
        return false
    end
    return true
end

---------------------------------------- Listeners ----------------------------------------
--- @return void
function BondManager:UpdatePerTurn()
    self._spreadedEffect:Clear()
end

--- @return number
--- @param damageInitiator BaseHero
--- @param target BaseHero
--- @param reason TakeDamageReason
--- @param damage number
function BondManager:OnTakeDamage(damageInitiator, target, reason, damage)
    if damage > 0 and self:CanSpreadDamage(reason) and self._bondList:Count() > 0 then
        for _, bond in pairs(self._bondList:GetItems()) do
            if bond:IsContainBondedHero(target) then
                damage = bond:OnTakeDamage(damageInitiator, target, reason, damage)
            end
        end
    end
    return damage
end

--- @return void
--- @param effect BaseEffect
function BondManager:OnTakeEffect(effect)
    if effect:IsCCEffect() and self:CanSpreadEffect(effect) and self._bondList:Count() > 0 then
        self._spreadedEffect:Add(effect)
        local target = effect.myHero

        for _, bond in pairs(self._bondList:GetItems()) do
            if bond:IsContainBondedHero(target) then
                bond:OnTakeCCEffect(effect)
            end
        end
    end
end

--- @return void
--- @param bond BaseBond
--- @param hero BaseHero
function BondManager:OnBondEffectRemove(bond, hero)
    if bond:OnBondHeroRemove(hero) then
        self._bondList:RemoveOneByReference(bond)
    end
end