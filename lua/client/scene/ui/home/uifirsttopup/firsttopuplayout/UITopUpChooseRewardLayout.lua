require "lua.client.data.Purchase.PurchaseConfig"
require "lua.client.scene.ui.home.uiFirstTopUp.FirstTopUpLayout.UIFirstTopUpLayout"

--- @class UITopUpChooseRewardLayout : UIFirstTopUpLayout
UITopUpChooseRewardLayout = Class(UITopUpChooseRewardLayout, UIFirstTopUpLayout)

function UITopUpChooseRewardLayout:Ctor(view,anchor)
    UIFirstTopUpLayout.Ctor(self, view,anchor)
    --XDebug.Log("oNHIDE CHOOSE REWARD")

end

function UITopUpChooseRewardLayout:OnShow()
    -- UIFirstTopUpLayout.OnShow(self)
    ---@type UIFirstChooseRewardLayoutConfig
    self.layoutConfig = UIBaseConfig(self.config.chooseRewardLayout)
    self.layoutConfig.gameObject:SetActive(true)
    self.layoutConfig.btnChoose1.onClick:RemoveAllListeners()
    self.layoutConfig.btnChoose2.onClick:RemoveAllListeners()
    self.layoutConfig.btnChoose3.onClick:RemoveAllListeners()

    self.layoutConfig.btnChoose1.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnChooseReward(1)
    end)
    self.layoutConfig.btnChoose2.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnChooseReward(2)
    end)
    self.layoutConfig.btnChoose3.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnChooseReward(3)
    end)

end

function UITopUpChooseRewardLayout:OnChooseReward(index)
    local _index = tonumber(index)
    XDebug.Log("index now " .. tostring(_index))

    local onReceived = function(result)
        --XDebug.Log("ON RECEIVED")
        --show next layout
        ---@type UIFirstTopUpView
        local firstTopUpView = self.view
        --PopupMgr.HidePopup(UIPopupName.UIScrollLoopReward)
        PopupMgr.HidePopup(UIPopupName.UIPopupNotificationReward)
        ---@type IapDataInBound
        local iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
        iapDataInBound:SetFirstPurchaseItemIndex(_index)
        --- @type Number
        local transaction = TrackingUtils.server:GetTracking(FBProperties.IAP_COUNT)
        ---@type boolean
        local isNonPaid = transaction:GetValue() == 0
        if (isNonPaid) then
            --XDebug.Log("Should show here")
            firstTopUpView:ShowLayout(UIFirstTopTab.PackageContent)
        else
            ---@type IapDataInBound
            local iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
            ---@type boolean
            iapDataInBound:SetShowPopup(false)
            --XDebug.Log("Should close here")
            self.view:OnClickBackOrClose()
            -- PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
        end
    end
    --show popup confirm here
    local yesCallback = function()
        --XDebug.Log("yesCallback")
        NetworkUtils.Request(OpCode.FIRST_PURCHASE_ITEM_CLAIM, UnknownOutBound.CreateInstance(PutMethod.Int, _index), onReceived)
    end
    --- @type PurchaseConfig
    local purchaseConfig = ResourceMgr.GetPurchaseConfig()
    --- @type List
    local iconDataList = purchaseConfig:GetListFirstTopUpIconReward(_index)
    local rewardList = purchaseConfig:GetListFirstTopUpReward(_index)
    --PopupMgr.ShowPopup(UIPopupName.UIScrollLoopReward, { ["resourceList"] = iconDataList ,["titleText"] = "first_Top_Up_Confirm_Choose_Reward", ["yesCallback"] = yesCallback  })
    PopupMgr.ShowPopup(UIPopupName.UIPopupNotificationReward, { ["resourceList"] = iconDataList ,["rewardList"] = rewardList,["titleText"] = LanguageUtils.LocalizeCommon("first_Top_Up_Confirm_Choose_Reward"), ["yesCallback"] = yesCallback  })
end