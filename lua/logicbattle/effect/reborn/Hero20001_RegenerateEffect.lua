--- @class Hero20001_RegenerateEffect : BaseEffect
Hero20001_RegenerateEffect = Class(Hero20001_RegenerateEffect, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function Hero20001_RegenerateEffect:Ctor(initiator, target)
    BaseEffect.Ctor(self, initiator, target, EffectType.REBORN, true)

    --- @type StatChangerSkillHelper
    self.statChangerSkillHelper = nil

    --- @type BaseTargetSelector
    self.enemyTargetSelector = nil

    self.ignoreUpdate = true

    --- @type EffectType
    self.effectType = nil
    --- @type number
    self.effectChance = nil
    --- @type number
    self.effectDuration = nil
    --- @type number
    self.targetNumber = nil

    --- @type boolean
    self.isCanReborn = false

    --- @type table
    self.skillData = nil
end

--- @return RebornActionResult
--- @param isTransform boolean
function Hero20001_RegenerateEffect:CreateEffectResult(isTransform)
    return Hero20001_RegenerateActionResult(self.initiator, self.myHero, self.duration, isTransform)
end

--- @return void
--- @param skill BaseSkill
function Hero20001_RegenerateEffect:SetInfo(skill)
    self.skill = skill
    self.skillData = skill.data

    self.statChangerSkillHelper = StatChangerSkillHelper(skill, skill.data.bonuses)
    self.statChangerSkillHelper:SetPersistentType(EffectPersistentType.MANUAL_REMOVE)

    self.effectType = self.skillData.effect_1_type
    self.effectChance = self.skillData.effect_1_chance
    self.effectDuration = self.skillData.effect_1_duration

    self:SetDuration(self.skillData.round_reborn)

    --- Attack to enemy
    local targetPosition = self.skillData.target_position
    local targetNumber = self.skillData.target_number
    self.enemyTargetSelector = TargetSelectorBuilder.Create(self.myHero, targetPosition, TargetTeamType.ENEMY, targetNumber)
end

--- @return void
--- for updating logic
function Hero20001_RegenerateEffect:UpdateBeforeRound()
    if self.myHero:IsDead() == false then
        if self.ignoreUpdate == true then
            self.ignoreUpdate = false
            local result = self:CreateEffectResult(false)
            ActionLogUtils.AddLog(self.myHero.battle, result)
        else
            if self.isCanReborn then
                self:RebornToHero()
            else
                local result = self:CreateEffectResult(false)
                ActionLogUtils.AddLog(self.myHero.battle, result)
            end
        end
    end
end

--- @return void
--- for updating duration
function Hero20001_RegenerateEffect:UpdateAfterRound()
    if self.myHero:IsDead() == false then
        self:DecreaseDuration()
        if self:IsShouldRemove() then
            if self.isCanReborn == false then
                self.isShouldRemove = false
                self.isCanReborn = true
            end
        end
    end
end

---------------------------------------- Listeners ----------------------------------------
--- @return void
--- @param target BaseHero
--- call right before add effect to hero
function Hero20001_RegenerateEffect:OnEffectAdd(target)
    self.statChangerSkillHelper:AddStatChangerEffect(self.initiator, target)
end

--- @return void
--- @param target BaseHero
--- call right before remove effect from hero
function Hero20001_RegenerateEffect:OnEffectRemove(target)
    self.myHero.hp:RebornToHero()
end

--- @return void
function Hero20001_RegenerateEffect:RebornToHero()
    self.myHero.effectController:ForceRemove(self)
    self.myHero.effectController:ForceRemove(self.statChangerSkillHelper.statChangerEffect)

    self.myHero.isSpecialState = false

    self.duration = -1
    local result = self:CreateEffectResult(true)
    ActionLogUtils.AddLog(self.myHero.battle, result)

    self:StunEnemy()
end

--- @return void
function Hero20001_RegenerateEffect:StunEnemy()
    if self.myHero.randomHelper:RandomRate(self.effectChance) then
        local targetList = self.enemyTargetSelector:SelectTarget(self.myHero.battle)

        local i = 1
        while i <= targetList:Count() do
            local target = targetList:Get(i)
            local ccEffect = EffectUtils.CreateCCEffect(self.myHero, target, self.effectType, self.effectDuration)
            target.effectController:AddEffect(ccEffect)
            i = i + 1
        end
    end
end

return Hero20001_RegenerateEffect