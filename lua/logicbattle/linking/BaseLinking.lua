--- @class BaseLinking
BaseLinking = Class(BaseLinking)

--- @return void
function BaseLinking:Ctor()
    --- @type number
    self.id = nil

    --- @type string
    self.name = nil

    --- @type Dictionary<number, BonusTier> key: tier level, value: BonusTier
    self.bonusTiers = Dictionary()

    --- @type List
    self.affectedHero = List()
end

--- @return void
--- @param parsedData table
function BaseLinking:ParseCsv(parsedData)
    self.id = tonumber(parsedData.id)
    self.name = parsedData.name

    local affectedHeroIds = parsedData[EffectConstants.STAT_AFFECTED_HERO_TAG]
    local heroIds = affectedHeroIds:Split(";")
    for j = 1, #heroIds do
        self.affectedHero:Add(tonumber(heroIds[j]))
    end

    --print(self.affectedHero:ToString())
end

--- @return boolean
--- @param hero number
function BaseLinking:IsContainEffectedHero(hero)
    local i = 1
    while i <= self.affectedHero:Count() do
        local heroId = self.affectedHero:Get(i)
        if heroId == hero then
            return true
        end
        i = i + 1
    end

    return false
end

--- @return boolean
--- @param team BattleTeam
--- @param level number
function BaseLinking:AddEffectToTeam(team, level)
    local heroList = team:GetHeroList()

    for i = 1, heroList:Count() do
        ---@type BaseHero
        local hero = heroList:Get(i)
        if self:IsContainEffectedHero(hero.id) then

            for j = 1, level do
                ---@type BonusTier
                local bonusTier = self.bonusTiers:Get(j)
                local bonuses = bonusTier:GetBonuses()

                for k = 1, bonuses:Count() do
                    local bonusStat = bonuses:Get(k)
                    self:AddStatChangerEffect(hero, hero, bonusStat)
                end
            end
        end
    end
end

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param statBonus StatBonus
function BaseLinking:AddStatChangerEffect(initiator, target, statBonus)
    if statBonus.affectedFaction == nil or target.originInfo.faction == statBonus.affectedFaction then
        local effect = StatChangerEffect(initiator, target, true)
        effect:SetPersistentType(EffectPersistentType.PERMANENT)
        effect:SetDuration(EffectConstants.INFINITY_DURATION)
        effect:SetEffectSource(StatChangerEffectSource.LINKING)

        local statChanger = StatChanger(true)
        statChanger:SetInfo(statBonus.statType, statBonus.calculationType, statBonus.amount)
        effect:AddStatChanger(statChanger)

        target.effectController:AddEffect(effect)
    end
end

--- @return void
--- @param bonus BonusTier
function BaseLinking:AddBonusTier(bonus)
    self.bonusTiers:Add(bonus.level, bonus)
end