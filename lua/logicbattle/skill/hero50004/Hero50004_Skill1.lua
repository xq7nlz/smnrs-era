--- @class Hero50004_Skill1 Grimm
Hero50004_Skill1 = Class(Hero50004_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50004_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.allyTargetSelector = nil

    --- @type BaseTargetSelector
    self.enemyTargetSelector = nil

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil

    --- @type number
    self.effectBonusPercent = nil

    --- @type number
    self.effectDuration = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50004_Skill1:CreateInstance(id, hero)
    return Hero50004_Skill1(id, hero)
end

--- @return void
function Hero50004_Skill1:Init()
    self.allyTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.allyTargetPosition,
            TargetTeamType.ALLY, self.data.allyTargetNumber)
    self.allyTargetSelector:SetIncludeSelf(false)

    local listener = EventListener(self.myHero, self, self.OnHeroDead)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_DEAD, listener)

    self.enemyTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.enemyTargetPosition,
            TargetTeamType.ENEMY, self.data.enemyTargetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetDamage(self.data.damage)

    self.effectBonusPercent = self.data.effectBonusPercent
    self.effectDuration = self.data.effectDuration
end

---------------------------------------- Calculate Active skill ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero50004_Skill1:UseActiveSkill()
    local targetList = TargetSelectorUtils.SelectTarget(self.myHero.battle, self.myHero, self.data.enemyTargetPosition,
            TargetTeamType.ENEMY, self.data.enemyTargetNumber)

    local useDamageSkillResults = self.damageSkillHelper:UseDamageSkill(targetList)
    local useDivineShieldResults = self:SetDivineShield()
    local isEndTurn = true

    local results = useDamageSkillResults
    if useDivineShieldResults ~= nil then
        results:Add(useDivineShieldResults)
    end

    return results, isEndTurn
end

--- @return BaseActionResult
function Hero50004_Skill1:SetDivineShield()
    local targetList = self.allyTargetSelector:SelectTarget(self.myHero.battle)

    --- @type List<BaseHero>
    local allyList = List()
    local i = 1
    while i <= targetList:Count() do
        local target = targetList:Get(i)
        if target:IsDead() == false then
            allyList:Add(target)
        end
        i = i + 1
    end

    if allyList:Count() > 0 then
        local attackPercent = self.effectBonusPercent / allyList:Count()
        local divineShield = self:SetDivineShieldForAlly(self.myHero, allyList, attackPercent, self.effectDuration)
        return DivineShieldResult(self.myHero, self.myHero, self.effectDuration, 0, divineShield.hp)
    end

    return nil
end

--- @return DivineShield
--- @param initial BaseHero
--- @param allyList List<BaseHero>
--- @param attackPercent number
--- @param effectDuration number
function Hero50004_Skill1:SetDivineShieldForAlly(initial, allyList, attackPercent, effectDuration)
    local divineShield
    local i = 1
    while i <= allyList:Count() do
        local target = allyList:Get(i)

        divineShield = DivineShield(initial, target)
        divineShield:SetInfo(attackPercent, effectDuration)

        --- @type DivineShield
        local shield = target.effectController:GetDistinctEffectWithType(EffectType.DIVINE_SHIELD)
        if shield == nil then
            target.effectController:AddEffect(divineShield)
        else
            if self:IsCanReplaceShield(shield, divineShield) then
                target.effectController:ForceRemove(shield)
                target.effectController:AddEffect(divineShield)
            end
        end

        i = i + 1
    end

    return divineShield
end

--- @return boolean
--- @param oldShield DivineShield
--- @param newShield DivineShield
function Hero50004_Skill1:IsCanReplaceShield(oldShield, newShield)
    if oldShield.hp > newShield.hp then
        return false
    end

    if oldShield.hp == newShield.hp and oldShield.duration > newShield.duration then
        return false
    end

    return true
end

--- @return void
--- @param eventData table
function Hero50004_Skill1:OnHeroDead(eventData)
    if eventData.target == self.myHero then
        local targetList = self.allyTargetSelector:SelectTarget(self.myHero.battle)
        local i = 1
        while i <= targetList:Count() do
            local target = targetList:Get(i)

            --- @type DivineShield
            local shield = target.effectController:GetDistinctEffectWithType(EffectType.DIVINE_SHIELD)
            if shield ~= nil and shield.initiator == self.myHero then
                shield:AddRemoveActionLog()
                target.effectController:ForceRemove(shield)
            end
            i = i + 1
        end
    end
end

return Hero50004_Skill1