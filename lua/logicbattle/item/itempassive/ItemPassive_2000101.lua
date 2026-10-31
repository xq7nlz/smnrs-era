--- @class ItemPassive_2000101 Talent passive First round benefit
ItemPassive_2000101 = Class(ItemPassive_2000101, BaseItemPassiveSkill)

--- @return void
--- @param id number id of talent level 10, 11, 12
--- @param hero BaseHero
function ItemPassive_2000101:Ctor(id, hero)
    BaseItemPassiveSkill.Ctor(self, id, hero)

    --- @type number
    self.blockChance = nil

    --- @type number
    self.blockAmount = nil

    --- @type number
    self.blockRound = nil

end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function ItemPassive_2000101:CreateInstance(id, hero)
    return ItemPassive_2000101(id, hero)
end

--- @return void
function ItemPassive_2000101:Init()
    self.blockChance = tonumber(self.data.fields.block_chance)
    self.blockAmount = tonumber(self.data.fields.block_amount)
    self.blockRound = tonumber(self.data.fields.block_round)

    self.myHero.hp:AddDamageItemPassive(self)

    local blockShield = TalentBlockShield(self.myHero, self.myHero, self.blockRound)
    self.myHero.effectController:AddEffect(blockShield)
end

--- @return number totalDamage
--- @param totalDamage number
--- @param type DamageFormulaType
--- @param reason TakeDamageReason
function ItemPassive_2000101:CalculateDamage(totalDamage, type, reason)
    local round = self.myHero.battle.battleRound
    if round.round ~= self.blockRound then
        return totalDamage
    end

    local isBlock = self.myHero.randomHelper:RandomRate(self.blockChance)
    if isBlock == true then
        local damage = totalDamage * (1 - self.blockAmount)
        local result = MagicShieldResult(self.myHero, self.myHero, reason, damage)
        ActionLogUtils.AddLog(self.myHero.battle, result)
        return damage
    else
        return totalDamage
    end
end

return ItemPassive_2000101