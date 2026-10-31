--- @class MultiQuestIdOutBound : OutBound
MultiQuestIdOutBound = Class(MultiQuestIdOutBound, OutBound)

--- @return void
function MultiQuestIdOutBound:Ctor( listQuestId)
    --- @type List
    self.listQuestId = listQuestId
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function MultiQuestIdOutBound:Serialize(buffer)
    buffer:PutByte(self.listQuestId:Count())
    for i = 1, self.listQuestId:Count() do
        buffer:PutInt(self.listQuestId:Get(i))
    end
end