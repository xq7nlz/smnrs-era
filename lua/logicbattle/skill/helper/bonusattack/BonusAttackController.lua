--- @class BonusAttackController : AttackController
BonusAttackController = Class(BonusAttackController, AttackController)

--- @return void
function BonusAttackController:Ctor(hero)
    AttackController.Ctor(self, hero)

    --- @type BaseSkill
    self.skill = nil

    --- @type boolean
    self.isDoBonusAttack = false
end

--- @return void
--- @param skill BaseSkill
function BonusAttackController:BindingWithSkill(skill)
    self.skill = skill
end

---------------------------------------- Attack ----------------------------------------
--- @return List<AttackResult> turn of this hero should be ended or not
--- @param targetList List<BaseHero>
function BonusAttackController:Attack(targetList)
    if self.skill == nil then
        return AttackController.Attack(self, targetList)
    end

    local results = List()
    local isEndTurn = true

    local basicAttackResult = List()

    local i = 1
    while i <= targetList:Count() do
        ---@type BaseHero
        local target = targetList:Get(i)

        local isDodgeAll = true
        local numberAttack = self.skill:GetNumberAttack()
        for j = 1, numberAttack do
            if target:IsDead() == false and self.myHero:IsDead() == false then
                if j == 1 then
                    self.isDoBonusAttack = false
                else
                    self.isDoBonusAttack = true
                end

                local result = self:AttackBonus(target, j)
                results:Add(result)

                if result.dodgeType ~= DodgeType.MISS then
                    isDodgeAll = false
                end

                if j == 1 then
                    basicAttackResult:Add(result)
                end
            end
        end

        if isDodgeAll == false then
            self:RegenHeroPower(target)
        end
        i = i + 1
    end

    i = 1
    while i <= basicAttackResult:Count() do
        local result = basicAttackResult:Get(i)
        self:TriggerAttackListener(result)
        self:TriggerCritListener(result)
        i = i + 1
    end

    EventUtils.TriggerEventBasicAttack(self.myHero)
    return results, isEndTurn
end

--- @return List<AttackResult> turn of this hero should be ended or not
--- @param target BaseHero
--- @param attackNumber number
function BonusAttackController:AttackBonus(target, attackNumber)
    local attackMultiplier = self.skill:GetAttackDamageMultiplier(attackNumber)
    self.myHero.battleHelper:SetBasicAttackMultiplier(attackMultiplier)

    local totalDamage, isCrit, dodgeType, isBlock = self.myHero.battleHelper:CalculateAttackResult(target)

    local result = self:CreateResult(target, isCrit, dodgeType, isBlock)
    ActionLogUtils.AddLog(self.myHero.battle, result)

    totalDamage = self:CalculateHeroStatus(target, totalDamage, dodgeType)
    result:SetDamage(totalDamage)

    return result
end

---------------------------------------- Calculate result ----------------------------------------
--- @return AttackResult
--- @param target BaseHero
--- @param isCrit boolean
--- @param dodgeType DodgeType
--- @param isBlock boolean
function BonusAttackController:CreateResult(target, isCrit, dodgeType, isBlock)
    if self.isDoBonusAttack == false then
        return AttackController.CreateResult(self, target, isCrit, dodgeType, isBlock)
    end

    local result = BonusAttackResult(self.myHero, target)
    result:SetInfo(isCrit, dodgeType, isBlock)

    return result
end

--- @return number
--- @param target BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function BonusAttackController:CalculateHeroStatus(target, totalDamage, dodgeType)
    if self.skill == nil then
        return AttackController.CalculateHeroStatus(self, target, totalDamage, dodgeType)
    end

    totalDamage = target.hp:TakeDamage(self.myHero, TakeDamageReason.ATTACK_DAMAGE, totalDamage)
    totalDamage = target.effectController.effectListener:OnTakeBasicAttackDamage(self.myHero, totalDamage)

    return totalDamage
end

--- @return number
--- @param target BaseHero
function BonusAttackController:RegenHeroPower(target)
    if self.isRegenPower == false then
        self.isRegenPower = true
        self.myHero.power:Regen(PowerGainActionType.ATTACK)
    end
    target.power:Regen(PowerGainActionType.BE_ATTACKED)
end
