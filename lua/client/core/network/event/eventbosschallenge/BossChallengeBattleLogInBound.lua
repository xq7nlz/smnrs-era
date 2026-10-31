--- @class BossChallengeBattleLogInBound
BossChallengeBattleLogInBound = Class(BossChallengeBattleLogInBound)

--- @param buffer UnifiedNetwork_ByteBuf
function BossChallengeBattleLogInBound:Ctor(buffer)
    --- @type number
    self.defenderTeamId = buffer:GetInt()
    --print("Defender Team Inbound: " .. self.defenderTeamId)

    self.selectedHeroWithStateList = List()
    self.size = buffer:GetByte()
    for i = 1, self.size do
        local selectedHeroStage = {}
        selectedHeroStage.selectHeroId = buffer:GetInt()
        selectedHeroStage.hpPercent =  buffer:GetLong()/1000000000
        selectedHeroStage.power =  buffer:GetByte()
        if selectedHeroStage.selectHeroId ~= nil then
            self.selectedHeroWithStateList:Add(selectedHeroStage)
        end
    end

    self.battleLog = buffer:GetString(false)
    self.listReward = NetworkUtils.GetRewardInBoundList(buffer)
end

--- @return Dictionary
function BossChallengeBattleLogInBound:ConvertHeroWithStateToDict()
    --- @type Dictionary
    local HeroWithStateDict = Dictionary()
    for i = 1, self.selectedHeroWithStateList:Count() do
        local item = self.selectedHeroWithStateList:Get(i)
        local heroState = {}
        heroState.hpPercent = item.hpPercent
        heroState.power = item.power
        HeroWithStateDict:Add(item.selectHeroId, heroState)
        --print("Hero Id : " .. item.selectHeroId .. "Hero HP : " .. heroState.hpPercent)
    end
    return HeroWithStateDict
end