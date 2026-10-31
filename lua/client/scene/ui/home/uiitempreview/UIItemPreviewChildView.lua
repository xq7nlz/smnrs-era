--- @class UIItemPreviewChildView
UIItemPreviewChildView = Class(UIItemPreviewChildView)

--- @return void
--- @param transform UnityEngine_Transform
function UIItemPreviewChildView:Ctor(transform)
    ---@type UIItemPreviewChildConfig
    self.config = UIBaseConfig(transform)
    ---@type IconView
    self.iconView = nil
    ---@type ResourceType
    self.type = nil
    ---@type number
    self.id = nil
    ---@type number
    self.setNumber = nil
    ---@type number
    self.class = nil
    ---@type number
    self.faction = nil
    ---@type {name, callback}
    self.buttonData1 = nil
    ---@type {name, callback}
    self.buttonData2 = nil
    ---@type Dictionary
    self.setFactionBuff = Dictionary()

    ---@type InputNumberView
    self.inputView = nil
    ---@type MoneyBarLocalView
    self.moneyBarView = MoneyBarLocalView(self.config.moneyBarInfo)

    self.config.localizeUpgrade.text = LanguageUtils.LocalizeCommon("upgrade")
end

function UIItemPreviewChildView:OnClickResetTalentBtn(inventoryId, callbackTalentReset, slotEquipmentType)
    local callBackReset = function(result)
        if (self.uiItemPreviewViewview ~= nil) then
            self.uiItemPreviewViewview:Hide()
        end
        callbackTalentReset(result)
    end

    local talentConfigList = ResourceMgr.GetHeroRefreshTalentConfig():GetTalentConfigListBySlotEquipment(slotEquipmentType)
    local listRewardInBound = List()
    --- @param talentConfig TalentConfig
    for _, talentConfig in ipairs(talentConfigList:GetItems()) do
        listRewardInBound:Add(talentConfig.resetMoneyData:GetRewardInbound())
    end

    if InventoryUtils.IsEnoughMultiResourceRequirement(listRewardInBound) then
        local yesCallBack = function()
            NetworkUtils.Request(OpCode.ITEM_TALENT_RESET, UnknownOutBound.CreateInstance(PutMethod.Long,
                    inventoryId, PutMethod.Int, slotEquipmentType), callBackReset)
        end
        PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("reset_talent_confirm"), nil, yesCallBack, nil)
    else

    end
