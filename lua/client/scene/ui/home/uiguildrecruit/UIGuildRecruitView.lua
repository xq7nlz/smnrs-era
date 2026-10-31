--- @class UIGuildRecruitView : UIBaseView
UIGuildRecruitView = Class(UIGuildRecruitView, UIBaseView)

--- @return void
--- @param model UIGuildRecruitModel
function UIGuildRecruitView:Ctor(model)
    --- @type UIGuildRecruitConfig
    self.config = nil
    --- @type number
    self.lastSend = os.time() - 1000
    UIBaseView.Ctor(self, model)
    --- @type UIGuildRecruitModel
    self.model = model
end

--- @return void
function UIGuildRecruitView:OnReadyCreate()
    ---@type UIGuildRecruitConfig
    self.config = UIBaseConfig(self.uiTransform)
    self.config.inputRecruit.characterLimit = ResourceMgr.GetChat().messageLength - 50
    self:_InitButtonListener()
end

--- @return void
function UIGuildRecruitView:InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("recruit")
    self.config.localizeSend.text = LanguageUtils.LocalizeCommon("send")
    self.config.localizeInputRecruitInfo.text = LanguageUtils.LocalizeCommon("input_recruit_info")
    self.config.inputRecruit.placeholder:GetComponent(ComponentName.UnityEngine_UI_Text).text = LanguageUtils.LocalizeCommon("enter_chat")
end

function UIGuildRecruitView:_InitButtonListener()
    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.bgClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonSend.onClick:AddListener(function()
        self:_OnClickSend()
    end)
end

function UIGuildRecruitView:_OnClickSend()
    if self.config.inputRecruit.text == "" then
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("enter_recruit_info_please"))
        return
    end
    ---@type number
    local delay = self.lastSend + ChatData.DELAY_SEND_MESSAGE - os.time()
    if delay > 0 then
        SmartPoolUtils.ShowShortNotification(string.format(LanguageUtils.LocalizeCommon("chat_delay"), delay))
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self.lastSend = os.time()
        local onReceived = function(result)
            local onSuccess = function()
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("send_recruit_successful"))
                self:OnReadyHide()
            end
            --- @param logicCode LogicCode
            local onFailed = function(logicCode)
                SmartPoolUtils.LogicCodeNotification(logicCode)
                zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            end
            NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
        end
        local message = self.config.inputRecruit.text
        NetworkUtils.Request(OpCode.GUILD_MEMBER_RECRUIT, UnknownOutBound.CreateInstance(PutMethod.String, message), onReceived)
    end
end

function UIGuildRecruitView:OnReadyShow()
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
end

function UIGuildRecruitView:OnReadyHide()
    UIBaseView.OnReadyHide(self)
    self.config.inputRecruit.text = ""
end
