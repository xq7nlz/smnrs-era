--- @class ItemPassive_290402:BaseItemPassiveSkill  --Talent passive First round benefit
ItemPassive_290402 = Class(ItemPassive_290402, BaseItemPassiveSkill)

--- @return void
--- @param id number id of talent level 10, 11, 12
--- @param hero BaseHero
function ItemPassive_290402:Ctor(id, hero)
    BaseItemPassiveSkill.Ctor(self, id, hero)
    --- @type number
    self.burnPercent = nil

    --- @type number
    self.burnRound = nil

    --- @type boolean
    self.isCastBurn = false
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function ItemPassive_290402:CreateInstance(id, hero)
    return ItemPassive_290402(id, hero)
end

--- @return void
function ItemPassive_290402:Init()
    self.burnPercent = tonumber(self.data.fields.burn_percent)
    self.burnRound = tonumber(self.data.fields.burn_round)
    local listener = EventListener(self.myHero, self, self.CastBurningMark)
    self.myHero.battle.eventManager:AddListener(EventType.START_ROUND, listener)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param eventData table
function ItemPassive_290402:CastBurningMark(eventData)
    if eventData.initiator ~= self.myHero then
        return
    end

    if self.isCastBurn then
        return
    end

    local enemyTargetSelector = TargetSelectorBuilder.Create(self.myHero, TargetPositionType.PREFER_FRONT_LINE,
            TargetTeamType.ENEMY, 5)
    local targetList = enemyTargetSelector:SelectTarget(self.myHero.battle)

    local i = 1
    local burnEffect = nil
    while i <= targetList:Count() do
        local target = targetList:Get(i)
        burnEffect = ItemPassive290402_BurningEffect(self.myHero, target)
        burnEffect:SetDuration(self.burnRound)
        burnEffect:SetDotAmount(self.burnPercent)
        burnEffect:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL_UPDATABLE)

        target.effectController:AddEffect(burnEffect)
        i = i + 1
    end

    self.isCastBurn = true
end

return ItemPassive_290402