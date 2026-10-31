require "lua.client.core.network.mail.MailActionOutBound"

local MAIL_TYPE = {
    SYSTEM_MAIL = 1,
    TRANSACTION_MAIL = 2,
    PLAYER_MAIL = 3,
}
--- @class UIMailView : UIBaseView
UIMailView = Class(UIMailView, UIBaseView)

--- @return void
--- @param model UIMailModel
function UIMailView:Ctor(model, ctrl)
    ---@type MailDataInBound
    self.mailDataInBound = nil
    ---@type UIMailConfig
    self.config = nil
    self.currentTab = nil
    --- @type Dictionary -- UITabItem
    self.tabDic = Dictionary()
    --- @type table
    self.funSelectTab = { self.ShowSystemMail, self.ShowTransactionMail, self.ShowPlayerMail }
    ---@type UILoopScroll
    self.uiScroll = nil
    ---@type List
    self.listMail = nil
    ---@type MailData
    self.currentMail = nil

    -- init variables here
    UIBaseView.Ctor(self, model, ctrl)
    --- @type UIMailModel
    self.model = model
end

--- @return void
function UIMailView:OnReadyCreate()
    ---@type UIMailConfig
    self.config = UIBaseConfig(self.uiTransform)
    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.exitBtn.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonClaimAll.onClick:AddListener(function()
        self:OnClickClaimAll()
        zg.audioMgr:PlaySfxUi(SfxUiType.CLAIM)
    end)
    self.config.buttonDeleteAll.onClick:AddListener(function()
        self:OnClickDeleteAll()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
    self:InitTabs()
    ---- Tab
    ----- @param obj UITabConfig
    ----- @param isSelect boolean
    --local onSelect = function(obj, isSelect, indexTab)
    --    if obj ~= nil then
    --        obj.button.interactable = not isSelect
    --    obj.imageOn.gameObject:SetActive(isSelect)
    --    end
    --end
    --
    --local onChangeSelect = function(indexTab)
    --    if indexTab ~= nil then
    --        self.funSelectTab[indexTab](self)
    --    end
    --end
    --self.tab = UISelect(self.config.tab, UIBaseConfig, onSelect, onChangeSelect)

    --- @param obj UIMailItemView
    --- @param index number
    local onCreateItem = function(obj, index)
        ---@type MailData
        local mailData = self.listMail:Get(index + 1)
        obj:SetData(mailData)
        obj.callbackSelect = function()
            self:OnClickMail(index)
        end
    end
    self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.UIMailItemView, onCreateItem, onCreateItem)
    self.uiScroll:SetUpMotion(MotionConfig())
end
function UIMailView:InitTabs()
    self.currentTab = MAIL_TYPE.SYSTEM_MAIL
    self.selectTab = function(currentTab)
        self.currentTab = currentTab
        for k, v in pairs(self.tabDic:GetItems()) do
            v:SetTabState(k == currentTab)
        end
        self.funSelectTab[self.currentTab](self)
    end
    local addTab = function(tabId, anchor, localizeFunction)
        self.tabDic:Add(tabId, UITabItem(anchor, self.selectTab, localizeFunction, tabId))
    end
    addTab(MAIL_TYPE.SYSTEM_MAIL, self.config.systemMailTab.transform, function()
        return LanguageUtils.LocalizeCommon("system_mail")
    end)
    addTab(MAIL_TYPE.TRANSACTION_MAIL, self.config.transactionMailTab.transform, function()
        return LanguageUtils.LocalizeCommon("transaction_mail")
    end)
    addTab(MAIL_TYPE.PLAYER_MAIL, self.config.playerMailTab.transform, function()
        return LanguageUtils.LocalizeCommon("player_mail")
    end)
end

function UIMailView:InitLocalization()
    self.config.titleMailBox.text = LanguageUtils.LocalizeCommon("mail_box")
    self.config.localizeClaimAll.text = LanguageUtils.LocalizeCommon("claim_all")
    self.config.localizeDeleteAll.text = LanguageUtils.LocalizeCommon("delete_all")
    self.config.textMailEmpty.text = LanguageUtils.LocalizeCommon("mail_empty")
    self.config.localizeTapToClose.gameObject:SetActive(false)

    if self.tabDic ~= nil then
        --- @param v UITabItem
        for _, v in pairs(self.tabDic:GetItems()) do
            v:InitLocalization()
        end
    end
end

--- @return void
function UIMailView:OnReadyShow()
    self.currentTab = MAIL_TYPE.SYSTEM_MAIL
    self.mailDataInBound = zg.playerData:GetMethod(PlayerDataMethod.MAIL)
    self:InitListener()
    self.selectTab(self.currentTab)
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    self.uiScroll:PlayMotion()
end

