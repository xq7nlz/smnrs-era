--- @class Hero40009_Skill1 Sylph
Hero40009_Skill1 = Class(Hero40009_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40009_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil

    --- @type BaseTargetSelector
    self.targetSelector = nil

    --- @type number
    self.damage = 0

    --- @type boolean
    self.canBeTargetedByEnemy = true

    --- @type number
    self.numberRoundCanNotBeTargeted = nil

    --- @type number
    self.currentNumberRoundCanNotBeTargeted = 0
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40009_Skill1:CreateInstance(id, hero)
    return Hero40009_Skill1(id, hero)
end

--- @return void
function Hero40009_Skill1:Init()
    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.damageTargetPosition,
            TargetTeamType.ENEMY, self.data.damageTargetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetDamage(self.data.damage)

    self.numberRoundCanNotBeTargeted = self.data.numberRoundCanNotBeTargeted

    self.myHero:BindingWithSkill_1(self)
    self.myHero.battleListener:BindingWithSkill_1(self)
end

----------------------------------- Battle -------------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero40009_Skill1:UseActiveSkill()
    local targetList = TargetSelectorUtils.SelectTarget(self.myHero.battle, self.myHero, self.data.damageTargetPosition,
            TargetTeamType.ENEMY, self.data.damageTargetNumber)
    local results = self.damageSkillHelper:UseDamageSkill(targetList)

    local isEndTurn = true
    self:SwitchTargetedByEnemyState(false)

    self.currentNumberRoundCanNotBeTargeted = 0

    return results, isEndTurn
end

--- @return void
--- @param round BattleRound
function Hero40009_Skill1:OnStartBattleRound(round)
    self.currentNumberRoundCanNotBeTargeted = self.numberRoundCanNotBeTargeted + 1
    if self.currentNumberRoundCanNotBeTargeted > self.numberRoundCanNotBeTargeted then
        self:SwitchTargetedByEnemyState(true)
    end
end

--- @return boolean
function Hero40009_Skill1:CanBeTargetedByEnemy()
    return self.canBeTargetedByEnemy
end

--- @return void
--- @param canBeTargetedByEnemy boolean
function Hero40009_Skill1:SwitchTargetedByEnemyState(canBeTargetedByEnemy)
    self.canBeTargetedByEnemy = canBeTargetedByEnemy

    if canBeTargetedByEnemy == false then
        local nonTargetedMark = NonTargetedMark(self.myHero, self.myHero)
        nonTargetedMark:SetDuration(self.numberRoundCanNotBeTargeted)

        self.myHero.effectController:AddEffect(nonTargetedMark)
    end
end

return Hero40009_Skill1