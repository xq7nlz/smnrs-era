--- @class EventSkinHotDealConfig
EventSkinHotDealConfig = Class(EventSkinHotDealConfig)

local SKIN_BUNDLE_HOT_PACK = "skin_bundle_pack.csv"

function EventSkinHotDealConfig:Ctor(path)
    --- @type string
    self.path = path
    --- @type SkinRawProducts
    self.skinRawProducts = nil
end

--- @return SkinRawProducts
function EventSkinHotDealConfig:GetSkinProductConfigs()
    if self.skinRawProducts == nil then
        local pathSkinBundle = string.format("%s/%s", self.path, SKIN_BUNDLE_HOT_PACK)
        self.skinRawProducts = SkinRawProducts(OpCode.EVENT_SKIN_HOT_DEAL_PURCHASE, ProductConfig, pathSkinBundle)
    end
    return self.skinRawProducts
end

return EventSkinHotDealConfig