--- @class Hero40027_Skill2 : BaseSkill Ariyuu
Hero40027_Skill2 = Class(Hero40027_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40027_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    ---@type BaseTargetSelector
    self.normalTargetSelector = nil

    ---@type BaseTargetSelector
    self.dragonTargetSelector = nil

    ---@type BaseEffect
    self.dragonBuffEffect = nil

    --- @type BaseEffect
    self.debuffEffect = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40027_Skill2:CreateInstance(id, hero)
    return Hero40027_Skill2(id, hero)
end

--- @return void
function Hero40027_Skill2:Init()
    self.myHero.attackListener:BindingWithSkill_2(self)
    self.myHero.skillController:BindingWithSkill_2(self)
    self.myHero.battleHelper:BindingWithSkill_2(self)
    self.myHero.attackController:BindingWithSkill_2(self)

    self:CreateTargetSelector()
end

--- @return void
function Hero40027_Skill2:CreateTargetSelector()
    self.normalTargetSelector = self.myHero.attackController.targetSelector
    self.dragonTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)
end

---------------------------------------- BATTLE -----------------------------------
--- @return void
--- @param target BaseHero
--- @param totalDamage number
function Hero40027_Skill2:TriggerHeal(target, totalDamage)
    local healAmount = self.data.healAmount * totalDamage
    HealUtils.Heal(self.myHero, self.myHero, healAmount, HealReason.HEAL_SKILL)
end

--- @return number
function Hero40027_Skill2:GetCritRateByTarget()
    return 1
end

--- @return void
--- @param isDragonForm boolean
function Hero40027_Skill2:OnTransform(isDragonForm)
    local targetSelector
    if isDragonForm == true then
        targetSelector = self.dragonTargetSelector

        local statChangerSkillHelper = StatChangerSkillHelper(self, self.data.bonuses)
        statChangerSkillHelper:SetPersistentType(EffectPersistentType.PERMANENT_REMOVABLE)
        self.dragonBuffEffect = statChangerSkillHelper:AddStatChangerEffect(self.myHero, self.myHero)
    else
        targetSelector = self.normalTargetSelector
        self.myHero.effectController:ForceRemove(self.dragonBuffEffect)
    end

    self.myHero.attackController:SetSelector(targetSelector)
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero40027_Skill2:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    -- human form
    if dodgeType == DodgeType.MISS then
        return
    end

    if (self.myHero.isDragonForm == true) then
        self:TriggerHeal(enemyDefender, totalDamage)
    else
        self:AddDebuffToTarget(enemyDefender)
    end
end

--- @return void
--- @param enemyDefender BaseHero
function Hero40027_Skill2:AddDebuffToTarget(enemyDefender)
    if self.debuffEffect ~= nil and enemyDefender.effectController:IsContainEffect(self.debuffEffect) then
        return
    end

    local listDebuff = enemyDefender.effectController:GetEffectWithType(EffectType.STAT_CHANGER)

    local totalDeBuffAmount = 0
    local i = 1
    while i <= listDebuff:Count() do
        local effectOnEnemy = listDebuff:Get(i)
        if self:IsAiryuuDebuff(effectOnEnemy.initiator, self.myHero, effectOnEnemy) then
            for j = 1, effectOnEnemy.statChangerList:Count() do
                local statChangeDebuff = effectOnEnemy.statChangerList:Get(j)
                totalDeBuffAmount = totalDeBuffAmount + statChangeDebuff.amount
            end
        end
        i = i + 1
    end

    if totalDeBuffAmount >= self.data.statDebuffMax then
        return
    end

    local newDeBuffAmount
    if self.data.statDebuffMax - totalDeBuffAmount > self.data.statDebuffAmount then
        newDeBuffAmount = self.data.statDebuffAmount
    else
        newDeBuffAmount = self.data.statDebuffMax - totalDeBuffAmount
    end

    self:CreateDebuff(enemyDefender, newDeBuffAmount)
end

--- @return void
--- @param enemyDefender BaseHero
--- @param amount number
function Hero40027_Skill2:CreateDebuff(enemyDefender, amount)
    local statChanger = StatChanger(false)
    statChanger:SetInfo(self.data.statDebuffType, self.data.statDebuffCalculationType, amount)

    self.debuffEffect = StatChangerEffect(self.myHero, enemyDefender, false)
    self.debuffEffect:SetDuration(self.data.statDebuffDuration)
    self.debuffEffect:AddStatChanger(statChanger)
    self.debuffEffect:SetInitiatorSkill(self)
    enemyDefender.effectController:AddEffect(self.debuffEffect)
end

--- @return void
--- @param hero BaseHero
--- @param otherHero BaseHero
--- @param debuffEffect BaseSkill
function Hero40027_Skill2:IsAiryuuDebuff(hero, otherHero, debuffEffect)
    if hero.id ~= otherHero.id then
        return false
    end

    if debuffEffect.initiatorSkill == nil then
        return false
    end

    if debuffEffect.initiatorSkill.id ~= self.id then
        return false
    end

    return true
end

return Hero40027_Skill2