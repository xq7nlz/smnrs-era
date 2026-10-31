--- @class Hero50007_Skill1 Celestia
Hero50007_Skill1 = Class(Hero50007_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50007_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    ---@type BaseTargetSelector
    self.damageTargetSelector = nil

    ---@type BaseTargetSelector
    self.buffTargetSelector = nil

    --- @type number
    self.healAmount = nil

    --- @type number
    self.effectChance = nil

    --- @type number
    self.effectDuration = nil
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50007_Skill1:CreateInstance(id, hero)
    return Hero50007_Skill1(id, hero)
end

--- @return void
function Hero50007_Skill1:Init()
    self.effectType = self.data.effectType
    self.healAmount = self.data.healAmount

    self.damageTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.damageTargetPosition, TargetTeamType.ENEMY, self.data.damageTargetNumber)

    self.buffTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.buffTargetPosition, TargetTeamType.ALLY, self.data.buffTargetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetDamage(self.data.damage)
end

---------------------------------------- BATTLE -----------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero50007_Skill1:UseActiveSkill()
    local targetList = TargetSelectorUtils.SelectTarget(self.myHero.battle, self.myHero, self.data.damageTargetPosition,
            TargetTeamType.ENEMY, self.data.damageTargetNumber)
    local result = self.damageSkillHelper:UseDamageSkill(targetList)

    self:BuffHeal()
    self:CastDispelEffect()

    local isEndTurn = true

    return result, isEndTurn
end

--- @return void
function Hero50007_Skill1:BuffHeal()
    local amount = self.healAmount * self.myHero.hp:GetMax()
    if amount > 0 then
        HealUtils.Heal(self.myHero, self.myHero, amount, HealReason.HEAL_SKILL)
    end
end

--- @return void
function Hero50007_Skill1:CastDispelEffect()
    local targetList = self.buffTargetSelector:SelectTarget(self.myHero.battle)
    local i = 1
    while i <= targetList:Count() do
        local ally = targetList:Get(i)
        ally.effectController:DispelDebuff()
        i = i + 1
    end
end

return Hero50007_Skill1