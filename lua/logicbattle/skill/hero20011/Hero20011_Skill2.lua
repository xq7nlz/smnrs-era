--- @class Hero20011_Skill2 Labord
Hero20011_Skill2 = Class(Hero20011_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20011_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type HeroClassType
    self.bonusClassHero = nil

    --- @type number
    self.bonusDamageWithClass = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero20011_Skill2:CreateInstance(id, hero)
    return Hero20011_Skill2(id, hero)
end

--- @return void
function Hero20011_Skill2:Init()
    self.bonusClassHero = self.data.bonusClassHero
    self.bonusDamageWithClass = self.data.bonusDamageWithClass

    local statChangerSkillHelper = StatChangerSkillHelper(self, self.data.bonuses)
    statChangerSkillHelper:AddStatChangerEffect(self.myHero, self.myHero)

    self.myHero.battleHelper:BindingWithSkill_2(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return number
--- @param target BaseHero
--- @param originMultiDamage number
function Hero20011_Skill2:GetDamage(target, originMultiDamage)
    if target.originInfo.class == self.bonusClassHero then
        return originMultiDamage * (1 + self.bonusDamageWithClass)
    end
    return originMultiDamage
end

return Hero20011_Skill2