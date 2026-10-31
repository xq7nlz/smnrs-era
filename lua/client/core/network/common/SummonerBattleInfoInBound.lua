--- @class SummonerBattleInfoInBound
SummonerBattleInfoInBound = Class(SummonerBattleInfoInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function SummonerBattleInfoInBound:Ctor(buffer)
    --- @type SummonerBattleInfo
    self.summonerBattleInfo = self:GetSummonerBattleInfoByBuffer(buffer)
    --- @type Dictionary
    self.masteryDict = NetworkUtils.GetDictMastery(buffer)
    local size = buffer:GetByte()
    --- @type Dictionary
    self.linkingDict = Dictionary()
    for i = 1, size do
        self.linkingDict:Add(buffer:GetByte(), buffer:GetByte())
    end
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function SummonerBattleInfoInBound:GetSummonerBattleInfoByBuffer(buffer)
    local summonerBattleInfo = SummonerBattleInfo()
    summonerBattleInfo.isDummy = buffer:GetBool()
    if summonerBattleInfo.isDummy == false then
        summonerBattleInfo.star = buffer:GetByte()
        summonerBattleInfo.summonerId = buffer:GetByte()
        local size = buffer:GetByte()
        summonerBattleInfo.skills = List()
        for i = 1, size do
            summonerBattleInfo.skills:Add(buffer:GetByte())
        end
    else
        summonerBattleInfo.summonerId = 0
        summonerBattleInfo.star = 3
    end
    --XDebug.Log(LogUtils.ToDetail(summonerBattleInfo))
    return summonerBattleInfo
end