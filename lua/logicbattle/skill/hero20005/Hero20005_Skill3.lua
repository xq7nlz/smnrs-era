--- @class Hero20005_Skill3 Yin
Hero20005_Skill3 = Class(Hero20005_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20005_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.splashDamage = 0

    --- @type number
    self.splashVerticalRange = 0

    ---@type EffectType
    self.effectDotType = nil

    ---@type number
    self.dotAmount = nil

    ---@type number
    self.dotChance = nil

    ---@type number
    self.dotDuration = nil
end

--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero20005_Skill3:CreateInstance(id, hero)
    return Hero20005_Skill3(id, hero)
end

--- @return void
function Hero20005_Skill3:Init()
    local targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition, TargetTeamType.ENEMY, self.data.targetNumber)
    self.myHero.attackController:SetSelector(targetSelector)

    self.splashDamage = self.data.splashDamage
    self.splashVerticalRange = self.data.splashVerticalRange

    self.effectDotType = self.data.effectDotType
    self.dotAmount = self.data.dotAmount
    self.dotChance = self.data.dotChance
    self.dotDuration = self.data.dotDuration

    self.myHero.attackListener:BindingWithSkill_3(self)
end

-----------------------------------------Battle---------------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero20005_Skill3:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS then
        self:BurnTarget(enemyDefender)

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
function Hero20005_Skill3:SplashDamage(target, totalDamage)
    local result = SplashDamageResult(self.myHero, target)
    ActionLogUtils.AddLog(self.myHero.battle, result)

    local damage = totalDamage * self.splashDamage
    damage = target.hp:TakeDamage(self.myHero, TakeDamageReason.SPLASH_DAMAGE, damage)

    result:SetDamage(damage)
    result:RefreshHeroStatus()

    self:BurnTarget(target)
end

--- @return void
--- @param target BaseHero
function Hero20005_Skill3:BurnTarget(target)
    if self.myHero.randomHelper:RandomRate(self.dotChance) then
        local amount = self.dotAmount * (1 + self.myHero.skillController:GetBonusDotDamage())

        local dotEffect = EffectUtils.CreateDotEffect(self.myHero, target, self.effectDotType, self.dotDuration, amount)
        target.effectController:AddEffect(dotEffect)
    end
end

return Hero20005_Skill3