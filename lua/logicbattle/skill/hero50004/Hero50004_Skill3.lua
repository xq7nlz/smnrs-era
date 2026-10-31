--- @class Hero50004_Skill3 Grimm
Hero50004_Skill3 = Class(Hero50004_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50004_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.statConvert = nil

    --- @type number
    self.statPercent = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50004_Skill3:CreateInstance(id, hero)
    return Hero50004_Skill3(id, hero)
end

--- @return void
function Hero50004_Skill3:Init()
    self.statConvert = self.data.statConvert
    self.statPercent = self.data.statPercent

    self.myHero.battleHelper:BindingWithSkill_3(self)
end

--- @return number
--- @param target BaseHero
--- @param attack number
function Hero50004_Skill3:CalculateAttack(target, attack)
    if self.myHero:IsBoss() == false then
        return self.myHero.hp:GetValue() * self.statPercent + attack
    end

    return attack
end

return Hero50004_Skill3