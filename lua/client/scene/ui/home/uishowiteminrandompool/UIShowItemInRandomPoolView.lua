---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiShowItemInRandomPool.UIShowItemInRandomPoolConfig"

--- @class UIShowItemInRandomPoolView : UIBaseView
UIShowItemInRandomPoolView = Class(UIShowItemInRandomPoolView, UIBaseView)

--- @return void
--- @param model UIShowItemInRandomPoolModel
function UIShowItemInRandomPoolView:Ctor(model)
    --- @type UIShowItemInRandomPoolConfig
    self.config = nil
    --- @type ItemsTableView
    self.itemsTableView = nil
    UIBaseView.Ctor(self, model)
    --- @type UIShowItemInRandomPoolModel
    self.model = model
end

--- @return void
function UIShowItemInRandomPoolView:OnReadyCreate()
    ---@type UIShowItemInRandomPoolConfig
    self.config = UIBaseConfig(self.uiTransform)

    self:InitButtonListener()
    self.itemsTableView = ItemsTableView(self.config.content)
end

function UIShowItemInRandomPoolView:InitLocalization()
    self.config.textItemPool.text = LanguageUtils.LocalizeCommon("random_item_pool")
end

function UIShowItemInRandomPoolView:InitButtonListener()
    self.config.bgClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

--- @type {listRewardIconData : List}
function UIShowItemInRandomPoolView:OnReadyShow(data)
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    local uiPoolType = data.uiPoolType
    self.itemsTableView:SetData(data.listRewardIconData,uiPoolType)
end

function UIShowItemInRandomPoolView:Hide()
    UIBaseView.Hide(self)
    self.itemsTableView:Hide()
end