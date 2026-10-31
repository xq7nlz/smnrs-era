require "lua.client.core.network.playerData.common.HeroStateInBound"

--- @class KazetsuTowerBattleResultInBound : BattleResultInBound
KazetsuTowerBattleResultInBound = Class(KazetsuTowerBattleResultInBound ,BattleResultInBound )

--- @return void
function KazetsuTowerBattleResultInBound:Ctor()
    --- @type boolean
    self.isWin = nil
    --- @type List
    self.heroStateAttacker = nil
    --- @type List
    self.heroStateDefender = nil
    --- @type SeedInBound
    self.seedInBound = nil
    --- @type Dictionaryt
    self.activeLinking = nil
    --- @type boolean
    self.isKazetsuDead = nil
end

--- @return KazetsuTowerBattleResultInBound
--- @param buffer UnifiedNetwork_ByteBuf
--- @param isApply boolean
function KazetsuTowerBattleResultInBound.CreateByBuffer(buffer, isApply)
    local data = KazetsuTowerBattleResultInBound()

    data.isWin = buffer:GetBool()

    data.heroStateAttacker = NetworkUtils.GetListDataInBound(buffer, HeroStateInBound.CreateByBuffer)
    data.heroStateDefender = NetworkUtils.GetListDataInBound(buffer, HeroStateInBound.CreateByBuffer)

    data.seedInBound = SeedInBound.CreateByBuffer(buffer)
    if isApply == nil or isApply == true then
        data.seedInBound:Initialize()
    end
    local size = buffer:GetByte()
    data.activeLinking = Dictionary()
    for i = 1, size do
        data.activeLinking:Add(buffer:GetInt(), buffer:GetInt())
    end
    zg.playerData:SetActiveLinking(data.activeLinking)

    --- Read dda buffer
    buffer:GetByte()

    data.isKazetsuDead = buffer:GetBool()
    data.selectedHeroWithStateList = List()
    size = buffer:GetByte()
    for i = 1, size do
        local selectedHeroStage = {}
        selectedHeroStage.selectHeroId = buffer:GetInt()
        selectedHeroStage.hpPercent =  buffer:GetLong()/1000000000
        selectedHeroStage.power =  buffer:GetByte()
        if selectedHeroStage.selectHeroId ~= nil then
            data.selectedHeroWithStateList:Add(selectedHeroStage)
        end
    end
    return data
end