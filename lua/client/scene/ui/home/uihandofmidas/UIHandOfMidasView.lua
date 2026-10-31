---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiHandOfMidas.UIHandOfMidasConfig"

--- @class UIHandOfMidasView : UIBaseView
UIHandOfMidasView = Class(UIHandOfMidasView, UIBaseView)

--- @return void
--- @param model UIHandOfMidasModel
function UIHandOfMidasView:Ctor(model, ctrl)
    ---@type UIHandOfMidasConfig
    self.config = nil
    ---@type HandOfMidasDataConfig
    self.csv = nil
    ---@type HandOfMidasInBound
    self.server = nil
    ---@type number
    self.timeRefresh = nil

    UIBaseView.Ctor(self, model, ctrl)
    --- @type UIHandOfMidasModel
    self.model = model
end

--- @return void
function UIHandOfMidasView:OnReadyCreate()
    self.csv = ResourceMgr.GetHandOfMidasConfig()
    ---@type UIHandOfMidasConfig
    self.config = UIBaseConfig(self.uiTransform)
    ---@type UIHandOfMidasItemConfig
    self.item1 = UIBaseConfig(self.config.layout:GetChild(0))
    ---@type UIHandOfMidasItemConfig
    self.item2 = UIBaseConfig(self.config.layout:GetChild(1))
    ---@type UIHandOfMidasItemConfig
    self.item3 = UIBaseConfig(self.config.layout:GetChild(2))
    self:InitButtonListener()
    local spriteGold = ResourceLoadUtils.LoadMoneyIcon(MoneyType.GOLD)
    self.item1.iconCoin.sprite = spriteGold
    self.item2.iconCoin.sprite = spriteGold
    self.item3.iconCoin.sprite = spriteGold
    local spriteGem = ResourceLoadUtils.LoadMoneyIcon(MoneyType.GEM)
    self.item2.iconGem.sprite = spriteGem
    self.item3.iconGem.sprite = spriteGem
end

function UIHandOfMidasView:InitButtonListener()
    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.backGround.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)

    local onClaimButton = function(index)
        self:RequestClaim(index)
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end
    self.item1.freeButton.onClick:AddListener(function()
        onClaimButton(1)
    end)
    self.item2.watchAdButton.onClick:AddListener(function()
        onClaimButton(2)
    end)
    self.item3.claimCoinButton.onClick:AddListener(function()
        onClaimButton(3)
    end)
end

--- @return void
function UIHandOfMidasView:InitLocalization()
    self.localizeRefresh = LanguageUtils.LocalizeCommon("refresh_x")
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("gold_mine")
    self.item1.textFree.text = LanguageUtils.LocalizeCommon("free")
    local localizeClaim = LanguageUtils.LocalizeCommon("claim")
    self.item2.textAd.text = localizeClaim
    self.item3.textClaim.text = localizeClaim
    self.config.textTapToClose.gameObject:SetActive(false)
end

--- @return void
function UIHandOfMidasView:OnReadyShow()
    self:InitServerCallback()
    self:InitGoldConvert()
    self.server:SetTimeRefresh()
    if self.server:CanRefresh() then
        self.server:ResetClaimDict()
        self:SetTextTimeRefreshStatus(false)
    else
        self.server:StartRefreshTime()
        self:SetTextTimeRefreshStatus(true)
        self.config.textRefresh.text = string.format(self.localizeRefresh, UIUtils.SetColorString(UIUtils.green_light, TimeUtils.SecondsToClock(self.server.timeRefresh)))
    end
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    self:SetButtonClaimStatus()
end

--- @return void
function UIHandOfMidasView:InitServerCallback()
    --- @type HandOfMidasInBound
    self.server = zg.playerData:GetMethod(PlayerDataMethod.HAND_OF_MIDAS)
    if self.server == nil then
        XDebug.Error("hand of midas data can't be nil")
        return
    end
    self.server.viewCallback = function(timeRefresh)
        self:TimeUpdate(timeRefresh)
    end
end

