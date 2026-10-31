require "lua.client.scene.ui.common.UITabItem"
--- @class CommunityEventLayout
CommunityEventLayout = Class(CommunityEventLayout)

local Position = {
    BottomRight = U_Vector3(489.5, -232),
    BottomLeft = U_Vector3(-489.5, -232),
}

--- @return void
--- @param transform UnityEngine_Transform
--- @param view UIWikiView
function CommunityEventLayout:Ctor(view, transform)
    --- @type UICommunityTotalView
    self.view = view
    --- @type UISelect
    self.tab = nil
    ---@type CommunityEventLayoutConfig
    self.config = UIBaseConfig(transform)
    ---@type number
    self.currentTabIndex = nil
    ---@type UITopTabItem
    self.currentTabItem = nil
    ---@type List - UITopTabItem
    self.tabItemList = List()
    ---@type CommunityEventData
    self.communityEventData = zg.playerData:GetEvents().communityEventData
    if self.communityEventData.configs[1].id ~= 0 then
        self:InitTab()
    end
end

--- @return void
function CommunityEventLayout:InitTab()
    --- @param obj UITopTabItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type CommunityEventConfig
        local communityEventConfig = self.communityEventData.configs[dataIndex]
        self.tabItemList:Add(obj)
        obj:SetIcon(ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconTabCommunityEvent, communityEventConfig.event_image_id))
        obj:SetTabName(communityEventConfig.event_name)
        obj:AddOnSelectListener(function()
            self:SelectTab(dataIndex)
        end)
        obj:EnableNoti(self.communityEventData:CheckTabNotSeen(communityEventConfig))
    end

    self.uiScroll = UILoopScroll(self.config.loopScrollHorizontal, UIPoolType.UITopTabItem, onCreateItem)
    self.uiScroll:SetUpMotion(MotionConfig())
end

---@param urlTable {}
---@param languageCode LanguageCode
function CommunityEventLayout:InitImageListener(urlTable, languageCode)
    local url = urlTable[LanguageCode.DefaultLanguage]
    for k, v in pairs(urlTable) do
        if k == languageCode then
            url = v
        end
    end
    self:SetActiveTextTapMoreDetail(not StringUtils.IsNilOrEmpty(url))
    self:GoToURL(self.config.bannerEventButton, url)
end

---@param buttonType CommunityEventButtonType
---@param data {isActive, localize, text}
function CommunityEventLayout:InitButtonListener(buttonType, data, languageCode)
    --- @type UnityEngine_UI_Button
    local button
    local buttonFunction
    if buttonType == CommunityEventButtonType.Facebook then
        self.config.textDiscord.text = LanguageUtils.LocalizeCommon(data.localize)
        button = self.config.buttonFacebook
        buttonFunction = function()
            PopupUtils.OpenFanpage()
        end
    elseif buttonType == CommunityEventButtonType.Discord then
        self.config.textFacebook.text = data.text
        button = self.config.buttonDiscord
        buttonFunction = function()
            U_Application.OpenURL("https://discord.gg/jUPHrrP")
        end
    elseif buttonType == CommunityEventButtonType.Other then
        self.config.textGoEvent.text = LanguageUtils.LocalizeCommon(data.localize)
        local url = data[LanguageCode.DefaultLanguage]
        for k, v in pairs(data) do
            if k == languageCode then
                url = v
            end
        end
        button = self.config.buttonGoEvent
        buttonFunction = function()
            U_Application.OpenURL(string.format("%s", url))
        end
    end
    button.gameObject:SetActive(data.isActive)
    button.onClick:RemoveAllListeners()
    button.onClick:AddListener(function()
        if buttonFunction then
            buttonFunction()
        end
    end)
end

---@param buttonPosition CommunityEventButtonPosition
function CommunityEventLayout:SetButtonAnchorPos(buttonPosition)
    local stringPos = tostring(buttonPosition)
    --- @type UnityEngine_RectTransform
    self.buttonAnchor = self.config.transform:Find("banner_event_content/button_anchor"):GetComponent(ComponentName.UnityEngine_RectTransform)
    --- @type UnityEngine_Vector3
    local pos
    if stringPos == CommunityEventButtonPosition.BottomLeft then
        pos = Position.BottomLeft
    elseif stringPos == CommunityEventButtonPosition.BottomRight then
        pos = Position.BottomRight
    else
        pos = Position.BottomRight
    end
    self.buttonAnchor.transform.localPosition = pos
