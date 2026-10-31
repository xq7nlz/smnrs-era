--- @class Hero20001_Skill2 Icarus
Hero20001_Skill2 = Class(Hero20001_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20001_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type EffectType
    self.effect1_type = nil
    --- @type number
    self.effect1_duration = nil
    --- @type number
    self.effect1_amount = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20001_Skill2:CreateInstance(id, hero)
    return Hero20001_Skill2(id, hero)
end

--- @return void
function Hero20001_Skill2:Init()
    self.effect1_type = self.data.effect1_type
    self.effect1_duration = self.data.effect1_duration
    self.effect1_amount = self.data.effect1_amount

    self.myHero.attackListener:BindingWithSkill_2(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero20001_Skill2:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS then
        local dotEffect = EffectUtils.CreateDotEffect(self.myHero, enemyDefender, self.effect1_type, self.effect1_duration, self.effect1_amount)
        enemyDefender.effectController:AddEffect(dotEffect)
    end
end

return Hero20001_Skill2