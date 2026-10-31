--- @class Hero60010_Skill4 Diadora
Hero60010_Skill4 = Class(Hero60010_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60010_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.targetSelectorEffect = nil

    --- @type BaseTargetSelector
    self.targetSelectorBuff = nil

    --- @type number
    self.effectType = 0

    --- @type number
    self.statBuffChance = false
    --- @type StatType
    self.statBuffType = false
    --- @type number
    self.statBuffAmount = false

    --- @type number
    self.duration = 0
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60010_Skill4:CreateInstance(id, hero)
    return Hero60010_Skill4(id, hero)
end

--- @return void
function Hero60010_Skill4:Init()
    self.effectType = self.data.effectType
    self.statBuffChance = self.data.statBuffChance
    self.statBuffType = self.data.statBuffType
    self.statBuffAmount = self.data.statBuffAmount
    self.duration = self.data.duration

    self.targetSelectorEffect = TargetSelectorBuilder.Create(self.myHero, self.data.targetPositionEffect,
            TargetTeamType.ENEMY, self.data.targetNumberEffect)

    self.targetSelectorBuff = TargetSelectorBuilder.Create(self.myHero, self.data.targetPositionBuff,
            TargetTeamType.ALLY, self.data.targetNumberBuff)

    local listener = EventListener(self.myHero, self, self.OnHeroDead)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_DEAD, listener)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param eventData table
function Hero60010_Skill4:OnHeroDead(eventData)
    if eventData.target == self.myHero then
        local inflictTargetList = self.targetSelectorEffect:SelectTarget(self.myHero.battle)
        local i = 1
        while i <= inflictTargetList:Count() do
            local target = inflictTargetList:Get(i)
            local effect = SilenceEffect(self.myHero, target, self.duration)
            target.effectController:AddEffect(effect)
            i = i + 1
        end

        if self.myHero.randomHelper:RandomRate(self.statBuffChance) then
            local buffTargetList = self.targetSelectorBuff:SelectTarget(self.myHero.battle)
            i = 1
            while i <= buffTargetList:Count() do
                local target = buffTargetList:Get(i)
                local statBuff = StatChanger(true)
                statBuff:SetInfo(self.statBuffType, StatChangerCalculationType.PERCENT_ADD, self.statBuffAmount)

                local effectBuff = StatChangerEffect(self.myHero, target, true)
                effectBuff:SetDuration(self.duration)
                effectBuff:AddStatChanger(statBuff)

                target.effectController:AddEffect(effectBuff)
                i = i + 1
            end
        end
    end
end

return Hero60010_Skill4