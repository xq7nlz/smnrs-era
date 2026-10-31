--- @class Hero10008_Skill4 Mammusk
Hero10008_Skill4 = Class(Hero10008_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10008_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type StatChangerSkillHelper
    self.statChangerSkillHelper = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10008_Skill4:CreateInstance(id, hero)
    return Hero10008_Skill4(id, hero)
end

--- @return void
function Hero10008_Skill4:Init()
    self.statChangerSkillHelper = StatChangerSkillHelper(self, self.data.bonuses)
    self.statChangerSkillHelper:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL)

    self.myHero.attackListener:BindingWithSkill_4(self)
    self.myHero.skillListener:BindingWithSkill_4(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero10008_Skill4:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if enemyDefender:IsDead() then
        self:OnKill(enemyDefender)
    end
end

--- @return void
--- @param enemyTarget BaseHero
--- @param totalDamage number
function Hero10008_Skill4:OnDealSkillDamageToEnemy(enemyTarget, totalDamage)
    if enemyTarget:IsDead() then
        self:OnKill(enemyTarget)
    end
end

--- @return void
--- @param target BaseHero
function Hero10008_Skill4:OnKill(target)
    self.statChangerSkillHelper:AddStatChangerEffect(self.myHero, self.myHero)
end

return Hero10008_Skill4