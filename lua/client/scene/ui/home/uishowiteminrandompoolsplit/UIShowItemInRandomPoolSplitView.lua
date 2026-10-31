---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiShowItemInRandomPool.UIShowItemInRandomPoolConfig"

--- @class UIShowItemInRandomPoolSplitView : UIBaseView
UIShowItemInRandomPoolSplitView = Class(UIShowItemInRandomPoolSplitView, UIBaseView)

--- @return void
--- @param model UIShowItemInRandomPoolModel
function UIShowItemInRandomPoolSplitView:Ctor(model)
    --- @type UIShowItemInRandomPoolSplitConfig
    self.config = nil
    --- @type ItemsTableView
    self.itemsTableView = nil
    --- @type ItemsTableView
    self.itemsTableView2 = nil
    UIBaseView.Ctor(self, model)
    --- @type UIShowItemInRandomPoolModel
    self.model = model
end

--- @return void
function UIShowItemInRandomPoolSplitView:OnReadyCreate()
    ---@type UIShowItemInRandomPoolConfig
    self.config = UIBaseConfig(self.uiTransform)

    self:InitButtonListener()
    self.itemsTableView = ItemsTableView(self.config.content)
    self.itemsTableView2 = ItemsTableView(self.config.content2)
end

function UIShowItemInRandomPoolSplitView:InitLocalization()
    self.config.textItemPool.text = LanguageUtils.LocalizeCommon("random_item_pool")
    self.config.textCompleteReward.text = LanguageUtils.LocalizeCommon("complete_reward")
end

function UIShowItemInRandomPoolSplitView:InitButtonListener()
    self.config.bgClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

function UIShowItemInRandomPoolSplitView:SetLocalize(key1, key2)
    self.config.textItemPool.text = LanguageUtils.LocalizeCommon(key1)
    self.config.textCompleteReward.text = LanguageUtils.LocalizeCommon(key2)
end

--- @type {listRewardIconData : List}
function UIShowItemInRandomPoolSplitView:OnReadyShow(data)
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    if data.localize then
        self:SetLocalize(data.localize.key1, data.localize.key2)
    end
    local uiPoolType = data.uiPoolType
    self.itemsTableView:SetData(data.listRewardIconData, uiPoolType)
    self.itemsTableView2:SetData(data.listRewardIconData2, uiPoolType)

end

function UIShowItemInRandomPoolSplitView:Hide()
    UIBaseView.Hide(self)
    self:InitLocalization()
    self.itemsTableView:Hide()
    self.itemsTableView2:Hide()
end