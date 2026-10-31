--- @class UIEventLunarNewYearSpringBoxLayout : UIEventLunarNewYearLayout
UIEventLunarNewYearSpringBoxLayout = Class(UIEventLunarNewYearSpringBoxLayout, UIEventLunarNewYearLayout)

--- @param view UIEventNewYearView
--- @param newYearTab LunarNewYearTab
--- @param anchor UnityEngine_RectTransform
function UIEventLunarNewYearSpringBoxLayout:Ctor(view, newYearTab, anchor)
    --- @type UIEventLunarNewYearSpringBoxLayoutConfig
    self.layoutConfig = nil
    --- @type EventLunarNewYearConfig
    self.eventConfig = nil

    --- @type EventLunarNewYearModel
    self.eventModel = nil

    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_LUNAR_NEW_YEAR_2022

    --- List price and items of all gift box
    self.listBoxReward = nil

    --- @type number amount of exchange left
    self.numberBought = nil

    --- Price and items inside selected gift box
    self.boxRewardSelected = nil

    --- @type string
    self.localizeLimitText = nil

    --- @type number
    self.packBuyId = 1

    ---@type MoneyBarView
    self.moneyBar = nil
    
    UIEventLunarNewYearLayout.Ctor(self ,view, newYearTab, anchor)
    
    --- @type OpCode
    self.opCode = OpCode.EVENT_LUNAR_2022_SPRING_BOX_EXCHANGE
end

function UIEventLunarNewYearSpringBoxLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("lunar_new_year_spring_box", self.anchor)
    UIEventLunarNewYearLayout.InitLayoutConfig(self, inst)
    self:InitLocalization()
    self:InitButtonListener()
end

function UIEventLunarNewYearSpringBoxLayout:SetUpLayout()
    UIEventLunarNewYearLayout.SetUpLayout(self)
    self:HideSelectedBox()
    self.anchor.gameObject:SetActive(true)
end

function UIEventLunarNewYearSpringBoxLayout:SetEventBanner()
end

function UIEventLunarNewYearSpringBoxLayout:SetEventTitle()
end

function UIEventLunarNewYearSpringBoxLayout:SetEventDesc()
end

function UIEventLunarNewYearSpringBoxLayout:OnShow()
    self:GetModelConfig()
    UIEventLunarNewYearLayout.OnShow(self)
    self:GetGiftBoxes()
    self:SetUpGemBar()
end

--- @return void
--- Localize text display in screen
function UIEventLunarNewYearSpringBoxLayout:InitLocalization()
    --- Localize common text
    self.layoutConfig.textBuy.text = LanguageUtils.LocalizeCommon("buy")
    self.layoutConfig.textFree.text = LanguageUtils.LocalizeCommon("free")
    self.layoutConfig.textPleaseSelectBox.text = LanguageUtils.LocalizeCommon("please_select_box")
    
    --- Localize text of each gift box
    self.layoutConfig.textWaterBox.text = LanguageUtils.LocalizeCommon("water_box")
    self.layoutConfig.textFireBox.text = LanguageUtils.LocalizeCommon("fire_box")
    self.layoutConfig.textAbyssBox.text = LanguageUtils.LocalizeCommon("abyss_box")
    self.layoutConfig.textNatureBox.text = LanguageUtils.LocalizeCommon("nature_box")
    self.layoutConfig.textLightBox.text = LanguageUtils.LocalizeCommon("light_box")
    self.layoutConfig.textDarkBox.text = LanguageUtils.LocalizeCommon("dark_box")

    self.localizeLimitText = LanguageUtils.LocalizeCommon("limit_x")
end

--- @return void
function UIEventLunarNewYearSpringBoxLayout:InitButtonListener()
    self.layoutConfig.waterBox.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickGiftBox(GiftBoxType.WATER, self.layoutConfig.waterBox)
    end)
    self.layoutConfig.fireBox.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickGiftBox(GiftBoxType.FIRE, self.layoutConfig.fireBox)
    end)
    self.layoutConfig.abyssBox.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickGiftBox(GiftBoxType.ABYSS, self.layoutConfig.abyssBox)
    end)
    self.layoutConfig.natureBox.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickGiftBox(GiftBoxType.NATURE, self.layoutConfig.natureBox)
    end)
    self.layoutConfig.lightBox.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickGiftBox(GiftBoxType.LIGHT, self.layoutConfig.lightBox)
    end)
    self.layoutConfig.darkBox.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickGiftBox(GiftBoxType.DARK, self.layoutConfig.darkBox)
    end)
    self.layoutConfig.chosenBox.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:PreviewSelectedChest()
    end)
    self.layoutConfig.buttonFree.onClick:AddListener(function()
        self:OnClaimFreeGiftBox()
    end)
    self.layoutConfig.buttonBuy.onClick:AddListener(function()
        self:OnBuyGiftBox()
    end)