--- @return void
function UIMailView:Hide()
    UIBaseView.Hide(self)
    self:RemoveListener()
    self.uiScroll:Hide()
end

--- @return void
function UIMailView:InitListener()
    self.listener = RxMgr.notificationRequestMail:Subscribe(RxMgr.CreateFunction(self, self.OnServerNotificationMail))
    self.listenerUINoti = RxMgr.notificationUiMail:Subscribe(RxMgr.CreateFunction(self, self.CheckNotificationAll))
end

--- @return void
function UIMailView:RemoveListener()
    if self.listener then
        self.listener:Unsubscribe()
        self.listener = nil
    end
    if self.listenerUINoti then
        self.listenerUINoti:Unsubscribe()
        self.listenerUINoti = nil
    end
end

--- @return void
function UIMailView:OnServerNotificationMail()
    PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.MAIL }, function()
        self.mailDataInBound:RequestMailData(function()
            if self.currentTab == MAIL_TYPE.SYSTEM_MAIL then
                self.listMail = self.mailDataInBound.listSystemMail
            elseif self.currentTab == MAIL_TYPE.PLAYER_MAIL == 3 then
                self.listMail = self.mailDataInBound.listPlayerMail
            elseif self.currentTab == MAIL_TYPE.TRANSACTION_MAIL then
                self.listMail = self.mailDataInBound.listTransactionMail
            end

            if self.listMail:Count() > 1 then
                self.listMail:SortWithMethod(MailData.SortMail)
            end
            self.uiScroll:SetSize(self.listMail:Count())
            self.uiScroll:RefillCells()
            self:CheckNotificationAll()
        end)
    end)
end

--- @return boolean
function UIMailView:IsPlayerMail()
    return self.currentTab == MAIL_TYPE.PLAYER_MAIL
end

--- @return void
function UIMailView:ShowSystemMail()
    self.listMail = self.mailDataInBound.listSystemMail
    self:ShowMail()
end

--- @return void
function UIMailView:ShowPlayerMail()
    self.listMail = self.mailDataInBound.listPlayerMail
    self:ShowMail()
end

--- @return void
function UIMailView:ShowTransactionMail()
    self.listMail = self.mailDataInBound.listTransactionMail
    self:ShowMail()
end

--- @return void
function UIMailView:SortAndShowMail()
    self.listMail:SortWithMethod(MailData.SortMail)
    self:ShowMail()
end

--- @return void
function UIMailView:ShowMail()
    if self.listMail:Count() > 1 then
        self.listMail:SortWithMethod(MailData.SortMail)
    end

    self.uiScroll:Resize(self.listMail:Count())
    self:CheckNotificationAll()
    self:UpdateMailNumber()
    self:CheckTransactionMail()
end

--- @return void
function UIMailView:UpdateMailNumber()
    if self.listMail:Count() == 0 then
        self.config.empty.gameObject:SetActive(true)
        UIUtils.SetInteractableButton(self.config.buttonDeleteAll, false)
        UIUtils.SetInteractableButton(self.config.buttonClaimAll, false)
    else
        self.config.empty.gameObject:SetActive(false)
        UIUtils.SetInteractableButton(self.config.buttonDeleteAll, true)
        UIUtils.SetInteractableButton(self.config.buttonClaimAll, true)
    end
end

--- @return void
function UIMailView:CheckTransactionMail()
    if self.currentTab == MAIL_TYPE.TRANSACTION_MAIL then
        UIUtils.SetInteractableButton(self.config.buttonDeleteAll, false)
        UIUtils.SetInteractableButton(self.config.buttonClaimAll, false)
    end
end

--- @return void
function UIMailView:CheckNotificationTab()
    if self.currentTab == MAIL_TYPE.SYSTEM_MAIL then
        self.tabDic:Get(self.currentTab):EnableNotify(self.mailDataInBound:CheckEventNotificationSystem())
    elseif self.currentTab == MAIL_TYPE.PLAYER_MAIL then
        self.tabDic:Get(self.currentTab):EnableNotify(self.mailDataInBound:CheckEventNotificationPlayer())
    end
end

--- @return void
function UIMailView:CheckNotificationAll()
    local notifyTab = function(tabId, isNotified)
        --- @type UITabItem
        local uiTabItem = self.tabDic:Get(tabId)
        if uiTabItem ~= nil then
            uiTabItem:EnableNotify(isNotified)
        end
    end
    notifyTab(MAIL_TYPE.SYSTEM_MAIL, self.mailDataInBound.isNotificationSystem)
    notifyTab(MAIL_TYPE.PLAYER_MAIL, self.mailDataInBound.isNotificationPlayer)
