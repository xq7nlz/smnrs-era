require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackLayout"

--- @class IapTilePackLargeItem : IapTilePackItem
IapTilePackLargeItem = Class(IapTilePackLargeItem, IapTilePackItem)

function IapTilePackLargeItem:Ctor()
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

function IapTilePackLargeItem:SetPrefabName()
    self.prefabName = 'iap_tile_pack_large_item'
    self.uiPoolType = UIPoolType.IapTilePackLargeItem
end

function IapTilePackLargeItem:SetViewIconData(packViewType, data, listener)
    IapTilePackItem.SetViewIconData(self, packViewType, data, listener)
    self.config.textBundleTitle.text = LanguageUtils.LocalizeCommon("bundle").." ".. data.id
end

return IapTilePackLargeItem