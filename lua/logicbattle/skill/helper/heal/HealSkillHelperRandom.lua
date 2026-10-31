--- @class HealSkillHelperRandom : HealSkillHelper
HealSkillHelperRandom = Class(HealSkillHelperRandom, HealSkillHelper)

--- @return void
--- @param skill BaseSkill
function HealSkillHelperRandom:Ctor(skill)
    HealSkillHelper.Ctor(self, skill)

    --- @type number
    self.healChance = nil
end

--- @return void
--- @param healChance number
function HealSkillHelperRandom:SetHealChance(healChance)
    self.healChance = healChance
end

---------------------------------------- Use Heal skill ----------------------------------------
--- @return void
--- @param targetList List<BaseHero>
function HealSkillHelperRandom:UseHealSkill(targetList)
    if self.myHero.randomHelper:RandomRate(self.healChance) then
        local i = 1
        while i <= targetList:Count() do
            local target = targetList:Get(i)
            self:OnUseHealSkill(target)
            i = i + 1
        end
    end
end