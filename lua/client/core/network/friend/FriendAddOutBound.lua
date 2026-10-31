--- @class FriendAddOutBound : OutBound
FriendAddOutBound = Class(FriendAddOutBound, OutBound)

--- @return void
function FriendAddOutBound:Ctor()
    ---@type List
    self.listFriendId = List()
    ---@type boolean
    self.isAccept = nil
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function FriendAddOutBound:Serialize(buffer)
    buffer:PutBool(self.isAccept)
    buffer:PutShort(self.listFriendId:Count())
    for _, v in ipairs(self.listFriendId:GetItems()) do
        buffer:PutLong(v)
    end
end