--- @class UIRenameView : UIBaseView
UIRenameView = Class(UIRenameView, UIBaseView)

--- @param model UIRenameModel
function UIRenameView:Ctor(model)
    ---@type UIRenameConfig
    self.config = nil

    UIBaseView.Ctor(self, model)
    --- @type UIRenameModel
    self.model = model
end

--- @return void
function UIRenameView:OnReadyCreate()
    ---@type UIRenameConfig
    self.config = UIBaseConfig(self.uiTransform)
    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.bgClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonOk.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickOK()
    end)
    self.config.buttonOkFree.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickOK()
    end)
    self.config.buttonInput.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickInput()
    end)
    self.config.inputName.onEndEdit:AddListener(function(text)
        self:EndInputName()
    end)
    self.config.buttonRandom.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickRandomName()
    end)

    self.config.inputName.characterLimit = ResourceMgr.GetBasicInfo().maxCharacterOfName
end

--- @return void
function UIRenameView:InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("rename")
    local localizeOk = LanguageUtils.LocalizeCommon("ok")
    self.config.localizeOk.text = localizeOk
    self.config.localizeOkFree.text = localizeOk
    self.config.localizeCharacter.text = LanguageUtils.LocalizeCommon("your_summoner_name")
    self.config.textRenameRule.text = string.format(LanguageUtils.LocalizeCommon("x_character"), ResourceMgr.GetBasicInfo().minCharacterOfName .. "-" .. ResourceMgr.GetBasicInfo().maxCharacterOfName)
    self.config.textRandom.text = LanguageUtils.LocalizeCommon("random_name")
end

--- @return void
function UIRenameView:OnReadyShow(data)
    self.config.inputName.text = ""
    self.config.popup.localPosition = U_Vector3.zero
    --- @type BasicInfoInBound
    self.basicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
    self.config.buttonOk.gameObject:SetActive(self.basicInfoInBound.numberChangeName ~= nil
            and self.basicInfoInBound.numberChangeName > 0)
    if self.basicInfoInBound.numberChangeName ~= nil
            and self.basicInfoInBound.numberChangeName > 0 then
        self.config.buttonOkFree.gameObject:SetActive(false)
        self.config.textDiamond.text = tostring(ResourceMgr.GetBasicInfo().changeNameGemPrice)
    else
        self.config.buttonOkFree.gameObject:SetActive(true)
    end

    if data ~= nil and data.notClose == true then
        self.config.buttonClose.gameObject:SetActive(false)
    else
        self.config.buttonClose.gameObject:SetActive(true)
    end
end

--- @return void
function UIRenameView:OnFinishAnimation()
    UIBaseView.OnFinishAnimation(self)
    self:CheckAndInitTutorial()
end

--- @return void
function UIRenameView:Hide()
    self:RemoveListenerTutorial()

    self.parsedData = nil

    UIBaseView.Hide(self)
end

--- @return void
function UIRenameView:OnClickOK()
    zg.audioMgr:PlaySfxUi(SfxUiType.CONFIRM)
    if self.config.inputName.text == self.basicInfoInBound.name then
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("current_name"))
        self:RenameFalse()
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
    elseif self.basicInfoInBound.numberChangeName ~= nil
            and self.basicInfoInBound.numberChangeName > 0
            and not InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.GEM, ResourceMgr.GetBasicInfo().changeNameGemPrice)) then
    elseif self.config.inputName.text ~= "" then
        local rename = function()
            local onReceived = function(result)
                local onSuccess = function()
                    local newName = self.config.inputName.text
                    InventoryUtils.Sub(ResourceType.Money, MoneyType.GEM, ResourceMgr.GetBasicInfo().changeNameGemPrice)
                    SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("change_success"))
                    zg.playerData:UpdatePlayerInfoOnOthersUI("name", newName, self.basicInfoInBound.name)
                    self.basicInfoInBound.name = self.config.inputName.text
                    RxMgr.finishName:Next()
                    self.basicInfoInBound.numberChangeName = self.basicInfoInBound.numberChangeName + 1
                    PopupMgr.HidePopup(UIPopupName.UIRename)

                    if UIBaseView.IsActiveTutorial() then
                        UIBaseView.tutorial:NextTutorial()
                    end
                end

                local onFailed = function(logicCode)
                    SmartPoolUtils.LogicCodeNotification(logicCode)
                    self:RenameFalse()
                end
                NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
            end
            NetworkUtils.Request(OpCode.PLAYER_NAME_CHANGE, UnknownOutBound.CreateInstance(PutMethod.String, self.config.inputName.text), onReceived)
        end
        if self.basicInfoInBound.numberChangeName ~= nil and self.basicInfoInBound.numberChangeName > 0 then
            local canOke = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.GEM, ResourceMgr.GetBasicInfo().changeNameGemPrice))
            if canOke then
                PopupUtils.ShowPopupNotificationUseResource(MoneyType.GEM, ResourceMgr.GetBasicInfo().changeNameGemPrice, rename)
            end
        else
            rename()
        end
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("enter_name_please"))
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
    end
end

--- @return void
function UIRenameView:RenameFalse()
    --if UIBaseView.tutorial ~= nil then
    --	UIBaseView.tutorial:NextTutorial(TutorialRenameFalse():Start():GetStartNode())
    --end
end

--- @return void
function UIRenameView:OnClickInput()
    if self.config.inputName.isFocused == false then
        self.config.inputName:Select()
        if IS_MOBILE_PLATFORM then
            DOTweenUtils.DOMove(self.config.popup.transform, self.config.positionInput.position, 0.2, U_Ease.OutBounce, nil)
        end
    end
end

--- @return void
function UIRenameView:EndInputName()
    --if UIBaseView.tutorial ~= nil then
    --	UIBaseView.tutorial:NextTutorial()
    --end
    if IS_MOBILE_PLATFORM then
        DOTweenUtils.DOMove(self.config.popup.transform, self.config.transform.position, 0.2, U_Ease.OutBounce, nil)
    end
end

--- @return void
---@param tutorial UITutorialView
---@param step number
function UIRenameView:ShowTutorial(tutorial, step)
    if step == TutorialStep.CLICK_RENAME then
        self:OnClickRandomName()
        --tutorial:AddCallbackButton1(self.config.inputName.transform,
        --		self.config.inputName.gameObject:GetComponent(ComponentName.UnityEngine_RectTransform).sizeDelta,
        --function ()
        --	self:OnClickInput()
        --end)
        tutorial:AddCallbackButton1(self.config.buttonRandom.transform,
                self.config.buttonRandom.gameObject:GetComponent(ComponentName.UnityEngine_RectTransform).sizeDelta,
                function()
                    self:OnClickRandomName()
                end)
        tutorial:AddCallbackButton2(self.config.buttonOkFree.transform,
                self.config.buttonOkFree.gameObject:GetComponent(ComponentName.UnityEngine_RectTransform).sizeDelta,
                function()
                    self:OnClickOK()
                end)
        tutorial:ViewFocusCurrentTutorial(self.config.buttonInput, U_Vector2(900, 150), nil, true)
        --elseif step == TutorialStep.OK_RENAME then
        --	tutorial:ViewFocusCurrentTutorial(self.config.buttonOkFree, 0.5, nil, true)
    end
end

function UIRenameView:OnClickRandomName()
    if self.parsedData == nil then
        self.parsedData = CsvReaderUtils.ReadAndParseLocalFile("csv/client/surnames.csv")
    end
    self.config.inputName.text = self.parsedData[math.random(1, #self.parsedData)].name
end