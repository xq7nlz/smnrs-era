require "lua.client.scene.ui.utils.uiSelect.UISelectCustomSprite"

--- @class UIInventoryArtifactView
UIInventoryArtifactView = Class(UIInventoryArtifactView)

--- @return void
--- @param transform UnityEngine_Transform
--- @param view UIInventoryView
function UIInventoryArtifactView:Ctor(view, transform, model)
    --- @type UIInventoryView
    self.view = view
    ---@type UIInventoryModel
    self.model = model
    ---@type List --<id>
    self.itemDic = nil

    ---@type UIInventoryArtifactConfig
    ---@type UIInventoryArtifactConfig
    self.config = UIBaseConfig(transform)

    -- Select faction
    local onChangeSelect = function (indexTab)
        if indexTab == nil then
            self.config.iconSelect.gameObject:SetActive(false)
        else
            self.config.iconSelect.gameObject:SetActive(true)
            self.config.iconSelect.transform.position = self.config.selectType:GetChild(indexTab - 1).position
        end
        self:Sort()
    end
    self.selectType = UISelectRarityFilter(self.config.selectType, nil, nil, onChangeSelect)
    --self.selectType:SetSprite()

    --- @param obj ItemIconView
    --- @param index number
    local onCreateItem = function(obj, index)
        local type = ResourceType.ItemArtifact
        local id = self.itemDic:Get(index + 1)
        local number = InventoryUtils.Get(type, id)
        obj:EnableButton(true)
        obj:SetIconData(ItemIconData.CreateInstance(type, id, number))
        obj:RemoveAllListeners()
        obj:AddListener(function ()
            zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
            PopupMgr.ShowPopup(UIPopupName.UIItemPreview, { ["data1"] = {["type"] = type, ["id"] = id}})
        end)
    end
    ---@type UILoopScroll
    self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.ItemIconView, onCreateItem)
    self.config.buttonCollection.onClick:AddListener(function ()
        self:OnClickCollection()
    end)
end

--- @return void
function UIInventoryArtifactView:Show()
    self.selectType:Select(nil)
end

--- @return void
function UIInventoryArtifactView:Hide()
    self.uiScroll:Hide()
end

--- @return void
function UIInventoryArtifactView:Sort()
    if self.selectType.indexTab ~= nil then
        self.itemDic = InventoryUtils.GetArtifact( 1, self.selectType.indexTab)
    else
        self.itemDic = InventoryUtils.GetArtifact(1)
    end
    local itemCount = self.itemDic:Count()
    self.uiScroll:Resize(itemCount)
    self.view:EnableEmpty(itemCount == 0)
end

--- @return void
function UIInventoryArtifactView:OnClickCollection()
    PopupMgr.ShowPopup(UIPopupName.UIArtifactCollection)
    zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
end