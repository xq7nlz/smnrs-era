require "lua.client.core.network.altar.AltarDisassembleHeroOutBound"
require "lua.client.core.network.altar.AltarDisassembleHeroInBound"

--- @class UIHeroReset2
UIHeroReset2 = Class(UIHeroReset2)

--- @return void
--- @param transform UnityEngine_Transform
--- @param uiHeroMenu2View UIHeroMenu2View
function UIHeroReset2:Ctor(transform, model, uiHeroMenu2View)
    --- @type UIHeroMenu2Model
    self.model = model
    --- @type UIHeroMenu2View
    self.uiHeroMenu2View = uiHeroMenu2View
    ---@type UIHeroResetConfig
    self.config = UIBaseConfig(transform)
    --- @type List --<ItemIconData>
    self.resourceList = List()
    ---@type StatHeroEvolveChangeConfig
    self.levelCap = UIBaseConfig(self.config.levelCap)
    ---@type StatHeroEvolveChangeConfig
    self.hp = UIBaseConfig(self.config.hp)
    ---@type StatHeroEvolveChangeConfig
    self.attack = UIBaseConfig(self.config.attack)
    ---@type StatHeroEvolveChangeConfig
    self.speed = UIBaseConfig(self.config.speed)

    self.config.buttonReset.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickReset()
    end)

    ---@type HeroResetConfig
    self.heroResetConfig = ResourceMgr.GetHeroResetConfig()
    self.config.priceReset.text = self.heroResetConfig.moneyValue

    --- @param obj IconView
    --- @param index number
    local onCreateItem = function(obj, index)
        local data = self.resourceList:Get(index + 1)
        --XDebug.Log(LogUtils.ToDetail(data))
        obj:SetIconData(data)
        obj:RegisterShowInfo()
    end

    self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.RootIconView, onCreateItem)

    self:InitLocalization()
end

--- @return void
function UIHeroReset2:InitLocalization()
    self.config.localizeReset.text = LanguageUtils.LocalizeCommon("reset")
    self.config.localizeLevelCap.text = LanguageUtils.LocalizeCommon("level")
    self.config.localizeMaterial.text = LanguageUtils.LocalizeCommon("material_refund")
end

--- @return void
function UIHeroReset2:Show()
    self.playerRaiseHero = zg.playerData:GetRaiseLevelHero()
    self.uiHeroMenu2View:SetButtonNextHero(self.config.buttonReset.transform.position)
    self:UpdateUI()
end

--- @return void
---@param view StatHeroEvolveChangeConfig
function UIHeroReset2:SetStat(view, base, upgrade)
    view.base.text = tostring(base)
    view.upgrade.text = UIUtils.SetColorString(UIUtils.color11, upgrade)
end

--- @return void
function UIHeroReset2:UpdateUI()
    local heroResource = self.uiHeroMenu2View.model.heroResource
    self.config.textHeroName.text = LanguageUtils.LocalizeNameHero(heroResource.heroId)
    self.config.iconFaction.sprite = ResourceLoadUtils.LoadFactionIcon(ClientConfigUtils.GetFactionIdByHeroId(heroResource.heroId))
    self.config.iconClass.sprite = ResourceLoadUtils.LoadCLassIcon(ResourceMgr.GetHeroClassConfig():GetClass(heroResource.heroId))

    ---@type Dictionary
    local statDict1 = ClientConfigUtils.GetBaseStatHero(heroResource.heroId, heroResource.heroStar, heroResource.heroLevel)
    ---@type Dictionary
    local statDict2 = ClientConfigUtils.GetBaseStatHero(heroResource.heroId, heroResource.heroStar, 1)
    self:SetStat(self.levelCap, heroResource.heroLevel, 1)
    self:SetStat(self.hp, statDict1:Get(StatType.HP), statDict2:Get(StatType.HP))
    self:SetStat(self.attack, statDict1:Get(StatType.ATTACK), statDict2:Get(StatType.ATTACK))
    self:SetStat(self.speed, statDict1:Get(StatType.SPEED), statDict2:Get(StatType.SPEED))

    self.resourceList = self.uiHeroMenu2View.model.heroResource:GetResourceReset()
    self.uiScroll.scroll.enabled = true
    self.uiScroll:Resize(self.resourceList:Count())
    Coroutine.start(function()
        coroutine.waitforendofframe()
        coroutine.waitforendofframe()
        if self.resourceList:Count() <= 12 then
            self.uiScroll.scroll.enabled = false
        end
    end)
end

--- @return void
function UIHeroReset2:OnChangeHero()
    self.uiScroll:Hide()
    self:UpdateUI()
end

--- @return void
function UIHeroReset2:Hide()
    self.uiScroll:Hide()
end

--- @return void
function UIHeroReset2:OnClickReset()
    local checkInRaise = ClientConfigUtils.CheckHeroInRaiseLevel(self.uiHeroMenu2View.model.heroResource.inventoryId)
    if not checkInRaise then
        local canReset = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, self.heroResetConfig.moneyType, self.heroResetConfig.moneyValue))
        if canReset then
            local reset = function()
                local listHeroInventoryId = List()
                listHeroInventoryId:Add(self.uiHeroMenu2View.model.heroResource.inventoryId)

                ---@type AltarDisassembleHeroInBound
                local altarDisassembleHeroInBound

                --- @param buffer UnifiedNetwork_ByteBuf
                local onBufferReading = function(buffer)
                    altarDisassembleHeroInBound = AltarDisassembleHeroInBound(buffer)
                end

                local callbackSuccess = function()
                    InventoryUtils.Sub(ResourceType.Money, self.heroResetConfig.moneyType, self.heroResetConfig.moneyValue)
                    ---@type List
                    local listResource = self.uiHeroMenu2View.model.heroResource:GetResourceReset()
                    ---@param v ItemIconData
                    for _, v in pairs(listResource:GetItems()) do
                        v:AddToInventory()
                    end
                    self.uiHeroMenu2View.model.heroResource:OnSuccessResetHero()
                    PopupUtils.ShowRewardList(listResource)
                    self.uiHeroMenu2View.tab:Select(1)
                    self.uiHeroMenu2View:ChangeStatHero()
                    self.uiHeroMenu2View.previewHeroMenu:PreviewHero(self.uiHeroMenu2View.model.heroResource, HeroModelType.Basic)
                    self.playerRaiseHero:UpdateLowestLevelInReset(self.uiHeroMenu2View.model.heroResource)
                end
                NetworkUtils.RequestAndCallback(OpCode.ALTAR_HERO_RESET, AltarDisassembleHeroOutBound(listHeroInventoryId),
                        callbackSuccess, SmartPoolUtils.LogicCodeNotification, onBufferReading)
            end
            PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("are_you_sure"), nil, reset)
        end
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("hero_in_raise_level"))
    end
end