end
--- @return void
--- @param data {type, id, setNumber, button1{name, callback}, button2{name, callback}, callbackReplace, info, input{number, min, max, onChangeInput}, moneyType}
function UIItemPreviewChildView:Show(data, uiItemPreviewViewview)
    self.config.localizeReplace.text = LanguageUtils.LocalizeCommon("replace")
    local color = UIUtils.color_rarity_1
    self.type = data.type
    self.uiItemPreviewViewview = uiItemPreviewViewview
    self.id = data.id
    self.class = data.class
    self.faction = data.faction
    self.heroId = data.heroId
    self.setNumber = data.setNumber or 0
    self.rate = data.rate
    self.slotEquipmentType = data.slotEquipmentType
    ---@type boolean
    local inventoryId = data.talentReset
    local showTalent = inventoryId ~= nil

    if self.type == ResourceType.ItemEquip
            or self.type == ResourceType.ItemStone
            or self.type == ResourceType.ItemArtifact
    --or self.type == ResourceType.Talent
    then
        self:InitButton()
        self:SortByFaction()
        self:ShowFactionFilterBuff()
        self:ShowFactionFilterIcon()
        self.config.factionStatTitle.text = LanguageUtils.LocalizeCommon("show_more_information")
        self.config.factionSelect.gameObject:SetActive(false)
    end

    self.config.talentRoot.gameObject:SetActive(showTalent)
    self.config.textContent.gameObject:SetActive(true)

    if (showTalent) then
        ---@type ItemsTableView
        self.moneyCostTableView = ItemsTableView(self.config.moneyCostBarAnchor, nil, UIPoolType.MoneyCostBarView)

        self.talentConfigList = ResourceMgr.GetHeroRefreshTalentConfig():GetTalentConfigListBySlotEquipment(self.slotEquipmentType)
        local listResetMoneyCost = List()
        --- @param talentConfig TalentConfig
        for _, talentConfig in ipairs(self.talentConfigList:GetItems()) do
            listResetMoneyCost:Add(talentConfig.resetMoneyData:GetRewardInbound())
        end

        self.moneyCostTableView:SetData(RewardInBound.GetItemIconDataList(listResetMoneyCost))

        self.config.btnRefreshTalent.onClick:RemoveAllListeners()
        self.config.btnRefreshTalent.interactable = true
        self.config.btnRefreshTalent.onClick:AddListener(function()
            self.coroutine = Coroutine.start(function()
                self:OnClickResetTalentBtn(inventoryId, data.callbackConfirmReset, self.slotEquipmentType)
                self.config.btnRefreshTalent.interactable = false
                coroutine.waitforseconds(0.5)
                self.config.btnRefreshTalent.interactable = true
            end)
        end)
        self.config.txtTalentReset.text = LanguageUtils.LocalizeCommon("reset_talent")
    end
    if data.moneyType ~= nil then
        self.config.moneyBarInfo.parent.gameObject:SetActive(true)
        self:SetMoneyBar(data.moneyType)
    else
        self.config.moneyBarInfo.parent.gameObject:SetActive(false)
    end
    if data.input ~= nil then
        self.config.input.parent.gameObject:SetActive(true)
        self:SetDataInput(data.input)
    else
        self.config.input.parent.gameObject:SetActive(false)
    end
    if self.rate ~= nil then
        self.config.textRate.gameObject:SetActive(true)
        self.config.textRate.text = string.format(LanguageUtils.LocalizeCommon("rate_x"), self.rate * 100)
    else
        self.config.textRate.gameObject:SetActive(false)
    end
    self.iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.itemEquipInfo)
    self.iconView:SetIconData(ItemIconData.CreateInstance(self.type, self.id))

    self.config.textSkillName.text = LanguageUtils.GetStringResourceName(self.type, self.id)
    self.config.textActiveSkill.text = LanguageUtils.GetStringResourceType(self.type, self.id)

    if self.type == ResourceType.Skin then
        local heroId = self.heroId
        if not heroId and self.id then
            heroId = ClientConfigUtils.GetHeroIdBySkinId(self.id)
        end
        if heroId then
            self.config.textActiveSkill.text = UIUtils.SetColorString(UIUtils.Cement1, LanguageUtils.LocalizeNameHero(heroId))
        end
    end

    for i = 1, self.config.textContent.childCount - 1 do
        self.config.textContent:GetChild(i).gameObject:SetActive(false)
    end
    if self.type == ResourceType.Talent and self.id / ClientItemConstants.TALENT_2_DEFINE >= 1 then
        local localizeTalentBuff = LanguageUtils.LocalizePassiveTalentBuff(ResourceMgr.GetServiceConfig():GetItemData(ResourceType.Talent, self.id))
        self.config.textContent:GetChild(0):GetComponent(ComponentName.UnityEngine_UI_Text).text = localizeTalentBuff
        local rarity = ResourceMgr.GetServiceConfig():GetItemRarity(data.type, data.id)
        color = UIUtils.GetColorRarity(rarity)
    elseif self.type == ResourceType.ItemEquip
            or self.type == ResourceType.ItemStone
            or self.type == ResourceType.ItemArtifact
            or self.type == ResourceType.Skin
            or self.type == ResourceType.Talent
    then
        LanguageUtils.SetDescriptionItemData(self.config.textContent, self.type, self.id, self.faction, self.class, self.heroId, self.setNumber)
        local rarity = ResourceMgr.GetServiceConfig():GetItemRarity(data.type, data.id)
        color = UIUtils.GetColorRarity(rarity)
    elseif self.type == ResourceType.Avatar then
        local avatarItemConfig = ResourceMgr.GetAvatarConfig():GetAvatarItemConfig(self.id)
        ---@type UnityEngine_UI_Text
        local textContent = self.config.textContent:GetChild(0):GetComponent(ComponentName.UnityEngine_UI_Text)
        if avatarItemConfig ~= nil and avatarItemConfig.timeDuration > 0 then
            textContent.text = string.format(LanguageUtils.LocalizeCommon("expire_in_s"),
                    string.format("%s %s", avatarItemConfig.timeDuration, LanguageUtils.LocalizeCommon("day")))
        else
            textContent.text = ""
        end
    else
        ---@type UnityEngine_UI_Text
        local textContent = self.config.textContent:GetChild(0):GetComponent(ComponentName.UnityEngine_UI_Text)
        textContent.gameObject:SetActive(true)
        textContent.text = LanguageUtils.GetStringResourceInfo(self.type, self.id)
    end
    if self.type == ResourceType.Talent then
        self.iconView:ActiveBorderTalent(true)
    end
    if (self.type == ResourceType.AvatarFrame) then
        local showText = (data.border ~= nil and data.border > 0)
        self.config.textContent.gameObject:SetActive(showText)
        if (showText) then
            local textContent = self.config.textContent:GetChild(0):GetComponent(ComponentName.UnityEngine_UI_Text)
            textContent.text = string.format(LanguageUtils.LocalizeCommon("expire_in_s"),
                    string.format("%s %s", data.border, LanguageUtils.LocalizeCommon("day")))
        end
    end
    self.buttonData1 = data.button1
    self.buttonData2 = data.button2

    if self.buttonData1 == nil and self.buttonData2 == nil then
        self.config.button.gameObject:SetActive(false)
    else
        self.config.button.gameObject:SetActive(true)
        self:_SetDataButton(self.buttonData1, self.config.button1)
        self:_SetDataButton(self.buttonData2, self.config.button2)
    end

    if data.callbackReplace == nil then
        self.config.buttonReplace.gameObject:SetActive(false)
    else
        self.config.buttonReplace.gameObject:SetActive(true)
        self.config.buttonReplace.onClick:RemoveAllListeners()
        self.config.buttonReplace.onClick:AddListener(function()
            data.callbackReplace()
        end)
    end
    Coroutine.start(function()
        coroutine.waitforendofframe()
        self.config.bgFilterPanel.enabled = false
        self.config.bgFilterPanel.enabled = true
        coroutine.waitforendofframe()
        self.config.bgFilterPanel.enabled = false
        self.config.bgFilterPanel.enabled = true
    end)
