--- @class Hero40008_Skill4 Lass
Hero40008_Skill4 = Class(Hero40008_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40008_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.resistanceEffectRate_1 = 0
    --- @type EffectType
    self.resistanceEffectType_1 = 0

    --- @type number
    self.resistanceEffectRate_2 = 0
    --- @type EffectType
    self.resistanceEffectType_2 = 0

    --- @type StatChangerSkillHelper
    self.statChangerSkillHelper = nil

    --- @type number
    self.effectDotChance = 0
    --- @type EffectType
    self.effectDotType = 0
    --- @type number
    self.effectDotAmount = 0
    --- @type number
    self.effectDotDuration = 0

    --- @type number
    self.silenceChance = 0
    --- @type number
    self.silenceDuration = 0
end

--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero40008_Skill4:CreateInstance(id, hero)
    return Hero40008_Skill4(id, hero)
end

--- @return void
function Hero40008_Skill4:Init()
    self.effectDotChance = self.data.effectDotChance
    self.effectDotType = self.data.effectDotType
    self.effectDotAmount = self.data.effectDotAmount
    self.effectDotDuration = self.data.effectDotDuration

    self.silenceChance = self.data.silenceChance
    self.silenceDuration = self.data.silenceDuration

    self.resistanceEffectRate_1 = self.data.resistanceEffectRate_1
    self.resistanceEffectType_1 = self.data.resistanceEffectType_1

    self.resistanceEffectRate_2 = self.data.resistanceEffectRate_2
    self.resistanceEffectType_2 = self.data.resistanceEffectType_2

    self.myHero.effectController:BindingWithSkill_4(self)
    self.myHero.attackListener:BindingWithSkill_4(self)
end

-----------------------------------------Battle---------------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero40008_Skill4:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS then
        if self.myHero.randomHelper:RandomRate(self.effectDotChance) then
            local dotEffect = EffectUtils.CreateDotEffect(self.myHero,enemyDefender,self.effectDotType, self.effectDotDuration, self.effectDotAmount)
            enemyDefender.effectController:AddEffect(dotEffect)
        end

        if self.myHero.randomHelper:RandomRate(self.silenceChance) then
            local silenceEffect = SilenceEffect(self.myHero, enemyDefender, self.silenceDuration)
            enemyDefender.effectController:AddEffect(silenceEffect)
        end
    end
end

--- @return boolean
--- @param effect BaseEffect
function Hero40008_Skill4:CanAddEffect(effect)
    if effect.type == self.resistanceEffectType_1 then
        if self.myHero.randomHelper:RandomRate(self.resistanceEffectRate_1) then
            return false
        end
    elseif effect.type == self.resistanceEffectType_2 then
        if self.myHero.randomHelper:RandomRate(self.resistanceEffectRate_2) then
            return false
        end
    end
    return true
end

return Hero40008_Skill4