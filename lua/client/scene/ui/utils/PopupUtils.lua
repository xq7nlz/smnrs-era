--- @class PopupUtils
PopupUtils = Class(PopupUtils)

--- @return void
--- @param name string
--- @param parent UnityEngine_Transform
--- @param onLoaded function
--- @param loadFromResources boolean
function PopupUtils.SpawnUI(name, parent, onLoaded, loadFromResources)
    local ui = ResourceLoadUtils.LoadUI(name, loadFromResources)
    --- @type UnityEngine_RectTransform
    local rectTransform = ui:GetComponent(ComponentName.UnityEngine_RectTransform)
    PopupUtils.ResetTransform(rectTransform, parent)
    onLoaded(rectTransform)
end

--- @return void
--- @param rectTransform UnityEngine_RectTransform
--- @param parent UnityEngine_Transform
function PopupUtils.ResetTransform(rectTransform, parent)
    UIUtils.SetParent(rectTransform, parent)
    rectTransform.offsetMax = U_Vector2.zero
    rectTransform.offsetMin = U_Vector2.zero
end

function PopupUtils.BackToMainArea()
    PopupMgr.ShowPopup(UIPopupName.UIMainArea, nil, UIPopupHideType.HIDE_ALL)
end

--- @param disconnectReason DisconnectReason
--- @param onClose function
function PopupUtils.ShowPopupDisconnect(disconnectReason, onClose)
    local popName = UIPopupName.UIPopupNotification

    UIPopupWaitingUtils.StopWaitingCoroutine()
    if UIBaseView.IsActiveTutorial() then
        PopupMgr.HidePopup(UIPopupName.UITutorial)
    end

    local localizeReason = disconnectReason > 80 and 99 or disconnectReason
    local content = LanguageUtils.LocalizeDisconnectReasonCode(localizeReason)
    local data = {}
    data.notification = string.format("%s(%d)", content, disconnectReason)
    data.alignment = U_TextAnchor.MiddleCenter
    data.canCloseByBackButton = false

    local buttonNo = {}
    buttonNo.text = LanguageUtils.LocalizeCommon("go_to_fanpage")
    buttonNo.callback = PopupUtils.OpenFanpage
    data.button1 = buttonNo
    ---@type boolean
    data.showClearData = disconnectReason == 94 or disconnectReason == 98 or disconnectReason == 95 or disconnectReason == 96
    local funcBtn1
    local textBtn1
    textBtn1 = LanguageUtils.LocalizeCommon("retry")
    funcBtn1 = function()
        PopupMgr.HidePopup(popName)
        if onClose ~= nil then
            onClose()
        end
    end
    local buttonYes = {}
    buttonYes.text = textBtn1
    --buttonYes.text = LanguageUtils.LocalizeCommon("delete data")
    buttonYes.callback = funcBtn1
    data.button2 = buttonYes

    if (data.showClearData) then
        local buttonDeleteData = {}

        --textBtn3 =
        local funcBtn3 = function()
            local yesCallback = function()
                UIDownloadView.DeleteAllDataAndReset()
            end
            local noCallback = function()
                --XDebug.Log("RESETING GAME")
                PopupMgr.HidePopup(popName)
                --Main.ResetGame()
                if onClose ~= nil then
                    onClose()
                end
            end
            PopupMgr.HidePopup(popName)
            PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("warning_delete_data"), noCallback, yesCallback)
        end
        buttonDeleteData.callback = funcBtn3
        buttonDeleteData.text = LanguageUtils.LocalizeCommon("delete_data")
        data.buttonDeleteData = buttonDeleteData
    else

    end
    PopupMgr.ShowPopup(popName, data)

end

--- @return void
--- @param notification string
function PopupUtils.ShowPopupNotificationOK(notification, callbackOk, callbackClose, canCloseByBackButton, callbackClickBg)
    PopupUtils.ShowPopupNotificationOneButton(notification, callbackOk, callbackClose,
            canCloseByBackButton, 2, "ok", true, callbackClickBg)
end

--- @return void
function PopupUtils.GoToStore()
    if IS_IOS_PLATFORM == true then
        U_Application.OpenURL(IOS_STORE_URL_PREFIX .. APPSFLYER_ID())
    else
        U_Application.OpenURL(string.format(ANDROID_STORE_URL_PREFIX, U_Application.identifier))
    end
end

