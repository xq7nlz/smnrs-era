--- @class CommunityCustomerServiceLayout
CommunityCustomerServiceLayout = Class(CommunityCustomerServiceLayout)

--- @return void
--- @param transform UnityEngine_Transform
--- @param view UIWikiView
function CommunityCustomerServiceLayout:Ctor(view, transform)
    --- @type UICommunityTotalView
    self.view = view
    ---@type CommunityCustomerServiceConfig
    self.config = UIBaseConfig(transform)
    self:InitButton()
end

function CommunityCustomerServiceLayout:InitButton()
    self.config.buttonGoToFanpage.onClick:AddListener(function()
        self:OpenUrl("https://forms.gle/jsvxaQ7bg8SKxadT6")
    end)
end

function CommunityCustomerServiceLayout:OpenUrl(url)
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
end

function CommunityCustomerServiceLayout:InitLocalize()
    self.config.localizeTitle.text = LanguageUtils.LocalizeCommon("customer_service")
    self.config.localizeContent.text = LanguageUtils.LocalizeCommon("customer_service_content")
    self.config.localizeGoToFanpage.text = LanguageUtils.LocalizeCommon("form")
end

--- @return void
function CommunityCustomerServiceLayout:OnShow()
    self.config.gameObject:SetActive(true)
    self:InitLocalize()
end

--- @return void
function CommunityCustomerServiceLayout:OnHide()
    self.config.gameObject:SetActive(false)
end