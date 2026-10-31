
---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiItemPreview.UIItemPreviewConfig"
require "lua.client.scene.ui.home.uiFastForge.UIItemPreviewChildFastForgeView"

--- @class UIItemPreviewFastForgeView
UIItemPreviewFastForgeView = Class(UIItemPreviewFastForgeView)

--- @return void
function UIItemPreviewFastForgeView:Ctor(uiTransform)
    ---@type UIItemPreviewFastForgeConfig
    self.config = nil
    ---@type UIItemPreviewChildFastForgeView
    self.previewChild1 = nil
    ---@type UIItemPreviewChildFastForgeView
    self.previewChild2 = nil

    self.uiTransform = uiTransform
    self:OnReadyCreate()
end

--- @return void
function UIItemPreviewFastForgeView:OnReadyCreate()
    ---@type UIItemPreviewConfig
    self.config = UIBaseConfig(self.uiTransform)
    self.previewChild1 = UIItemPreviewChildFastForgeView(self.config.view1)
    self.previewChild2 = UIItemPreviewChildFastForgeView(self.config.view2)
end

function UIItemPreviewFastForgeView:InitLocalization()
end

--- @return void
function UIItemPreviewFastForgeView:Init(result)
    if result.data1 == nil then
        if self.previewChild1 ~= nil then
            self.previewChild1.config.gameObject:SetActive(false)
        end
    else
        self.previewChild1.config.gameObject:SetActive(true)
        self.previewChild1:Show(result.data1)
    end
    if result.data2 == nil then
        if self.previewChild2 ~= nil then
            self.previewChild2.config.gameObject:SetActive(false)
        end
    else
        self.previewChild2.config.gameObject:SetActive(true)
        self.previewChild2:Show(result.data2)
    end
end

--- @return void
function UIItemPreviewFastForgeView:ShowPreview(result)
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    if result ~= nil then
        self:Init(result)
    end
end

--- @return void
function UIItemPreviewFastForgeView:Hide()
    UIBaseView.Hide(self)
    if self.previewChild1 ~= nil then
        self.previewChild1:Hide()
    end
    if self.previewChild2 ~= nil then
        self.previewChild2:Hide()
    end

    self:RemoveListenerTutorial()
end
