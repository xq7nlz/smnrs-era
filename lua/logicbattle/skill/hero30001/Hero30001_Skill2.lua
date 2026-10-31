--- @class Hero30001_Skill2 Charon
Hero30001_Skill2 = Class(Hero30001_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30001_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type StatChangerSkillHelper
    self.statChangerSkillHelper = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30001_Skill2:CreateInstance(id, hero)
    return Hero30001_Skill2(id, hero)
end

--- @return void
function Hero30001_Skill2:Init()
    self.statChangerSkillHelper = StatChangerSkillHelper(self, self.data.bonuses)
    self.statChangerSkillHelper:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL)

    self.myHero.attackListener:BindingWithSkill_2(self)
    self.myHero.skillListener:BindingWithSkill_2(self)

    self.myHero.skillController.activeSkill:BindingWithSkill_2(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero30001_Skill2:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if enemyDefender:IsDead() then
        self:OnKill(enemyDefender)
    end
end

--- @return void
--- @param enemyTarget BaseHero
--- @param totalDamage number
function Hero30001_Skill2:OnDealSkillDamageToEnemy(enemyTarget, totalDamage)
    if enemyTarget:IsDead() then
        self:OnKill(enemyTarget)
    end
end

--- @return void
--- @param target BaseHero
function Hero30001_Skill2:OnKill(target)
    self.statChangerSkillHelper:AddStatChangerEffect(self.myHero, self.myHero)
end

return Hero30001_Skill2