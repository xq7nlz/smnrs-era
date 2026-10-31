--- @class Hero10002_Skill2 Sharpwater
Hero10002_Skill2 = Class(Hero10002_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10002_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type EffectType
    self.effectType = nil
    --- @type number
    self.effectChance = nil
    --- @type number
    self.effectDuration = nil
    --- @type number
    self.effectAmount = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10002_Skill2:CreateInstance(id, hero)
    return Hero10002_Skill2(id, hero)
end

--- @return void
function Hero10002_Skill2:Init()
    self.effectType = self.data.effectType
    self.effectChance = self.data.effectChance
    self.effectDuration = self.data.effectDuration
    self.effectAmount = self.data.effectAmount

    self.myHero.attackListener:BindingWithSkill_2(self)
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero10002_Skill2:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS then
        if self.myHero.randomHelper:RandomRate(self.effectChance) then
            local dotEffect = EffectUtils.CreateDotEffect(self.myHero, enemyDefender, self.effectType,
                    self.effectDuration, self.effectAmount)
            enemyDefender.effectController:AddEffect(dotEffect)
        end
    end
end

return Hero10002_Skill2