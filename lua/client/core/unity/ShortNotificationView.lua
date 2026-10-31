--- @class ShortNotificationView
ShortNotificationView = Class(ShortNotificationView)

--- @param transform
function ShortNotificationView:Ctor(transform)
    --- @type UnityEngine_Vector2
    self.targetBgSize = U_Vector2(1700, 163)
    --- @type number
    self.timeFade = 0.2
    self.timeHold = 1

    --- @type UnityEngine_RectTransform
    self.rectTrans = nil
    --- @type DG_Tweening_Tweener
    self.tweenerFade = nil
    --- @type DG_Tweening_Tweener
    self.tweenerSize = nil

    --- @type UnityEngine_Coroutine
    self.coroutine = nil

    self:SetConfig(transform)
end

--- @param transform UnityEngine_Transform
function ShortNotificationView:SetConfig(transform)
    ---@type ShortNotificationConfig
    self.config = UIBaseConfig(transform)
    self.rectTrans = self.config.transform

    self.rectTrans.localScale = U_Vector3(1, 0, 1)
    self.rectTrans.anchoredPosition3D = U_Vector3.zero
    self.rectTrans:SetAsLastSibling()
end

--- @param message string
function ShortNotificationView:ShowMessage(message)
    self.config.resourceRequireView:SetActive(false)
    self.config.notiText.text = message
    self:DoShow()
end

--- @return void
function ShortNotificationView:DoShow()
    self:Reset()
    self:SetActive(true)

    self.coroutine = Coroutine.start(function()
        coroutine.waitforendofframe()
        self.config.groupLayout.enabled = false
        coroutine.waitforendofframe()
        self.config.groupLayout.enabled = true
        self.tweenerFade = DOTweenUtils.DOFade(self.config.canvasGroupContent, 1, self.timeFade)
        self.tweenerSize = DOTweenUtils.DOSizeDelta(self.config.bg, self.targetBgSize, self.timeFade)
        coroutine.waitforseconds(self.timeHold)
        self.tweenerSize = DOTweenUtils.DOScale(self.config.transform, 1.2, self.timeFade)
        self.tweenerFade = DOTweenUtils.DOFade(self.config.canvasGroup, 0, self.timeFade, function()
            self:SetActive(false)
        end)
    end)
end

function ShortNotificationView:Reset()
    self.config.canvasGroupContent.alpha = 0
    ClientConfigUtils.KillTweener(self.tweenerFade)
    ClientConfigUtils.KillTweener(self.tweenerSize)
    ClientConfigUtils.KillCoroutine(self.coroutine)
    self.config.transform.localScale = U_Vector3.one
    self.config.canvasGroup.alpha = 1
    self:SetBgHeight(80)
end

function ShortNotificationView:SetBgHeight(height)
    self.config.bg.sizeDelta = U_Vector2(self.targetBgSize.x, height)
end

--- @param isActive boolean
function ShortNotificationView:SetActive(isActive)
    self.config.gameObject:SetActive(isActive)
end

--- @param rewardInBound RewardInBound
function ShortNotificationView:ShowRewardNotification(rewardInBound)
    self.config.notiText.text = ""
    self.config.textNeed.text = LanguageUtils.LocalizeCommon("warning_you_need_more_resources")
    self.config.resourceRequireView:SetActive(true)

    local sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconCoins, rewardInBound.id)
    self.config.iconResources:SetActive(sprite ~= nil)
    if sprite ~= nil then
        self.config.icon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconCoins, rewardInBound.id)
        self.config.icon:SetNativeSize()
    end
    if PlayerSettingData.language == U_SystemLanguage.Korean:ToString() then
        self.config.textNeed.text =  UIUtils.SetColorString(UIUtils.red_light,
                        string.format("%s %s",
                        LanguageUtils.LocalizeNameItem(rewardInBound.type, rewardInBound.id),
                        ClientConfigUtils.FormatNumber(rewardInBound.number))) .. " " .. self.config.textNeed.text
    else
        self.config.textNeed.text =  self.config.textNeed.text .. " " ..   UIUtils.SetColorString(UIUtils.red_light,
                string.format("%s %s",
                        ClientConfigUtils.FormatNumber(rewardInBound.number),
                        LanguageUtils.LocalizeNameItem(rewardInBound.type, rewardInBound.id)))
    end
    self:DoShow()
end

return ShortNotificationView