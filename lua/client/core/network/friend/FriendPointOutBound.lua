--- @class FriendPointOutBound : OutBound
FriendPointOutBound = Class(FriendPointOutBound, OutBound)

--- @return void
function FriendPointOutBound:Ctor()
    ---@type List
    self.listFriendId = List()
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function FriendPointOutBound:Serialize(buffer)
    buffer:PutByte(self.listFriendId:Count())
    for _, v in ipairs(self.listFriendId:GetItems()) do
        buffer:PutLong(v)
    end
end