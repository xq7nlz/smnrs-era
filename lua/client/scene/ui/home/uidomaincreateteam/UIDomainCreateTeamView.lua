--- @class UIDomainCreateTeamView : UIBaseView
UIDomainCreateTeamView = Class(UIDomainCreateTeamView, UIBaseView)

--- @param model UIDomainCreateTeamModel
function UIDomainCreateTeamView:Ctor(model)
    --- @type UIDomainCreateTeamConfig
    self.config = nil
    UIBaseView.Ctor(self, model)
    --- @type UIDomainCreateTeamModel
    self.model = model
end

function UIDomainCreateTeamView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)
    self.config.inputFieldUID.characterLimit = 40
    self.config.inputFieldContent.characterLimit = 400
    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.bgClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonSend.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickSend()
    end)
end

function UIDomainCreateTeamView:InitLocalization()
    self.config.localizeTitle.text = LanguageUtils.LocalizeCommon("create_team")
    self.config.localizeButton.text = LanguageUtils.LocalizeCommon("create")
    self.config.nameRequire.text = LanguageUtils.LocalizeCommon("domain_name_require")
    self.config.descRequire.text = LanguageUtils.LocalizeCommon("domain_desc_require")
end

--- @return void
function UIDomainCreateTeamView:OnReadyShow(data)
    self.config.inputFieldUID.text = ""
    self.config.inputFieldContent.text = ""
    if data ~= nil then
        self.callbackCreateSuccess = data.callbackCreateSuccess
    end
end

--- @return void
function UIDomainCreateTeamView:OnClickSend()
	local name = self.config.inputFieldUID.text
	local desc = self.config.inputFieldContent.text

    if name ~= nil then
        if desc ~= nil then
            local callbackSuccess = function()
                PopupMgr.HidePopup(UIPopupName.UIDomainCreateTeam)
                if self.callbackCreateSuccess ~= nil then
                    self.callbackCreateSuccess()
                end
            end
            DomainInBound.RequestCreateTeam(name, desc, false, callbackSuccess)
        else
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("need_input_team_content"))
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        end
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("need_input_team"))
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
    end
end
