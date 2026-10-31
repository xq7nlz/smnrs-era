--- @class Hero30026_Skill1 Vlad
Hero30026_Skill1 = Class(Hero30026_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30026_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.enemyTargetSelector = nil

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil

    --- @type number
    self.healPercent = 0
    --- @type number
    self.totalDamage = 0
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30026_Skill1:CreateInstance(id, hero)
    return Hero30026_Skill1(id, hero)
end

--- @return void
function Hero30026_Skill1:Init()
    self.enemyTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.enemyTargetPosition,
            TargetTeamType.ENEMY, self.data.enemyTargetNumber)

    self.healPercent = self.data.healPercent

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetDamage(self.data.damage)

    self.myHero.battleListener:BindingWithSkill_1(self)
    self.myHero.skillListener:BindingWithSkill_1(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero30026_Skill1:UseActiveSkill()
    local targetList = self.enemyTargetSelector:SelectTarget(self.myHero.battle)

    local results = self.damageSkillHelper:UseDamageSkill(targetList)
    local isEndTurn = true

    return results, isEndTurn
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
function Hero30026_Skill1:OnDealSkillDamageToEnemy(enemyDefender, totalDamage)
    self.totalDamage = self.totalDamage + totalDamage
end

--- @return void
--- @param turn BattleTurn
function Hero30026_Skill1:OnEndBattleTurn(turn)
    if turn.actionType == ActionType.USE_SKILL and turn.myHero == self.myHero then
        HealUtils.Heal(self.myHero, self.myHero, self.totalDamage * self.healPercent, HealReason.HEAL_SKILL)
        self.totalDamage = 0
    end
end

return Hero30026_Skill1