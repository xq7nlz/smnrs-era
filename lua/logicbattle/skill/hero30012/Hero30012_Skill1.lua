--- @class Hero30012_Skill1 Dzuteh
Hero30012_Skill1 = Class(Hero30012_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30012_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.damageTargetSelector = nil

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil

    --- @type StatType
    self.statBuffType = nil

    --- @type number
    self.statBuffAmount = nil

    --- @type number
    self.statBuffDuration = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30012_Skill1:CreateInstance(id, hero)
    return Hero30012_Skill1(id, hero)
end

--- @return void
function Hero30012_Skill1:Init()
    self.statBuffType =  self.data.statBuffType
    self.statBuffAmount =  self.data.statBuffAmount
    self.statBuffDuration =  self.data.statBuffDuration

    self.damageTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.damageTargetPosition, TargetTeamType.ENEMY, self.data.damageTargetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetDamage(self.data.damage)
end

---------------------------------------- Calculate Active skill ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero30012_Skill1:UseActiveSkill()
    local enemyTargetList = self.damageTargetSelector:SelectTarget(self.myHero.battle)
    local results = self.damageSkillHelper:UseDamageSkill(enemyTargetList)

    self:BuffStat()

    local isEndTurn = true

    return results, isEndTurn
end

--- @return void
function Hero30012_Skill1:BuffStat()
    local statChanger = StatChanger(true)
    statChanger:SetInfo(self.statBuffType, StatChangerCalculationType.PERCENT_ADD, self.statBuffAmount)

    local effect = StatChangerEffect(self.myHero, self.myHero, true)
    effect:SetDuration(self.statBuffDuration)
    effect:AddStatChanger(statChanger)

    self.myHero.effectController:AddEffect(effect)
end

return Hero30012_Skill1