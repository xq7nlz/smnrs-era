--- @class UIIdleEffect
UIIdleEffect = Class(UIIdleEffect)

--- @return void
--- @param transform UnityEngine_Transform
function UIIdleEffect:Ctor(transform, model, heroMenu2View)
    --- @type UIHeroMenu2Model
    self.model = model
    --- @type UIHeroMenu2View
    self.heroMenuView = heroMenu2View
    ---@type UIIdleEffectConfig
    self.config = UIBaseConfig(transform)
    ---@type List
    self.listIdleEffectData = List()
    self:InitButton()
    ---@type EquipItemOutBound
    self.equipItemOutBound = EquipItemOutBound()
    --- @type HeroResource
    self.heroResource = nil
    --- @type List
    self.listItem = List()
    --- @type MoneyIconView
    self.currentIdleEffectView = nil
    --- @type MoneyIconView
    self.lastItemEquip = nil
    --- @type number
    self.index = 1
    --- @type boolean
    self.enablePreview = false
    self:InitScroll()
end


function UIIdleEffect:InitButton()
    self.config.buttonHelp.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickHelp()
    end)
    self.config.buttonEquip.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickEquip()
    end)
    self.config.buttonUnequip.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickUnEquip()
    end)
end


function UIIdleEffect:InitScroll()
    ----- @param obj IdleEffectInfo
    local onCreateItem = function(obj, index)
        index = index + 1
        local type = ResourceType.IDLE_EFFECT
        --- @type {idleEffectId, number}
        local idleEffectData = self.listIdleEffectData:Get(index)
        local id = idleEffectData.idleEffectId
        local number = idleEffectData.number
        local seen = false
        if zg.playerData.remoteConfig.listSeenIdleEffect == nil then
            zg.playerData.remoteConfig.listSeenIdleEffect = {}
            zg.playerData:SaveRemoteConfig()
        end
        for k, v in pairs(zg.playerData.remoteConfig.listSeenIdleEffect) do
            if v == id then
                seen = true
                break
            end
        end
        obj.index = index
        obj:EnableButton(true)
        obj:SetIconData(ItemIconData.CreateInstance(type, id, number))
        obj:SetNew(not seen)
        obj:RemoveAllListeners()
        obj:AddListener(function()
            self:UnChoosenItem()
            if zg.playerData.remoteConfig.listSeenIdleEffect ~= nil then
                local length = 0
                local constants = false
                for k, v in pairs(zg.playerData.remoteConfig.listSeenIdleEffect) do
                    if v == id then
                        constants =true
                        break
                    end
                    length = length + 1
                end
                if not constants then
                    zg.playerData.remoteConfig.listSeenIdleEffect[tostring(length+1)] = id
                    zg.playerData:SaveRemoteConfig()
                    obj:SetNew(false)
                end
            end
            self:UpdatePreviewIdleEffect(obj)
            obj:SetChoosen(true)
        end)
        self.listItem:Add(obj)
    end
    ---@type UILoopScroll
    self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.IdleEffectInfo, onCreateItem)
end

function UIIdleEffect:UnChoosenItem()
    for i = 1,  self.listItem:Count() do
        self.listItem:Get(i):SetChoosen(false)
    end
end

--- @return void
function UIIdleEffect:InitLocalization()
    self.config.textEquip.text = LanguageUtils.LocalizeCommon("equip")
    self.config.textDisable.text = LanguageUtils.LocalizeCommon("equip")
    self.config.textPreview.text = LanguageUtils.LocalizeCommon("preview")
    self.config.textUnequip.text = LanguageUtils.LocalizeCommon("unequip")
    self.config.textBuy.text = LanguageUtils.LocalizeCommon("buy")
    self.config.listIdleEffectText.text = LanguageUtils.LocalizeCommon("list_idle_effect")
    self.config.empty.text = LanguageUtils.LocalizeCommon("empty_2")
end

