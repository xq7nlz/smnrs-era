require "lua.client.core.network.playerData.common.HeroStateInBound"
require "lua.client.core.network.event.eventBossChallenge.BossChallengeBattleLogInBound"

--- @class BossChallengeTowerBattleResultInBound : BattleResultInBound
BossChallengeTowerBattleResultInBound = Class(BossChallengeTowerBattleResultInBound ,BattleResultInBound )

--- @return void
function BossChallengeTowerBattleResultInBound:Ctor()
    --- @type boolean
    self.isWin = nil
    --- @type List
    self.heroStateAttacker = nil
    --- @type List
    self.heroStateDefender = nil
    --- @type List
    self.defenderHeroState = nil
    --- @type SeedInBound
    self.seedInBound = nil
    --- @type Dictionary
    self.activeLinking = nil
    --- @type boolean
    self.isKazetsuDead = nil
    --- @type string
    self.battleLog = nil
    --- @type number
    self.currentFinalStageTeamId = nil
    ---@type number
    self.battleIndex = 1
    --- @type List
    self.listBattleLogs = List()
end

--- @return number
function BossChallengeTowerBattleResultInBound:GetBattleIndex()
    return self.battleIndex
end

--- @return number
function BossChallengeTowerBattleResultInBound:IncreaseBattleIndex()
    if self.battleIndex < self.listBattleLogs:Count() then
        self.battleIndex = self.battleIndex + 1
    end
end

--- @return BossChallengeTowerBattleResultInBound
--- @param buffer UnifiedNetwork_ByteBuf
--- @param isApply boolean
function BossChallengeTowerBattleResultInBound.CreateByBuffer(buffer, isApply)
    local data = BossChallengeTowerBattleResultInBound()

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
    data.battleLog = buffer:GetString(false)

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

    data.defenderHeroState = NetworkUtils.GetListDataInBound(buffer, HeroStateInBound.CreateByBuffer)
    data.currentFinalStageTeamId = buffer:GetInt()

    size = buffer:GetByte()
    for i = 1,size do
        data.listBattleLogs:Add(BossChallengeBattleLogInBound(buffer))
    end

    return data
end