--- @class Hero60006_Skill4 Eitri
Hero60006_Skill4 = Class(Hero60006_Skill4, BaseSkill)

--- @return void
--- @param id number
--- @param hero BaseHero
function Hero60006_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type StealStatAndReturnSkillHelper
    self.stealAndReturnHelper = nil

    --- @type number
    self.deadTransferStatValue1 = nil

    --- @type number
    self.deadTransferStatValue2 = nil

    --- @type number
    self.isTransfer = false

    --- @type number
    self.isInitTransferValue = false
end

--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero60006_Skill4:CreateInstance(id, hero)
    return Hero60006_Skill4(id, hero)
end

--- @return void
function Hero60006_Skill4:Init()
    self.myHero.attackListener:BindingWithSkill_4(self)
    self.myHero.battleListener:BindingWithSkill_4(self)

    local targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.attackTargetPosition,
            TargetTeamType.ENEMY, self.data.attackTargetNumber)
    self.myHero.attackController:SetSelector(targetSelector)

    self.stealAndReturnHelper = StealStatAndReturnSkillHelper(self)
    self.stealAndReturnHelper:SetDuration(EffectConstants.INFINITY_DURATION)
    self.stealAndReturnHelper:AddSteal(self.data.stealStatType, self.data.stealStatValue)

    self.transferAllySelector = TargetSelectorBuilder.Create(self.myHero, self.data.transferAllyPosition,
            TargetTeamType.ALLY, self.data.transferAllyNumber)

    local deadListener = EventListener(self.myHero, self, self.OnHeroDead)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_DEAD, deadListener)
end

-------------------------------------------BATTLE------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero60006_Skill4:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if self.myHero:IsDead() == false and dodgeType ~= DodgeType.MISS then
        local allyHeroes = TargetSelectorUtils.SelectTarget(self.myHero.battle, self.myHero, self.data.buffAllyPosition,
                TargetTeamType.ALLY, self.data.buffAllyNumber + 1)

        if allyHeroes:IsContainValue(self.myHero) == false then
            allyHeroes = TargetSelectorUtils.SelectTarget(self.myHero.battle, self.myHero, self.data.buffAllyPosition,
                    TargetTeamType.ALLY, self.data.buffAllyNumber)
            allyHeroes:Add(self.myHero)
        end

        self.stealAndReturnHelper:StealStat(enemyDefender, allyHeroes)
    end
end

--- @return void
--- @param round number
function Hero60006_Skill4:OnStartBattleRound(round)
    if self.isInitTransferValue == false then
        self.isInitTransferValue = true
        self.deadTransferStatValue1 = self.myHero:GetStat(self.data.transferStatType1):GetValue() * self.data.transferStatPercent
        self.deadTransferStatValue2 = self.myHero:GetStat(self.data.transferStatType2):GetValue() * self.data.transferStatPercent
    end
end

--- @return void
--- @param eventData table
function Hero60006_Skill4:OnHeroDead(eventData)
    if eventData.target == self.myHero and self.isTransfer == false then
        self.isTransfer = true
        self:TriggerSkill()
    end
end

--- @return void
function Hero60006_Skill4:TriggerSkill()
    if self.isInitTransferValue == false then
        return
    end

    local targetList = self.transferAllySelector:SelectTarget(self.myHero.battle)
    if targetList:Count() > 0 then

        local i = 1
        while i <= targetList:Count() do
            local target = targetList:Get(i)

            local statChanger1 = StatChanger(true)
            statChanger1:SetInfo(self.data.transferStatType1, StatChangerCalculationType.RAW_ADD_IN_GAME, self.deadTransferStatValue1)

            local statChanger2 = StatChanger(true)
            statChanger2:SetInfo(self.data.transferStatType2, StatChangerCalculationType.RAW_ADD_IN_GAME, self.deadTransferStatValue2)

            local statChangerEffect = StatTransferEffect(self.myHero, target)
            statChangerEffect:AddStatChanger(statChanger1)
            statChangerEffect:AddStatChanger(statChanger2)

            target.effectController:AddEffect(statChangerEffect)
            i = i + 1
        end
    end
end

return Hero60006_Skill4
