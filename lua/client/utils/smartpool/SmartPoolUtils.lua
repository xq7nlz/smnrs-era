--- @class SmartPoolUtils
SmartPoolUtils = {}

function SmartPoolUtils.ClearUIEffect()
    SmartPool.Instance:DestroyGameObjectByPoolType(AssetType.UIEffect)
end

--- @return IconView
--- @param iconData {ItemIconData, HeroIconData}
--- @param parent UnityEngine_RectTransform
function SmartPoolUtils.GetIconViewByIconData(iconData, parent)
    local newIconData
    local resourceType = iconData.type
    --- @type IconView
    local iconView
    if resourceType == ResourceType.HeroFragment then
        iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.HeroIconView, parent)
        newIconData = ItemIconData.Clone(iconData)
    elseif resourceType == ResourceType.EvolveFoodMaterial then
        ---@type HeroIconView
        iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.HeroIconView, parent)
        iconView:SetSizeFragment()
        newIconData = ItemIconData.Clone(iconData)
    elseif resourceType == ResourceType.Hero then
        iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.HeroIconView, parent)
        newIconData = HeroIconData.Clone(iconData)
    elseif resourceType == ResourceType.Money then
        iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyIconView, parent)
        newIconData = ItemIconData.Clone(iconData)
    elseif resourceType == ResourceType.Avatar then
        iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.AvatarIconView, parent)
        newIconData = ItemIconData.Clone(iconData)
    elseif resourceType == ResourceType.AvatarFrame then
        iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.BorderIconView, parent)
        newIconData = ItemIconData.Clone(iconData)
    elseif resourceType == ResourceType.CampaignQuickBattleTicket then
        iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.QuickBattleTicketView, parent)
        newIconData = ItemIconData.Clone(iconData)
    elseif resourceType == ResourceType.Skin then
        iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.SkinIconView, parent)
        newIconData = ItemIconData.Clone(iconData)
    else
        iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.ItemIconView, parent)
        newIconData = ItemIconData.Clone(iconData)
    end
    iconView:SetIconData(newIconData)
    iconView:DefaultShow()
    return iconView
end
--- @return IconView
--- @param iconData {ItemIconData, HeroIconData}
--- @param parent UnityEngine_RectTransform
--- @param rate number
function SmartPoolUtils.GetIconViewByIconDataWithRate(iconData, parent,rate)
    --- @type IconView
    local iconView = SmartPoolUtils.GetIconViewByIconData(iconData,parent)
    --- @type RateView
     local rateView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RateView,iconView.config.transform )
    rateView:SetIconData(rate .. "%")
    iconView.uiPoolDict:Add(UIPoolType.RateView, rateView)
    return iconView
end


--- @param notification string
function SmartPoolUtils.ShowShortNotification(notification)
    uiCanvas:ShowShortNotification(notification)
end

--- @param rewardInBound RewardInBound
function SmartPoolUtils.ShowRewardNotification(rewardInBound)
    uiCanvas:ShowRewardNotification(rewardInBound)
end

--- @param iconData ItemIconData
function SmartPoolUtils.ShowReward1Item(iconData, callback, delayTime)
    local showReward = function()
        --- @type UIPopupReward1ItemView
        local reward1Item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.Reward1ItemView, uiCanvas.config.uiLoading)
        reward1Item:SetIconData(iconData)
        if callback ~= nil then
            callback()
        end
    end
    if delayTime ~= nil then
        Coroutine.start(function()
            coroutine.waitforseconds(delayTime)
            showReward()
        end)
    else
        showReward()
    end
end

--- @return ShortNotificationView
--- @param logicCode LogicCode
function SmartPoolUtils.LogicCodeNotification(logicCode)
    if logicCode ~= nil then
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeLogicCode(logicCode))
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
    end
end

--- @return ShortNotificationView
--- @param logicCode LogicCode
function SmartPoolUtils.GiftCodeResultNotification(logicCode)
    if logicCode ~= nil then
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeGiftCodeResult(logicCode))
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
    end
end

--- @return ShortNotificationView
--- @param vipUnlock number
--- @param levelRequire number
--- @param stageRequire number
function SmartPoolUtils.NotificationRequireVipOrLevelAndStage(vipUnlock, levelRequire, stageRequire)
    SmartPoolUtils.ShowShortNotification(LanguageUtils.NotificationRequireVipOrLevelAndStage(vipUnlock, levelRequire, stageRequire))
    zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
end

--- @return void
--- @param moneyType MoneyType
function SmartPoolUtils.NotiLackResource(moneyType)
    if moneyType ~= nil then
        --if moneyType == MoneyType.GEM then
        --    PopupMgr.ShowPopup(UIPopupName.UIPopupRawPack)
        --else
            SmartPoolUtils.ShowShortNotification(string.format(LanguageUtils.LocalizeCommon("not_enough_x"),
                    LanguageUtils.LocalizeMoneyType(moneyType)))
        --end
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("not_enough_resource"))
    end
    zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
end

--- @param moneyType MoneyType
--- @param anchor UnityEngine_RectTransform
function SmartPoolUtils.CreateResItemRawPack(moneyType, content, anchor)
    --- @type UIResItemRawPack
    local item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.UIResItemRawPack, anchor)
    item:SetIconData({ ['moneyType'] = moneyType, ['content'] = content })
    return item
end

--- @param featureState FeatureState
function SmartPoolUtils.ShowNotificationFeatureState(featureState)
    if featureState == FeatureState.LOCK then
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("lock"))
    elseif featureState == FeatureState.COMING_SOON then
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("coming_soon"))
    elseif featureState == FeatureState.MAINTAIN then
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("feature_maintain"))
    end
end