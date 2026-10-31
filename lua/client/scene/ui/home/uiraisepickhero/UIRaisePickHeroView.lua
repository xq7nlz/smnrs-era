require "lua.client.scene.ui.home.uiRaiseLevelHero.RaiseBindingOutbound"

--- @class UIRaisePickHeroView : UIBaseView
UIRaisePickHeroView = Class(UIRaisePickHeroView, UIBaseView)

--- @return void
--- @param model UIRaiseLevelHeroModel
function UIRaisePickHeroView:Ctor(model)
    ---@type UIRaisePickHeroConfig
    self.config = nil

    self.heroList = nil
    self.bindDict = Dictionary()
    ---@type PlayerRaiseLevelInbound
    self.playerRaiseLevelInbound = nil
    UIBaseView.Ctor(self, model)
    self.model = model

end

function UIRaisePickHeroView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)
    self:InitScroll()
    self:InitButtons()
end

function UIRaisePickHeroView:InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("hero_list")
    self.config.textGreen.text = LanguageUtils.LocalizeCommon("select")
end

function UIRaisePickHeroView:OnReadyShow(result)
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    self.selectedId = nil
    self.raisedSlotIndex = result.index
    self.resetEffect = result.resetEffect
    self.playerRaiseLevelInbound = zg.playerData:GetRaiseLevelHero()
    self.heroList = InventoryUtils.Get(ResourceType.Hero)
    self:ShowHeroList()
    self.uiScroll:PlayMotion()
end

function UIRaisePickHeroView:InitButtons()
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

function UIRaisePickHeroView:InitScroll()
    -- Scroll Hero
    --- @param obj HeroRaisePickIconView
    --- @param index number
    local onUpdateItemHeroCard = function(obj, index)
        ---@type HeroResource
        local heroResource = self.heroList:Get(index + 1)
        obj:ActiveEffectSelect(false)
        local state = self:GetState(heroResource.inventoryId)
        obj:SetupView(state)
    end
    --- @param obj HeroRaisePickIconView
    --- @param index number
    local onCreateItemHeroCard = function(obj, index)
        onUpdateItemHeroCard(obj, index)
        obj:EnableButton(true)
        obj:ActiveEffectSelect(false)
        ---@type HeroResource
        local heroResource = self.heroList:Get(index + 1)
        ---@type HeroIconData
        local heroData = HeroIconData.CreateByHeroResource(heroResource) --self.model.heroIconDataListSort:Get(index + 1)
        if heroData then
            obj:SetIconData(heroData)
        end
        if self.selectedId == nil then
            local state = self:GetState(heroResource.inventoryId)
            obj:SetupView(state)
        end
        obj:RemoveAllListeners()
        obj:AddListener(function()
            self:SelectHero(heroResource.inventoryId, obj)
        end)
    end
    self.uiScroll = UILoopScrollAsync(self.config.scroll, UIPoolType.RaiseHeroPickIconView, onCreateItemHeroCard, onUpdateItemHeroCard)
    self.uiScroll:SetUpMotion(MotionConfig(0, 0, 0, 0.02, 4))
end
---@return string
function UIRaisePickHeroView:GetNotification(inventoryId)
    local noti = nil
    if self.playerRaiseLevelInbound:IsInPentaGram(inventoryId) then
        noti = LanguageUtils.LocalizeCommon("hero_in_pentagram")
    elseif self.playerRaiseLevelInbound:IsInRaisedSlot(inventoryId) then
        noti = LanguageUtils.LocalizeCommon("hero_in_raise_level")
    elseif ClientConfigUtils.CheckHeroInTraining(inventoryId) then
        noti = LanguageUtils.LocalizeCommon("hero_in_training")
    elseif ClientConfigUtils.CheckHeroInAncientTree(inventoryId) then
        noti = LanguageUtils.LocalizeCommon("hero_in_ancient_tree")
    elseif self.playerRaiseLevelInbound:IsTheSameHeroId(inventoryId) then
        noti = LanguageUtils.LocalizeCommon("same_hero_id")
    else
        noti = LanguageUtils.LocalizeCommon("can_not_select")
    end
    return noti
end

function UIRaisePickHeroView:GetState(inventory)
    local state = nil
    if self.playerRaiseLevelInbound:IsInPentaGram(inventory) then
        state = HeroRaisePickIconView.STATE.PENTAGRAM
    elseif self.playerRaiseLevelInbound:IsInRaisedSlot(inventory) then
        state = HeroRaisePickIconView.STATE.RAISE_SLOT
    elseif self.playerRaiseLevelInbound:IsTheSameHeroId(inventory) then
        state = HeroRaisePickIconView.STATE.SAME_HERO_ID
    elseif ClientConfigUtils.CheckHeroInTraining(inventory) then
        state = HeroRaisePickIconView.STATE.TRAINING
    elseif ClientConfigUtils.CheckHeroInAncientTree(inventory) then
        state = HeroRaisePickIconView.STATE.ANCIENT_TREE
    elseif self.selectedId ~= nil and self.selectedId ~= inventory then
        state = HeroRaisePickIconView.STATE.HIDE
    else
        state = HeroRaisePickIconView.STATE.NOT_SELECT
    end
    return state
end
function UIRaisePickHeroView:ShowHeroList()
    self.uiScroll:Resize(self.heroList:Count())
end
--- @param obj HeroRaisePickIconView
--- @return void
function UIRaisePickHeroView:SelectHero(inventoryId, obj)
    local state = self:GetState(inventoryId)
    if state == HeroRaisePickIconView.STATE.NOT_SELECT or state == HeroRaisePickIconView.STATE.HIDE then
        if self.selectedId == nil or self.selectedId ~= inventoryId then
            self.selectedId = inventoryId
            self.uiScroll:RefreshCells()
            obj:ActiveEffectSelect(true)
        end
    else
        SmartPoolUtils.ShowShortNotification(self:GetNotification(inventoryId))
    end
end

--- @return void
function UIRaisePickHeroView:OnClickSelect()
    if self.selectedId ~= nil then
        local onSuccess = function()
            self.playerRaiseLevelInbound:AddRaisedSlot(self.raisedSlotIndex, self.selectedId)
            PopupMgr.ShowPopup(UIPopupName.UIRaiseLevelHero, { ["show"] = false })
            PopupMgr.ShowAndHidePopup(UIPopupName.UIPopupEnhanceRaiseLevel, { ["inventoryId"] = self.selectedId, ["index"] = self.raisedSlotIndex },
                    UIPopupName.UIRaisePickHero)
            if self.resetEffect ~= nil then
                self.resetEffect()
            end
        end
        local onFail = function(logicCode)
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeLogicCode(logicCode))
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        end
        self.bindDict:Add(self.raisedSlotIndex, self.selectedId)
        local outbound = RaiseBindingOutbound()
        outbound.bindingDict:Add(self.raisedSlotIndex, self.selectedId)
        NetworkUtils.RequestAndCallback(OpCode.RAISE_HERO_BIND_RAISED_HEROES, outbound, onSuccess, onFail)
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("need_to_select"))
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
    end
end

--- @return void
function UIRaisePickHeroView:Hide()
    UIBaseView.Hide(self)
    self.uiScroll:Hide()
end