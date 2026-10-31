--- @class HeroStateWithPosition
HeroStateWithPosition = Class(HeroStateWithPosition)

--- @param buffer UnifiedNetwork_ByteBuf
function HeroStateWithPosition:Ctor(buffer)
    ---@type boolean
    self.isFrontLine = buffer:GetBool()
    if self.isBoss == true then
        ---@type FriendBoss
        self.friendBoss = FriendBoss.CreateByBuffer(buffer)
    else
        ---@type List
        self.listReward = NetworkUtils.GetRewardInBoundList(buffer)
    end
end