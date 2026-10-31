---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiCashShop.raw.UIResItemRawPackConfig"

--- @class UIResItemRawPack : IconView
UIResItemRawPack = Class(UIResItemRawPack, IconView)

function UIResItemRawPack:Ctor()
    --- @type UIResItemRawPackConfig
    self.config = nil

    IconView.Ctor(self)
end

function UIResItemRawPack:SetPrefabName()
    self.prefabName = 'res_item_raw_pack'
    self.uiPoolType = UIPoolType.UIResItemRawPack
end

--- @param transform UnityEngine_Transform
function UIResItemRawPack:SetConfig(transform)
    ---@type UIResItemRawPackConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
--- @param data {moneyType:MoneyType, content:string}
function UIResItemRawPack:SetIconData(data)
    local scale = self.config.transform.parent.localScale
    local ratio = scale.y / scale.x
    assert(data and data.moneyType and data.content)
    self.config.resIcon.sprite = ResourceLoadUtils.LoadMoneyIcon(data.moneyType)
    self.config.resIcon.transform.localScale = U_Vector3(ratio, 1, 1)
    self.config.textResValue.text = data.content
end

return UIResItemRawPack