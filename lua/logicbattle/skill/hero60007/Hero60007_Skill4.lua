--- @class Hero60007_Skill4 Rannantos
Hero60007_Skill4 = Class(Hero60007_Skill4, BaseSkill)

--- @return void
--- @param id number
--- @param hero BaseHero
function Hero60007_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.targetSelector = nil

    --- @type StatType
    self.buffStat = nil

    --- @type number
    self.buffAmount = nil

    --- @type number
    self.buffDuration = nil
end

--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero60007_Skill4:CreateInstance(id, hero)
    return Hero60007_Skill4(id, hero)
end

--- @return void
function Hero60007_Skill4:Init()
    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ALLY, self.data.targetNumber)

    self.buffStat = self.data.buffStat
    self.buffAmount = self.data.buffAmount
    self.buffDuration = self.data.buffDuration

    self.myHero.attackListener:BindingWithSkill_4(self)
    self.myHero.skillListener:BindingWithSkill_4(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero60007_Skill4:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    self:TriggerSkill(enemyAttacker)
end

--- @return void
--- @param enemy BaseHero
--- @param totalDamage number
function Hero60007_Skill4:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    self:TriggerSkill(enemy)
end

--- @return void
--- @param enemy BaseHero
function Hero60007_Skill4:TriggerSkill(enemy)
    if enemy.effectController:IsContainEffectType(EffectType.DISEASE_MARK) == true then
        local targetList = self.targetSelector:SelectTarget(self.myHero.battle)
        local i = 1
        while i <= targetList:Count() do
            local target = targetList:Get(i)

            local statChanger = StatChanger(true)
            statChanger:SetInfo(self.buffStat, StatChangerCalculationType.PERCENT_ADD, self.buffAmount)

            local effect = StatChangerEffect(self.myHero, target, true)
            effect:SetDuration(self.buffDuration)
            effect:AddStatChanger(statChanger)

            target.effectController:AddEffect(effect)
            i = i + 1
        end
    end
end

return Hero60007_Skill4
