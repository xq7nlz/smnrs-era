---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiDungeonSeller.UIDungeonSellerConfig"

--- @class UIDungeonSellerView : UIBaseView
UIDungeonSellerView = Class(UIDungeonSellerView, UIBaseView)

--- @return void
--- @param model UIDungeonSellerModel
--- @param ctrl UIDungeonSellerCtrl
function UIDungeonSellerView:Ctor(model, ctrl)
    --- @type
    self.config = nil
    UIBaseView.Ctor(self, model, ctrl)
    --- @type UIDungeonSellerModel
    self.model = model
    --- @type UIDungeonSellerCtrl
    self.ctrl = ctrl
end

--- @return void
function UIDungeonSellerView:OnReadyCreate()
    ---@type UIDungeonSellerConfig
    self.config = UIBaseConfig(self.uiTransform)

    self:_InitButtonListener()
end

--- @return void
function UIDungeonSellerView:InitLocalization()
    self.config.localizeTitle.text = LanguageUtils.LocalizeCommon("mysterious_merchant")
    self.config.localizePrimary.text = LanguageUtils.LocalizeCommon("primary")
    self.config.localizeMedium.text = LanguageUtils.LocalizeCommon("medium")
    self.config.localizeSenior.text = LanguageUtils.LocalizeCommon("senior")
    local buy = LanguageUtils.LocalizeCommon("buy")
    self.config.localizeBuy1.text = buy
    self.config.localizeBuy2.text = buy
    self.config.localizeBuy3.text = buy
end

function UIDungeonSellerView:_InitButtonListener()
    self.config.bgFog.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonBuyPrimary.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:_ShowStore(UIDungeonSellerModel.Child, LanguageUtils.LocalizeCommon("primary_merchant"))
    end)
    self.config.buttonBuyMedium.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:_ShowStore(UIDungeonSellerModel.Woman, LanguageUtils.LocalizeCommon("medium_merchant"))
    end)
    self.config.buttonBuySenior.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:_ShowStore(UIDungeonSellerModel.Granny, LanguageUtils.LocalizeCommon("senior_merchant"))
    end)
end

--- @return void
--- @param seller number
--- @param tittle string
function UIDungeonSellerView:_ShowStore(seller, tittle)
    self.model.sellerId = seller
    PopupMgr.ShowPopup(UIPopupName.UIDungeonPrimaryMerchant, { ["seller"] = seller, ["tittle"] = tittle })
end



