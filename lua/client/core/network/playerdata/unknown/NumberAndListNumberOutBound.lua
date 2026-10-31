require "lua.client.core.network.playerData.unknown.PutMethod"

--- @class NumberAndListNumberOutBound : OutBound
NumberAndListNumberOutBound = Class(NumberAndListNumberOutBound, OutBound)

--- @return void
function NumberAndListNumberOutBound:Ctor()
    --- @type number
    self.id = nil
    --- @type List -- number
    self.listNumber = List()
end

function NumberAndListNumberOutBound.CreateInstance(id, _listNumber)
    local inst = NumberAndListNumberOutBound()
    inst:SetData(id,_listNumber)
    return inst
end

function NumberAndListNumberOutBound:SetData(id,_listNumber)
    self.id = id
    self.listNumber = _listNumber
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function NumberAndListNumberOutBound:Serialize(buffer)
    buffer:PutInt(self.id)
    buffer:PutByte(self.listNumber:Count())
    for i = 1, self.listNumber:Count() do
        ---@type UpgradeArtifactHeroInfoOutBound
        local item = self.listNumber:Get(i)
        buffer:PutInt(item)
    end
end