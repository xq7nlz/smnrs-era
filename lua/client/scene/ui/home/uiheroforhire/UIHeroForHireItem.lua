require "lua.client.scene.ui.home.uiHeroForHire.HeroForHireOutBound"

--- @class UIHeroForHireItem : MotionIconView
UIHeroForHireItem = Class(UIHeroForHireItem, MotionIconView)

--- @return void
function UIHeroForHireItem:Ctor(transform)
    ---@type HeroForHireItemConfig
    self.config = nil

    self.inventoryId = nil
    self.heroLinkingTierConfig = ResourceMgr.GetHeroLinkingTierConfig()
    MotionIconView.Ctor(self, transform)
    self:InitButtons()
    self:InitLocalization()

end

--- @return void
function UIHeroForHireItem:SetPrefabName()
    self.prefabName = 'hero_for_hire_item'
    self.uiPoolType = UIPoolType.HeroForHireItem
end

--- @return void
--- @param transform UnityEngine_Transform
function UIHeroForHireItem:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    self.config = UIBaseConfig(transform)
end

--- @return void
function UIHeroForHireItem:InitLocalization()
    self.config.describeTxt.text = LanguageUtils.LocalizeCommon("describe_hero_for_hire")
    self.config.textRemove.text = LanguageUtils.LocalizeCommon("remove")
end

function UIHeroForHireItem:InitButtons()
    self.config.pickHeroBtn.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickPickHero()
    end)
    self.config.removeBtn.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickRemove()
    end)
end

function UIHeroForHireItem:SetupCallBackAndDataList(addHeroSupport, removeHeroSupport, dataList)
    self.addHeroSupport = addHeroSupport
    self.removeHeroSupport = removeHeroSupport
    self.dataList = dataList
end

function UIHeroForHireItem:UpdateText()
    if self.inventoryId ~= nil and self.inventoryId > 1000 then
        ---@type HeroResource
        local heroSource = InventoryUtils.GetHeroResourceByInventoryId(self.inventoryId)
        self.config.heroNameTxt.text = LanguageUtils.LocalizeNameHero(heroSource.heroId)
        self.config.starTxt.text = string.format("%s-%s", heroSource.heroStar, LanguageUtils.LocalizeCommon("star_hero"))
    end
end

function UIHeroForHireItem:UpdateIconHero(inventoryId)
    self:KillTween()
    ---@type SupportHeroData
    self.supportData = zg.playerData:GetMethod(PlayerDataMethod.FRIEND):GetSupportHeroWithInventoryId(self.inventoryId)
    if inventoryId ~= nil and inventoryId > 1000 then
        ---@type HeroIconView
        self.heroIcon = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.HeroIconView, self.config.heroIconAnchor)
        self.heroIcon:SetIconData(HeroIconData.CreateByHeroResource(InventoryUtils.GetHeroResourceByInventoryId(inventoryId)))
        self.inventoryId = inventoryId
        self.config.heroIconAnchor.gameObject:SetActive(true)
        self.config.removeBtn.gameObject:SetActive(true)
        self.config.pickHeroBtn.gameObject:SetActive(false)
        self:UpdateText()
    else
        self.config.heroIconAnchor.gameObject:SetActive(false)
        self.config.removeBtn.gameObject:SetActive(false)
        self.config.pickHeroBtn.gameObject:SetActive(true)
    end
    self:UpdateTime()
end

function UIHeroForHireItem:OnClickPickHero()
    local data = {}
    data.addHero = function(inventoryId, onSuccess)
        self:AddHeroSupport(inventoryId, onSuccess)
    end
    data.dataList = self.dataList
    PopupMgr.ShowPopup(UIPopupName.UILinkingSelectHero, data)
end

function UIHeroForHireItem:OnClickRemove()
    self.supportData = zg.playerData:GetMethod(PlayerDataMethod.FRIEND):GetSupportHeroWithInventoryId(self.inventoryId)
    if self.supportData ~= nil and self.supportData:IsCanRemove(self.heroLinkingTierConfig.intervalTime) then
        local onSuccess = function()
            if self.inventoryId ~= nil then
                self.removeHeroSupport(self.inventoryId)
            end
            self:UpdateIconHero()
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("remove_hire_success"))
        end

        local onFail = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
        end
        self:OnRequestRemoveHero(onSuccess, onFail)
    else
        SmartPoolUtils.ShowShortNotification(self.supportData:GetTimeLocalize(self.heroLinkingTierConfig.intervalTime))
    end
end

function UIHeroForHireItem:AddHeroSupport(inventoryId, onSuccess)
    local onSuccess = function()
        if self.inventoryId ~= nil then
            self.removeHeroSupport(self.inventoryId)
        end
        self.addHeroSupport(inventoryId)
        self:UpdateIconHero(inventoryId)
        self:UpdateText()
        if onSuccess ~= nil then
            onSuccess()
        end
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("hire_success"))
    end

    local onFail = function(logicCode)
        SmartPoolUtils.LogicCodeNotification(logicCode)
    end
    local fakeList = List()
    for i = 1, self.dataList:Count() do
        ---@type SupportHeroData
        local data = self.dataList:Get(i)
        if self.inventoryId ~= nil and self.inventoryId == data.inventoryId then
        else
            fakeList:Add(data.inventoryId)
        end
    end
    fakeList:Add(inventoryId)
    local outbound = HeroForHireOutBound()
    outbound.dataList = fakeList
    NetworkUtils.RequestAndCallback(OpCode.HERO_LINKING_SUPPORT_HERO_SAVE, outbound, onSuccess, onFail)
end

function UIHeroForHireItem:OnRequestRemoveHero(onSuccess, onFail)
    local fakeList = List()
    for i = 1, self.dataList:Count() do
        ---@type SupportHeroData
        local data = self.dataList:Get(i)
        if self.inventoryId ~= nil and self.inventoryId == data.inventoryId then
        else
            fakeList:Add(data.inventoryId)
        end
    end
    local outbound = HeroForHireOutBound()
    outbound.dataList = fakeList
    NetworkUtils.RequestAndCallback(OpCode.HERO_LINKING_SUPPORT_HERO_SAVE, outbound, onSuccess, onFail)
end

function UIHeroForHireItem:UpdateTime()
    if self.inventoryId ~= nil then
        self.supportData = zg.playerData:GetMethod(PlayerDataMethod.FRIEND):GetSupportHeroWithInventoryId(self.inventoryId)
        if self.supportData ~= nil then
            self.updateTimeCoroutine = Coroutine.start(function()
                while self.supportData:IsCanRemove(self.heroLinkingTierConfig.intervalTime) do
                    coroutine.waitforseconds(1)
                    self.supportData.registerTime = self.supportData.registerTime - 1
                end
            end)
        end
    end
end
function UIHeroForHireItem:KillTween()
    if self.updateTimeCoroutine ~= nil then
        Coroutine.stop(self.updateTimeCoroutine)
        self.updateTimeCoroutine = nil
    end
end
return UIHeroForHireItem