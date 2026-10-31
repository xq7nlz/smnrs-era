--- @class DefenseWaveRecordBasicItem
DefenseWaveRecordBasicItem = Class(DefenseWaveRecordBasicItem)

function DefenseWaveRecordBasicItem:Ctor(buffer)
    if buffer then
        self:ReadBuffer(buffer)
    end
end

--- @param buffer UnifiedNetwork_ByteBuf
function DefenseWaveRecordBasicItem:ReadBuffer(buffer)
    self.wave = buffer:GetByte()
    self.remainHp = buffer:GetInt()

    self.towerTeamStateDict = Dictionary()
    local size = buffer:GetByte()
    for i = 1, size do
        local towerId = buffer:GetByte()
        local listHeroState = NetworkUtils.GetListDataInBound(buffer, HeroStateInBound.CreateByBuffer)
        self.towerTeamStateDict:Add(towerId, listHeroState)
    end
end

function DefenseWaveRecordBasicItem:GetArgTeamHp(towerId)
    --- @type List
    local listHeroState = self.towerTeamStateDict:Get(towerId)
    if listHeroState then
        local hp = 0
        local count = listHeroState:Count()
        for i = 1, count do
            --- @type HeroStateInBound
            local heroStateInBound = listHeroState:Get(i)
            hp = hp + heroStateInBound.hp
        end
        return hp / count
    end
    return nil
end

function DefenseWaveRecordBasicItem:GetListHeroState(towerId)
    return self.towerTeamStateDict:Get(towerId) or List()
end