function UIHandOfMidasView:InitGoldConvert()
    self:SetGoldConvert(1, self.item1.textValue)
    self:SetGoldConvert(2, self.item2.textValue, self.item2.textGemValue)
    self:SetGoldConvert(3, self.item3.textValue, self.item3.textGemValue)
end

function UIHandOfMidasView:TimeUpdate(timeRefresh)
    if self.server:CanRefresh(timeRefresh) then
        self:SetTextTimeRefreshStatus(false)
        self:SetButtonClaimStatus()
    else
        self:SetTextTimeRefreshStatus(true)
        self.config.textRefresh.text = string.format(self.localizeRefresh, UIUtils.SetColorString(UIUtils.green_light, TimeUtils.SecondsToClock(self.server.timeRefresh)))
    end
end

--- @param index number
--- @param textGold UnityEngine_UI_Text
--- @param textGem UnityEngine_UI_Text
function UIHandOfMidasView:SetGoldConvert(index, textGold, textGem)
    ---@type HandOfMidasData
    local data = self.csv.dictData:Get(index)
    textGold.text = tostring(data:CalculateResource())
    if index > 1 then
        textGem.text = data.gemPrice
    end
end

--- @param enable boolean
function UIHandOfMidasView:SetTextTimeRefreshStatus(enable)
    self.config.textRefresh.transform.parent.gameObject:SetActive(enable)
end

function UIHandOfMidasView:SetButtonClaimStatus()
    local setButton = function(index, button)
        local enable = self.server:CanClaim(index)
        UIUtils.SetInteractableButton(button, enable)
        UIUtils.SetActiveColorDisable(button.gameObject, enable)
    end
    setButton(1, self.item1.freeButton)
    setButton(2, self.item2.watchAdButton)
    setButton(3, self.item3.claimCoinButton)
end

--- @return void
function UIHandOfMidasView:RequestClaim(id)
    ---@type HandOfMidasData
    local data = self.csv.dictData:Get(id)
    local canRequest
    if data.isWatchAds or data.gemPrice == 0 then
        data.gemPrice = 0
        canRequest = true
    else
        canRequest = InventoryUtils.IsEnoughSingleResourceRequirement(
                RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.GEM, data.gemPrice))
    end
    if canRequest then
        local price = data.gemPrice
        local onSuccess = function()
            -- price
            InventoryUtils.Sub(ResourceType.Money, MoneyType.GEM, price)
            -- reward icon
            ---@type ItemIconData
            local iconData = ItemIconData.CreateInstance(data.resourceType, data.resourceId, data:CalculateResource())
            iconData:AddToInventory()
            SmartPoolUtils.ShowReward1Item(iconData)
            if self.server:CanRefresh() then
                self.server:Refresh()
            end
            -- update data into server info
            self.server:AddClaim(id)
            -- update ui
            self:SetButtonClaimStatus()
            -- trigger turn of noti in main
            RxMgr.notificationHandOfMidas:Next(id)
        end

        local action = function()
            NetworkUtils.RequestAndCallback(
                    OpCode.HAND_OF_MIDAS_CLAIM,
                    UnknownOutBound.CreateInstance(PutMethod.Byte, id),
                    onSuccess,
                    SmartPoolUtils.LogicCodeNotification
            )
        end

        if data.isWatchAds then
            VideoRewardedUtils.SetType(1)
            VideoRewardedUtils.SetAction(function()
                action()
            end)
            IapDataInBound.Validate(function()
                if VideoRewardedUtils.AllowSkipVideo() then
                    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.MAIN_FEATURES, "watch_video", 0)
                    VideoRewardedUtils.RequestToServer()
                else
                    VideoRewardedUtils.OpenRewarded(AdsPlacement.HAND_MIDAS)
                end
            end)
        else
            action()
        end
    end
end

function UIHandOfMidasView:OnReadyHide()
    UIBaseView.OnReadyHide(self)
    self.server.viewCallback = nil
end

function UIHandOfMidasView:Hide()
    UIBaseView.Hide(self)
    self.server:RemoveUpdateTime()
end