--- @return void
function UIIdleEffect:InitUI()
    self.listItem:Clear()
    self.heroResource = self.model.heroResource:Clone()
    local  dictIdleEffectData = zg.playerData:GetInventoryData():Get(ResourceType.IDLE_EFFECT)
    self.listIdleEffectData = List()

    for k,v in pairs(dictIdleEffectData:GetItems()) do
        if v > 0 then
            local idleEffectData = {}
            idleEffectData.idleEffectId = k
            idleEffectData.number = v
            self.listIdleEffectData:Add(idleEffectData)
        end
    end
    self.uiScroll:Resize(self.listIdleEffectData:Count())
    if self.listIdleEffectData:Count() == 0 then
        self.config.empty.gameObject:SetActive(true)
        self.currentIdleEffectView = nil
    else
        if self.currentIdleEffectView ~= nil then
            if self.currentIdleEffectView.iconData.quantity < 1 then
                self.listItem:RemoveByIndex(self.currentIdleEffectView.index)
                if self.listItem:Count() > 0 then
                    self.currentIdleEffectView = self.listItem:Get(1)
                    --self.currentIdleEffectView:SetChoosen(true)
                end
            end
        else
            if self.listItem:Count() > 0 then
                self.currentIdleEffectView = self.listItem:Get(1)
                --self.currentIdleEffectView:SetChoosen(true)
            end
        end
        self.config.empty.gameObject:SetActive(false)
    end
    if self.currentIdleEffectView ~= nil then
        self.currentIdleEffectView:SetChoosen(true)
    end
end

--- @return void
function UIIdleEffect:Show()
    self.config.heroName.text = LanguageUtils.LocalizeNameHero(self.model.heroResource.heroId)
    self.heroMenuView:SetButtonNextHero(self.config.buttonEquip.transform.position)
    self.uiScroll:Hide()
    self:InitUI()
    local updatePreview = function()
        self:CheckButton()
    end
    Coroutine.start(function()
        coroutine.waitforendofframe()
        self:UpdateUI()
        updatePreview()
    end)
end



--- @return void
function UIIdleEffect:OnChangeHero()
    self.config.heroName.text = LanguageUtils.LocalizeNameHero(self.model.heroResource.heroId)
    self.heroMenuView:SetButtonNextHero(self.config.buttonEquip.transform.position)
    self:InitUI()
    Coroutine.start(function()
        coroutine.waitforendofframe()
        self:CheckButton()
    end)
end

--- @return void
function UIIdleEffect:StopCoroutine()
    if self.coroutine ~= nil then
        Coroutine.stop(self.coroutine)
        self.coroutine = nil
    end
end

--- @return void
function UIIdleEffect:ReturnPoolIdleEffectItem()
    ---@param v MoneyIconView
    for _, v in ipairs(self.listItem:GetItems()) do
        v:ReturnPool()
    end
    self.listItem:Clear()
end

--- @return void
function UIIdleEffect:Hide()
    self:StopCoroutine()
    self.uiScroll:Hide()
    self.currentIdleEffectView = nil
    if self.heroMenuView ~= nil and self.heroMenuView.previewHeroMenu ~= nil then
        self.heroMenuView.previewHeroMenu:PreviewHero(self.model.heroResource, HeroModelType.Basic)
    end
end

--- @return void
function UIIdleEffect:UpdateUI()
    -----@param v SkinCardView
    --for i, v in ipairs(self.listItem:GetItems()) do
    --    v.config.transform:GetChild(0).localScale = U_Vector3.one * math.max(0.7, 1 - math.abs(v.config.transform.position.x - self.config.content.parent.position.x) / 10)
    --end
    --self.config.layout.enabled = false
    --self.config.layout.enabled = true
end


--- @return void
function UIIdleEffect:CheckButton()
    self.heroResource = self.model.heroResource:Clone()
    self.config.buttonBuy.gameObject:SetActive(false)
    self.config.buttonEquip.gameObject:SetActive(false)
    self.config.buttonUnequip.gameObject:SetActive(false)
    self.config.buttonPreviewSkin.gameObject:SetActive(false)
    self.config.buttonHideSkin.gameObject:SetActive(false)
    self.config.disablebutton.gameObject:SetActive(false)
    local currentEquippedIdleEffect = self.heroResource.heroItem:Get(HeroItemSlot.IDLE_EFFECT)
    if  self.currentIdleEffectView ~= nil   then
        if self.currentIdleEffectView.iconData.quantity > 0 then
            if currentEquippedIdleEffect ~= nil then
                 self.config.buttonUnequip.gameObject:SetActive(true)
            else
                self.config.buttonEquip.gameObject:SetActive(true)
            end
        end
        --if self.currentIdleEffectView.iconData.itemId == currentEquippedIdleEffect then

        --self.config.nameSkin.text = LanguageUtils.LocalizeIdleEffect(self.currentIdleEffectView.iconData.itemId)
    else
        if currentEquippedIdleEffect ~= nil then
            self.config.buttonUnequip.gameObject:SetActive(true)
        else
            self.config.disablebutton.gameObject:SetActive(true)
        end
    end
    self.config.nameSkin.text = LanguageUtils.LocalizeNameHero(self.heroResource.heroId)
