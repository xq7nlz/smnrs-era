--- @class UIEventBirthdayDarkLightSelectSideLayout : UIEventBirthdayLayout
UIEventBirthdayDarkLightSelectSideLayout = Class(UIEventBirthdayDarkLightSelectSideLayout, UIEventBirthdayLayout)

--- @param view UIEventNewYearView
--- @param newYearTab LunarNewYearTab
--- @param anchor UnityEngine_RectTransform
function UIEventBirthdayDarkLightSelectSideLayout:Ctor(view, tab, anchor)
    --- thay type bằng type config của từng layout
    --- @type BirthdayDarkLightLayoutConfig
    self.layoutConfig = nil
    UIEventBirthdayLayout.Ctor(self ,view, tab, anchor)
    --- thay op code neu co
    self.opCode = OpCode.EVENT_BIRTHDAY_SELECT_SIDE
end

function UIEventBirthdayDarkLightSelectSideLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("birthday_dark_light", self.anchor)
    UIEventBirthdayLayout.InitLayoutConfig(self, inst)
    self:InitLocalization()
    self:SetUpLayout()
    self:SetEventTitle()
end


function UIEventBirthdayDarkLightSelectSideLayout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventBirthdayDarkLightSelectSideLayout:SetEventBanner()
end

function UIEventBirthdayDarkLightSelectSideLayout:SetEventTitle()
    self.layoutConfig.title.text = LanguageUtils.LocalizeCommon("dark_vs_light")
end

function UIEventBirthdayDarkLightSelectSideLayout:InitLocalization()
    self.layoutConfig.textButtonDark.text = LanguageUtils.LocalizeCommon("select_dark_path")
    self.layoutConfig.textButtonLight.text = LanguageUtils.LocalizeCommon("select_light_path")
end

function UIEventBirthdayDarkLightSelectSideLayout:InitButtonListener()
    self.layoutConfig.buttonLight.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:SendRequestSelectSideByHeroId(5)
    end)
    self.layoutConfig.buttonDark.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:SendRequestSelectSideByHeroId(6)
    end)
end

function UIEventBirthdayDarkLightSelectSideLayout:OnShow()
    UIEventBirthdayLayout.OnShow(self)
    self:InitButtonListener()
end


function UIEventBirthdayDarkLightSelectSideLayout:OnHide()
    UIEventBirthdayLayout.OnHide(self)
end

function UIEventBirthdayDarkLightSelectSideLayout:SendRequestSelectSideByHeroId(selectionId)
    PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("select_side_confirm"), nil, function()
        local onSuccess = function()
            self.eventModel.selectSideId = selectionId
            self.view:SelectTab(self.eventBirthdayTab)
        end
        NetworkUtils.Request(self.opCode, UnknownOutBound.CreateInstance(PutMethod.Int, selectionId), onSuccess)
    end)
end