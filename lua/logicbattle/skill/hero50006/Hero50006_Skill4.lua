--- @class Hero50006_Skill4 Enule
Hero50006_Skill4 = Class(Hero50006_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50006_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type Dictionary<BaseHero, number>
    self.allEnemyTakeDamageFromHero = nil

    --- @type number
    self.numberTakeDamageRequired = nil

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
function Hero50006_Skill4:CreateInstance(id, hero)
    return Hero50006_Skill4(id, hero)
end

--- @return void
function Hero50006_Skill4:Init()
    self.numberTakeDamageRequired = self.data.numberTakeDamageRequired
    self.effectType = self.data.effectType
    self.effectChance = self.data.effectChance
    self.effectDuration = self.data.effectDuration

    self.allEnemyTakeDamageFromHero = Dictionary()

    self.myHero.attackListener:BindingWithSkill_4(self)
    self.myHero.skillListener:BindingWithSkill_4(self)
    self.myHero.battleListener:BindingWithSkill_4(self)
end

----------------------------------------BATTLE-----------------------------------
--- @return void
function Hero50006_Skill4:OnEndBattleRound()
    self.allEnemyTakeDamageFromHero:Clear()
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero50006_Skill4:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    self:DealDamageToEnemyWithinBouncing(enemyDefender, totalDamage)
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
function Hero50006_Skill4:OnDealSkillDamageToEnemy(enemyDefender, totalDamage)
    self:DealDamageToEnemyWithinBouncing(enemyDefender, totalDamage)
end

--- @return void
--- @param target BaseHero
--- @param totalDamage number
function Hero50006_Skill4:DealDamageToEnemyWithinBouncing(target, totalDamage)
    if totalDamage > 0 then
        local number = self.allEnemyTakeDamageFromHero:GetOrDefault(target, 0)
        number = number + 1

        self.allEnemyTakeDamageFromHero:Add(target, number)
        if number >= self.numberTakeDamageRequired then
            if self.myHero.randomHelper:RandomRate(self.effectChance) then
                local ccEffect = EffectUtils.CreateCCEffect(self.myHero, target, self.effectType, self.effectDuration)
                target.effectController:AddEffect(ccEffect)
            end
            self.allEnemyTakeDamageFromHero:Add(target, 0)
        end
    end
end

return Hero50006_Skill4