--- @return void
function PopupUtils.GoToStoreNew()
    if IS_IOS_PLATFORM == true then
        U_Application.OpenURL(IOS_STORE_URL_PREFIX .. APPSFLYER_ID())
    else
        U_Application.OpenURL(string.format(ANDROID_STORE_URL_PREFIX, U_Application.identifier))
    end
end

--- @return void
function PopupUtils.ShowPopupGoToStore()
    local notification = string.format(LanguageUtils.LocalizeCommon("version_outdate"), VERSION)
    local buttonText = LanguageUtils.LocalizeCommon("go_to_store")
    PopupUtils.ShowPopupCantClose(notification, buttonText, function()
        PopupUtils.GoToStoreNew()
    end)
end

--- @return void
function PopupUtils.ShowPopupLowerDevice()
    PopupUtils.ShowPopupCantClose("The game is not support your device. \n Use Iphone 6 or newer.", "Thank you", function()
        U_Application.Quit()
    end)
end

--- @return void
--- @param finishMaintainTime string
function PopupUtils.ShowPopupMaintenance(finishMaintainTime)
    local notification = LanguageUtils.LocalizeCommon("under_maintenance")
    if finishMaintainTime then
        notification = string.format("%s\n%s", notification,
                string.format("%s %s",
                        LanguageUtils.LocalizeCommon("will_open_in"),
                        UIUtils.SetColorString(UIUtils.color2, os.date("%c", finishMaintainTime)))
        )
    end
    PopupUtils.ShowPopupCantClose(notification, LanguageUtils.LocalizeCommon("ok"), function()
        U_Application.Quit()
    end)
end

function PopupUtils.ShowPopupCantClose(notification, buttonText, callback)
    local data = {}
    data.notification = notification
    data.alignment = U_TextAnchor.MiddleCenter
    local buttonOK = {}
    buttonOK.text = buttonText
    buttonOK.callback = callback
    data.button2 = buttonOK
    data.canCloseByBackButton = false
    PopupMgr.ShowPopup(UIPopupName.UIPopupNotification, data)
end

--- @return void
--- @param notification string
function PopupUtils.ShowPopupNotificationOneButton(notification, callbackOk, callbackClose, canCloseByBackButton, buttonIndex, localize, canClickBg, callbackClickBg)
    local data = {}
    data.notification = notification
    data.alignment = U_TextAnchor.MiddleCenter
    data.closeCallback = callbackClose
    local buttonOK = {}
    buttonOK.text = LanguageUtils.LocalizeCommon(localize)
    buttonOK.callback = function()
        PopupMgr.HidePopup(UIPopupName.UIPopupNotification)
        if callbackOk ~= nil then
            callbackOk()
        end
    end
    if buttonIndex == 1 then
        data.button1 = buttonOK
    else
        data.button2 = buttonOK
    end
    data.canCloseByBackButton = canCloseByBackButton
    if canClickBg ~= false then
        if callbackClickBg == nil then
            data.clickBgCallback = buttonOK.callback
        else
            data.clickBgCallback = callbackClickBg
        end
    end
    PopupMgr.ShowPopup(UIPopupName.UIPopupNotification, data)
end

--- @return void
--- @param number number
--- @param moneyType MoneyType
function PopupUtils.ShowPopupNotificationUseResource(moneyType, number, callbackYes, callbackNo, callbackClose)
    PopupUtils.ShowPopupNotificationYesNo(StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("do_you_want_use_resource"), number,
            LanguageUtils.LocalizeMoneyType(moneyType)), callbackNo, callbackYes, callbackClose)
end

--- @return void
--- @param notification string
function PopupUtils.ShowPopupNotificationYesNo(notification, callbackNo, callbackYes, callbackClose, listItem)
    PopupUtils.ShowPopupNotificationTwoButtons(notification, callbackNo, callbackYes, callbackClose,
            "no", "yes", true, listItem)
end

function PopupUtils.ShowPopupNotificationDeleteData(notification, callbackNo, callbackYes, callBackDeleteData, callbackClose, listItem)
    PopupUtils.ShowPopupNotificationTwoButtons(notification, callbackNo, callbackYes, callBackDeleteData, callbackClose,
            "no", "yes", "warning_delete_data", true, listItem)
end

