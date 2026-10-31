--- @class LinkingHeroDataInBound
LinkingHeroDataInBound = Class(LinkingHeroDataInBound)

function LinkingHeroDataInBound:Ctor()

end

--- @param buffer UnifiedNetwork_ByteBuf
function LinkingHeroDataInBound:ReadBuffer(buffer)
    ---@type number
    self.slot = buffer:GetByte()
    ---@type number
    self.inventoryId = buffer:GetLong()
    self.isOwnHero = buffer:GetBool()
    if self.isOwnHero == false then
        ---@type number
        self.friendId = buffer:GetLong()
    end
end