--- @class Hero50003_Skill1 LifeKeeper
Hero50003_Skill1 = Class(Hero50003_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50003_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.enemyTargetSelector = nil

    --- @type BaseTargetSelector
    self.allyTargetSelector = nil

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil

    --- @type StealStatSkillHelper
    self.stealStatSkillHelper = nil

    --- @type StatType
    self.stealStatType = nil

    --- @type number
    self.statStealAmount = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50003_Skill1:CreateInstance(id, hero)
    return Hero50003_Skill1(id, hero)
end

--- @return void
function Hero50003_Skill1:Init()
    self.stealStatType = self.data.stealStatType
    self.statStealAmount = self.data.statStealAmount

    self.enemyTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.enemyTargetPosition,
            TargetTeamType.ENEMY, self.data.enemyTargetNumber)

    self.allyTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.allyTargetPosition,
            TargetTeamType.ALLY, self.data.allyTargetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetActionPerTarget(self.InflictEffect)
    self.damageSkillHelper:SetDamage(self.data.damage)

    self.stealStatSkillHelper = StealStatSkillHelper(self)
    self.stealStatSkillHelper:SetInfo(self.stealStatType)
end

---------------------------------------- Calculate Active skill ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero50003_Skill1:UseActiveSkill()
    local enemyTargetList = TargetSelectorUtils.SelectTarget(self.myHero.battle, self.myHero, self.data.enemyTargetPosition,
            TargetTeamType.ENEMY, self.data.enemyTargetNumber)
    local results = self.damageSkillHelper:UseDamageSkill(enemyTargetList)

    local stealAmount = self:StealStat(enemyTargetList)
    if stealAmount > 0 then
        local allyTargetList = self.allyTargetSelector:SelectTarget(self.myHero.battle)
        self:AddStat(allyTargetList, stealAmount)
    end

    local isEndTurn = true

    return results, isEndTurn
end

--- @return number
--- @param targetList List<BaseHero>
function Hero50003_Skill1:StealStat(targetList)
    local stealAmount = 0

    -- steal stat from enemy
    local i = 1
    while i <= targetList:Count() do
        local target = targetList:Get(i)
        if target:IsBoss() == false then
            local statToSteal = target:GetStat(self.stealStatType)
            local amount = statToSteal:GetMax() * self.statStealAmount

            self.stealStatSkillHelper:StealStat(target, amount)
            stealAmount = stealAmount + amount
        end

        i = i + 1
    end

    return stealAmount
end

--- @return void
--- @param targetList List<BaseHero>
--- @param amount number
function Hero50003_Skill1:AddStat(targetList, amount)
    if targetList:Count() > 0 then
        local amountPerTarget = amount / targetList:Count()
        local i = 1
        while i <= targetList:Count() do
            local target = targetList:Get(i)
            self.stealStatSkillHelper:AddStolenStat(target, amountPerTarget)
            i = i + 1
        end
    end
end

return Hero50003_Skill1