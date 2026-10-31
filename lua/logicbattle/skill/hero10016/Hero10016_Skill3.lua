--- @class Hero10016_Skill3 Croconile
Hero10016_Skill3 = Class(Hero10016_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10016_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type EffectType
    self.effectType = nil
    --- @type number
    self.effectAmount = nil
    --- @type number
    self.effectDuration = nil

    --- @type HeroClassType
    self.enemyClass = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10016_Skill3:CreateInstance(id, hero)
    return Hero10016_Skill3(id, hero)
end

--- @return void
function Hero10016_Skill3:Init()
    self.effectType = self.data.effectType
    self.effectAmount = self.data.effectAmount
    self.effectDuration = self.data.effectDuration
    self.enemyClass = self.data.enemyClass

    self.myHero.attackListener:BindingWithSkill_3(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero10016_Skill3:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS and enemyDefender.originInfo.class == self.enemyClass then
        local dotEffect = EffectUtils.CreateDotEffect(self.myHero, enemyDefender, self.effectType, self.effectDuration, self.effectAmount)
        enemyDefender.effectController:AddEffect(dotEffect)
    end
end

return Hero10016_Skill3