function PopupUtils.ShowPopupNotificationThreeButtons(notification, callbackNo, callbackYes, callBackDeleteData, callbackClose, localizeNo, localizeYes, localizeDeleteData, canCloseByBackButton, listItem)
    local data = {}
    data.notification = notification
    data.alignment = U_TextAnchor.MiddleCenter
    data.closeCallback = callbackClose
    data.canCloseByBackButton = canCloseByBackButton
    data.listItem = listItem
    local buttonNo = {}
    buttonNo.text = LanguageUtils.LocalizeCommon(localizeNo)
    buttonNo.callback = function()
        PopupMgr.HidePopup(UIPopupName.UIPopupNotification)
        if callbackNo ~= nil then
            callbackNo()
        else
            zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_CLOSE)
        end
    end
    data.button1 = buttonNo
    local buttonYes = {}
    buttonYes.text = LanguageUtils.LocalizeCommon(localizeYes)
    buttonYes.callback = function()
        PopupMgr.HidePopup(UIPopupName.UIPopupNotification)
        if callbackYes ~= nil then
            callbackYes()
        end
    end
    data.button2 = buttonYes
    local buttonDeleteData = {}
    buttonDeleteData.text = LanguageUtils.LocalizeCommon(localizeDeleteData)
    buttonDeleteData.callback = function()
        PopupMgr.HidePopup(UIPopupName.UIPopupNotification)
        if callBackDeleteData ~= nil then
            callBackDeleteData()
        end
    end
    data.buttonDeleteData = buttonDeleteData

    PopupMgr.ShowPopup(UIPopupName.UIPopupNotification, data)
end

--- @return void
--- @param notification string
function PopupUtils.ShowPopupNotificationTwoButtons(notification, callbackNo, callbackYes, callbackClose, localizeNo, localizeYes, canCloseByBackButton, listItem)
    local data = {}
    data.notification = notification
    data.alignment = U_TextAnchor.MiddleCenter
    data.closeCallback = callbackClose
    data.canCloseByBackButton = canCloseByBackButton
    data.listItem = listItem
    local buttonNo = {}
    buttonNo.text = LanguageUtils.LocalizeCommon(localizeNo)
    buttonNo.callback = function()
        PopupMgr.HidePopup(UIPopupName.UIPopupNotification)
        if callbackNo ~= nil then
            callbackNo()
        else
            zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_CLOSE)
        end
    end
    data.button1 = buttonNo
    local buttonYes = {}
    buttonYes.text = LanguageUtils.LocalizeCommon(localizeYes)
    buttonYes.callback = function()
        PopupMgr.HidePopup(UIPopupName.UIPopupNotification)
        if callbackYes ~= nil then
            --XDebug.Log("HOANG PL CALL BACK YES")
            callbackYes()
        end
    end
    data.button2 = buttonYes
    PopupMgr.ShowPopup(UIPopupName.UIPopupNotification, data)
end

--- @return void
--- @param resourceList List <ItemIconData>
--- @param callback function
function PopupUtils.ShowRewardList(resourceList, callback, notSeparatePopup)
    if resourceList:Count() == 0 then
        return
    end
    if resourceList:Count() == 1 and notSeparatePopup ~= true then
        SmartPoolUtils.ShowReward1Item(resourceList:Get(1), callback)
    else
        PopupMgr.ShowPopup(UIPopupName.UIPopupReward, { ["resourceList"] = resourceList, ["callback"] = callback })
    end
end

--- @return void
--- @param resourceList List <ItemIconData>
--- @param callback function
function PopupUtils.ShowManyManyReward(resourceList, callback, notSeparatePopup)
    if resourceList:Count() == 1 and notSeparatePopup ~= true then
        SmartPoolUtils.ShowReward1Item(resourceList:Get(1), callback)
    else
        PopupMgr.ShowPopup(UIPopupName.UIPopupManyManyReward, { ["resourceList"] = resourceList, ["callback"] = callback })
    end
end

--- @return void
--- @param resourceList List <ItemIconData>
--- @param callback function
function PopupUtils.ShowSplitReward(resourceList1, resourceList2, callback, notSeparatePopup, localize)
    PopupMgr.ShowPopup(UIPopupName.UIPopupSplitReward, { ["resourceList1"] = resourceList1,
                                                         ["resourceList2"] = resourceList2,
                                                         ["callback"] = callback,
                                                         ["localize"] = localize })
end

