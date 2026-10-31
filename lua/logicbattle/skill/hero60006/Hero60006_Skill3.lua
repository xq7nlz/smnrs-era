--- @class Hero60006_Skill3 Hehta
Hero60006_Skill3 = Class(Hero60006_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60006_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type EffectType
    self.effectType = nil

    --- @type number
    self.effectDuration = nil

    --- @type number
    self.effectAmount = nil

    --- @type number
    self.silenceDuration = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60006_Skill3:CreateInstance(id, hero)
    return Hero60006_Skill3(id, hero)
end

--- @return void
function Hero60006_Skill3:Init()
    self.effectType = self.data.effectType
    self.effectDuration = self.data.effectDuration
    self.effectAmount = self.data.effectAmount
    self.silenceDuration = self.data.silenceDuration

    self.myHero.attackListener:BindingWithSkill_3(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero60006_Skill3:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS then
        local dotEffect = EffectUtils.CreateDotEffect(self.myHero, enemyDefender, self.effectType, self.effectDuration, self.effectAmount)
        enemyDefender.effectController:AddEffect(dotEffect)

        local silenceEffect = SilenceEffect(self.myHero, enemyDefender, self.silenceDuration)
        enemyDefender.effectController:AddEffect(silenceEffect)
    end
end

return Hero60006_Skill3