--- @class Hero10012_Skill1 Assassiren
Hero10012_Skill1 = Class(Hero10012_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10012_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.targetSelector = nil

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil

    --- @type number
    self.effectDrowningChance = 0
    --- @type number
    self.effectDrowningDuration = 0

    --- @type BaseSkill
    self.skill_4 = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10012_Skill1:CreateInstance(id, hero)
    return Hero10012_Skill1(id, hero)
end

--- @return void
function Hero10012_Skill1:Init()
    self.effectDrowningChance = self.data.effectDrowningChance
    self.effectDrowningDuration = self.data.effectDrowningDuration

    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetActionPerTarget(self.InflictEffect)
    self.damageSkillHelper:SetDamage(self.data.damage)
end

--- @return number
--- @param skill BaseSkill
function Hero10012_Skill1:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

---------------------------------------- Calculate ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero10012_Skill1:UseActiveSkill()
    local targetList = TargetSelectorUtils.SelectTarget(self.myHero.battle, self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)

    local results = self.damageSkillHelper:UseDamageSkill(targetList)
    local isEndTurn = true

    return results, isEndTurn
end

--- @return void
--- @param target BaseHero
function Hero10012_Skill1:InflictEffect(target)
    if self.myHero.randomHelper:RandomRate(self.effectDrowningChance) and target:IsBoss() == false then
        local drowningEffect = DrowningMark(self.myHero, target, self.effectDrowningDuration)

        if self.skill_4 ~= nil then
            drowningEffect:SetPersistentType(self.skill_4:GetPersistentDrowningEffect())
        end

        target.effectController:AddEffect(drowningEffect)
    end
end

return Hero10012_Skill1