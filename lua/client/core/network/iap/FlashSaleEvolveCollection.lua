--- @class FlashSaleEvolveCollection
FlashSaleEvolveCollection = Class(FlashSaleEvolveCollection)

function FlashSaleEvolveCollection:Ctor()
    ---@type List
    self.listHeroId = nil
end

--- @param buffer UnifiedNetwork_ByteBuf
function FlashSaleEvolveCollection:ReadBuffer(buffer)
    self.listHeroId = List()
    for _ = 1, buffer:GetByte() do
        self.listHeroId:Add(buffer:GetInt())
    end
end

--- @return List
function FlashSaleEvolveCollection:GetListIdHeroActive()
    return self.listHeroId
end

--- @return List
function FlashSaleEvolveCollection:ClearListIdHeroActive()
    self.listHeroId:Clear()
    self.listHeroId = List()
end