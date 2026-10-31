--- @class Hero60005_Skill3 Karos
Hero60005_Skill3 = Class(Hero60005_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60005_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type StatType
    self.statDebuffType = 0

    --- @type number
    self.statDebuffChance = 0

    --- @type StatChangerCalculationType
    self.statDebuffCalculationType = 0

    --- @type number
    self.statDebuffAmount = 0

    --- @type number
    self.statDebuffDuration = 0

    --- @type number
    self.statDebuffMax = 0

    --- @type EffectType
    self.effectType = nil

    ---@type number
    self.effectChance = nil

    --- @type number
    self.effectDuration = nil
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60005_Skill3:CreateInstance(id, hero)
    return Hero60005_Skill3(id, hero)
end

--- @return void
function Hero60005_Skill3:Init()
    self.statDebuffType = self.data.statDebuffType
    self.statDebuffChance = self.data.statDebuffChance
    self.statDebuffCalculationType = self.data.statDebuffCalculationType
    self.statDebuffAmount = self.data.statDebuffAmount
    self.statDebuffDuration = self.data.statDebuffDuration
    self.statDebuffMax = self.data.statDebuffMax
    self.effectType = self.data.effectType
    self.effectChance = self.data.effectChance
    self.effectDuration = self.data.effectDuration

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
function Hero60005_Skill3:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS then
        if self.myHero.randomHelper:RandomRate(self.statDebuffChance) then
            if self:IncreaseDebuffAmountFromTarget(enemyDefender) == false then
                self:AddDebuffToTarget(enemyDefender)
            end
        end
        self:InflictEffect(enemyDefender)
    end
end

--- @return boolean
--- @param enemyDefender BaseHero
function Hero60005_Skill3:IncreaseDebuffAmountFromTarget(enemyDefender)
    local listDebuff = enemyDefender.effectController:GetEffectWithType(EffectType.STAT_CHANGER)
    if listDebuff ~= nil and listDebuff:Count() > 0 then
        local i = 1
        while i <= listDebuff:Count() do
            local effectOnEnemy = listDebuff:Get(i)
            if effectOnEnemy.initiator == self.myHero then
                for j = 1, effectOnEnemy.statChangerList:Count() do
                    local statChangeDebuff = effectOnEnemy.statChangerList:Get(j)
                    if statChangeDebuff.statAffectedType == self.statDebuffType then
                        if statChangeDebuff.amount < self.statDebuffMax then
                            local amount
                            if statChangeDebuff.amount + self.statDebuffAmount <= self.statDebuffMax then
                                amount = statChangeDebuff.amount + self.statDebuffAmount
                            else
                                amount = self.statDebuffMax
                            end

                            statChangeDebuff:SetInfo(self.statDebuffType, self.statDebuffCalculationType, amount)
                            effectOnEnemy:Recalculate()
                        end

                        return true
                    end
                end
            end
            i = i + 1
        end
    end
    return false
end

--- @return void
--- @param enemyDefender BaseHero
function Hero60005_Skill3:AddDebuffToTarget(enemyDefender)
    local statChanger = StatChanger(false)
    statChanger:SetInfo(self.statDebuffType, self.statDebuffCalculationType, self.statDebuffAmount)

    local statChangerEffect = StatChangerEffect(self.myHero, enemyDefender, false)
    statChangerEffect:SetDuration(self.statDebuffDuration)
    statChangerEffect:AddStatChanger(statChanger)

    enemyDefender.effectController:AddEffect(statChangerEffect)
end

---------------------------------------- Calculate Active skill ----------------------------------------
function Hero60005_Skill3:InflictEffect(target)
    if self.myHero.randomHelper:RandomRate(self.effectChance) then
        local ccEffect = EffectUtils.CreateCCEffect(self.myHero, target, self.effectType, self.effectDuration)
        target.effectController:AddEffect(ccEffect)
    end
end

return Hero60005_Skill3