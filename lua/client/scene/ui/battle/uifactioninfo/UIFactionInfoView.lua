---COMMENT_CONFIG    require "lua.client.scene.ui.battle.uiFactionInfo.UIFactionInfoConfig"

--- @class UIFactionInfoView : UIBaseView
UIFactionInfoView = Class(UIFactionInfoView, UIBaseView)

--- @return void
--- @param model UIFactionInfoModel
function UIFactionInfoView:Ctor(model)
    --- @type UIFactionInfoConfig
    self.config = nil

    UIBaseView.Ctor(self, model)
end

--- @return void
function UIFactionInfoView:OnReadyCreate()
    ---@type UIFactionInfoConfig
    self.config = UIBaseConfig(self.uiTransform)
    --- @type UnityEngine_Transform
    self.config.buttonBg.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)

    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)

    self:InitIcon()
end

function UIFactionInfoView:OnReadyShow()
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
end

--- @return void
function UIFactionInfoView:InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("faction_restrain")
    self.config.textInfo.text = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("faction_restrain_info"),
            UIUtils.SetColorString(UIUtils.green_dark, (HeroConstants.FACTION_BONUS_DAMAGE * 100) .. "%%"),
            UIUtils.SetColorString(UIUtils.green_dark, (HeroConstants.FACTION_BONUS_ACCURACY * 100) .. "%%"))
end

function UIFactionInfoView:InitIcon()
    --- @param image UnityEngine_UI_Image
    --- @param faction number
    local setIcon = function(image, faction)
        image.sprite = ResourceLoadUtils.LoadFactionIcon(faction)
    end
    setIcon(self.config.fire, 2)
    setIcon(self.config.nature, 4)
    setIcon(self.config.abyss, 3)
    setIcon(self.config.water, 1)
    setIcon(self.config.light, 5)
    setIcon(self.config.dark, 6)
end

--- @return void
function UIFactionInfoView:CheckCallbackAnimation()
    if self.animationCallback == nil then
        self:OnFinishAnimation()
    end
end