end

--- @return void
--- @param giftBoxType GiftBoxType
--- @param selectedBoxUI UnityEngine_UI_Button
--- Add event trigger when clicked on gift boxes
function UIEventLunarNewYearSpringBoxLayout:OnClickGiftBox(giftBoxType, selectedBoxUI)
    self:SelectGiftBox(giftBoxType, selectedBoxUI)
end

--- @return void
--- Hide all selected gift box game object
function UIEventLunarNewYearSpringBoxLayout:HideSelectedBox()
    self:SetActiveFreeOrBuyButton(nil)
    self:ShowSelectedBoxImage(nil)
    self.layoutConfig.selectedOutline.gameObject:SetActive(false)
    self.layoutConfig.textLimit.gameObject:SetActive(false)

    self.layoutConfig.textPleaseSelectBox.gameObject:SetActive(true)
end

--- @return void
--- Get list reward of all gift box from csv 
function UIEventLunarNewYearSpringBoxLayout:GetGiftBoxes()
    --- @type Dictionary
    local result = self.eventConfig:GetListBoxReward()
    if(result ~= nil) then
        self.listBoxReward = result
    end
end


--- @return void
--- Get list reward of all gift box from csv
function UIEventLunarNewYearSpringBoxLayout:SetUpGemBar()
    self.moneyBar = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.gemTopBar)
    self.moneyBar:SetIconData(MoneyType.GEM)
end



--- @return void
--- @param giftBoxType GiftBoxType
--- @param selectedBoxUI UnityEngine_UI_Button
--- Select gift box and get reward list of corresponding gift box
function UIEventLunarNewYearSpringBoxLayout:SelectGiftBox(giftBoxType, selectedBoxUI)
    --- Get reward list from corresponding gift box
    self.boxRewardSelected = self.listBoxReward:Get(giftBoxType)
    
    --- Check box selected has data yet or not?
    if(self.boxRewardSelected ~= nil) then
        --- Set highlight circle outlet to selected box
        self:highLightSelectedBox(selectedBoxUI)

        --- Show gift box inside circle at center layout
        self:ShowSelectedBoxImage(giftBoxType)

        --- Show Button Buy/Free for selected gift box
        self:UpdateButton()

        --- Show and Update limit time left to buy
        self:UpdateLimit()
    end
end

--- @return void
--- @param selectedBoxUI UnityEngine_UI_Button
--- Set highlight circle outlet to selected box
function UIEventLunarNewYearSpringBoxLayout:highLightSelectedBox(selectedBoxUI)
    --- Put highlight GO inside hierarchy of selected box GO
    self.layoutConfig.selectedOutline.gameObject:SetActive(true)
    self.layoutConfig.selectedOutline.gameObject.transform:SetParent(selectedBoxUI.gameObject.transform, false)
    self.layoutConfig.selectedOutline.transform.position = selectedBoxUI.transform.position
    --- Set Highlight Outlet GO order to before text and after Default Outlet GO
    self.layoutConfig.selectedOutline.transform:SetSiblingIndex(1)
end

--- @return void
--- @param giftBoxType GiftBoxType
--- Update image of selected box and show it on ui
function UIEventLunarNewYearSpringBoxLayout:ShowSelectedBoxImage(giftBoxType)
    if(giftBoxType ~= nil) then
        self.boxRewardSelected.imageBoxChosen = ResourceLoadUtils.LoadSpringBoxIcon(giftBoxType)
        self.layoutConfig.imageBoxChosen.sprite = self.boxRewardSelected.imageBoxChosen
        self.layoutConfig.imageBoxChosen.gameObject:SetActive(true)
        self.layoutConfig.textPleaseSelectBox.gameObject:SetActive(false)
    else
        self.layoutConfig.imageBoxChosen.sprite = nil
        self.layoutConfig.imageBoxChosen.gameObject:SetActive(false)
    end
end

--- @return void
--- Update Button Buy/Free for selected gift box
function UIEventLunarNewYearSpringBoxLayout:UpdateButton()
    self.layoutConfig.textCurrency.text =  self.boxRewardSelected.moneyValue
    --- Show Buy button if already claimed free spring box and vice versa
    if(self.eventModel:IsNotClaimedFreeSpringBox()) then
        self:SetActiveFreeOrBuyButton(true)
    else
        self:SetActiveFreeOrBuyButton(false)
    end
end

--- @return void
--- @param isEnable boolean
--- True: enable Free button, false: enable Buy button, no argument: disable both button
function UIEventLunarNewYearSpringBoxLayout:SetActiveFreeOrBuyButton(isEnable)
    if isEnable == nil then
        self.layoutConfig.buttonFree.gameObject:SetActive(false)
        self.layoutConfig.buttonBuy.gameObject:SetActive(false)
    else
        self.layoutConfig.buttonFree.gameObject:SetActive(isEnable)
        self.layoutConfig.textLimit.gameObject:SetActive(not isEnable)
        self.layoutConfig.buttonBuy.gameObject:SetActive(not isEnable)
    end
