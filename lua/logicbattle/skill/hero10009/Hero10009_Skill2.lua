--- @class Hero10009_Skill2 Lashna
Hero10009_Skill2 = Class(Hero10009_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10009_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.numberBouncing = 0

    --- @type number
    self.damageBouncing = 0
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10009_Skill2:CreateInstance(id, hero)
    return Hero10009_Skill2(id, hero)
end

--- @return void
function Hero10009_Skill2:Init()
    self.numberBouncing = self.data.numberBouncing
    self.damageBouncing = self.data.damageBouncing

    self.myHero.attackListener:BindingWithSkill_2(self)
end

---------------------------------------- BATTLE -----------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
--- @param bouncingId number
function Hero10009_Skill2:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType, bouncingId)
    self:Bouncing(enemyDefender, totalDamage, bouncingId)
end

--- @return void
--- @param target BaseHero
--- @param totalDamage number
--- @param bouncingId number
function Hero10009_Skill2:Bouncing(target, totalDamage, bouncingId)
    local attackerTeam, defenderTeam = self.myHero.battle:GetTeam()
    local targetTeam = TargetSelectorUtils.GetAllyTeam(attackerTeam, defenderTeam, target.teamId)

    local currentTargetBouncing = target
    local damage = totalDamage
    for id = 1, self.numberBouncing do
        local bouncingTarget = self:GetNextBouncingTarget(currentTargetBouncing, targetTeam)
        if bouncingTarget ~= nil then
            local result = BouncingDamageResult(self.myHero, bouncingTarget, bouncingId, id)
            ActionLogUtils.AddLog(self.myHero.battle, result)

            damage = damage * self.damageBouncing
            local resultDamage = bouncingTarget.hp:TakeDamage(self.myHero, TakeDamageReason.BOUNCING_DAMAGE, damage)

            result:SetDamage(resultDamage)
            result:RefreshHeroStatus()

            currentTargetBouncing = bouncingTarget
        end
    end
end

--- @return BaseHero
--- @param currentTarget BaseHero
--- @param targetTeam BattleTeam
function Hero10009_Skill2:GetNextBouncingTarget(currentTarget, targetTeam)
    local startPosition = self:GetPositionIndex(currentTarget, targetTeam)
    for i = 1, targetTeam.heroList:Count() do
        local hero = targetTeam.heroList:Get(i)
        if i > startPosition and hero ~= currentTarget and hero:CanBeTargetedByEnemy() == true and hero:IsDead() == false then
            return hero
        end
    end

    for i = 1, targetTeam.heroList:Count() do
        local hero = targetTeam.heroList:Get(i)
        if hero ~= currentTarget and hero:CanBeTargetedByEnemy() == true and hero:IsDead() == false then
            return hero
        end
    end

    return nil
end

--- @return BaseHero
--- @param currentTarget BaseHero
function Hero10009_Skill2:GetPositionIndex(currentTarget, targetTeam)
    for i = 1, targetTeam.heroList:Count() do
        local hero = targetTeam.heroList:Get(i)
        if hero == currentTarget then
            return i
        end
    end

    return -1
end

return Hero10009_Skill2