end

--- @return void
---@param input {number, min, max, onChangeInput}
function UIItemPreviewChildView:SetDataInput(input)
    if self.inputView == nil then
        self.inputView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.InputNumberView, self.config.input)
        local changeInput = function(value)
            if input.onChangeInput ~= nil then
                input.onChangeInput(value, self.moneyBarView)
            end
        end
        self.inputView.onChangeInput = changeInput
    end
    self.inputView:SetData(input.number, input.min, input.max)
end

--- @return void
function UIItemPreviewChildView:SetMoneyBar(moneyType)
    self.moneyBarView:SetIconData(moneyType)
end

--- @return void
--- @param data {name, callback}
--- @param button UnityEngine_UI_Button
function UIItemPreviewChildView:_SetDataButton(data, button)
    if data == nil then
        button.gameObject:SetActive(false)
    else
        button.gameObject:SetActive(true)
        ---@type UnityEngine_UI_Text
        local text = button.transform:GetChild(0):GetComponent(ComponentName.UnityEngine_UI_Text)
        if text ~= nil and data.name ~= nil then
            text.text = data.name
        end
        button.onClick:RemoveAllListeners()
        if data.callback ~= nil then
            button.onClick:AddListener(function()
                data.callback()
                zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
            end)
        end
    end
end

function UIItemPreviewChildView:InitButton()
    self.config.buttonCloseFaction.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_CLOSE)
        self:HideFactionBuffPopup()
    end)
    self.config.bgCloseFaction.onClick:AddListener(function()
        self:HideFactionBuffPopup()
    end)
end

function UIItemPreviewChildView:SortByFaction()
    --- @param obj UnityEngine_UI_Button
    --- @param isSelect boolean
    local onSelectFaction = function(obj, isSelect)
        if obj ~= nil then
            --UIUtils.SetInteractableButton(obj, not isSelect)
            if isSelect then
                self.config.factionSelect.gameObject:SetActive(true)
                self.config.factionSelect.transform:SetParent(obj.transform)
                self.config.factionSelect.transform.localPosition = U_Vector3.zero
            end
        end
    end
    local onChangeSelectFaction = function(indexTab, lastTab)

    end
    local onClickSelectFaction = function(indexTab)
        self:ShowPopupFactionBuff(indexTab - 1)
    end
    self.factionFilter = UISelectFactionFilter(self.config.factionFilter,
            nil, onSelectFaction, onChangeSelectFaction,
            onClickSelectFaction)
    self.factionFilter:SetSprite()
