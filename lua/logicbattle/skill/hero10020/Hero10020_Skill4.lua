--- @class Hero10020_Skill4 Sniper
Hero10020_Skill4 = Class(Hero10020_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10020_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.effectChance = 0

    --- @type number
    self.effectType = 0

    --- @type number
    self.effectDuration = 0
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10020_Skill4:CreateInstance(id, hero)
    return Hero10020_Skill4(id, hero)
end

--- @return void
function Hero10020_Skill4:Init()
    self.effectChance = self.data.effectChance
    self.effectType = self.data.effectType
    self.effectDuration = self.data.effectDuration

    self.myHero.attackListener:BindingWithSkill_4(self)
end

----------------------------------- Battle ---------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero10020_Skill4:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS and self.myHero.randomHelper:RandomRate(self.effectChance) then
        self:SilenceTarget(enemyDefender)
    end
end

function Hero10020_Skill4:SilenceTarget(target)
    local silenceEffect = SilenceEffect(self.myHero, target, self.effectDuration)
    target.effectController:AddEffect(silenceEffect)
end

return Hero10020_Skill4