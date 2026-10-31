--- @class UIHelpInfoView : UIBaseView
UIHelpInfoView = Class(UIHelpInfoView, UIBaseView)

--- @return void
--- @param model UIHelpInfoModel
function UIHelpInfoView:Ctor(model, ctrl)
    ---@type UIHelpInfoConfig
    self.config = nil

    UIBaseView.Ctor(self, model, ctrl)
    --- @type UIHelpInfoModel
    self.model = model
end

--- @return void
function UIHelpInfoView:OnReadyCreate()
    ---@type UIHelpInfoConfig
    self.config = UIBaseConfig(self.uiTransform)
    self.config.bg.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

--- @return void
function UIHelpInfoView:InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("help")
    self.config.textTapToClose.gameObject:SetActive(false)
end

function UIHelpInfoView:StartTime()
    if self.updateTime ~= nil then
        zg.timeMgr:AddUpdateFunction(self.updateTime)
    end
end

function UIHelpInfoView:StopTime()
    if self.updateTime ~= nil then
        zg.timeMgr:RemoveUpdateFunction(self.updateTime)
    end
end

function UIHelpInfoView:OnTimeEnd()
    self:ResizeScrollView(false)
end

function UIHelpInfoView:Hide()
    UIBaseView.Hide(self)
    self:StopTime()
end

function UIHelpInfoView:InitUpdateTime(timeOpenIn)
    self.config.textTime.text = ""
    if (timeOpenIn > 0) then
        self.timeRemaining = timeOpenIn
        self.updateTime = function(isSetTime)
            if isSetTime == true then
            else
                self.timeRemaining = self.timeRemaining - 1
            end
            if self.timeRemaining > 0 then
                self.config.textTime.text = string.format("%s %s", LanguageUtils.LocalizeCommon("will_open_in"), TimeUtils.GetDeltaTime(self.timeRemaining, 4))
                --self.config.textTime.text = string.format(LanguageUtils.LocalizeCommon("expire_in_s"), TimeUtils.GetDeltaTime(self.timeRemaining, 4))
            else
                self:OnTimeEnd()
                self.config.textTime.text = ""
                self:StopTime()
            end
        end
        self:StartTime()
    else
        self.updateTime = nil
    end

end

function UIHelpInfoView:ResizeScrollView(hasTime)
    local posY = -67.4
    local height = 592.9
	if hasTime then
        posY = -90
        height = 550
    end
    self.config.scroll.anchoredPosition = U_Vector2(self.config.scroll.anchoredPosition.x, posY)
    self.config.scroll.sizeDelta = U_Vector2(self.config.scroll.sizeDelta.x, height)
end

--- @return void
function UIHelpInfoView:OnReadyShow(result)
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    local hasTime = result.timeOpen ~= nil
    local textContent = ""
    local posY = -58.8
    local height = 550.668
    local timeOpen = 0
    if (hasTime) then
        posY = -89.9
        height = 488.5632
        timeOpen = tonumber(result.timeOpen)
        textContent = result.textHelp
    elseif result.icon ~= nil then
        --- @type IconView
        local icon = result.icon
        UIUtils.SetParent(icon.config.transform,self.config.transform)
        textContent = result.content
    else
        textContent = result
    end
    self:InitUpdateTime(timeOpen)
    self:ResizeScrollView(hasTime)
    if textContent ~= nil then
        self.config.content.text = textContent
    end
end