--- @class BossChallengeDefenderTeamInBound
BossChallengeDefenderTeamInBound = Class(BossChallengeDefenderTeamInBound)

--- @param buffer UnifiedNetwork_ByteBuf
function BossChallengeDefenderTeamInBound:Ctor(buffer)
    --- @type number
    self.stageId = buffer:GetInt()
    --self.stageId = self.stageId + 1
    --- @type List -- <HeroStateInBound>
    self.listHeroState = NetworkUtils.GetListDataInBound(buffer, HeroStateInBound.CreateByBuffer)
    --print("stageId : " .. self.stageId)
    --for i = 1, self.listHeroState:Count() do
    --    print("idHero : " .. i .. "hero : " .. LogUtils.ToDetail(self.listHeroState:Get(i)))
    --end
    --- @type number
    self.bossCreatedTime = buffer:GetLong()
end