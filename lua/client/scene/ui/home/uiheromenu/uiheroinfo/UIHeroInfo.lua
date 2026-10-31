---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiHeroMenu.uiHeroInfo.UIHeroInfoConfig"
require "lua.client.scene.ui.common.prefabHeroInfo.PrefabHeroInfoView"

--- @class UIHeroInfo
UIHeroInfo = Class(UIHeroInfo)

--- @return void
--- @param transform UnityEngine_Transform
--- @param heroMenuView UIHeroMenuView
function UIHeroInfo:Ctor(transform, model, heroMenuView)
    --- @type UIHeroMenuModel
    self.model = model
    --- @type UIHeroMenuView
    self.heroMenuView = heroMenuView
    ---@type UIHeroInfoConfig
    self.config = UIBaseConfig(transform)
    ---@type PrefabHeroInfoView
    self.prefabHeroInfoView = PrefabHeroInfoView(self.config.prefabHeroInfo)
    ---@type HeroResource
    self.heroResource = nil
    ---@type number
    self.timeLevelUp = nil
    ---@type HeroLevelDataConfig
    self.heroLevelData = nil
    ---@type HeroLevelCapConfig
    self.heroLevelCap = nil

    self.config.buttonUpLv.onClick:AddListener(function ()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickLevelUp()
    end)
    self.config.buttonLvMax.onClick:AddListener(function ()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickMaxLevel()
    end)
    self.config.buttonEvolve.onClick:AddListener(function ()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickEvolve()
    end)

end

--- @return void
function UIHeroInfo:InitLocalization()
    self.config.localizeLvToMax.text = LanguageUtils.LocalizeCommon("level_to_max")
    self.config.localizeLvUp.text = LanguageUtils.LocalizeCommon("level_up")
    self.config.localizeEvolve.text = LanguageUtils.LocalizeCommon("evolve")
    self.config.localizeLevelMax.text = LanguageUtils.LocalizeCommon("hero_info_max_level")
end

--- @return void
function UIHeroInfo:Show()
    self:UpdateUI()
end

--- @return void
function UIHeroInfo:Hide()
    self:CheckRequestLevelUp()
    self.prefabHeroInfoView:OnDisable()
    PopupUtils.CheckAndHideSkillPreview()
end

--- @return void
function UIHeroInfo:CheckRequestLevelUp()
    if self.heroResource ~= nil then
        local callback = function(result)
            local onSuccess = function()

            end
            local onFailed = function(logicCode)
                SmartPoolUtils.LogicCodeNotification(logicCode)
            end
            NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
        end
        NetworkUtils.Request(OpCode.HERO_LEVEL_UP, UnknownOutBound.CreateInstance(PutMethod.Long, self.heroResource.inventoryId , PutMethod.Short, self.heroResource.heroLevel), callback)
        self.heroResource = nil
    end
end

--- @return void
function UIHeroInfo:DelayCheckRequestLevelUp()
    self.timeLevelUp = zg.timeMgr:GetServerTime()
    if self.up == nil then
        self.up = Coroutine.start(function ()
            while zg.timeMgr:GetServerTime() - self.timeLevelUp <= 1 do
                coroutine.waitforendofframe()
            end
            self:CheckRequestLevelUp()
            self.up = nil
        end)
    end
end

--- @return void
function UIHeroInfo:OnChangeHero()
    self:CheckRequestLevelUp()
    self:UpdateUI()
end

--- @return void
function UIHeroInfo:UpdateUI()
    ---@type HeroResource
    local heroResource = self.model.heroResource
    self.heroLevelData = ResourceMgr.GetHeroMenuConfig():GetHeroLevelDataDictionary(heroResource.heroLevel + 1)
    self.heroLevelCap = ResourceMgr.GetHeroMenuConfig():GetHeroLevelCapDictionary(heroResource.heroStar)
    self.config.textLevelCharacter.text = "Lv." .. tostring(heroResource.heroLevel) .. "/" .. tostring(self.heroLevelCap.levelCap)
    if self.heroLevelData ~= nil then
        self.config.textGold.text = ClientConfigUtils.FormatNumber(self.heroLevelData.gold)
        if self.heroLevelData.magicPotion > 0 then
            self.config.iconMagicPotion.sprite = ResourceLoadUtils.LoadMoneyIcon(MoneyType.MAGIC_POTION)
            self.config.textGem.text = ClientConfigUtils.FormatNumber(self.heroLevelData.magicPotion)
        else
            self.config.iconMagicPotion.sprite = ResourceLoadUtils.LoadMoneyIcon(MoneyType.ANCIENT_POTION)
            self.config.textGem.text = ClientConfigUtils.FormatNumber(self.heroLevelData.ancientPotion)
        end
        self.config.iconMagicPotion:SetNativeSize()
    end
    if self.heroLevelCap ~= nil then
        if heroResource.heroLevel >= self.heroLevelCap.levelCap then
            self.config.lvUp:SetActive(false)
            self.config.lvMax:SetActive(true)
            self.config.buttonLvMax.gameObject:SetActive(false)
        else
            self.config.lvUp:SetActive(true)
            self.config.lvMax:SetActive(false)

            ---@type HeroLevelDataConfig
            local heroLevelData = ResourceMgr.GetHeroMenuConfig():GetHeroLevelDataDictionary(self.model.heroResource.heroLevel + 1)
            if heroLevelData.ancientPotion > 0 then
                self.config.buttonLvMax.gameObject:SetActive(false)
            else
                self.config.buttonLvMax.gameObject:SetActive(true)
            end
        end
    end
    self.prefabHeroInfoView:SetData(heroResource)
