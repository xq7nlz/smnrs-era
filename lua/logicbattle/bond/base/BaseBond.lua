--- @class BaseBond
BaseBond = Class(BaseBond)

--- @return void
--- @param initiator BaseHero
--- @param type BondType
function BaseBond:Ctor(initiator, type)
    --- @type BaseHero
    self.initiator = initiator

    --- @type List<BaseHero>
    self.bondedHeroList = List()

    --- @type BondType
    self.type = type
end

--- @return void
--- @param hero BaseHero
function BaseBond:AddBondedHero(hero)
    self.bondedHeroList:Add(hero)
end

--- @return TakeDamageReason
--- @param reason TakeDamageReason
function BaseBond:GetTakeDamageReason(reason)
    if DamageUtils.IsDotDamage(reason) == true then
        return TakeDamageReason.BOND_DAMAGE_DOT
    else
        return TakeDamageReason.BOND_DAMAGE
    end
end

--- @return boolean
--- @param hero BaseHero
function BaseBond:IsContainBondedHero(hero)
    return self.bondedHeroList:IsContainValue(hero)
end

---------------------------------------- Listeners ----------------------------------------
--- @return number
--- @param damageInitiator BaseHero
--- @param target BaseHero
--- @param reason TakeDamageReason
--- @param damage number
function BaseBond:OnTakeDamage(damageInitiator, target, reason, damage)
    --- Override if needed
    return damage
end

--- @return void
--- @param ccEffect BaseEffect
function BaseBond:OnTakeCCEffect(ccEffect)
    --- Override if needed
end

--- @return boolean bond should be remove or not
--- @param hero BaseHero
function BaseBond:OnBondHeroRemove(hero)
    self.bondedHeroList:RemoveOneByReference(hero)

    --- Remove bond in case of bondedList have only 1 hero
    if self.bondedHeroList:Count() > 1 then
        return false
    else
        return true
    end
end