--- @return void
--- @param rewardList List -- RewardInBound --
--- @param callback function
function PopupUtils.ClaimAndShowRewardList(rewardList, callback)
    assert(rewardList)
    local iconList = List()
    --- @param reward RewardInBound
    for _, reward in ipairs(rewardList:GetItems()) do
        reward:AddToInventory()
        iconList:Add(reward:GetIconData())
    end
    local eventItemDictConfig = ClientConfigUtils.GetEventItemConfig()
    for i = iconList:Count(), 1, -1 do
        local itemId = iconList:Get(i).itemId
        if eventItemDictConfig:IsContainKey(itemId) then
            local value = eventItemDictConfig:Get(itemId)
            if value < 0 then
                iconList:RemoveByIndex(i)
            end
        end
    end
    PopupUtils.ShowRewardList(iconList, callback)
end

--- @return void
--- @param rewardList List -- RewardInBound --
--- @param callback function
function PopupUtils.ClaimAndShowManyManyReward(rewardList, callback)
    assert(rewardList)
    local iconList = List()
    --- @param reward RewardInBound
    for _, reward in ipairs(rewardList:GetItems()) do
        reward:AddToInventory()
        iconList:Add(reward:GetIconData())
    end
    PopupUtils.ShowManyManyReward(iconList, callback)
end

--- @return void
--- @param rewardList List -- RewardInBound --
--- @param callback function
function PopupUtils.ClaimAndShowSplitReward(rewardList1, rewardList2, callback, localize)
    assert(rewardList1)
    assert(rewardList2)
    PopupUtils.ShowSplitReward(rewardList1, rewardList2, callback, nil, localize)
end

--- @return void
--- @param rewardList List <ItemIconData>
--- @param callback function
function PopupUtils.ClaimAndShowItemList(rewardList, callback, notSeparatePopup)
    assert(rewardList)
    local iconList = List()
    --- @param reward ItemIconData
    for _, reward in ipairs(rewardList:GetItems()) do
        reward:AddToInventory()
        iconList:Add(reward)
    end
    PopupUtils.ShowRewardList(iconList, callback, notSeparatePopup)
end

--- @return void
--- @param
function PopupUtils.ShowBuyItem(title, cost, yesCallback)
    local canBuy = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, cost.moneyType, cost.value))
    if canBuy then
        PopupUtils.ShowPopupNotificationYesNo(title, nil, yesCallback, nil)
    end
end

---@return void
---@param listUnlock List
function PopupUtils.UnlockListFeature(listUnlock, callbackSuccess)
    if listUnlock:Count() > 0 then
        local i = 1
        local showUnlockFeature
        showUnlockFeature = function()
            PopupMgr.HidePopup(UIPopupName.UIUnlockFeature)
            if i <= listUnlock:Count() then
                PopupMgr.ShowPopup(UIPopupName.UIUnlockFeature, { ["feature"] = listUnlock:Get(i), ["callbackClose"] = showUnlockFeature })
                i = i + 1
            else
                if callbackSuccess ~= nil then
                    callbackSuccess()
                end
            end
        end
        showUnlockFeature()
    else
        if callbackSuccess ~= nil then
            callbackSuccess()
        end
    end
end

--- @param leaderBoardType LeaderBoardType
function PopupUtils.ShowLeaderBoard(leaderBoardType)
    TrackingUtils.AddClickLeaderBoardEvent(leaderBoardType)
    PopupMgr.ShowPopup(UIPopupName.UILeaderBoard, leaderBoardType)
end

function PopupUtils.CheckAndHideSkillPreview()
    if PopupUtils.IsPopupShowing(UIPopupName.UISkillPreview) then
        PopupMgr.HidePopup(UIPopupName.UISkillPreview)
    end
end

--- @return boolean
function PopupUtils.IsNotificationShowing()
    return PopupUtils.IsPopupShowing(UIPopupName.UIPopupNotification)
end

--- @return boolean
function PopupUtils.IsWaitingShowing()
    return PopupUtils.IsPopupShowing(UIPopupName.UIPopupWaiting)
end

--- @return boolean
--- @param popupName UIPopupName
function PopupUtils.IsPopupShowing(popupName)
    --- @param v UIPopupInfo
    for _, v in ipairs(zg.popupMgr.uiOpenPopupList:GetItems()) do
        if v.name == popupName then
            return true
        end
    end
    return false
end

