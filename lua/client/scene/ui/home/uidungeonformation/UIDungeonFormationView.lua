require "lua.client.core.network.dungeon.DungeonRequest"
require "lua.client.scene.ui.home.uiFormation2.dungeonWorldFormation.DungeonWorldFormation"

local MAX_HERO = 5

--- @class UIDungeonFormationView : UIBaseView
UIDungeonFormationView = Class(UIDungeonFormationView, UIBaseView)

--- @return void
--- @param model UIDungeonFormationModel
function UIDungeonFormationView:Ctor(model)
    --- @type EventTimeData
    self.eventTime = nil
    --- @type function
    self.updateTime = nil
    --- @type UIDungeonFormationConfig
    self.config = nil
    ---@type HeroListView
    self.heroList = nil
    --- @type DungeonWorldFormation
    self.dungeonWorldFormation = nil
    UIBaseView.Ctor(self, model)
    --- @type UIDungeonFormationModel
    self.model = model
end

--- @return void
function UIDungeonFormationView:OnReadyCreate()
    ---@type UIDungeonFormationConfig
    self.config = UIBaseConfig(self.uiTransform)

    --HERO LIST
    self.heroList = HeroListView(self.config.heroList)

    --- @return void
    --- @param heroIndex number
    --- @param buttonHero HeroIconView
    --- @param heroResource HeroResource
    self.onUpdateIconHero = function(heroIndex, buttonHero, heroResource)
        if self:IsContainHeroInventoryId(heroResource) then
            buttonHero:ActiveMaskSelect(true, UIUtils.sizeItem)
            buttonHero:EnableButton(true)
        else
            buttonHero:ActiveMaskSelect(false)
            buttonHero:EnableButton(true)
        end
    end

    --- @return void
    --- @param heroIndex number
    --- @param buttonHero HeroIconView
    --- @param heroResource HeroResource
    self.buttonListener = function(heroIndex, buttonHero, heroResource)
        if self:IsContainHeroInventoryId(heroResource) then
            self:RemoveHeroFromTeam(heroResource)
            buttonHero:ActiveMaskSelect(false)
            buttonHero:EnableButton(true)
        else
            if self:IsFull() == false then
                self:AddHeroToTeam(heroResource)
                buttonHero:ActiveMaskSelect(true, UIUtils.sizeItem)
                buttonHero:EnableButton(true)
                self:UpdateTeamFormation()
            else
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("full_slot"))
                zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            end
        end
    end

    self.heroList:Init(self.buttonListener, nil, nil, nil, nil, self.onUpdateIconHero, self.onUpdateIconHero)

    self:InitButtonListener()
    self:InitUpdateTime()
    self:InitWorldFormation()
end

function UIDungeonFormationView:InitUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime then
            self:SetTimeRefresh()
        else
            self.timeRefresh = self.timeRefresh - 1
        end
        if self.timeRefresh >= 0 then
            self.config.textTimer.text = string.format("%s %s",
                    UIUtils.SetColorString(UIUtils.white, LanguageUtils.LocalizeCommon("season_end_in")),
                    UIUtils.SetColorString(UIUtils.green_light, TimeUtils.SecondsToClock(self.timeRefresh))
            )
        end
        if self.timeRefresh <= 0 then
            self:RemoveUpdateTime()
            zg.playerData:GetEvents().lastTimeGetEventPopupModel = nil

            PopupUtils.ShowTimeOut(function ()
                PopupUtils.ShowPopupNotificationOK(LanguageUtils.LocalizeCommon("dungeon_time_up"), function()
                    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
                end)
            end)
        end
    end
end

function UIDungeonFormationView:SetTimeRefresh()
    self.timeRefresh = self.eventTime.endTime - zg.timeMgr:GetServerTime()
end

function UIDungeonFormationView:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIDungeonFormationView:InitWorldFormation()
    self.dungeonWorldFormation = DungeonWorldFormation(self.config.dungeonWorldFormation)
    self.dungeonWorldFormation.removeCallback = function(slotId)
        self:RemoveHeroBySlot(slotId)
    end
    self.dungeonWorldFormation.saveCallback = function()
        zg.audioMgr:PlaySfxUi(SfxUiType.START_BATTLE)
        self:SaveTeam()
    end
    self.dungeonWorldFormation:OnCreate()