end

--- @return void
function CommunityEventLayout:SelectTab(indexTab)
    if self.currentTabIndex ~= nil then
        self.tabItemList:Get(self.currentTabIndex):SetSelectState(false)
    end
    --- @type CommunityEventConfig
    local communityEventConfig = self.communityEventData.configs[indexTab]
    self.currentTabIndex = indexTab

    ---@type  Language
    local currentLanguage = LanguageUtils.GetLanguageByType(PlayerSettingData.language)

    self:DisableAllButton()
    self:InitEventImage(communityEventConfig, currentLanguage.code)
    self:InitImageListener(communityEventConfig.event_url, currentLanguage.code)

    self:InitButtonListener(CommunityEventButtonType.Facebook, communityEventConfig.button_facebook)
    self:InitButtonListener(CommunityEventButtonType.Discord, communityEventConfig.button_discord)
    self:InitButtonListener(CommunityEventButtonType.Other, communityEventConfig.button_other, currentLanguage.code)

    self:SetButtonAnchorPos(communityEventConfig.button_position)

    self.tabItemList:Get(self.currentTabIndex):SetSelectState(true)

    self.communityEventData:SaveTabSeenRemoteConfig(communityEventConfig)
    self.tabItemList:Get(self.currentTabIndex):EnableNoti(self.communityEventData:CheckTabNotSeen(communityEventConfig))
    RxMgr.notificationRequestCommunityTotal:Next()
end

---@param communityEventConfig CommunityEventConfig
---@param languageCode LanguageCode
function CommunityEventLayout:InitEventImage(communityEventConfig, languageCode)
    --- @type string
    local imgName = communityEventConfig.event_image_id
    local languageCodes = communityEventConfig.img_localize:Split(",")
    ---@param v LanguageCode
    for _, v in ipairs(languageCodes) do
        if v == languageCode then
            imgName = string.format("%s-%s", communityEventConfig.event_image_id, languageCode)
            break
        end
    end
    self.config.bannerEventContent.sprite = ResourceLoadUtils.LoadTexture(ResourceLoadUtils.iconBannerCommunityEvent, imgName, ComponentName.UnityEngine_Sprite)
end

---@param button UnityEngine_UI_Button
function CommunityEventLayout:GoToURL(button, url)
    if button then
        button.onClick:RemoveAllListeners()
        button.onClick:AddListener(function()
            local openOnBrowzer = function()
                U_Application.OpenURL(url)
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
                    U_Application.OpenURL(url)
                elseif IS_IOS_PLATFORM then
                    U_Application.OpenURL(url)
                end
            else
                openOnBrowzer()
            end
        end)
    end
end

function CommunityEventLayout:SetActiveTextTapMoreDetail(isActive)
    self.config.textTapToMoreDetail.gameObject:SetActive(isActive)
end

function CommunityEventLayout:DisableAllButton()
    self.config.buttonFacebook.gameObject:SetActive(false)
    self.config.buttonDiscord.gameObject:SetActive(false)
    self.config.buttonGoEvent.gameObject:SetActive(false)
end

function CommunityEventLayout:InitLocalize()
    self.config.textEmpty.text = LanguageUtils.LocalizeCommon("empty_event")
    self.config.textTapToMoreDetail.text = string.format("* %s", LanguageUtils.LocalizeCommon("tap_for_more_information"))
end

function CommunityEventLayout:ShowEmptyIcon(isActive)
    self.config.emptyObj:SetActive(isActive)
end

--- @return void
function CommunityEventLayout:OnShow()
    self.tabItemList = List()
    self.config.gameObject:SetActive(true)
    self:InitLocalize()
    if self.communityEventData.configs[1].id ~= 0 then
        self.uiScroll:Resize(#self.communityEventData.configs)
        self:SelectTab(1)
        self:ShowEmptyIcon(false)
    else
        self:ShowEmptyIcon(true)
        self.config.bannerEventContent.gameObject:SetActive(false)
    end
end

--- @return void
function CommunityEventLayout:OnHide()
    self.config.gameObject:SetActive(false)
    self.config.bannerEventContent.gameObject:SetActive(true)
    if self.communityEventData.configs[1].id ~= 0 then
        self.uiScroll:Hide()
        self.tabItemList:Clear()
    end
end