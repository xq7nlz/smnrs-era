--- @class Hero50001_Skill1 AmiableAngel
Hero50001_Skill1 = Class(Hero50001_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50001_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.enemyTargetSelector = nil
    --- @type BaseTargetSelector
    self.allyTargetSelector = nil

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil

    --- @type number
    self.effectChance = nil
    --- @type EffectType
    self.effectType = nil
    --- @type number
    self.effectDuration = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50001_Skill1:CreateInstance(id, hero)
    return Hero50001_Skill1(id, hero)
end

--- @return void
function Hero50001_Skill1:Init()
    self.enemyTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.enemyTargetPosition,
            TargetTeamType.ENEMY, self.data.enemyTargetNumber)

    self.allyTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.allyTargetPosition,
            TargetTeamType.ALLY, self.data.allyTargetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetDamage(self.data.damage)

    self.effectChance = self.data.effectChance
    self.effectType = self.data.effectType
    self.effectDuration = self.data.effectDuration
end

---------------------------------------- Calculate ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero50001_Skill1:UseActiveSkill()
    local enemyTargetList = TargetSelectorUtils.SelectTarget(self.myHero.battle, self.myHero, self.data.enemyTargetPosition,
            TargetTeamType.ENEMY, self.data.enemyTargetNumber)

    local results = self.damageSkillHelper:UseDamageSkill(enemyTargetList)
    local isEndTurn = true

    self:InflictBlessEffect()

    return results, isEndTurn
end

--- @return void
function Hero50001_Skill1:InflictBlessEffect()
    local targetList = self.allyTargetSelector:SelectTarget(self.myHero.battle)
    local i = 1
    while i <= targetList:Count() do
        local target = targetList:Get(i)
        EffectUtils.CreateBlessEffect(self.myHero, target, self.effectType, self.effectDuration)
        i = i + 1
    end
end

return Hero50001_Skill1