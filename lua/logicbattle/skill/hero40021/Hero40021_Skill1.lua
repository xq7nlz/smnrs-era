--- @class Hero40021_Skill1 Titi
Hero40021_Skill1 = Class(Hero40021_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40021_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.damageTargetSelector = nil
    --- @type BaseTargetSelector
    self.buffTargetSelector = nil

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40021_Skill1:CreateInstance(id, hero)
    return Hero40021_Skill1(id, hero)
end

--- @return void
function Hero40021_Skill1:Init()
    self.damageTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)

    self.buffTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.statBuffTargetPosition,
            TargetTeamType.ALLY, self.data.statBuffTargetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetDamage(self.data.damage)
end

---------------------------------------- Calculate ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero40021_Skill1:UseActiveSkill()
    local enemyTargetList = self.damageTargetSelector:SelectTarget(self.myHero.battle)
    local results = self.damageSkillHelper:UseDamageSkill(enemyTargetList)

    self:BuffAllies()

    local isEndTurn = true

    return results, isEndTurn
end

--- @return void
function Hero40021_Skill1:BuffAllies()
    local targetList = self.buffTargetSelector:SelectTarget(self.myHero.battle)
    local i = 1
    while i <= targetList:Count() do
        local target = targetList:Get(i)

        local statChanger = StatChanger(true)
        statChanger:SetInfo(self.data.statBuffType, StatChangerCalculationType.PERCENT_ADD, self.data.statBuffAmount)

        local effect = StatChangerEffect(self.myHero, target, true)
        effect:SetDuration(self.data.statBuffDuration)
        effect:AddStatChanger(statChanger)

        target.effectController:AddEffect(effect)
        i = i + 1
    end
end

return Hero40021_Skill1