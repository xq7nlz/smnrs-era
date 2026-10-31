--- @class UIEliteSummonPickWishView : UIBaseView
UIEliteSummonPickWishView = Class(UIEliteSummonPickWishView, UIBaseView)

--- @return void
--- @param model UIEliteSummonPickWishModel
function UIEliteSummonPickWishView:Ctor(model)
    --- @type number
    self.wishId = nil
    --- @type UILoopScroll
    self.scroll = nil
    --- @type Dictionary
    self.objDict = Dictionary()
    UIBaseView.Ctor(self, model)
    --- @type UIEliteSummonPickWishModel
    self.model = model
end

--- @return void
function UIEliteSummonPickWishView:OnReadyCreate()
    ---@type UIEliteSummonPickWishConfig
    self.config = UIBaseConfig(self.uiTransform)

    self:InitButtonListener()
    self:InitScroll()
    --self:InitHeroList()
end

--- @return void
function UIEliteSummonPickWishView:InitLocalization()
    self.config.textGreen.text = LanguageUtils.LocalizeCommon("select")
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("select_elite_summon_wish")
end

function UIEliteSummonPickWishView:InitButtonListener()
    self.config.bgClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonSelect.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickSelect()
    end)
end

function UIEliteSummonPickWishView:InitScroll()
    --- @param obj RootIconView
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        self.objDict:Add(dataIndex, obj)
        --- @type {rewardInBound : RewardInBound, pity}
        local data = self.wishDict:Get(dataIndex)
        obj:SetIconData(data.rewardInBound:GetIconData())
        obj:ActiveMaskSelect(dataIndex == self.wishId)
        obj:AddListener(function()
            self:OnClickWishId(obj, dataIndex)
        end)
    end
    self.scroll = UILoopScroll(self.config.scroll, UIPoolType.RootIconView, onCreateItem)
end

function UIEliteSummonPickWishView:InitHeroList()
    self.heroList = HeroListView(self.config.heroList)

    --- @return void
    --- @param heroIndex number
    --- @param buttonHero HeroIconView
    --- @param heroResource HeroResource
    self.onUpdateIconHero = function(heroIndex, buttonHero, heroResource)
        if ClientConfigUtils.CheckHeroInTraining(heroResource.inventoryId) then
            buttonHero:ActiveMaskLock(true, UIUtils.sizeItem)
        else
            buttonHero:ActiveMaskLock(false)
            if self.isSelectHeroEvolve == true and self:IsContainHeroEvolve(heroResource) then
                buttonHero:ActiveMaskSelect(true, UIUtils.sizeItem)
            elseif self.isSelectHeroEvolve == false and self:IsContainMaterialEvolve(heroResource) then
                buttonHero:ActiveMaskSelect(true, UIUtils.sizeItem)
            else
                buttonHero:ActiveMaskSelect(false)
            end
        end
        buttonHero:EnableButton(true)
    end

    --- @return void
    --- @param heroIndex number
    --- @param buttonHero HeroIconView
    --- @param heroResource HeroResource
    self.buttonListener = function(heroIndex, buttonHero, heroResource)
        if ClientConfigUtils.CheckHeroInTraining(heroResource.inventoryId) then
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("hero_in_training"))
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        else
            if self.isSelectHeroEvolve then
                self:OnSelectHeroEvolve(heroResource)
            else
                self:OnSelectMaterialEvolve(heroResource)
            end
        end
        self.onUpdateIconHero(heroIndex, buttonHero, heroResource)
    end

    self.heroList:Init(self.buttonListener, nil, nil, nil, nil,
            self.onUpdateIconHero, self.onUpdateIconHero)
end

--- @param data {wishDict : Dictionary, callbackSelect, selectedWishId}
function UIEliteSummonPickWishView:OnReadyShow(data)
    self.wishDict = data.wishDict
    self.wishId = data.selectedWishId
    self.callbackSelect = data.callbackSelect

    self.scroll:Resize(self.wishDict:Count())
end

function UIEliteSummonPickWishView:OnClickSelect()
    if self.wishId == nil then
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("need_to_select"))
        return
    end
    self:OnReadyHide()
    if self.callbackSelect then
        self.callbackSelect(self.wishId)
    end
end

function UIEliteSummonPickWishView:Hide()
    UIBaseView.Hide(self)
    self.scroll:Hide()
    --self.heroList:ReturnPool()
end

--- @param obj RootIconView
function UIEliteSummonPickWishView:OnClickWishId(obj, wishId)
    if self.wishId == wishId then
        obj:ActiveMaskSelect(false)
        self.wishId = nil
    else
        --- @type RootIconView
        local currentObj = self.objDict:Get(self.wishId)
        if currentObj ~= nil then
            currentObj:ActiveMaskSelect(false)
        end
        obj:ActiveMaskSelect(true)
        self.wishId = wishId
    end
end