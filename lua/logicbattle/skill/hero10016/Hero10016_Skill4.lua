--- @class Hero10016_Skill4 Croconile
Hero10016_Skill4 = Class(Hero10016_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10016_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.blockChance = nil
    --- @type number
    self.blockAmount = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10016_Skill4:CreateInstance(id, hero)
    return Hero10016_Skill4(id, hero)
end

--- @return void
function Hero10016_Skill4:Init()
    self.blockChance = self.data.blockChance
    self.blockAmount = self.data.blockAmount

    self.myHero.skillController:BindingWithSkill_4(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return number
--- @param target BaseHero
--- @param type DamageFormulaType
function Hero10016_Skill4:GetBlockDamageRate(target, type)
    if type == DamageFormulaType.BASIC_ATTACK or type == DamageFormulaType.ACTIVE_SKILL then
        local isBlock = self.myHero.randomHelper:RandomRate(self.blockChance)
        if isBlock == true then
            return self.blockAmount
        end
    end

    return 0
end

return Hero10016_Skill4