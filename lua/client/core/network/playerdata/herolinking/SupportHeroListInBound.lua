--- @class SupportHeroListInBound
SupportHeroListInBound = Class(SupportHeroListInBound)

function SupportHeroListInBound:Ctor()
    --- @type List
    self.listSupportHeroData = List()
end

--- @param buffer UnifiedNetwork_ByteBuf
function SupportHeroListInBound:ReadBuffer(buffer)
    self.listSupportHeroData = NetworkUtils.GetListDataInBound(buffer, SupportHeroData.CreateByBuffer)
end