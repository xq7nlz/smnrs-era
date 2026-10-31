--- @class Hero60011_Skill4 Vera
Hero60011_Skill4 = Class(Hero60011_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60011_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type StatType
    self.statDebuffType = 0

    --- @type number
    self.statDebuffAmount = 0

    --- @type Dictionary<BaseHero, StatChangerEffect>
    self.debuffHeroes = Dictionary()

    --- @type List<BaseHero>
    self.attackedHeroes = List()
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60011_Skill4:CreateInstance(id, hero)
    return Hero60011_Skill4(id, hero)
end

--- @return void
function Hero60011_Skill4:Init()
    self.statDebuffType = self.data.statDebuffType
    self.statDebuffAmount = self.data.statDebuffAmount

    self.myHero.attackListener:BindingWithSkill_4(self)
    self.myHero.battleListener:BindingWithSkill_4(self)
end

---------------------------------------- BATTLE -----------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero60011_Skill4:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS then
        self.attackedHeroes:Add(enemyDefender)
    end
end

--- @return void
--- @param turn BattleTurn
function Hero60011_Skill4:OnEndBattleTurn(turn)
    if turn.actionType == ActionType.BASIC_ATTACK then

        --- Add Debuff
        --- @type Dictionary<BaseHero, StatChangerEffect>
        local newDebuffHeroes = Dictionary()
        if self.attackedHeroes:Count() > 0 then
            local i = 1
            while i <= self.attackedHeroes:Count() do
                local attackedHero = self.attackedHeroes:Get(i)
                local statDebuffHero = self.debuffHeroes:Get(attackedHero)

                local statChangerEffect = self:AddDebuff(statDebuffHero, attackedHero)
                newDebuffHeroes:Add(attackedHero, statChangerEffect)
                i = i + 1
            end
        end

        --- Remove Debuff
        for hero, statEffect in pairs(self.debuffHeroes:GetItems()) do
            if self.attackedHeroes:IsContainValue(hero) == false then
                -- reset stack if target is changed
                hero.effectController:ForceRemove(statEffect)
            end
        end
        self.debuffHeroes = newDebuffHeroes
    end

    self.attackedHeroes:Clear()
end

--- @return StatChangerEffect
--- @param statDebuffHero StatChangerEffect
--- @param enemyDefender BaseHero
function Hero60011_Skill4:AddDebuff(statDebuffHero, enemyDefender)
    if statDebuffHero ~= nil then
        local i = 1
        while i <= statDebuffHero.statChangerList:Count() do
            local statChanger = statDebuffHero.statChangerList:Get(i)
            if statChanger.statAffectedType == self.statDebuffType then
                local amount = self.statDebuffAmount + statChanger:GetAmount()
                statChanger:SetInfo(self.statDebuffType, StatChangerCalculationType.PERCENT_ADD, amount)
                break
            end
            i = i + 1
        end

        statDebuffHero:Recalculate()
        return statDebuffHero
    else
        local statChangerEffect = StatChangerEffect(self.myHero, enemyDefender, false)
        local statChanger = StatChanger(false)
        statChanger:SetInfo(self.statDebuffType, StatChangerCalculationType.PERCENT_ADD, self.statDebuffAmount)
        statChangerEffect:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL)
        statChangerEffect:AddStatChanger(statChanger)
        enemyDefender.effectController:AddEffect(statChangerEffect)
        return statChangerEffect
    end
end

return Hero60011_Skill4