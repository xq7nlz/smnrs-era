require "lua.client.scene.ui.common.prefabHeroInfo.PrefabHeroInfo2View"
require "lua.client.core.network.starterPack.ProgressPackItemSelectOutbound"

--- @class UIPreviewStarterPackView : UIBaseView
UIPreviewStarterPackView = Class(UIPreviewStarterPackView, UIBaseView)

--- @param model UIPreviewStarterPackModel
function UIPreviewStarterPackView:Ctor(model)
    --- @type UIPreviewStarterPackConfig
    self.config = nil
    --- @type UISelect
    self.tabSkinCollection = nil
    --- @type HeroResource
    self.heroResource = nil
    --- @type List
    self.heroResourceList = nil
    --- @type List
    self.rewardSelectionList = nil
    ------@type number
    self.heroId = nil
    ------@type number
    self.packId = nil
    ------@type number
    self.currentHeroTab = nil
    ---@type PrefabHeroInfo2View
    self.prefabHeroInfoView = nil
    --- @type WorldSpaceHeroView
    self.worldSpaceHeroView = nil
    UIBaseView.Ctor(self, model)
    --- @type UIPreviewStarterPackModel
    self.model = model
    self.callBackSelectSuccess = nil
    self.curSelectedIdx = nil
    self.callbackClosed = nil
    --- @type Dictionary
    self.selectItems = Dictionary()
end

function UIPreviewStarterPackView:CreateHeroResourceTabList()
    --- @param obj HeroIconView
    --- @param index number
    local onUpdateItem = function(obj, index)
        ---@type HeroResource
        local heroResource = self.heroResourceList:Get(index + 1)
        --- @type IconView
        local data = HeroIconData.CreateByHeroResourceStarterPack(heroResource)
        obj:SetIconData(data)
        local isSelected = self.currentHeroTab == index + 1
        if (isSelected) then
            UIUtils.SetParent(self.config.selectBorder.transform, obj.config.transform)
            self.config.selectBorder.gameObject:SetActive(true)
        end
        -- if self.showClass then
        --obj:ShowClassHero()
        --[[       -- end
                if self.onUpdateItem ~= nil then
                    self.onUpdateItem(index, obj, heroResource)
                end]]
    end
    --- @param obj HeroIconView
    --- @param index number
    local onCreateItem = function(obj, index)
        ---@type HeroResource

        obj:AddListener(function()
            self:OnSelectHeroTab(index + 1)
        end)
        --[[        if self.onCreateItem ~= nil then
                    self.onCreateItem(heroIndex, obj, heroResource)
                end]]
        onUpdateItem(obj, index)
    end

    self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.HeroIconView, onCreateItem, onUpdateItem)
    --self.uiScroll:SetUpMotion(MotionConfig(0, 0, 0, 0.01))
end

function UIPreviewStarterPackView:OnSelectHeroTab(index, forceReload)
    if (not forceReload and index == self.currentHeroTab) then
        return
    end
    --set position of
    self:OnSelectHero(index)
    self.uiScroll:RefreshCells()
end

function UIPreviewStarterPackView:OnSelectHero(index)
    self.currentHeroTab = index
    self.heroResource = self.heroResourceList:Get(index)
    self:ShowHeroModel()
    --if heroResource.inventoryId == nil then
    --self.config.tab.gameObject:SetActive(false)
    self.config.skinCollection.gameObject:SetActive(true)
    self.tabSkinCollection:Select(1)
    --else
    --self.config.tab.gameObject:SetActive(true)
    --self.config.skinCollection.gameObject:SetActive(false)
    --self:UpdateLastStatHero()
    --self:UpdateHero()
    --end
end

function UIPreviewStarterPackView:Init(result)
    self.selectItems = result.selectItems
    self.curSelectedIdx = 1
    self.heroResourceList = List()
    if result ~= nil then
       self.callbackClosed = result.callbackClosed
        self.packId = result.packId
        self.rewardSelectionList = result.rewardSelectionList
        if (result.selectedIndex ~= nil and result.selectedIndex > 0) then
            self.curSelectedIdx = result.selectedIndex
        end
        self.callBackSelectSuccess = result.onSelectHeroSuccess
        for i = 1, self.rewardSelectionList:Count(), 1 do
            ---@type SelectReward
            local selectHeroReward = self.rewardSelectionList:Get(i)
            ---@type RewardInBound
            local rewardInBound = selectHeroReward.rewardInBound
            ---@type number
            local heroId = ClientConfigUtils.GetHeroIdByFragmentHeroId(rewardInBound.id)
            -- XDebug.Log("add id " .. tostring(selectionId))
            local heroResourceTemp = HeroResource.CreateInstance(nil, tonumber(heroId), 5, 1)
            self.heroResourceList:Add(heroResourceTemp)
        end
    end
    self.uiScroll:Resize(self.heroResourceList:Count())
    self:OnSelectHeroTab(self.curSelectedIdx, true)
end

