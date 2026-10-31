--- @class UIItemPreviewChildFastForgeView
UIItemPreviewChildFastForgeView = Class(UIItemPreviewChildFastForgeView)

--- @return void
--- @param transform UnityEngine_Transform
function UIItemPreviewChildFastForgeView:Ctor(transform)
    ---@type UIItemPreviewChildFastForgeConfig
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
    ---@type Dictionary
    self.setFactionBuff = Dictionary()
end

--- @return void
--- @param data {type, id, setNumber, button1{name, callback}, button2{name, callback}, callbackReplace, info, input{number, min, max, onChangeInput}, moneyType}
function UIItemPreviewChildFastForgeView:Show(data)
    local color = UIUtils.color_rarity_1
    self.type = data.type
    self.id = data.id
    self.class = data.class
    self.faction = data.faction
    self.setNumber = data.setNumber or 0
    self.rate = data.rate
    if self.rate ~= nil then
        self.config.textRate.gameObject:SetActive(true)
        self.config.textRate.text = string.format(LanguageUtils.LocalizeCommon("rate_x"), self.rate * 100)
    else
        self.config.textRate.gameObject:SetActive(false)
    end

    self:InitButton()
    self:SortByFaction()
    self:ShowFactionFilterBuff()
    self:ShowFactionFilterIcon()
    self.config.factionStatTitle.text = LanguageUtils.LocalizeCommon("show_more_information")
    self.config.factionSelect.gameObject:SetActive(false)

    self.iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.itemEquipInfo)
    self.iconView:SetIconData(ItemIconData.CreateInstance(self.type, self.id))

    self.config.textSkillName.text = LanguageUtils.GetStringResourceName(self.type, self.id)
    self.config.textActiveSkill.text = LanguageUtils.GetStringResourceType(self.type, self.id)
    --for i = 1, self.config.textContent.childCount - 1 do
    --    self.config.textContent:GetChild(i).gameObject:SetActive(false)
    --end
    local textContent = self.config.textContent:GetChild(0):GetComponent(ComponentName.UnityEngine_UI_Text)
    if self.type == ResourceType.ItemEquip
            or self.type == ResourceType.ItemStone
            or self.type == ResourceType.ItemArtifact
            or self.type == ResourceType.Skin
            or self.type == ResourceType.Talent then
        LanguageUtils.SetDescriptionItemData(self.config.textContent, self.type, self.id, self.faction, self.class, self.heroId, self.setNumber)
        local rarity = ResourceMgr.GetServiceConfig():GetItemRarity(data.type, data.id)
        color = UIUtils.GetColorRarity(rarity)
        textContent.gameObject:SetActive(false)
        Coroutine.start(function()
            coroutine.waitforendofframe()
            textContent.gameObject:SetActive(true)
        end)
        --self.config.textSkillName.text = string.format("<color=#%s>%s</color>", color, self.config.textSkillName.text)
        --self.config.textActiveSkill.text = string.format("<color=#%s>%s</color>", color, self.config.textActiveSkill.text)
    else
        ---@type UnityEngine_UI_Text
        textContent.text = LanguageUtils.GetStringResourceInfo(self.type, self.id)
    end
    self.config.textContent.gameObject:SetActive(true)
end

function UIItemPreviewChildFastForgeView:InitButton()
    self.config.buttonCloseFaction.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_CLOSE)
        self:HideFactionBuffPopup()
    end)
    self.config.bgCloseFaction.onClick:AddListener(function()
        self:HideFactionBuffPopup()
    end)
end

function UIItemPreviewChildFastForgeView:SortByFaction()
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
function UIItemPreviewChildFastForgeView:ShowPopupFactionBuff(id)
    if self.setFactionBuff then
        self.config.factionStatPopup:SetActive(true)
        self.config.bgCloseFaction.gameObject:SetActive(true)
        local maxSet = 0
        local text = ""
        ---@param v Dictionary
        for k, v in pairs(self.setFactionBuff:GetItems()) do
            local color = UIUtils.white
            if self.setNumber >= k then
                color = UIUtils.green_light
            end
            text = UIUtils.SetColorString(color, string.format("%s\n(%s / %s)", text, self.setNumber, k))
            color = UIUtils.white
            if self.setNumber >= k and self.faction == id then
                color = UIUtils.green_light
            end
            text = UIUtils.SetColorString(color, string.format("%s\n%s\n", text, v:Get(id)))
        end
        self.config.factionStatText.text = text
    end
end

function UIItemPreviewChildFastForgeView:ShowFactionFilterBuff()
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
function UIItemPreviewChildFastForgeView:HideFactionFilterBuff()
    self.config.factionStat:SetActive(false)
end

function UIItemPreviewChildFastForgeView:HideFactionBuffPopup()
    self.config.factionStatPopup:SetActive(false)
    self.config.factionSelect.gameObject:SetActive(false)
    self.config.bgCloseFaction.gameObject:SetActive(false)
end

--- @return void
function UIItemPreviewChildFastForgeView:ShowFactionFilterIcon()
    if not self.setFactionBuff or self.setFactionBuff:Count() == 0 then
        return
    end
    self:HideFactionFilterIcon()
    for _, v in pairs(self.setFactionBuff:GetItems()) do
        for i, k in pairs(v:GetItems()) do
            if not self.config.factionFilter:GetChild(i).gameObject.active then
                self.config.factionFilter:GetChild(i).gameObject:SetActive(true)
            end
        end
    end
end

--- @return void
function UIItemPreviewChildFastForgeView:HideFactionFilterIcon()
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
function UIItemPreviewChildFastForgeView:Hide()
    self.setFactionBuff:Clear()
    self:HideFactionFilterBuff()
    self:HideFactionFilterIcon()
    self:HideFactionBuffPopup()
    self.config.buttonCloseFaction.onClick:RemoveAllListeners()
    self.config.bgCloseFaction.onClick:RemoveAllListeners()
    self:_ReturnPoolIconView()
end

--- @return void
function UIItemPreviewChildFastForgeView:_ReturnPoolIconView()
    if self.iconView ~= nil then
        --XDebug.Log("_ReturnPoolIconView" .. LogUtils.ToDetail(self.iconView.iconData))
        self.iconView:ReturnPool()
        self.iconView = nil
        --XDebug.Log("UIItemPreviewChildFastForgeView:_ReturnPoolIconView")
    end
end