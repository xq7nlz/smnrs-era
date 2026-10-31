--- @class UILinkingSelectHeroView : UIBaseView
UILinkingSelectHeroView = Class(UILinkingSelectHeroView, UIBaseView)

--- @return void
function UILinkingSelectHeroView:Ctor(model)
    ---@type UILinkingPickHero
    self.config = nil
    ---@type HeroListView
    self.heroList = nil

    self.bindDict = Dictionary()
    UIBaseView.Ctor(self, model)
    self.model = model

end

function UILinkingSelectHeroView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)
    self:InitScroll()
    self:InitButtons()
end

function UILinkingSelectHeroView:InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("hero_list")
    self.config.textGreen.text = LanguageUtils.LocalizeCommon("select")
end

function UILinkingSelectHeroView:OnReadyShow(result)
    if result ~= nil then
        self.dataList = result.dataList
        self.selectCallback = result.addHero
    end

    ---@type HeroLinkingTierConfig
    self.linkingConfig = ResourceMgr.GetHeroLinkingTierConfig()

    self:ShowHeroList()
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    --self.uiScroll:PlayMotion()
end

function UILinkingSelectHeroView:InitButtons()
    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.bgClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonSelect.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickSelect()
    end)
end

function UILinkingSelectHeroView:InitScroll()
    self.heroList = HeroListView(self.config.heroList)
    ---- Scroll Hero
    ----- @param obj HeroIconView
    ----- @param index number
    --local onUpdateItemHeroCard = function(obj, index)
    --    ---@type HeroResource
    --    local heroResource = self.listHero:Get(index + 1)
    --    obj:ActiveMaskSelect(false)
    --end
    ------- @param buttonHero HeroIconView
    ------- @param heroIndex number
    --local onCreateItemHeroCard = function(heroIndex, buttonHero, heroResource)
    --    buttonHero:EnableButton(true)
    --    buttonHero:ActiveMaskSelect(false)
    --    ---@type HeroResource
    --    local heroResource = self.listHero:Get(heroIndex + 1)
    --    ---@type HeroIconData
    --    local heroData = HeroIconData.CreateByHeroResource(heroResource) --self.model.heroIconDataListSort:Get(index + 1)
    --    if heroData then
    --        buttonHero:SetIconData(heroData)
    --    end
    --    if self.selectedId ~= nil and self.selectedId == heroResource.inventoryId then
    --        buttonHero:ActiveMaskSelect(true)
    --    else
    --        buttonHero:ActiveMaskSelect(false)
    --    end
    --    --buttonHero:RemoveAllListeners()
    --    --buttonHero:AddListener(function()
    --    --    self:SelectHero(heroResource.inventoryId, buttonHero)
    --    --end)
    --end

    --- @param buttonHero HeroIconView
    local onUpdateIconHero = function(heroIndex, buttonHero, heroResource)
        buttonHero:ActiveMaskSelect(false)
        if self:IsInSomeWhere(heroResource) then
            buttonHero:ActiveMaskLock(true)
        end
    end

    --- @return void
    --- @param heroIndex number
    --- @param buttonHero HeroIconView
    --- @param heroResource HeroResource
    local buttonListener = function(heroIndex, buttonHero, heroResource)
        self:SelectHero(heroResource.inventoryId, buttonHero)
    end

    --- @return boolean
    --- @param heroIndex number
    ---@param heroResource HeroResource
    local filterConditionAnd = function(heroIndex, heroResource)
        local condition = self.linkingConfig:GetMinStarByHeroId(heroResource.heroId)
        return condition ~= nil
    end

    self.heroList:Init(buttonListener, nil, filterConditionAnd, nil, nil, onUpdateIconHero, onUpdateIconHero)
end

function UILinkingSelectHeroView:IsInDataSupport(heroResource)
    if self.dataList ~= nil then
        for i = 1, self.dataList:Count() do
            if self.dataList:Get(i).inventoryId == heroResource.inventoryId or self.dataList:Get(i).heroId == heroResource.heroId then
                return true
            end
        end
    end
    return false
end

function UILinkingSelectHeroView:IsInAncientTree(heroResource)
    return ClientConfigUtils.CheckHeroInAncientTree(heroResource.inventoryId)
end

function UILinkingSelectHeroView:IsInSomeWhere(heroResource)
    local isInSomeWhere = self:IsInDataSupport(heroResource) or self:IsInAncientTree(heroResource)
    return isInSomeWhere
end

function UILinkingSelectHeroView:ShowHeroList()
    self.listHero = InventoryUtils.Get(ResourceType.Hero)
    self.heroList:SetData(self.listHero)
end

--- @param obj HeroRaisePickIconView
--- @return void
function UILinkingSelectHeroView:SelectHero(inventoryId, obj)
    if not self:IsInSomeWhere(InventoryUtils.GetHeroResourceByInventoryId(inventoryId)) then
        if self.selectedId == nil or self.selectedId ~= inventoryId then
            self.selectedId = inventoryId
            --self.uiScroll:RefreshCells()
            self.heroList.uiScroll:RefreshCells()
            obj:ActiveMaskSelect(true)
        end
    else
        SmartPoolUtils.ShowShortNotification(self:GetNotification(inventoryId))
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
    end
end

function UILinkingSelectHeroView:GetNotification(inventoryId)
    local heroResource = InventoryUtils.GetHeroResourceByInventoryId(inventoryId)
    local noti = nil
    if ClientConfigUtils.CheckHeroInAncientTree(inventoryId) then
        noti = LanguageUtils.LocalizeCommon("hero_in_ancient_tree")
    elseif self:IsInDataSupport(heroResource) then
        noti = LanguageUtils.LocalizeCommon("require_unique_hero_id")
    else
        noti = LanguageUtils.LocalizeCommon("can_not_select")
    end
    return noti
end

--- @return void
function UILinkingSelectHeroView:OnClickSelect()
    if self.selectedId ~= nil then
        local onSuccess = function()
            self:OnClickBackOrClose()
        end
        self.selectCallback(self.selectedId, onSuccess)
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("need_to_select"))
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
    end
end

--- @return void
function UILinkingSelectHeroView:Hide()
    UIBaseView.Hide(self)
    --self.uiScroll:Hide()
    self.selectedId = nil
    self.heroList:ReturnPool()
end