end

--- @return void
function UIHeroInfo:UpLevelTo(levelTo)
    local currentGold = InventoryUtils.GetMoney(MoneyType.GOLD)
    local currentMagicPotion = InventoryUtils.GetMoney(MoneyType.MAGIC_POTION)
    local currentAncientPotion = InventoryUtils.GetMoney(MoneyType.ANCIENT_POTION)
    local enoughGold = false
    local enoughMagicPotion = false
    local enoughAncientPotion = false
    local gold = 0
    local magicPotion = 0
    local ancientPotion = 0
    local levelCanUp = self.model.heroResource.heroLevel
    for i = self.model.heroResource.heroLevel + 1, levelTo do
        ---@type HeroLevelDataConfig
        local heroLevelData = ResourceMgr.GetHeroMenuConfig():GetHeroLevelDataDictionary(i)
        enoughGold = currentGold - gold < heroLevelData.gold
        enoughMagicPotion = currentMagicPotion - magicPotion < heroLevelData.magicPotion
        enoughAncientPotion = currentAncientPotion - ancientPotion < heroLevelData.ancientPotion
        if enoughGold or enoughMagicPotion or enoughAncientPotion then
            break
        else
            gold = gold + heroLevelData.gold
            magicPotion = magicPotion + heroLevelData.magicPotion
            ancientPotion = ancientPotion + heroLevelData.ancientPotion
            levelCanUp = levelCanUp + 1
        end
    end
    if levelCanUp > self.model.heroResource.heroLevel then
        InventoryUtils.Sub(ResourceType.Money, MoneyType.GOLD, gold)
        InventoryUtils.Sub(ResourceType.Money, MoneyType.MAGIC_POTION, magicPotion)
        InventoryUtils.Sub(ResourceType.Money, MoneyType.ANCIENT_POTION, ancientPotion)
        self.heroResource = self.model.heroResource
        self:DelayCheckRequestLevelUp()
        self.heroResource.heroLevel = levelCanUp
        self.model.canSortHero = true
        if levelCanUp == self.heroLevelCap.levelCap then
            self.heroMenuView.previewHeroMenu:LevelUpMax()
        else
            self.heroMenuView.previewHeroMenu:LevelUp()
        end
        zg.audioMgr:PlaySfxUi(SfxUiType.HERO_LEVEL_UP)
        self:UpdateUI()
        self.heroMenuView:ChangeStatHero()
    else
        if enoughGold == true and enoughMagicPotion == false and enoughAncientPotion == false then
            SmartPoolUtils.NotiLackResource(MoneyType.GOLD)
        elseif enoughGold == false and enoughMagicPotion == true and enoughAncientPotion == false then
            SmartPoolUtils.NotiLackResource(MoneyType.MAGIC_POTION)
        elseif enoughGold == false and enoughMagicPotion == false and enoughAncientPotion == true then
            SmartPoolUtils.NotiLackResource(MoneyType.ANCIENT_POTION)
        elseif not (enoughGold == false and enoughMagicPotion == false and enoughAncientPotion == false) then
            SmartPoolUtils.NotiLackResource()
        end
    end
end

--- @return void
function UIHeroInfo:OnClickLevelUp()
    self:UpLevelTo(self.model.heroResource.heroLevel + 1)
end

--- @return void
function UIHeroInfo:OnClickMaxLevel()
    local nextLevel = nil
    for i = self.model.heroResource.heroLevel + 1, self.heroLevelCap.levelCap do
        ---@type HeroLevelDataConfig
        local heroLevelData = ResourceMgr.GetHeroMenuConfig():GetHeroLevelDataDictionary(i)
        if heroLevelData.ancientPotion > 0 then
            break
        else
            nextLevel = i
        end
    end
    if nextLevel ~= nil then
        self:UpLevelTo(nextLevel)
    end
end

--- @return void
function UIHeroInfo:OnClickEvolve()
    if self.heroMenuView:CheckCanOpenEvolve(true) == true then
        self.heroMenuView.tab:Select(3)
    end
end