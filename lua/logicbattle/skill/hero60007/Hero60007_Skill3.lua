--- @class Hero60007_Skill3 Rannantos
Hero60007_Skill3 = Class(Hero60007_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60007_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.healAmount = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60007_Skill3:CreateInstance(id, hero)
    return Hero60007_Skill3(id, hero)
end

--- @return void
function Hero60007_Skill3:Init()
    self.healAmount = self.data.healAmount

    self:AddHealByDiseaseMark()
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
function Hero60007_Skill3:GetHealAmount()
    return self.healAmount * self.myHero.attack:GetValue()
end

--- @return void
function Hero60007_Skill3:AddHealByDiseaseMark()
    local attackerTeam, defenderTeam = self.myHero.battle:GetTeam()
    local enemyTeam = TargetSelectorUtils.GetEnemyTeam(attackerTeam, defenderTeam, self.myHero.teamId)

    local targetList = enemyTeam:GetHeroList()
    local i = 1
    while i <= targetList:Count() do
        local target = targetList:Get(i)
        local markList = target.effectController:GetEffectWithType(EffectType.DISEASE_MARK_HEAL)

        if markList:Count() == 0 then
            local healByDiseaseMark = HealByDiseaseMark(self.myHero, target)
            healByDiseaseMark:AddHealingSkill(self)
            target.effectController:AddEffect(healByDiseaseMark)
        else
            local healByDiseaseMark = markList:Get(1)
            healByDiseaseMark:AddHealingSkill(self)
        end
        i = i + 1
    end
end

return Hero60007_Skill3