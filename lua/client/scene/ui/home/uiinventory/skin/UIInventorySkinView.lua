require "lua.client.scene.ui.utils.uiSelect.UISelectCustomSprite"

--- @class UIInventorySkinView
UIInventorySkinView = Class(UIInventorySkinView)

--- @return void
--- @param transform UnityEngine_Transform
--- @param view UIInventoryView
function UIInventorySkinView:Ctor(view, transform, model)
    --- @type UIInventoryView
    self.view = view
    ---@type UIInventoryModel
    self.model = model
    ---@type List
    self.itemDic = nil
    ---@type List
    self.listSkinData = List()
    --- @type List
    self.listFilteredSkillData = List()

    ---@type UIInventoryArtifactConfig
    self.config = UIBaseConfig(transform)

    -- Select faction
    --- @param obj UnityEngine_UI_Button
    --- @param isSelect boolean
    local onSelectFaction = function(obj, isSelect, indexTab)
        if obj ~= nil then
            UIUtils.SetInteractableButton(obj, not isSelect)
            if isSelect then
                self.config.iconSelect.gameObject:SetActive(true)
                self.config.iconSelect.transform.position = self.config.selectType:GetChild(indexTab - 1).position
            end
        end
    end
    local onChangeSelectFaction = function(indexTab, lastTab)

    end
    local onClickSelectFaction = function(indexTab)
        self:Sort()
    end
    self.selectType = UISelectFactionFilter(self.config.selectType, nil, onSelectFaction, onChangeSelectFaction, onClickSelectFaction)
    self.selectType:SetSprite()

    --- @param obj SkinCardView
    --- @param index number
    local onCreateItem = function(obj, index)
        index = index + 1
        local type = ResourceType.Skin
        --- @type {skinId, number}
        local skinData = self.listFilteredSkillData:Get(index)
        local id = skinData.skinId
        local number = skinData.number
        obj:EnableButton(true)
        obj:SetIconData(ItemIconData.CreateInstance(type, id, number))
        obj:RemoveAllListeners()
        obj:AddListener(function()
            local data = {}
            data.type = ResourceType.Skin
            data.id = id
            data.onBuySuccess = function(isExchange)
                if isExchange then
                    self:Show()
                end
            end
            PopupMgr.ShowPopup(UIPopupName.UISkinPreview, data)
        end)
    end
    ---@type UILoopScroll
    self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.SkinCardView, onCreateItem)

    self.config.buttonCollection.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickCollection()
    end)
end

--- @return void
function UIInventorySkinView:Show()
    if self.buyCompleteSub == nil then
        self.buyCompleteSub = RxMgr.buyCompleted:Subscribe(function()
            self:Show()
        end)
    end

    self.listSkinData:Clear()

    self.config.loadingRotate:SetActive(true)
    InventoryUtils.ValidateSkinInventory(function(skinDict)
        self.config.loadingRotate:SetActive(false)
        for k, v in pairs(skinDict:GetItems()) do
            local data = {}
            data.skinId = k
            data.number = v
            self.listSkinData:Add(data)
        end

        self.selectType:Select(1)
        self:Sort()
    end)
end

--- @return void
function UIInventorySkinView:Hide()
    self.uiScroll:Hide()

    self.config.loadingRotate:SetActive(false)

    if self.buyCompleteSub ~= nil then
        self.buyCompleteSub:Unsubscribe()
        self.buyCompleteSub = nil
    end
end

--- @return void
function UIInventorySkinView:Sort()
    local faction = self.selectType.indexTab - 1
    if faction == 0 then
        faction = nil
    end
    local itemCount = self.listSkinData:Count()

    self.listFilteredSkillData:Clear()
    for i = 1, itemCount do
        --- @type {skinId, number}
        local skinData = self.listSkinData:Get(i)
        local skinFaction = ClientConfigUtils.GetFactionIdByHeroId(ClientConfigUtils.GetHeroIdBySkinId(skinData.skinId))
        if faction == nil or faction == skinFaction then
            self.listFilteredSkillData:Add(skinData)
        end
    end

    itemCount = self.listFilteredSkillData:Count()
    self.uiScroll:Resize(itemCount)
    self.view:EnableEmpty(itemCount == 0)
end

--- @return void
function UIInventorySkinView:OnClickCollection()
    local onBuySuccess = function(isExchange)
        if isExchange then
            self:Show()
        end
    end
    PopupMgr.ShowPopup(UIPopupName.UISkinCollection, onBuySuccess)
end