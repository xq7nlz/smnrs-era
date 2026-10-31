--- @class HealByDiseaseMark : BaseEffect
HealByDiseaseMark = Class(HealByDiseaseMark, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function HealByDiseaseMark:Ctor(initiator, target)
    BaseEffect.Ctor(self, initiator, target, EffectType.DISEASE_MARK_HEAL, false)
    self:SetPersistentType(EffectPersistentType.MANUAL_REMOVE)

    --- @type List<BaseSkill>
    self.healingSkills = List()
end

--- @return void
--- @param healingSkill BaseSkill
function HealByDiseaseMark:AddHealingSkill(healingSkill)
    self.healingSkills:Add(healingSkill)
end

---------------------------------------- Listeners ----------------------------------------
--- @return void
--- @param target BaseHero
--- call right before add effect to hero
function HealByDiseaseMark:OnEffectAdd(target)
    target.effectController.effectListener:Register(EffectListenerType.TAKE_BASIC_ATTACK_DAMAGE, self)
    target.effectController.effectListener:Register(EffectListenerType.TAKE_SKILL_DAMAGE, self)
end

--- @return void
--- @param target BaseHero
--- call right before remove effect from hero
function HealByDiseaseMark:OnEffectRemove(target)
    target.effectController.effectListener:Unregister(EffectListenerType.TAKE_BASIC_ATTACK_DAMAGE, self)
    target.effectController.effectListener:Unregister(EffectListenerType.TAKE_SKILL_DAMAGE, self)
end

--- @return number modified damage
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function HealByDiseaseMark:OnBeAttacked(enemyAttacker, totalDamage)
    if self.myHero.effectController:IsContainEffectType(EffectType.DISEASE_MARK) then
        local skill = self:GetHighestHealingSkill()
        if skill ~= nil then
            local healAmount = skill:GetHealAmount()
            HealUtils.Heal(skill.myHero, enemyAttacker, healAmount, HealReason.DISEASE_MARK)
        end
    end

    return BaseEffect.OnBeAttacked(self, enemyAttacker, totalDamage)
end

--- @return number modified damage
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function HealByDiseaseMark:OnTakeSkillDamageFromEnemy(enemyAttacker, totalDamage)
    if self.myHero.effectController:IsContainEffectType(EffectType.DISEASE_MARK) then
        local skill = self:GetHighestHealingSkill()
        if skill ~= nil then
            local healAmount = skill:GetHealAmount()
            HealUtils.Heal(skill.myHero, enemyAttacker, healAmount, HealReason.DISEASE_MARK)
        end
    end

    return BaseEffect.OnTakeSkillDamageFromEnemy(self, enemyAttacker, totalDamage)
end

--- @return BaseSkill
function HealByDiseaseMark:GetHighestHealingSkill()
    local maxSkill
    local maxHeal = 0

    local i = 1
    while i <= self.healingSkills:Count() do
        local skill = self.healingSkills:Get(i)

        if skill.myHero:IsDead() == false then
            local heal = skill:GetHealAmount()

            if maxSkill == nil then
                maxSkill = skill
                maxHeal = heal
            else
                if heal > maxHeal then
                    maxSkill = skill
                    maxHeal = heal
                end
            end
        end
        i = i + 1
    end

    return maxSkill
end