--- @class Hero40002_Skill1 Yggra
Hero40002_Skill1 = Class(Hero40002_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40002_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.enemyTargetSelector = nil

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil
    --- @type number
    self.statDebuffDuration = nil
    --- @type StatType
    self.statDebuffType = nil
    --- @type number
    self.statDebuffAmount = nil

    --- @type BaseTargetSelector
    self.statBuffTargetSelector = nil
    --- @type number
    self.statBuffDuration = nil
    --- @type StatType
    self.statBuffType = nil
    --- @type number
    self.statBuffAmount = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40002_Skill1:CreateInstance(id, hero)
    return Hero40002_Skill1(id, hero)
end

--- @return void
function Hero40002_Skill1:Init()
    self.enemyTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.enemyTargetPosition,
            TargetTeamType.ENEMY, self.data.enemyTargetNumber)

    self.statDebuffDuration = self.data.statDebuffDuration
    self.statDebuffType = self.data.statDebuffType
    self.statDebuffAmount = self.data.statDebuffAmount

    self.statBuffTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.allyTargetPosition,
            TargetTeamType.ALLY, self.data.allyTargetNumber)

    self.statBuffDuration = self.data.statBuffDuration
    self.statBuffType = self.data.statBuffType
    self.statBuffAmount = self.data.statBuffAmount

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetActionPerTarget(self.InflictEffect)
    self.damageSkillHelper:SetDamage(self.data.damage)
end

---------------------------------------- Calculate ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero40002_Skill1:UseActiveSkill()
    local targetList = TargetSelectorUtils.SelectTarget(self.myHero.battle, self.myHero, self.data.enemyTargetPosition,
            TargetTeamType.ENEMY, self.data.enemyTargetNumber)

    local results = self.damageSkillHelper:UseDamageSkill(targetList)
    local isEndTurn = true

    self:BuffAlly()

    return results, isEndTurn
end

--- @return void
--- @param target BaseHero
function Hero40002_Skill1:InflictEffect(target)
    local statChanger = StatChanger(false)
    statChanger:SetInfo(self.statDebuffType, StatChangerCalculationType.PERCENT_ADD, self.statDebuffAmount)

    local effect = StatChangerEffect(self.myHero, target, false)
    effect:SetDuration(self.statDebuffDuration)
    effect:AddStatChanger(statChanger)

    target.effectController:AddEffect(effect)
end

--- @return void
function Hero40002_Skill1:BuffAlly()
    local targetList = self.statBuffTargetSelector:SelectTarget(self.myHero.battle)
    local i = 1
    while i <= targetList:Count() do
        local target = targetList:Get(i)

        local statChanger = StatChanger(true)
        statChanger:SetInfo(self.statBuffType, StatChangerCalculationType.PERCENT_ADD, self.statBuffAmount)

        local effect = StatChangerEffect(self.myHero, target, true)
        effect:SetDuration(self.statBuffDuration)
        effect:AddStatChanger(statChanger)

        target.effectController:AddEffect(effect)
        i = i + 1
    end
end

return Hero40002_Skill1