--- @param callback function
function PopupUtils.ShowTimeOut(callback)
    if PopupUtils.IsWaitingShowing() then
        PopupMgr.HidePopup(UIPopupName.UIPopupWaiting)
    end

    if PopupUtils.IsNotificationShowing() then
        if zg.networkMgr.isConnected == false then
            return
        else
            PopupMgr.HidePopup(UIPopupName.UIPopupNotification)
            callback()
        end
    else
        callback()
    end
end

function PopupUtils.OpenFanpage()
    local FANPAGE_GLOBAL_ID = "101183864820149"
    local FANPAGE_VIETNAM_ID = "100063831916160"
    local FANPAGE_ID

    ---@type  Language
    local currentLanguage = LanguageUtils.GetLanguageByType(PlayerSettingData.language)
    if currentLanguage.code == LanguageCode.Vietnamese then
        FANPAGE_ID = FANPAGE_VIETNAM_ID
    else
        FANPAGE_ID = FANPAGE_GLOBAL_ID
    end

    local openOnBrowzer = function()
        U_Application.OpenURL(string.format("http://facebook.com/%s", FANPAGE_ID))
    end

    local delayOpenOnBrowzer = function()
        ---@type Subscription
        local listenerApplicationPause = nil
        local coroutine = Coroutine.start(function()
            coroutine.waitforseconds(0.5)
            openOnBrowzer()
            if listenerApplicationPause ~= nil then
                listenerApplicationPause:Unsubscribe()
            end
        end)
        listenerApplicationPause = RxMgr.applicationPause:Subscribe(function()
            Coroutine.stop(coroutine)
            listenerApplicationPause:Unsubscribe()
        end)
    end

    if IS_MOBILE_PLATFORM then
        delayOpenOnBrowzer()
        if IS_ANDROID_PLATFORM then
            U_Application.OpenURL(string.format("fb://page/%s", FANPAGE_ID))
        elseif IS_IOS_PLATFORM then
            U_Application.OpenURL(string.format("fb://profile/%s", FANPAGE_ID))
        end
    else
        openOnBrowzer()
    end
end

--- @param heroResource HeroResource
function PopupUtils.ShowPreviewHeroInfo(heroResource, overrideStatDict)
    local onSelectHeroItem = function(slotEquipmentType)
        local idItem = heroResource.heroItem:Get(slotEquipmentType)
        if idItem == nil then
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("empty"))
            return
        end
        local setNumber, heroId, faction, class

        --- @type ResourceType
        local resourceType
        if slotEquipmentType <= SlotEquipmentType.Accessory then
            resourceType = ResourceType.ItemEquip
            ---@type table
            local itemData = ResourceMgr.GetServiceConfig():GetItemData(resourceType, idItem)
            if itemData.setId ~= nil then
                for i = 1, SlotEquipmentType.Accessory do
                    if heroResource.heroItem:IsContainKey(i) and heroResource.heroItem:Get(i) > 0 then
                        local tempIdItem = heroResource.heroItem:Get(i)
                        ---@type EquipmentDataEntry
                        local equipmentData = ResourceMgr.GetServiceConfig():GetItemData(ResourceType.ItemEquip, tempIdItem)
                        if itemData.setId == equipmentData.setId then
                            if setNumber == nil then
                                setNumber = 1
                            else
                                setNumber = setNumber + 1
                            end
                        end
                    end
                end
            end
        elseif slotEquipmentType == SlotEquipmentType.Artifact then
            resourceType = ResourceType.ItemArtifact
            heroId = heroResource.heroId
            faction = ClientConfigUtils.GetFactionIdByHeroId(heroId)
            class = ResourceMgr.GetHeroClassConfig():GetClass(heroId)
        elseif slotEquipmentType == SlotEquipmentType.Stone then
            resourceType = ResourceType.ItemStone
        elseif slotEquipmentType == SlotEquipmentType.Talent then
            resourceType = ResourceType.Talent
        end
        PopupMgr.ShowPopup(UIPopupName.UIItemPreview, { ["data1"] = { ["type"] = resourceType, ["id"] = idItem,
                                                                      ["setNumber"] = setNumber, ["class"] = class, ["faction"] = faction, ["heroId"] = heroId } })
    end

    local data = {}
    data.heroResource = heroResource
    data.onSelectItem = function(slotEquipmentType)
        onSelectHeroItem(slotEquipmentType)
    end
    data.overrideStatDict = overrideStatDict
    data.disableIdleEffect = true
    PopupMgr.ShowPopup(UIPopupName.UIPreviewHeroInfo, data)
end