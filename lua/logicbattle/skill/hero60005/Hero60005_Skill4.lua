--- @class Hero60005_Skill4 Carnifex
Hero60005_Skill4 = Class(Hero60005_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60005_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type List<table>
    self.chanceAndBonus = List()
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60005_Skill4:CreateInstance(id, hero)
    return Hero60005_Skill4(id, hero)
end

--- @return void
function Hero60005_Skill4:Init()
    self.myHero.attackController:BindingWithSkill(self)
end

--------------------------------------------BATTLE--------------------------------------
--- @return number
function Hero60005_Skill4:GetNumberAttack()
    local i = 1
    while i <= self.data.chanceAndBonus:Count() do
        local rateResult = self.myHero.randomHelper:RandomFloat01()

        local bonusInfo = self.data.chanceAndBonus:Get(i)
        if rateResult > bonusInfo.chance then
            return i
        end
        i = i + 1
    end

    return i
end

--- @return void
--- @param attackNumber number
function Hero60005_Skill4:GetAttackDamageMultiplier(attackNumber)
    return 1
end

return Hero60005_Skill4