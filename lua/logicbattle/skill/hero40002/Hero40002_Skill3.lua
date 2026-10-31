--- @class Hero40002_Skill3 Yggra
Hero40002_Skill3 = Class(Hero40002_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40002_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.blockChance = nil

    --- @type number
    self.blockRate = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40002_Skill3:CreateInstance(id, hero)
    return Hero40002_Skill3(id, hero)
end

--- @return void
function Hero40002_Skill3:Init()
    self.blockChance = self.data.blockChance
    self.blockRate = self.data.blockRate

    local statChangerSkillHelper = StatChangerSkillHelper(self, self.data.bonuses)
    statChangerSkillHelper:AddStatChangerEffect(self.myHero, self.myHero)

    self.myHero.skillController:BindingWithSkill_3(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return number
--- @param target BaseHero
--- @param type DamageFormulaType
function Hero40002_Skill3:GetBlockDamageRate(target, type)
    if type == DamageFormulaType.BASIC_ATTACK or type == DamageFormulaType.ACTIVE_SKILL then
        local isBlock = self.myHero.randomHelper:RandomRate(self.blockChance)
        if isBlock == true then
            return self.blockRate
        end
    end

    return 0
end

return Hero40002_Skill3