end

--- @return void
function UIDungeonFormationView:InitLocalization()
    self.config.localizeSelectHeroToBattle.text = LanguageUtils.LocalizeCommon("select_hero_battle")
    self.config.localizeDungeon.text = LanguageUtils.LocalizeFeature(FeatureType.DUNGEON)
    if self.dungeonWorldFormation ~= nil then
        self.dungeonWorldFormation:InitLocalization()
    end
end

--- @return void
function UIDungeonFormationView:InitButtonListener()
    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

--- @return void
function UIDungeonFormationView:OnReadyShow()
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    self.model.heroSelectedList = {}
    self.heroList:SetData(InventoryUtils.Get(ResourceType.Hero), true)
    self.dungeonWorldFormation:OnShow()
    self:StartRefreshTime()
end

function UIDungeonFormationView:StartRefreshTime()
    self.eventTime = zg.playerData:GetEvents():GetEvent(EventTimeType.DUNGEON):GetTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end


function UIDungeonFormationView:Hide()
    UIBaseView.Hide(self)
    self:RemoveUpdateTime()
    self.heroList:ReturnPool()
    self.dungeonWorldFormation:OnHide()
end

--- @return void
function UIDungeonFormationView:SaveTeam()
    ---@type List
    local heroList = List()
    for i = 1, MAX_HERO do
        ---@type HeroResource
        local heroResource = self.model.heroSelectedList[i]
        if heroResource ~= nil then
            heroList:Add(heroResource.inventoryId)
        end
    end
    if heroList:Count() == 0 then
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("insert_least_one_hero"))
        return
    end

    local callback = function()
        --- @type DungeonInBound
        local server = zg.playerData:GetMethod(PlayerDataMethod.DUNGEON)
        for i = 1, MAX_HERO do
            ---@type HeroResource
            local heroResource = self.model.heroSelectedList[i]
            if heroResource ~= nil then
                local data = DungeonBindingHeroInBound()
                data.heroResource = HeroResource.Clone(heroResource)
                data.hpPercent = 1
                data.power = HeroConstants.DEFAULT_HERO_POWER
                data.index = server.bindingHeroList:Count() + 1
                server.bindingHeroList:Add(data)
            end
        end
        PopupMgr.ShowAndHidePopup(UIPopupName.UIDungeonMain, nil, UIPopupName.UIDungeonFormation)
    end
    DungeonRequest.BindingHero(heroList, callback)
end

--- @return void
--- @param heroResource HeroResource
function UIDungeonFormationView:AddHeroToTeam(heroResource)
    for i = 1, MAX_HERO do
        ---@type HeroResource
        local tempHeroResource = self.model.heroSelectedList[i]
        if tempHeroResource == nil then
            self.model.heroSelectedList[i] = heroResource
            self.dungeonWorldFormation:SetHeroAtSlot(i, heroResource)
            return
        end
    end
end

--- @return void
--- @param heroResource HeroResource
function UIDungeonFormationView:RemoveHeroFromTeam(heroResource)
    for i = 1, 5 do
        ---@type HeroResource
        local tempHeroResource = self.model.heroSelectedList[i]
        if tempHeroResource == heroResource then
            self.model.heroSelectedList[i] = nil
            self.dungeonWorldFormation:RemoveHeroAtSlot(i)
        end
    end
end

--- @param slotId number
function UIDungeonFormationView:RemoveHeroBySlot(slotId)
    self.model.heroSelectedList[slotId] = nil
    self.heroList.uiScroll:RefreshCells()
end

--- @return boolean
--- @param heroResource HeroResource
function UIDungeonFormationView:IsContainHeroInventoryId(heroResource)
    for i = 1, MAX_HERO do
        ---@type HeroResource
        local tempHeroResource = self.model.heroSelectedList[i]
        if tempHeroResource == heroResource then
            return true
        end
    end
    return false
end

--- @return boolean
function UIDungeonFormationView:IsFull()
    for i = 1, 5 do
        ---@type HeroResource
        local heroResource = self.model.heroSelectedList[i]
        if heroResource == nil then
            return false
        end
    end
    return true
end

--- @return void
function UIDungeonFormationView:UpdateTeamFormation()
    -- do nothing
end

function UIDungeonFormationView:OnClickBackOrClose()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UIDungeonFormation)
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
end