end

--- @return void
function UIItemPreviewChildView:ShowPopupFactionBuff(id)
    if self.setFactionBuff then
        self.config.factionStatPopup:SetActive(true)
        self.config.bgCloseFaction.gameObject:SetActive(true)
        local text = ""
        ---@param v Dictionary
        for k, v in pairs(self.setFactionBuff:GetItems()) do
            local color = UIUtils.color5
            if self.setNumber >= k then
                color = UIUtils.green_light
            end
            text = UIUtils.SetColorString(color, string.format("%s\n(%s / %s)", text, self.setNumber, k))
            color = UIUtils.color5
            if self.setNumber >= k and self.faction == id then
                color = UIUtils.green_light
            elseif self.setNumber >= k then
                color = UIUtils.white
            end
            text = UIUtils.SetColorString(color, string.format("%s\n%s\n", text, v:Get(id)))
        end
        self.config.factionStatText.text = text
    end
end

function UIItemPreviewChildView:ShowFactionFilterBuff()
    ---@type {itemData}
    local itemData = ResourceMgr.GetServiceConfig():GetItemData(self.type, self.id)
    if itemData and itemData.optionList then
        local setFactionBuff = LanguageUtils.GetDescriptionSetItemByFaction(itemData, self.faction, self.class, self.setNumber)
        if setFactionBuff:Count() == 0 then
            self.config.factionStat:SetActive(false)
        else
            self.setFactionBuff = setFactionBuff
            self.maxSet = 0
            for k, _ in pairs(self.setFactionBuff:GetItems()) do
                if k > self.maxSet then
                    self.maxSet = k
                end
            end
            self.config.factionStat:SetActive(true)
        end
    end
end

--- @return void
function UIItemPreviewChildView:HideFactionFilterBuff()
    self.config.factionStat:SetActive(false)
end

function UIItemPreviewChildView:HideFactionBuffPopup()
    self.config.factionStatPopup:SetActive(false)
    self.config.factionSelect.gameObject:SetActive(false)
    self.config.bgCloseFaction.gameObject:SetActive(false)
end

--- @return void
function UIItemPreviewChildView:ShowFactionFilterIcon()
    if not self.setFactionBuff or self.setFactionBuff:Count() == 0 then
        return
    end
    self:HideFactionFilterIcon()
    ---@param v Dictionary
    for _, v in pairs(self.setFactionBuff:GetItems()) do
        for i, k in pairs(v:GetItems()) do
            if not self.config.factionFilter:GetChild(i).gameObject.active then
                self.config.factionFilter:GetChild(i).gameObject:SetActive(true)
            end
        end
    end
end

--- @return void
function UIItemPreviewChildView:HideFactionFilterIcon()
    if not self.setFactionBuff or self.setFactionBuff:Count() == 0 then
        return
    end
    local count = self.config.factionFilter.childCount
    if count > 0 then
        for i = 1, count do
            if self.config.factionFilter:GetChild(i - 1) then
                self.config.factionFilter:GetChild(i - 1).gameObject:SetActive(false)
            end
        end
    end
end

--- @return void
function UIItemPreviewChildView:Hide()
    if self.type == ResourceType.ItemEquip then
        self.setFactionBuff:Clear()
        self:HideFactionFilterBuff()
        self:HideFactionFilterIcon()
        self:HideFactionBuffPopup()
        self.config.buttonCloseFaction.onClick:RemoveAllListeners()
        self.config.bgCloseFaction.onClick:RemoveAllListeners()
    end
    self:_ReturnPoolIconView()
    self.config.button1.onClick:RemoveAllListeners()
    self.config.button2.onClick:RemoveAllListeners()
    if self.inputView ~= nil then
        self.inputView:ReturnPool()
        self.inputView = nil
    end
    ClientConfigUtils.KillCoroutine(self.coroutine)
    if self.moneyCostTableView ~= nil then
        self.moneyCostTableView:Hide()
        self.moneyCostTableView = nil
    end
end

--- @return void
function UIItemPreviewChildView:_ReturnPoolIconView()
    if self.iconView ~= nil then
        --XDebug.Log("_ReturnPoolIconView" .. LogUtils.ToDetail(self.iconView.iconData))
        self.iconView:ReturnPool()
        self.iconView = nil
        --XDebug.Log("UIItemPreviewChildView:_ReturnPoolIconView")
    end
end
