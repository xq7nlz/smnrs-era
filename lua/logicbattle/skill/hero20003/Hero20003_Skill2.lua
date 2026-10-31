--- @class Hero20003_Skill2 Eitri
Hero20003_Skill2 = Class(Hero20003_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20003_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    ---@type number
    self.effectChance = nil

    --- @type number
    self.healAmount = nil
end

--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero20003_Skill2:CreateInstance(id, hero)
    return Hero20003_Skill2(id, hero)
end

--- @return void
function Hero20003_Skill2:Init()
    self.effectChance = self.data.effectChance
    self.healAmount = self.data.healAmount

    self.myHero.attackListener:BindingWithSkill_2(self)
    self.myHero.skillListener:BindingWithSkill_2(self)
end

-----------------------------------------Battle---------------------------------------
--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero20003_Skill2:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    self:RemoveCC()
end

--- @return void
--- @param enemy BaseHero
--- @param totalDamage number
function Hero20003_Skill2:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    self:RemoveCC()
end

--- @return void
function Hero20003_Skill2:RemoveCC()
    if self.myHero.randomHelper:RandomRate(self.effectChance) then
        local amount = self.healAmount * self.myHero.hp:GetMax()
        local listCC = List()
        local i = 1
        while i <= self.myHero.effectController.effectList:Count() do
            local effectElement = self.myHero.effectController.effectList:Get(i)
            if effectElement:IsCCEffect() then
                listCC:Add(effectElement)
            end
            i = i + 1
        end

        i = 1
        while i <= listCC:Count() do
            local effectCC = listCC:Get(i)
            self.myHero.effectController:ForceRemove(effectCC)
            i = i + 1
        end

        if listCC:Count() > 0 then
            if amount > 0 then
                HealUtils.Heal(self.myHero, self.myHero, amount, HealReason.HEAL_SKILL)
            end
        end
    end
end

return Hero20003_Skill2