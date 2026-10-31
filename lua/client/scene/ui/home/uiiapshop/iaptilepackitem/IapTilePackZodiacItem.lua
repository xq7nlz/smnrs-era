require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackLayout"

--- @class IapTilePackZodiacItem : IapTilePackItem
IapTilePackZodiacItem = Class(IapTilePackZodiacItem, IapTilePackItem)

function IapTilePackZodiacItem:Ctor()
    --- @type IapTilePackLargeItemConfig
    self.config = nil
    --- @type UIResItemRawPack
    self.rewardItem = nil
    --- @type UIResItemRawPack
    self.rewardVip = nil
    --- @type OpCode
    self.opCode = OpCode.PURCHASE_RAW_PACK
    --- @type number
    self.packId = nil
    --- @type number
    self.packKey = nil
    --- @type Dictionary
    self.layoutDict = Dictionary()
    --- @type IapTilePackLayout
    self.layout = nil
    IconView.Ctor(self)
end

function IapTilePackZodiacItem:SetPrefabName()
    self.prefabName = 'iap_tile_pack_zodiac_item'
    self.uiPoolType = UIPoolType.IapTilePackZodiacItem
end

return IapTilePackZodiacItem