--- @param heroResource HeroResource
function UIPreviewStarterPackView:ShowHeroModel()
    local heroResource = self.heroResource
    self.prefabHeroInfoView:SetData(heroResource)
    if self.worldSpaceHeroView == nil then
        ---@type UnityEngine_Transform
        local trans = SmartPool.Instance:SpawnTransform(AssetType.Battle, "world_space_hero_view")
        self.worldSpaceHeroView = WorldSpaceHeroView(trans)

        local renderTexture = U_RenderTexture(1000, 1000, 24, U_RenderTextureFormat.ARGB32)
        self.config.rawImage.texture = renderTexture
        self.worldSpaceHeroView:Init(renderTexture)
    end
    self.worldSpaceHeroView:ShowHero(heroResource)
    self.worldSpaceHeroView.config.transform.position = U_Vector3(100, 100, 0)
    self.previousScale =self.worldSpaceHeroView.config.heroAnchor.transform.localScale
    self.worldSpaceHeroView.config.heroAnchor.transform.localScale = U_Vector3(1.3,1.3, 1)
    self.worldSpaceHeroView.config.bg:SetActive(false)
end

function UIPreviewStarterPackView:SelectSkinCollection(skinIndex)
    -- XDebug.Log("skin index " .. tostring (skinIndex))
    if skinIndex ~= nil then
        if skinIndex == 1 then
            self.heroResource.heroStar = ResourceMgr.GetHeroMenuConfig():GetDictHeroBaseStar(self.heroResource.heroId)
        elseif skinIndex == 2 then
            self.heroResource.heroStar = 7
        elseif skinIndex == 3 then
            self.heroResource.heroStar = 13
        end
        ---@type HeroLevelCapConfig
        local heroLevelCap = ResourceMgr.GetHeroMenuConfig():GetHeroLevelCapDictionary(self.heroResource.heroStar)
        --self.heroResource.heroLevel = heroLevelCap.levelCap
    end
end

function UIPreviewStarterPackView:UpdateHeroResource()
    if self.tabSkinCollection ~= nil and self.tabSkinCollection.indexTab ~= nil then
        self:SelectSkinCollection(self.tabSkinCollection.indexTab)
        self:ShowHeroModel()
    end
end
function UIPreviewStarterPackView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)
    self.prefabHeroInfoView = PrefabHeroInfo2View(self.config.prefabHeroInfo2)
    self:InitButtons()

    -- Tab Skin
    --- @param obj UnityEngine_UI_Button
    --- @param isSelect boolean
    local onSelectSkin = function(obj, isSelect, indexTab)
        if obj ~= nil then
            UIUtils.SetInteractableButton(obj, not isSelect)
            obj.transform:GetChild(0).gameObject:SetActive(not isSelect)
            obj.transform:GetChild(1).gameObject:SetActive(isSelect)
        end
    end
    local onChangeSelectSkin = function(indexTab, lastTab)
        if indexTab ~= nil then
            self:UpdateHeroResource()
        end
    end
    self.tabSkinCollection = UISelect(self.config.skinCollection, nil, onSelectSkin, onChangeSelectSkin, onClickSelectSkin)
    self:CreateHeroResourceTabList()
end

function UIPreviewStarterPackView:SelectHero()
    local selectIdInList = self.currentHeroTab
    ---@type SelectReward
    local selectHeroReward = self.rewardSelectionList:Get(selectIdInList)
    local selectId = selectHeroReward.selectionId
    --XDebug.Log("click select " .. tostring(selectId))
    self.selectItems:Add(1, selectId)
    local onSuccess = function()
        self.callBackSelectSuccess(self.selectItems)
        self:OnClickBackOrClose()
    end

    local outBound = ProgressPackItemSelectOutbound(self.packId,
            self.selectItems:Count(), self.selectItems)
    NetworkUtils.RequestAndCallback(OpCode.PROGRESS_PACK_ITEM_SELECT, outBound, onSuccess)
end

function UIPreviewStarterPackView:InitButtons()
    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.bgNone.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonSelect.onClick:AddListener(function()
        self:SelectHero()
    end)
end

function UIPreviewStarterPackView:InitLocalization()
    self.config.textSelect.text = LanguageUtils.LocalizeCommon("select")
end

--- @param data {callbackClose : function}
function UIPreviewStarterPackView:OnReadyShow(result)
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)

    UIBaseView.OnReadyShow(self, heroResource)
    self:Init(result)
end

function UIPreviewStarterPackView:Hide()
    if self.callbackClosed ~= nil then
        self.callbackClosed()
    end

    UIUtils.SetParent(self.config.selectBorder.transform, self.config.transform)
    --self.config.selectBorder.transform:SetParent(self.config.transform)
    self.config.selectBorder.gameObject:SetActive(false)
    UIBaseView.Hide(self)
    self.prefabHeroInfoView:OnHide()
    if self.worldSpaceHeroView ~= nil then
        self.worldSpaceHeroView:OnHide()
        --self.worldSpaceHeroView.config.heroAnchor.localScale = U_Vector3(1,1,1)
        if self.previousScale ~= nil then
            self.worldSpaceHeroView.config.heroAnchor.localScale = self.previousScale
        end
        self.worldSpaceHeroView = nil
    end
    self.uiScroll:Hide()
end