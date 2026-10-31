require "lua.client.scene.ui.home.uiFirstTopUp.FirstTopUpLayout.UIFirstTopUpLayout"

--- @class UITopUpPackageContentLayout : UIFirstTopUpLayout
UITopUpPackageContentLayout = Class(UITopUpPackageContentLayout, UIFirstTopUpLayout)

function UITopUpPackageContentLayout:Ctor(view,anchor)
    --- @type UILoopScroll
    self.uiScroll = nil
    UIFirstTopUpLayout.Ctor(self, view,anchor)
end

function UITopUpPackageContentLayout:InitLocalization()

end

function UITopUpPackageContentLayout:ShowRewardByIndex(index)
    self.config.reward1.gameObject:SetActive(index == 1)
    self.config.reward2.gameObject:SetActive(index == 2)
    self.config.reward3.gameObject:SetActive(index == 3)
end

function UITopUpPackageContentLayout:OnShow()
    --UIFirstTopUpLayout.OnShow(self)
    --XDebug.Log("hoangpl SHOW CONTENT")
    if (self.uiScroll ~= nil) then
        self.uiScroll:Hide()
    end
    --- @type UIPackageContentLayoutConfig
    self.layoutConfig = UIBaseConfig(self.config.packageLayout)
    self.layoutConfig.gameObject:SetActive(true)
    local _index = IapDataInBound.GetChosenFirstPurchaseItemIndex()
    self:ShowRewardByIndex(_index)
    local listRewardInBound = PurchaseConfig:GetListFirstTopUpReward(_index)
    --- @type PurchaseConfig
    local purchaseConfig = ResourceMgr.GetPurchaseConfig()
    --- @type List
    local iconDataList = purchaseConfig:GetListFirstTopUpIconReward(_index)
    local onCreateItem = function(obj, index)
        local rewardInBound = listRewardInBound:Get(index+1)
        local data = iconDataList:Get(index + 1)
        obj:SetIconData(data)
        obj:AddListener(function()
            PopupMgr.ShowPopup(UIPopupName.UIItemPreview,
                    { ["data1"] = { ["type"] = rewardInBound.type, ["id"] = rewardInBound.id } })
          --  XDebug.Log("Click Item: " .. LogUtils.ToDetail(obj.iconData))
        end)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scroll, UIPoolType.RootIconView, onCreateItem)
    self.uiScroll:Resize(iconDataList:Count())
end

