--- @class Hero60015_Skill3 Murath
Hero60015_Skill3 = Class(Hero60015_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60015_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)
    ---@type number
    self.effectDotChance = nil

    ---@type EffectType
    self.effectDotType = nil

    ---@type number
    self.effectDotAmount = nil

    ---@type number
    self.effectDotDuration = nil
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60015_Skill3:CreateInstance(id, hero)
    return Hero60015_Skill3(id, hero)
end

--- @return void
function Hero60015_Skill3:Init()
    self.effectDotChance = self.data.effectDotChance
    self.effectDotType = self.data.effectDotType
    self.effectDotAmount = self.data.effectDotAmount
    self.effectDotDuration = self.data.effectDotDuration

    local targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)

    self.myHero.attackController:SetSelector(targetSelector)
    self.myHero.attackListener:BindingWithSkill_3(self)
end

---------------------------------------- BATTLE -----------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero60015_Skill3:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS then
        if self.myHero.randomHelper:RandomRate(self.effectDotChance) then
            local dotEffect = EffectUtils.CreateDotEffect(self.myHero, enemyDefender, self.effectDotType,
                    self.effectDotDuration, self.effectDotAmount)
            enemyDefender.effectController:AddEffect(dotEffect)
        end
    end
end

return Hero60015_Skill3