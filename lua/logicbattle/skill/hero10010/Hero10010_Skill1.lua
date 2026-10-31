--- @class Hero10010_Skill1 Japulan
Hero10010_Skill1 = Class(Hero10010_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10010_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.damageTargetSelector = nil
    --- @type DamageSkillHelper
    self.damageSkillHelper = nil
    --- @type number
    self.statDebuffDuration = nil
    --- @type StatType
    self.statDebuffType = nil
    --- @type number
    self.statDebuffAmount = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10010_Skill1:CreateInstance(id, hero)
    return Hero10010_Skill1(id, hero)
end

--- @return void
function Hero10010_Skill1:Init()
    self.damageTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.damageTargetPosition,
            TargetTeamType.ENEMY, self.data.damageTargetNumber)

    self.statDebuffDuration = self.data.statDebuffDuration
    self.statDebuffType = self.data.statDebuffType
    self.statDebuffAmount = self.data.statDebuffAmount

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetActionPerTarget(self.InflictEffect)
    self.damageSkillHelper:SetDamage(self.data.damage)
end

---------------------------------------- Calculate ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero10010_Skill1:UseActiveSkill()
    local targetList = TargetSelectorUtils.SelectTarget(self.myHero.battle, self.myHero, self.data.damageTargetPosition,
            TargetTeamType.ENEMY, self.data.damageTargetNumber)

    local results = self.damageSkillHelper:UseDamageSkill(targetList)
    local isEndTurn = true

    return results, isEndTurn
end

--- @return void
--- @param target BaseHero
function Hero10010_Skill1:InflictEffect(target)
    local statChanger = StatChanger(false)
    statChanger:SetInfo(self.statDebuffType, StatChangerCalculationType.PERCENT_ADD, self.statDebuffAmount)

    local effect = StatChangerEffect(self.myHero, target, false)
    effect:SetDuration(self.statDebuffDuration)
    effect:AddStatChanger(statChanger)

    target.effectController:AddEffect(effect)
end

return Hero10010_Skill1