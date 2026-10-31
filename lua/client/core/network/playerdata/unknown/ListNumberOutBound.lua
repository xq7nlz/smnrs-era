require "lua.client.core.network.playerData.unknown.PutMethod"


--- @class ListNumberOutBound : OutBound
ListNumberOutBound = Class(ListNumberOutBound, OutBound)

--- @return void
function ListNumberOutBound:Ctor()
    --- @type List -- number
    self.listNumber = List()
end

function ListNumberOutBound.CreateInstance(_listNumber)
    local inst = ListNumberOutBound()
    inst:SetData(_listNumber)
    return inst
end

function ListNumberOutBound:SetData(_listNumber)
    --- @type {}
    self.listNumber = _listNumber
end

    --- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function ListNumberOutBound:Serialize(buffer)
    buffer:PutByte(self.listNumber:Count())
    for i = 1, self.listNumber:Count() do
        ---@type UpgradeArtifactHeroInfoOutBound
        local item = self.listNumber:Get(i)
        buffer:PutInt(item)
    end
end