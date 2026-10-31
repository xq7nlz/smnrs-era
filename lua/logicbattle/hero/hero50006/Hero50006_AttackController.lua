--- @class Hero50006_AttackController
Hero50006_AttackController = Class(Hero50006_AttackController, AttackController)

--- @return void
--- @param hero BaseHero
function Hero50006_AttackController:Ctor(hero)
    AttackController.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_2 = nil

    --- @type BaseSkill
    self.skill_3 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero50006_AttackController:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return number
--- @param skill BaseSkill
function Hero50006_AttackController:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

--- @return List<AttackResult> turn of this hero should be ended or not
--- @param targetList List<BaseHero>
function Hero50006_AttackController:Attack(targetList)
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

            if self.skill_2 ~= nil then
                self.skill_2:OnDealDamageToEnemy(target, totalDamage)
            end

            results:Add(result)
        end
        i = i + 1
    end

    if self.skill_2 ~= nil then
        self.skill_2:StartBouncing()
    end

    i = 1
    while i <= results:Count() do
        local result = results:Get(i)
        self:TriggerAttackListener(result)
        self:TriggerCritListener(result)
        i = i + 1
    end

    EventUtils.TriggerEventBasicAttack(self.myHero)

    if self.skill_3 ~= nil then
        isEndTurn = self.skill_3:ExtraTurn() == false
    end

    return results, isEndTurn
end