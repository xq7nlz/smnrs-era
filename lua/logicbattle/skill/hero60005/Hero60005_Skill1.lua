--- @class Hero60005_Skill1 Carnifex
Hero60005_Skill1 = Class(Hero60005_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60005_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil

    --- @type number
    self.maxHpToKill = nil

    --- @type number
    self.effectChance = 0

    --- @type number
    self.effectType = 0

    --- @type number
    self.effectDuration = 0
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60005_Skill1:CreateInstance(id, hero)
    return Hero60005_Skill1(id, hero)
end

--- @return void
function Hero60005_Skill1:Init()
    self.effectType = self.data.effectType
    self.effectChance = self.data.effectChance
    self.effectDuration = self.data.effectDuration

    self.maxHpToKill = self.data.maxHpToKill

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetDamage(self.data.damage)

    self.myHero.battleHelper:BindingWithSkillActive(self)
end

---------------------------------------- BATTLE -----------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero60005_Skill1:UseActiveSkill()
    local instantKillResults = List()

    local targetList = TargetSelectorUtils.SelectTarget(self.myHero.battle, self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)
    local results = self.damageSkillHelper:UseDamageSkill(targetList)

    self:FocusTarget(targetList)

    local isEndTurn = true

    local i = 1
    while i <= targetList:Count() do
        local target = targetList:Get(i)
        if target:IsDead() == false and target.hp:GetStatPercent() < self.maxHpToKill and target:IsBoss() == false then
            local result = self:InstantKill(target)
            instantKillResults:Add(result)
        end
        i = i + 1
    end

    results:AddAll(instantKillResults)

    return results, isEndTurn
end

--- @return void
--- @param targetList List<BaseHero>
function Hero60005_Skill1:FocusTarget(targetList)
    local i = 1
    while i <= targetList:Count() do
        if self.myHero.randomHelper:RandomRate(self.effectChance) then
            local targetHero = targetList:Get(i)
            local tauntMark = TauntMark(self.myHero, targetHero, self.effectDuration)
            tauntMark:SetDuration(self.effectDuration)

            if targetHero.effectController:AddEffect(tauntMark) then
                tauntMark:InitToOtherAndMyTeam()
            end
        end
        i = i + 1
    end
end

--- @return number
--- @param target BaseHero
--- @param critRate number
function Hero60005_Skill1:GetCritRateByTarget(target, critRate)
    if target.hp:GetStatPercent() > self.data.hpTriggerCritRate then
        return 1
    end

    return critRate
end

--- @return BaseActionResult
--- @param target BaseHero
function Hero60005_Skill1:InstantKill(target)

    local result

    local instantKillResult = target.hp:Dead(self.myHero, TakeDamageReason.INSTANT_KILL)
    if instantKillResult == true then
        result = InstantKillResult(self.myHero, target)
    else
        result = ResistInstantKillResult(self.myHero, target)
    end

    ActionLogUtils.AddLog(self.myHero.battle, result)
    return result
end

return Hero60005_Skill1