--- @class AttackController
AttackController = Class(AttackController)

--- @return void
--- @param hero BaseHero
function AttackController:Ctor(hero)
    --- @type BaseHero
    self.myHero = hero

    --- @type BaseTargetSelector
    self.targetSelector = nil

    --- @type boolean
    self.isRegenPower = false

    --- @type List<BaseSkill>
    self.itemPassiveList = List()
end

--- @return void
--- @param heroDataEntry HeroDataEntry
function AttackController:CreateTargetSelector(heroDataEntry)
    local targetPosition = heroDataEntry.basicAttackTargetPosition
    local targetNumber = heroDataEntry.basicAttackTargetNumber

    --- @type BaseTargetSelector
    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, targetPosition, TargetTeamType.ENEMY, targetNumber)
end

--- @return void
--- @param selector BaseTargetSelector
function AttackController:SetSelector(selector)
    self.targetSelector = selector
end

--- @return void
--- @param itemPassive BaseSkill
function AttackController:AddItemPassive(itemPassive)
    self.itemPassiveList:Add(itemPassive)
end

---------------------------------------- Attack ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function AttackController:DoBasicAttack()
    local targetList = self.targetSelector:SelectTarget(self.myHero.battle)
    self.myHero.effectController.effectListener:OnSelectTargetForBasicAttack(self.myHero, targetList)

    self.isRegenPower = false
    return self:Attack(targetList)
end

--- @return List<AttackResult> turn of this hero should be ended or not
--- @param targetList List<BaseHero>
function AttackController:Attack(targetList)
    local results = List()
    local isEndTurn = true

    local i = 1
    while i <= targetList:Count() do
        local target = targetList:Get(i)
        if target:IsDead() == false then
            local totalDamage, isCrit, dodgeType, isBlock = self.myHero.battleHelper:CalculateAttackResult(target)

            local result = self:CreateResult(target, isCrit, dodgeType, isBlock)
            ActionLogUtils.AddLog(self.myHero.battle, result)

            totalDamage = self:CalculateHeroStatus(target, totalDamage, dodgeType)
            result:SetDamage(totalDamage)

            results:Add(result)
        end
        i = i + 1
    end

    i = 1
    while i <= results:Count() do
        ---@type AttackResult
        local result = results:Get(i)
        self:TriggerAttackListener(result)
        self:TriggerCritListener(result)
        i = i + 1
    end

    EventUtils.TriggerEventBasicAttack(self.myHero)
    return results, isEndTurn
end

---------------------------------------- Calculate result ----------------------------------------
--- @return AttackResult
--- @param target BaseHero
--- @param isCrit boolean
--- @param dodgeType DodgeType
--- @param isBlock boolean
function AttackController:CreateResult(target, isCrit, dodgeType, isBlock)
    local result = AttackResult(self.myHero, target)
    result:SetInfo(isCrit, dodgeType, isBlock)

    return result
end

--- @return number
--- @param target BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function AttackController:CalculateHeroStatus(target, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS then
        if self.isRegenPower == false then
            self.isRegenPower = true
            self.myHero.power:Regen(PowerGainActionType.ATTACK)
        end

        target.power:Regen(PowerGainActionType.BE_ATTACKED, self:CalculatePowerRegenMultiply(target))
    end

    totalDamage = target.hp:TakeDamage(self.myHero, TakeDamageReason.ATTACK_DAMAGE, totalDamage)
    totalDamage = target.effectController.effectListener:OnTakeBasicAttackDamage(self.myHero, totalDamage)

    return totalDamage
end

--- @return number
--- @param target BaseHero
function AttackController:CalculatePowerRegenMultiply(target)
    if self.itemPassiveList:Count() > 0 then
        local multiply = 0
        for i = 1, self.itemPassiveList:Count() do
            ---@type BaseSkill
            local passiveSkill = self.itemPassiveList:Get(i)
            local gainPercent = passiveSkill:CalculatePowerGain(target)
            multiply = multiply + gainPercent
        end

        return multiply
    end

    return 1
end

---------------------------------------- Trigger listeners ----------------------------------------
--- @return number
--- @param result AttackResult
function AttackController:TriggerCritListener(result)
    if result.isCrit == true then
        self.myHero.attackListener:OnDealCritDamage(result.target, result.damage)
        result.target.attackListener:OnTakeCritDamage(self.myHero, result.damage)
    end
end

--- @return void
--- @param result AttackResult
function AttackController:TriggerAttackListener(result)
    self.myHero.attackListener:OnDealDamageToEnemy(result.target, result.damage, result.dodgeType)
    if result.dodgeType ~= DodgeType.MISS then
        result.target.attackListener:OnTakeDamageFromEnemy(self.myHero, result.damage)
    end
    EventUtils.TriggerEventDealBasicAttackDamage(result)
end