end

--- @return void
--- Update the amount of time left as player can buy gift box
function UIEventLunarNewYearSpringBoxLayout:UpdateLimit()
    self.numberBought = self.eventModel:GetNumberBuyOpCode(self.opCode, self.packBuyId)
        if self.boxRewardSelected.limit > 0 then
            local color = UIUtils.green_light
            if self.numberBought >= self.boxRewardSelected.limit then
                color = UIUtils.red_light
            end
            self.layoutConfig.textLimit.text = string.format(self.localizeLimitText, string.format("<color=#%s>%s/%s</color>", color, self.boxRewardSelected.limit - self.numberBought, self.boxRewardSelected.limit))
        else
            self.layoutConfig.textLimit.text = self.localizeNoLimit
        end
end

--- @return void
--- Show preview reward in popup from current selected gift box
function UIEventLunarNewYearSpringBoxLayout:PreviewSelectedChest()
    if(self.boxRewardSelected ~= nil) then
        PopupMgr.ShowPopup(UIPopupName.UIBoxRewardPreview, self.boxRewardSelected)
    end
end

function UIEventLunarNewYearSpringBoxLayout:OnHide()
    UIEventLunarNewYearLayout.OnHide(self)
    self.anchor.gameObject:SetActive(false)
    --- Return money bar GO to pool after layout disable
    if self.moneyBar ~= nil then
        self.moneyBar:ReturnPool()
        self.moneyBar = nil
    end
end

function UIEventLunarNewYearSpringBoxLayout:GetModelConfig()
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    if self.eventModel ~= nil then
        self.eventConfig = self.eventModel:GetConfig()
    end
end

--- @return boolean
--- Check whether player can buy more gift box or not?
function UIEventLunarNewYearSpringBoxLayout:CanBuy()
    self.numberBought = self.eventModel:GetNumberBuyOpCode(self.opCode, self.packBuyId)
    return self.boxRewardSelected.limit - self.numberBought > 0
end

--- @return void
--- Send request claim free box to server then show list reward user can get
function UIEventLunarNewYearSpringBoxLayout:OnClaimFreeGiftBox()
    if(self.eventModel:IsNotClaimedFreeSpringBox()) then
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)

        --- @param buffer UnifiedNetwork_ByteBuf
        local function OnBufferReading(buffer)
            local listReward = NetworkUtils.GetRewardInBoundList(buffer)
            PopupUtils.ClaimAndShowRewardList(listReward)
        end

        --- @return void
        --- @param number number
        local function OnSuccessClaimBox()
            self.eventModel:SetClaimedFreeSpringBoxTime()
            self:UpdateButton()
            self.view:CheckAllNotificationTab()
        end

        PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("claim_daily"), nil, function()
            NetworkUtils.RequestAndCallback(self.opCode,
                    UnknownOutBound.CreateInstance(PutMethod.Int, self.boxRewardSelected.id, PutMethod.Int, 1), function()
                        OnSuccessClaimBox()
                    end, SmartPoolUtils.LogicCodeNotification, OnBufferReading, true, true)
        end)
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("can_not_claim"))
    end
end

--- @return void
--- Send request buy box to server then show list reward user can get
function UIEventLunarNewYearSpringBoxLayout:OnBuyGiftBox()
    if(self:CanBuy()) then
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)

        --- @param buffer UnifiedNetwork_ByteBuf
        local function OnBufferReading(buffer)
            local listReward = NetworkUtils.GetRewardInBoundList(buffer)
            PopupUtils.ClaimAndShowRewardList(listReward)
        end

        --- @return void
        --- @param number number
        local function OnSuccessBuyBox(number)
            self.eventModel:AddNumberBuyOpCode(self.opCode, self.packBuyId, number)
            --- Decrease amount of money which player need to pay
            InventoryUtils.Sub(ResourceType.Money, self.boxRewardSelected.moneyType, self.boxRewardSelected.moneyValue)
            self:UpdateLimit()
        end

        local canExchange = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, self.boxRewardSelected.moneyType, self.boxRewardSelected.moneyValue))
        if canExchange then
            PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("want_to_buy"), nil, function()
                NetworkUtils.RequestAndCallback(self.opCode,
                        UnknownOutBound.CreateInstance(PutMethod.Int, self.boxRewardSelected.id, PutMethod.Int, 1), function()
                                OnSuccessBuyBox(1)
                        end, SmartPoolUtils.LogicCodeNotification, OnBufferReading, true, true)
            end)
        end
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("spring_box_limited"))
    end
end

---@class GiftBoxType
GiftBoxType = {
    WATER = 1,
    FIRE = 2,
    ABYSS = 3,
    NATURE = 4,
    LIGHT = 5,
    DARK = 6
}


