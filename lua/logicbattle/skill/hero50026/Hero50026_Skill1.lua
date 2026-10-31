--- @class Hero50026_Skill1 Fioneth
Hero50026_Skill1 = Class(Hero50026_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50026_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.damageTargetSelector = nil

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil

    --- @type BaseTargetSelector
    self.statBuffTargetSelector = nil

    --- @type StatType
    self.statBuffType = nil
    --- @type number
    self.statBuffDuration = nil
    --- @type number
    self.statBuffAmount = nil
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50026_Skill1:CreateInstance(id, hero)
    return Hero50026_Skill1(id, hero)
end

--- @return void
function Hero50026_Skill1:Init()
    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)

    self.statBuffTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.statBuffTargetPosition,
            TargetTeamType.ALLY, self.data.statBuffTargetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetDamage(self.data.damage)

    self.statBuffType = self.data.statBuffType
    self.statBuffDuration = self.data.statBuffDuration
    self.statBuffAmount = self.data.statBuffAmount
end

----------------------------------- Battle -------------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero50026_Skill1:UseActiveSkill()
    local targetList = self.targetSelector:SelectTarget(self.myHero.battle)
    local results = self.damageSkillHelper:UseDamageSkill(targetList)

    local isEndTurn = true

    self:BuffStat()

    return results, isEndTurn
end

--- @return void
function Hero50026_Skill1:BuffStat()
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

return Hero50026_Skill1