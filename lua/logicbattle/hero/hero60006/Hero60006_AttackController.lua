--- @class Hero60006_AttackController
Hero60006_AttackController = Class(Hero60006_AttackController, AttackController)

--- @return void
--- @param hero BaseHero
function Hero60006_AttackController:Ctor(hero)
    AttackController.Ctor(self, hero)
end

--- @return List<AttackResult> turn of this hero should be ended or not
--- @param targetList List<BaseHero>
function Hero60006_AttackController:Attack(targetList)
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

    self:TriggerAttackListener(results)

    EventUtils.TriggerEventBasicAttack(self.myHero)
    return results, isEndTurn
end

--- @return void
--- @param results List<AttackResult>
function Hero60006_AttackController:TriggerAttackListener(results)
    local i = 1
    while i <= results:Count() do
        local result = results:Get(i)
        i = i + 1

        self.myHero.attackListener:OnDealDamageToEnemy(result.target, result.damage, result.dodgeType)
        EventUtils.TriggerEventDealBasicAttackDamage(result)

        if result.isCrit == true then
            self.myHero.attackListener:OnDealCritDamage(result.target, result.damage)
        end
    end

    i = 1
    while i <= results:Count() do
        local result = results:Get(i)
        i = i + 1

        if result.dodgeType ~= DodgeType.MISS then
            result.target.attackListener:OnTakeDamageFromEnemy(self.myHero, result.damage)
        end

        if result.isCrit == true then
            result.target.attackListener:OnTakeCritDamage(self.myHero, result.damage)
        end
    end
end