end

--- @return void
function UIMailView:OnClickReadAll()
    ---@param v MailData
    for _, v in pairs(self.listMail:GetItems()) do
        if v.mailState == MailState.NEW then
            v.mailState = MailState.OPENED
        end
    end
    NetworkUtils.RequestAndCallback(OpCode.MAIL_READ, MailActionOutBound(true, self:IsPlayerMail()))
end

--- @return void
function UIMailView:OnClickClaimAll()
    local canClaim = false
    for _, v in pairs(self.listMail:GetItems()) do
        if v.mailState ~= MailState.NEW or (v.mailState ~= MailState.REWARD_RECEIVED and v.listReward:Count() > 0) then
            canClaim = true
            break
        end
    end
    if canClaim == true then
        local callbackSuccess = function()
            ---@type Dictionary
            local dictResource = Dictionary()
            ---@param v MailData
            for _, v in pairs(self.listMail:GetItems()) do
                if v.mailState ~= MailState.REWARD_RECEIVED and v.listReward:Count() > 0 then
                    ---@param reward RewardInBound
                    for _, reward in pairs(v.listReward:GetItems()) do
                        ---@type ItemIconData
                        local iconData = reward:GetIconData()
                        ---@type Dictionary
                        local dictId
                        local number = iconData.quantity
                        if dictResource:IsContainKey(iconData.type) then
                            dictId = dictResource:Get(iconData.type)
                            if dictId:IsContainKey(iconData.itemId) then
                                number = number + dictId:Get(iconData.itemId)
                            end
                        else
                            dictId = Dictionary()
                            dictResource:Add(iconData.type, dictId)
                        end
                        dictId:Add(iconData.itemId, number)
                    end
                end
                v.mailState = MailState.REWARD_RECEIVED
            end
            ---@type List
            local listResource = List()
            ---@param v Dictionary
            for type, v in pairs(dictResource:GetItems()) do
                for id, number in pairs(v:GetItems()) do
                    if number > 0 then
                        ---@type ItemIconData
                        local iconData = ItemIconData.CreateInstance(type, id, number)
                        iconData:AddToInventory()
                        listResource:Add(iconData)
                    end
                end
            end
            if listResource:Count() > 0 then
                PopupUtils.ShowRewardList(listResource)
            end
            self:SortAndShowMail()
            self:CheckNotificationTab()
        end
        local callbackFailed = function()

        end
        NetworkUtils.RequestAndCallback(OpCode.MAIL_REWARD_CLAIM, MailActionOutBound(true, self:IsPlayerMail()), callbackSuccess, callbackFailed)
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("can_not_claim_mail"))
    end
end

--- @return void
function UIMailView:OnClickDeleteAll()
    local yesCallback = function()
        local callbackSuccess = function()
            local i = self.listMail:Count()
            while i > 0 do
                ---@type MailData
                local mail = self.listMail:Get(i)
                if mail:CanDelete() then
                    self.listMail:RemoveByReference(mail)
                end
                i = i - 1
            end
            self:ShowMail()
            self:CheckNotificationTab()
        end

        local callbackFailed = function()

        end
        NetworkUtils.RequestAndCallback(OpCode.MAIL_DELETE, MailActionOutBound(true, self:IsPlayerMail()), callbackSuccess, callbackFailed)
        zg.audioMgr:PlaySfxUi(SfxUiType.CONFIRM)
    end
    local noCallback = function()
        zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
    end
    PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("want_delete_all_mail"), noCallback, yesCallback)
end

--- @return void
--- @param index number
function UIMailView:OnClickMail(index)
    self.currentMail = self.listMail:Get(index + 1)
    if self.currentMail.mailState == MailState.NEW then
        NetworkUtils.RequestAndCallback(OpCode.MAIL_READ, MailActionOutBound(false, self:IsPlayerMail(), self.currentMail.mailId))
        self.currentMail.mailState = MailState.OPENED
    end
    self.uiScroll:RefreshCells(self.listMail:Count())
    self:CheckNotificationTab()
    PopupMgr.ShowPopup(UIPopupName.UIMailPreview,
            { ["currentMail"] = self.currentMail,
              ["callbackClaim"] = function(mail)
                  self.uiScroll:RefreshCells()
                  self:CheckNotificationTab()
              end,
              ["canDelete"] = self.currentTab ~= MAIL_TYPE.TRANSACTION_MAIL,
              ["callbackDelete"] = function(mail)
                  self.listMail:RemoveByReference(mail)
                  self.uiScroll:RefreshCells(self.listMail:Count())
                  self:UpdateMailNumber()
              end
            })
    zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
end