require "lua.client.core.network.playerData.defenseMode.TeamHeroState"

--- @class WaveChallengeData
WaveChallengeData = Class(WaveChallengeData)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function WaveChallengeData:Ctor(buffer)
    --- @type Dictionary
    self.towerHpDict = Dictionary()
    if buffer ~= nil then
        self:ReadBuffer(buffer)
    end
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function WaveChallengeData:ReadBuffer(buffer)
    --- @type number
    self.isChallenging = buffer:GetBool()
    if self.isChallenging ~= true then
        return
    end

    --- @type number
    self.reachWave = buffer:GetByte()
    --- @type number
    self.mainConstructionHp = buffer:GetInt()
    self.towerHpDict = Dictionary()
    local size = buffer:GetByte()
    if size > 0 then
        for i = 1, size do
            self.towerHpDict:Add(buffer:GetByte(), buffer:GetLong() / MathUtils.BILLION)
        end
    end
end

--- @return number
function WaveChallengeData:GetRoadHp(road)
    if self.isChallenging == false then
        return 1
    end
    if self.towerHpDict:IsContainKey(road) == true then
        return self.towerHpDict:Get(road)
    end
    return 1
end

--- @param defenseChallengeResultInBound DefenseChallengeResultInBound
function WaveChallengeData:FakeWaveDataByChallengeResult(defenseChallengeResultInBound)
    --- @param v TowerBattleResultInBound
    for k, v in pairs(defenseChallengeResultInBound.challengeResultDict:GetItems()) do
        self.towerHpDict:Add(k, v.defenseHp)
    end
end