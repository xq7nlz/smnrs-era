--- @class Hero50006_Skill2 Enule
Hero50006_Skill2 = Class(Hero50006_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50006_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.damageBouncing = 0

    --- @type number
    self.numberBouncing = 0

    --- @type number
    self.bouncingId = 0

    --- @type Dictionary<number, table>
    self.enemyTargetDict = Dictionary()
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50006_Skill2:CreateInstance(id, hero)
    return Hero50006_Skill2(id, hero)
end

--- @return void
function Hero50006_Skill2:Init()
    self.numberBouncing = self.data.numberBouncing
    self.damageBouncing = self.data.damageBouncing

    self.myHero.attackController:BindingWithSkill_2(self)
    self.myHero.skillController.activeSkill:BindingWithSkill_2(self)
end

---------------------------------------- BATTLE -----------------------------------
--- @return void
--- @param target BaseHero
--- @param totalDamage number
function Hero50006_Skill2:OnDealDamageToEnemy(target, totalDamage)
    self:AddTarget(target, totalDamage)
end

--- @return void
--- @param target BaseHero
--- @param totalDamage number
function Hero50006_Skill2:AddTarget(target, totalDamage)
    self.bouncingId = self.bouncingId + 1
    local targetData = {
        ["target"] = target,
        ["totalDamage"] = totalDamage
    }

    self.enemyTargetDict:Add(self.bouncingId, targetData)
end

--- @return void
function Hero50006_Skill2:StartBouncing()
    local attackerTeam, defenderTeam = self.myHero.battle:GetTeam()
    local targetTeam = TargetSelectorUtils.GetEnemyTeam(attackerTeam, defenderTeam, self.myHero.teamId)

    --- @type Dictionary<number, table>
    local newTargetDict = Dictionary()

    for numberBouncing = 1, self.numberBouncing do
        for bouncingId = 1, self.enemyTargetDict:Count() do
            local targetData = self.enemyTargetDict:Get(bouncingId)

            local currentBouncingTarget = targetData.target
            local damage = targetData.totalDamage

            local bouncingTarget = self:GetNextBouncingTarget(currentBouncingTarget, targetTeam)

            if bouncingTarget ~= nil then
                local result = BouncingDamageResult(self.myHero, bouncingTarget, bouncingId, numberBouncing)
                ActionLogUtils.AddLog(self.myHero.battle, result)

                damage = damage * self.damageBouncing
                local resultDamage = bouncingTarget.hp:TakeDamage(self.myHero, TakeDamageReason.BOUNCING_DAMAGE, damage)
                self.myHero.attackListener:BouncingDamageToEnemy(bouncingTarget, resultDamage)
                result:SetDamage(resultDamage)
                result:RefreshHeroStatus()

                currentBouncingTarget = bouncingTarget

                local targetData = {
                    ["target"] = currentBouncingTarget,
                    ["totalDamage"] = resultDamage
                }

                newTargetDict:Add(bouncingId, targetData)
            end
        end

        -- Copy new target to current target
        self.enemyTargetDict:Clear()
        for i = 1, newTargetDict:Count() do
            local targetData = newTargetDict:Get(i)
            if targetData ~= nil then
                self.enemyTargetDict:Add(i, targetData)
            end
        end
    end

    self.bouncingId = 0
    self.enemyTargetDict:Clear()
end

--- @return BaseHero
--- @param currentTarget BaseHero
--- @param targetTeam BattleTeam
function Hero50006_Skill2:GetNextBouncingTarget(currentTarget, targetTeam)
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
function Hero50006_Skill2:GetPositionIndex(currentTarget, targetTeam)
    for i = 1, targetTeam.heroList:Count() do
        local hero = targetTeam.heroList:Get(i)
        if hero == currentTarget then
            return i
        end
    end

    return -1
end

return Hero50006_Skill2