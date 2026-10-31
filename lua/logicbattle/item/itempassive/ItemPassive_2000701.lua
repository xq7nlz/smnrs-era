--- @class ItemPassive_2000701 Talent passive No silence on me!
ItemPassive_2000701 = Class(ItemPassive_2000701, BaseItemPassiveSkill)

--- @return void
--- @param id number id of talent level 10, 11, 12
--- @param hero BaseHero
function ItemPassive_2000701:Ctor(id, hero)
    BaseItemPassiveSkill.Ctor(self, id, hero)

    --- @type number
    self.triggerChance = nil

    --- @type BattleRound
    self.round = nil

    --- @type boolean
    self.isCastResist = false
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function ItemPassive_2000701:CreateInstance(id, hero)
    return ItemPassive_2000701(id, hero)
end

--- @return void
function ItemPassive_2000701:Init()
    self.triggerChance = tonumber(self.data.fields.trigger_chance)

    local listener = EventListener(self.myHero, self, self.CalculateSilenceResist)
    self.myHero.battle.eventManager:AddListener(EventType.START_ROUND, listener)

    local markEffect = TalentBlockSilentEffect(self.myHero, self.myHero)
    self.myHero.effectController:AddEffect(markEffect)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param eventData table
function ItemPassive_2000701:CalculateSilenceResist(eventData)
    if eventData.initiator ~= self.myHero then
        return
    end
    --- Check cuz event sent duplicate
    if self.round ~= eventData.round then
        self.round = eventData.round
        self.isCastResist = false
    end

    if self.isCastResist then
        return
    end

    local talentShield =  self.myHero.effectController:GetDistinctEffectWithType(EffectType.TALENT_BLOCK_SILENT_CAST)
    if talentShield ~= nil then
        self.myHero.effectController:ForceRemove(talentShield)
    end

    if self.myHero.randomHelper:RandomRate(self.triggerChance) then
        local markEffect = TalentBlockSilentCastEffect(self.myHero, self.myHero)
        self.myHero.effectController:AddEffect(markEffect)

        self.isCastResist = true
    end
end

return ItemPassive_2000701