end
--- @param moneyIcon MoneyIconView
function UIIdleEffect:UpdatePreviewIdleEffect(moneyIcon)
    self.currentIdleEffectView = moneyIcon
    self:CheckButton()
    --self.config.tickPreview:SetActive(self.enablePreview)
    --
    --if self.enablePreview then
    --    self.heroResource.heroItem:Add(HeroItemSlot.IDLE_EFFECT, self.effectId)
    --    self.heroResource.isHideSkin = false
    --else
    --    self.heroResource.heroItem:RemoveByKey(HeroItemSlot.IDLE_EFFECT)
    --end
    --self.heroMenuView.previewHeroMenu:PreviewHero(self.heroResource, HeroModelType.Basic)
end

function UIIdleEffect:OnClickEquip()
    if self.currentIdleEffectView.iconData.itemId ~= nil and self.currentIdleEffectView.iconData.itemId > 0 then                                        -- EQUIP
        print(" self.currentIdleEffectView :" ..  self.currentIdleEffectView.iconData.itemId)
        self.equipItemOutBound.listData:Add(
                EquipItemRecordOutBound(self.model.heroResource.inventoryId, 8,
                        self.currentIdleEffectView.iconData.itemId))
    end
    NetworkUtils.RequestAndCallback(OpCode.ITEM_EQUIP,self.equipItemOutBound
           ,
            function()
                local lastEquip = self.model.heroResource.heroItem:Get(HeroItemSlot.IDLE_EFFECT)
                if lastEquip ~= nil then
                    InventoryUtils.Add(ResourceType.IDLE_EFFECT, lastEquip, 1)
                end
                self.model.heroResource.heroItem:Add(HeroItemSlot.IDLE_EFFECT,
                        self.currentIdleEffectView.iconData.itemId)
                InventoryUtils.Sub(ResourceType.IDLE_EFFECT, self.currentIdleEffectView.iconData.itemId, 1)
                self:InitUI()
                self:CheckButton()
                self.heroMenuView.previewHeroMenu:PreviewHero(self.heroResource, HeroModelType.Basic)
                self.equipItemOutBound.listData:Clear()
            end, SmartPoolUtils.LogicCodeNotification, nil, true)
end

function UIIdleEffect:OnClickUnEquip()
    if self.currentIdleEffectView ~= nil then
        if self.currentIdleEffectView.iconData.itemId ~= nil and self.currentIdleEffectView.iconData.itemId > 0 then                                        -- EQUIP
            self.equipItemOutBound.listData:Add(
                    EquipItemRecordOutBound(self.model.heroResource.inventoryId, 8, -1))
        end
    else
        self.equipItemOutBound.listData:Add(
                EquipItemRecordOutBound(self.model.heroResource.inventoryId, 8, -1))
    end

    local lastEquip = self.model.heroResource.heroItem:Get(HeroItemSlot.IDLE_EFFECT)
    NetworkUtils.RequestAndCallback(OpCode.ITEM_EQUIP,
            self.equipItemOutBound,
            function()
                if lastEquip ~= nil and lastEquip ~= -1 then
                    self.model.heroResource.heroItem:RemoveByKey(HeroItemSlot.IDLE_EFFECT)
                    InventoryUtils.Add(ResourceType.IDLE_EFFECT, lastEquip, 1)
                end
                self:InitUI()
                self:CheckButton()
                self.equipItemOutBound.listData:Clear()
                self.heroMenuView.previewHeroMenu:PreviewHero(self.heroResource, HeroModelType.Basic)
            end, SmartPoolUtils.LogicCodeNotification, nil, true)
end


function UIIdleEffect:OnClickHelp()
    local info = LanguageUtils.LocalizeHelpInfo("help_idle_effect")
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, info)
end
