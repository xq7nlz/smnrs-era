--- @class Hero10011_Skill1 Jeronim
Hero10011_Skill1 = Class(Hero10011_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10011_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.damageTargetSelector = nil
    --- @type DamageSkillHelper
    self.damageSkillHelper = nil
    --- @type number
    self.damage = 0
    --- @type number
    self.multiDamageChance = 0
    --- @type number
    self.multiDamageValue = 0
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10011_Skill1:CreateInstance(id, hero)
    return Hero10011_Skill1(id, hero)
end

--- @return void
function Hero10011_Skill1:Init()
    self.damageTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.damageTargetPosition,
            TargetTeamType.ENEMY, self.data.damageTargetNumber)

    self.damage = self.data.damage
    self.multiDamageChance = self.data.multiDamageChance
    self.multiDamageValue = self.data.multiDamageValue
    self.damageSkillHelper = DamageSkillHelper(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero10011_Skill1:UseActiveSkill()
    if self.myHero.randomHelper:RandomRate(self.multiDamageChance) then
        self.damageSkillHelper:SetDamage(self.damage * self.multiDamageValue)
    else
        self.damageSkillHelper:SetDamage(self.damage)
    end

    local enemyTargetList = TargetSelectorUtils.SelectTarget(self.myHero.battle, self.myHero, self.data.damageTargetPosition,
            TargetTeamType.ENEMY, self.data.damageTargetNumber)
    local results = self.damageSkillHelper:UseDamageSkill(enemyTargetList)

    self.myHero.skillListener:AfterUseSkill()

    local isEndTurn = true

    return results, isEndTurn
end

return Hero10011_Skill1