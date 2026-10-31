--- @class Hero30009_Skill3 Gorzodin
Hero30009_Skill3 = Class(Hero30009_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30009_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.splashDamage = 0

    --- @type number
    self.splashVerticalRange = 0

    --- @type EffectType
    self.effectType = nil
    --- @type number
    self.effectChance = nil
    --- @type number
    self.effectDuration = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30009_Skill3:CreateInstance(id, hero)
    return Hero30009_Skill3(id, hero)
end

--- @return void
function Hero30009_Skill3:Init()
    local targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition, TargetTeamType.ENEMY, self.data.targetNumber)
    self.myHero.attackController:SetSelector(targetSelector)

    self.splashDamage = self.data.splashDamage
    self.splashVerticalRange = self.data.splashVerticalRange

    self.effectType = self.data.effectType
    self.effectChance = self.data.effectChance
    self.effectDuration = self.data.effectDuration

    self.myHero.attackListener:BindingWithSkill_3(self)
end

----------------------------------------- Battle ---------------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero30009_Skill3:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS then
        self:StunTarget(enemyDefender)

        local nearTargets = TargetSelectorUtils.GetNearTarget(enemyDefender, self.splashVerticalRange)
        local i = 1
        while i <= nearTargets:Count() do
            local target = nearTargets:Get(i)
            self:SplashDamage(target, totalDamage)
            i = i + 1
        end
    end
end

--- @return void
--- @param target BaseHero
--- @param totalDamage number
function Hero30009_Skill3:SplashDamage(target, totalDamage)
    local result = SplashDamageResult(self.myHero, target)
    ActionLogUtils.AddLog(self.myHero.battle, result)

    local damage = totalDamage * self.splashDamage
    damage = target.hp:TakeDamage(self.myHero, TakeDamageReason.SPLASH_DAMAGE, damage)

    result:SetDamage(damage)
    result:RefreshHeroStatus()
end

--- @return void
--- @param target BaseHero
function Hero30009_Skill3:StunTarget(target)
    if self.myHero.randomHelper:RandomRate(self.effectChance) then
        local ccEffect = EffectUtils.CreateCCEffect(self.myHero, target, self.effectType, self.effectDuration)
        target.effectController:AddEffect(ccEffect)
    end
end

return Hero30009_Skill3