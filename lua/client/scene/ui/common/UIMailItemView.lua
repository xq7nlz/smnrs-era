--- @class UIMailItemView : MotionIconView
UIMailItemView = Class(UIMailItemView, MotionIconView)

--- @return void
function UIMailItemView:Ctor()
    ---@type MailData
    self.mail = nil
    ---@type function
    self.callbackSelect = nil
    ---@type UILoopScroll
    self.uiScroll = nil
    MotionIconView.Ctor(self)
end

--- @return void
function UIMailItemView:SetPrefabName()
    self.prefabName = 'mail_item_view'
    self.uiPoolType = UIPoolType.UIMailItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function UIMailItemView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    --- @type UIMailItemConfig
    ---@type UIMailItemConfig
    self.config = UIBaseConfig(transform)
    self.config.button.onClick:AddListener(function ()
        self:OnClickSelect()
    end)

    --- @param obj RootIconView
    --- @param index number
    local onUpdateItem = function(obj, index)
        ---@type RewardInBound
        local reward = self.mail.listReward:Get(index + 1)
        obj:SetIconData(reward:GetIconData())
        obj:SetActiveColor(self.mail.mailState ~= MailState.REWARD_RECEIVED)
    end
    --- @param obj RootIconView
    --- @param index number
    local onCreateItem = function(obj, index)
        obj:SetSize(150, 150)
        onUpdateItem(obj, index)
        obj:RegisterShowInfo()
    end
    self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.RootIconView, onCreateItem, onUpdateItem)
end

--- @return void
--- @param mail MailData
function UIMailItemView:SetData(mail)
    self.mail = mail
    self:UpdateUI()
end

--- @return void
function UIMailItemView:UpdateUI()
    if self.mail.senderType == SenderType.PLAYER then
        self.config.textUserName.text = self.mail.senderName--UIUtils.SetColorString(UIUtils.brown, self.mail.senderName)
    else
        self.config.textUserName.text = self.mail:GetSubject() -- UIUtils.SetColorString(UIUtils.brown, self.mail:GetSubject())
    end
    self.config.textEventTimeJoin.text = TimeUtils.GetTimeFromDateTime(self.mail.createTime) -- UIUtils.SetColorString(UIUtils.color2, TimeUtils.GetTimeFromDateTime(self.mail.createTime))
    if self.mail.mailState == MailState.NEW then
        self.config.iconMail:SetActive(true)
        self.config.iconMailUnbox:SetActive(false)
    else
        self.config.iconMail:SetActive(false)
        self.config.iconMailUnbox:SetActive(true)
    end
    if self.mail:CanNotification() == false then
        self.config.iconNoti:SetActive(false)
    else
        self.config.iconNoti:SetActive(true)
    end
    self.config.scroll.enabled = true
    self.config.mask.enabled = true
    self.uiScroll:Resize(self.mail.listReward:Count())
    Coroutine.start(function()
        coroutine.waitforendofframe()
        coroutine.waitforendofframe()
        if self.mail.listReward:Count() <= 4 then
            self.config.scroll.enabled = false
            self.config.mask.enabled = false
        end
    end)
end

--- @return void
function UIMailItemView:ReturnPool()
    self.uiScroll:Hide()
    MotionIconView.ReturnPool(self)
end

--- @return void
function UIMailItemView:OnClickSelect()
    if self.callbackSelect ~= nil then
        self.callbackSelect()
    end
end

return UIMailItemView