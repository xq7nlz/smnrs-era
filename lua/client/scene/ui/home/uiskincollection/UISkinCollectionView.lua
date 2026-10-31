require "lua.client.scene.ui.utils.uiSelect.UISelectCustomSprite"

--- @class UISkinCollectionView : UIBaseView
UISkinCollectionView = Class(UISkinCollectionView, UIBaseView)

--- @return void
--- @param model UISkinCollectionModel
function UISkinCollectionView:Ctor(model, ctrl)
    ---@type UISkinCollectionConfig
    self.config = nil
    ---@type UISelectFactionFilter
    self.selectType = nil
    ---@type UILoopScroll
    self.uiScroll = nil

    -- init variables here
    UIBaseView.Ctor(self, model, ctrl)
    ---@type UISkinCollectionModel
    self.model = model
end

--- @return void
function UISkinCollectionView:OnReadyCreate()
    ---@type UISkinCollectionConfig
    self.config = UIBaseConfig(self.uiTransform)

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
    self.selectType = UISelectFactionFilter(self.config.selectType, nil,
            onSelectFaction, onChangeSelectFaction, onClickSelectFaction)
    self.selectType:SetSprite()

    --- @param obj SkinCardView
    --- @param index number
    local onCreateItem = function(obj, index)
        local type = ResourceType.Skin
        local id = self.model.itemDic:Get(index + 1)
        obj:EnableButton(true)
        obj:SetIconData(ItemIconData.CreateInstance(type, id))
        obj:RemoveAllListeners()
        obj:AddListener(function()
            PopupMgr.ShowPopup(UIPopupName.UISkinPreview, { ["type"] = type, ["id"] = id, ["onBuySuccess"] = self.onBuySuccess })
        end)
    end
    self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.SkinCardView, onCreateItem)

    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.bgClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

--- @return void
function UISkinCollectionView:InitLocalization()
    self.config.titleArtifactCollection.text = LanguageUtils.LocalizeCommon("gallery")
    self.config.textEmpty.text = LanguageUtils.LocalizeCommon("empty")
end

function UISkinCollectionView:OnReadyShow(onBuySuccess)
    self.onBuySuccess = onBuySuccess
    self.selectType:Select(1)
    self:Sort()
end

--- @return void
function UISkinCollectionView:Sort()
    local faction = self.selectType.indexTab - 1
    if faction == 0 then
        faction = nil
    end
    self.model.itemDic = UISkinCollectionView.GetSkinCollection(1, nil, faction)
    self.uiScroll:Resize(self.model.itemDic:Count())
    self.config.empty:SetActive(self.model.itemDic:Count() <= 0)
end

--- @return List <number>
function UISkinCollectionView.GetSkinCollection(sort, rarity, faction)
    local list = List()
    ---@param skinDataEntry SkinDataEntry
    for k, skinDataEntry in pairs(ResourceMgr.GetServiceConfig():GetItems().skinDataEntries:GetItems()) do
        if (rarity == nil or skinDataEntry.rarity == rarity) and (faction == nil
                or faction == ClientConfigUtils.GetFactionIdByHeroId(ClientConfigUtils.GetHeroIdBySkinId(skinDataEntry.id))) then
            if ClientConfigUtils.IsSkinUnlock(k) then
                list:Add(k)
            end
        end
    end

    if sort ~= nil then
        if sort == 1 then
            list:SortWithMethod(SortUtils._SkinSortRarity)
        end
    end
    return list
end