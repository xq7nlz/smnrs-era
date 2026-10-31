---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiPopupTavernReward.UIPopupTavernRewardConfig"
require "lua.client.core.network.tavern.TavernStartQuestOutBound"

--- @class UIPopupTavernRewardView : UIBaseView
UIPopupTavernRewardView = Class(UIPopupTavernRewardView, UIBaseView)

--- @return void
--- @param model UIPopupTavernRewardModel
function UIPopupTavernRewardView:Ctor(model)
    ---@type UIPopupTavernRewardConfig
    self.config = nil
    ---@type IconView
    self.iconView = nil
    ---@type TavernQuestDataConfig
    self.tavernQuestDataConfig = nil
    ---@type function
    self.callbackStart = nil
    ---@type List  --<SlotHeroIconView>
    self.listSlotHero = List()
    ---@type RequirementHeroView
    self.requirementStar = nil
    ---@type RequirementHeroView
    self.requirementFaction = nil
    ---@type RequirementHeroView
    self.requirementClass = nil
    ---@type RequirementHeroInfoView
    self.requirementInfo = nil

    ---@type UILoopScroll
    self.uiScroll = nil
    ---@type UISelect
    self.sortFaction = nil

    ---@type HeroListView
    self.heroList = nil

    -- init variables here
    UIBaseView.Ctor(self, model)
    --- @type UIPopupTavernRewardModel
    self.model = model
end

--- @return void
function UIPopupTavernRewardView:OnReadyCreate()
    ---@type UIPopupTavernRewardConfig
    self.config = UIBaseConfig(self.uiTransform)

    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.bgClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonAuto.onClick:AddListener(function()
        self:OnClickAutoFill()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
    self.config.buttonStart.onClick:AddListener(function()
        self:OnClickStart()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
end

--- @return void
function UIPopupTavernRewardView:InitLocalization()
    self.config.localizeSelectHero.text = LanguageUtils.LocalizeCommon("select_heroes")
    self.config.localizeAutoSelect.text = LanguageUtils.LocalizeCommon("auto_fill")
    self.config.localizeRequirement.text = LanguageUtils.LocalizeCommon("requirement")
    self.config.localizeStart.text = LanguageUtils.LocalizeCommon("start")
    self.config.textTapToClose.gameObject:SetActive(false)
end

--- @return void
function UIPopupTavernRewardView:OnReadyShow(result)
    self:Init(result)
end

--- @return void
function UIPopupTavernRewardView:Hide()
    UIBaseView.Hide(self)
    if self.iconView ~= nil then
        self.iconView:ReturnPool()
        self.iconView = nil
    end
    if self.heroList ~= nil then
        self.heroList:ReturnPool()
    end
    ---@param v SlotHeroIconView
    for _, v in pairs(self.listSlotHero:GetItems()) do
        v:ReturnPool()
    end
    self.listSlotHero:Clear()
    if self.requirementStar ~= nil then
        self.requirementStar:ReturnPool()
        self.requirementStar = nil
    end
    if self.requirementFaction ~= nil then
        self.requirementFaction:ReturnPool()
        self.requirementFaction = nil
    end
    if self.requirementClass ~= nil then
        self.requirementClass:ReturnPool()
        self.requirementClass = nil
    end
end

--- @return void
function UIPopupTavernRewardView:InitDataQuest()
    self.model.heroResourceList:Clear()
    ---@type List
    local listHeroInventoryIdIgnor = List()
    ---@param quest TavernQuestInBound
    for _, quest in pairs(zg.playerData:GetMethod(PlayerDataMethod.TAVERN).listTavernQuest:GetItems()) do
        if quest ~= self.model.quest and quest.questState == TavernQuestState.DOING then
            ---@param questParticipant TavernQuestParticipantInBound
            for _, questParticipant in pairs(quest.inventoryHeroList:GetItems()) do
                listHeroInventoryIdIgnor:Add(questParticipant.inventoryId)
            end
        end
    end
    ---@param heroResource HeroResource
    for i, heroResource in pairs(InventoryUtils.Get(ResourceType.Hero):GetItems()) do
        if listHeroInventoryIdIgnor:IsContainValue(heroResource.inventoryId) == false then
            self.model.heroResourceList:Add(heroResource)
        end
    end
end

--- @return void
function UIPopupTavernRewardView:Init(result)
    self.model.quest = result.quest
    self.callbackStart = result.callbackStart
    --XDebug.Log(LogUtils.ToDetail(self.model.quest))
    self:InitDataQuest()
    self.tavernQuestDataConfig = ResourceMgr.GetTavernQuestConfig():GetQuestDataByStar(self.model.quest.star)
    assert(self.tavernQuestDataConfig)

    if self.iconView == nil then
        self.iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.itemReward)
        self.iconView:RegisterShowInfo()
    end
    self.iconView:SetIconData(self.model.quest.reward:GetIconData())
    self.config.localizeQuest.text = self.model.quest.questName

    --- BUTTON
    if self.model.quest.questState == TavernQuestState.WAITING then
        self.config.buttonStart.gameObject:SetActive(true)
        self.config.buttonAuto.gameObject:SetActive(true)
        local time = self.tavernQuestDataConfig.time / TimeUtils.SecondAHour
        if time < 1 then
            self.config.textTimeQuest.text = string.format(LanguageUtils.LocalizeCommon("min_x"), math.floor(time * 60))
        else
            self.config.textTimeQuest.text = string.format(LanguageUtils.LocalizeCommon("hour_x"), math.floor(time))
        end
    else
        self.config.buttonStart.gameObject:SetActive(false)
        self.config.buttonAuto.gameObject:SetActive(false)
    end

    --- SLOT HERO
    if self.listSlotHero:Count() == 0 then
        for i = 1, self.model.quest.heroNumber do
            ---@type SlotHeroIconView
            local slotHeroIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.SlotHeroIconView, self.config.slot)
            self.listSlotHero:Add(slotHeroIconView)
            if self.model.quest.questState == TavernQuestState.WAITING then
                slotHeroIconView:AddListener(function()
                    if slotHeroIconView.heroResource ~= nil then
                        self.model.quest:RemoveHeroResource(slotHeroIconView.heroResource)
                        slotHeroIconView:DeSpawnHeroIconView()
                        self.heroList.uiScroll.scroll:RefreshCells()
                        self:UpdateRequirement()
                    end
                end)
            end
        end
    end
    self:UpdateSlot()

    --- QUEST REQUIREMENT
    if self.model.quest.heroStar ~= nil and self.model.quest.heroStar > 0 and self.requirementStar == nil then
        self.requirementStar = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RequirementHeroIconView, self.config.parentRequire)
        self.requirementStar.config.icon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconStarNumbers, self.model.quest.heroStar)
        local onPointEnter = function()
            self:RequirementStar()
        end
        local onPointExit = function()
            self:HideRequirementInfo()
        end
        self.requirementStar:InitTrigger(onPointEnter, onPointExit)
    end
    if self.model.quest.heroFaction ~= nil and self.model.quest.heroFaction > 0 and self.requirementFaction == nil then
        self.requirementFaction = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RequirementHeroIconView, self.config.parentRequire)
        self.requirementFaction.config.icon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconFactions, self.model.quest.heroFaction)
        local onPointEnter = function(skillVIew)
            self:RequirementFaction()
        end
        local onPointExit = function()
            self:HideRequirementInfo()
        end
        self.requirementFaction:InitTrigger(onPointEnter, onPointExit)
    end
    if self.model.quest.heroClass ~= nil and self.model.quest.heroClass > 0 and self.requirementClass == nil then
        self.requirementClass = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RequirementHeroIconView, self.config.parentRequire)
        self.requirementClass.config.icon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconClassHeroes, self.model.quest.heroClass)
        local onPointEnter = function(skillVIew)
            self:RequirementClass()
        end
        local onPointExit = function()
            self:HideRequirementInfo()
        end
        self.requirementClass:InitTrigger(onPointEnter, onPointExit)
    end
    self:UpdateRequirement()

    self:CreateHeroList()
end

--- @return void
function UIPopupTavernRewardView:CreateHeroList()
    if self.heroList == nil then
        self.heroList = HeroListView(self.config.heroList)

        --- @return void
        --- @param heroIndex number
        --- @param buttonHero HeroIconView
        --- @param heroResource HeroResource
        self.onUpdateIconHero = function(heroIndex, buttonHero, heroResource)
            if self.model.quest:ContainHeroInventoryId(heroResource.inventoryId) then
                buttonHero:ActiveMaskSelect(true, UIUtils.sizeItem)
            else
                buttonHero:ActiveMaskSelect(false)
            end
        end

        --- @return void
        --- @param heroIndex number
        --- @param buttonHero HeroIconView
        --- @param heroResource HeroResource
        self.buttonListener = function(heroIndex, buttonHero, heroResource)
            self:SelectHero(buttonHero, heroIndex, heroResource)
            self.onUpdateIconHero(heroIndex, buttonHero, heroResource)
        end
        self.heroList:Init(self.buttonListener, nil, nil, nil, nil, self.onUpdateIconHero, self.onUpdateIconHero)
    end
    self.heroList.showClass = true
    self.heroList:SetData(self.model.heroResourceList)
end

--- @return void
function UIPopupTavernRewardView:UpdateSlot()
    for i = 1, self.listSlotHero:Count() do
        ---@type SlotHeroIconView
        local slotHeroIconView = self.listSlotHero:Get(i)
        if self.model.quest.inventoryHeroList:Count() >= i then
            ---@type TavernQuestParticipantInBound
            local questParticipant = self.model.quest.inventoryHeroList:Get(i)
            ---@type HeroResource
            local heroResource = InventoryUtils.GetHeroResourceByInventoryId(questParticipant.inventoryId)
            if heroResource ~= nil then
                slotHeroIconView:ShowHeroIconView(heroResource, true)
            else
                --self.model.quest.inventoryHeroList:RemoveByIndex(i)
            end
        end
        if self.model.quest.questState == TavernQuestState.DONE then
            slotHeroIconView:SetTickSlot(true)
        else
            slotHeroIconView:SetTickSlot(false)
        end
    end
end

--- @return void
function UIPopupTavernRewardView:UpdateRequirement()
    --XDebug.Log("UpdateRequirement")
    if self.requirementClass ~= nil then
        self.requirementClass:SetPass(self.model.quest:IsPassRequirementClass())
    end
    if self.requirementFaction ~= nil then
        self.requirementFaction:SetPass(self.model.quest:IsPassRequirementFaction())
    end
    if self.requirementStar ~= nil then
        self.requirementStar:SetPass(self.model.quest:IsPassRequirementStar())
    end
end

--- @return void
function UIPopupTavernRewardView:OnReadyHide()
    if self.model.quest.questState == TavernQuestState.WAITING then
        self.model.quest.inventoryHeroList:Clear()
    end
    PopupMgr.HidePopup(UIPopupName.UIPopupTavernReward)
end

--- @return void
--- @param obj HeroIconView
--- @param index number
--- @param heroResource HeroResource
function UIPopupTavernRewardView:SelectHero(obj, index, heroResource)
    if heroResource ~= nil then
        if self.model.quest:ContainHeroInventoryId(heroResource.inventoryId) then
            self:_RemoveHeroResource(heroResource)
            obj:ActiveMaskSelect(false)
        elseif self.model.quest.inventoryHeroList:Count() < self.model.quest.heroNumber then
            self:_AddHeroResource(heroResource)
            obj:ActiveMaskSelect(true, UIUtils.sizeItem)
        end
    end
end

--- @return void
---@param heroResource HeroResource
function UIPopupTavernRewardView:_AddHeroResource(heroResource)
    self.model.quest:AddHeroResource(heroResource)
    ---@param v SlotHeroIconView
    for _, v in pairs(self.listSlotHero:GetItems()) do
        if v.heroResource == nil then
            v:ShowHeroIconView(heroResource, true)
            break
        end
    end
    self:UpdateRequirement()
end

--- @return void
---@param heroResource HeroResource
function UIPopupTavernRewardView:_RemoveHeroResource(heroResource)
    self.model.quest:RemoveHeroResource(heroResource)
    ---@param v SlotHeroIconView
    for _, v in pairs(self.listSlotHero:GetItems()) do
        if v.heroResource == heroResource then
            v:DeSpawnHeroIconView()
            break
        end
    end
    self:UpdateRequirement()
end

--- @return void
function UIPopupTavernRewardView:OnClickAutoFill()
    self:AutoFillQuest()
    self:UpdateSlot()
    self:UpdateRequirement()
    self.heroList.uiScroll.scroll:RefreshCells()
end

--- @return void
function UIPopupTavernRewardView:OnClickStart()
    if self.model.quest.inventoryHeroList:Count() == self.model.quest.heroNumber and self.model.quest:IsPassRequirementClass() == true
            and self.model.quest:IsPassRequirementFaction() == true and self.model.quest:IsPassRequirementStar() == true then
        local callback = function(result)
            local onSuccess = function()
                --XDebug.Log("Quest Start Success")
            end
            local onFailed = function(logicCode)
                SmartPoolUtils.LogicCodeNotification(logicCode)
            end
            NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
        end
        ---@type TavernStartQuestOutBound
        local tavernStartQuestOutBound = TavernStartQuestOutBound(self.model.quest.id, self.model.quest.inventoryHeroList)
        NetworkUtils.Request(OpCode.TAVERN_QUEST_START, tavernStartQuestOutBound, callback)
        if self.callbackStart ~= nil then
            self.callbackStart(self.model.quest)
        end
        PopupMgr.HidePopup(UIPopupName.UIPopupTavernReward)
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("require_tavern"))
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
    end
end

--- @return void
function UIPopupTavernRewardView:ShowRequirement(string)
    if self.requirementInfo == nil then
        self.requirementInfo = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RequirementHeroInfoView, self.config.requirementInfo)
    end
    self.requirementInfo.config.gameObject:SetActive(true)
    self.requirementInfo:SetData(string)
end

--- @return void
function UIPopupTavernRewardView:RequirementStar()
    self:ShowRequirement(string.format(LanguageUtils.LocalizeCommon("require_hero_star_x"), self.model.quest.heroStar))
end

--- @return void
function UIPopupTavernRewardView:RequirementFaction()
    self:ShowRequirement(string.format(LanguageUtils.LocalizeCommon("require_hero_faction_x"), LanguageUtils.LocalizeFaction(self.model.quest.heroFaction)))
end

--- @return void
function UIPopupTavernRewardView:RequirementClass()
    self:ShowRequirement(string.format(LanguageUtils.LocalizeCommon("require_hero_class_x"), LanguageUtils.LocalizeClass(self.model.quest.heroClass)))
end

--- @return void
function UIPopupTavernRewardView:HideRequirementInfo()
    if self.requirementInfo ~= nil then
        self.requirementInfo.config.gameObject:SetActive(false)
    end
end

--- @return void
function UIPopupTavernRewardView:AutoFillQuest()
    ---@type TavernQuestInBound
    local quest = self.model.quest
    quest.inventoryHeroList:Clear()
    local heroClassConfig = ResourceMgr.GetHeroClassConfig()

    for i = 1, self.listSlotHero:Count() do
        ---@type SlotHeroIconView
        local slotHeroIconView = self.listSlotHero:Get(i)
        slotHeroIconView:DeSpawnHeroIconView()
    end

    ---@param heroResource HeroResource
    local sortStar = function(heroResource)
        if quest.heroStar <= 0 or quest:IsPassRequirementStar() or heroResource.heroStar >= quest.heroStar then
            return true
        else
            return false
        end
    end
    ---@param heroResource HeroResource
    local sortFaction = function(heroResource)
        if quest.heroFaction <= 0 or quest:IsPassRequirementFaction() or ClientConfigUtils.GetFactionIdByHeroId(heroResource.heroId) == quest.heroFaction then
            return true
        else
            return false
        end
    end

    ---@param heroResource HeroResource
    local sortClass = function(heroResource)
        if quest.heroClass <= 0 or quest:IsPassRequirementClass() or heroClassConfig:GetClass(heroResource.heroId) == quest.heroClass then
            return true
        else
            return false
        end
    end

    ---@type List
    local listStarFactionClass = List()
    ---@type List
    local listStarFaction = List()
    ---@type List
    local listStarClass = List()
    ---@type List
    local listFactionClass = List()
    ---@type List
    local listStar = List()
    ---@type List
    local listFaction = List()
    ---@type List
    local listClass = List()
    ---@type List
    local listHeroDefault = List()

    ---@type HeroResource
    local heroResource
    ---@type boolean
    local star = false
    ---@type boolean
    local faction = false
    ---@type boolean
    local class = false

    ---@param index number
    for _, index in ipairs(self.heroList.heroInUseList:GetItems()) do
        heroResource = self.heroList.heroResourceList:Get(index)
        star = sortStar(heroResource)
        faction = sortFaction(heroResource)
        class = sortClass(heroResource)

        if star then
            listStar:Add(heroResource)
        end
        if faction then
            listFaction:Add(heroResource)
        end
        if class then
            listClass:Add(heroResource)
        end
        if star and faction then
            listStarFaction:Add(heroResource)
        end
        if star and class then
            listStarClass:Add(heroResource)
        end
        if class and faction then
            listFactionClass:Add(heroResource)
        end
        if star and faction and class then
            listStarFactionClass:Add(heroResource)
        end
    end

    ---@type List
    local listHeroSort = List()
    for _ = 1, quest.heroNumber do
        listHeroSort:Clear()
        if quest:IsPassRequirementStar() == false then
            listHeroSort = listStarFactionClass
            if listHeroSort:Count() == 0 then
                listHeroSort = listStarFaction
            end
            if listHeroSort:Count() == 0 then
                listHeroSort = listStarClass
            end
            if listHeroSort:Count() == 0 then
                if(self.requirementStar ~= nil) then
                    listHeroSort = listStar
                end
            end
        end
        if quest:IsPassRequirementFaction() == false then
            if listHeroSort:Count() == 0 then
                listHeroSort = listFactionClass
            end
            if listHeroSort:Count() == 0 then
                if(self.requirementFaction ~= nil) then
                    listHeroSort = listFaction
                end
            end
        end
        if quest:IsPassRequirementClass() == false then
            if listHeroSort:Count() == 0 then
                if(self.requirementClass ~= nil) then
                    listHeroSort = listClass
                end
            end
        end
        if listHeroSort:Count() == 0 then
            listHeroSort = listHeroDefault
        end
        heroResource = nil
        if listHeroSort:Count() > 0 then
            for i = listHeroSort:Count(), 1, -1 do
                heroResource = listHeroSort:Get(i)
                if quest:ContainHeroInventoryId(heroResource.inventoryId) == false then
                    break
                else
                    heroResource = nil
                end
            end
        else
            if(quest:IsPassRequirementClass() and quest:IsPassRequirementFaction() and quest:IsPassRequirementStar()) then
                if(quest.inventoryHeroList:Count() ~= quest.heroNumber) then
                    for i = self.heroList.heroInUseList:Count(), 1, -1 do
                        heroResource = self.heroList.heroResourceList:Get(self.heroList.heroInUseList:Get(i))
                        if quest:ContainHeroInventoryId(heroResource.inventoryId) == false then
                            break
                        else
                            heroResource = nil
                        end
                    end
                end
            else
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("not_have_hero_meet_requirement"))
                heroResource = nil
            end
        end
        if heroResource ~= nil then
            quest:AddHeroResource(heroResource)
        else
            break
        end
    end
end

--- @return HeroResource
---@param condition {func(HeroResource)}
function UIPopupTavernRewardView:_GetListHeroCondition(condition)
    ---@type List --<HeroResource>
    local listHero = List()
    ---@type boolean
    local isHeroCondition = true
    ---@param index number
    for _, index in pairs(self.heroList.heroInUseList:GetItems()) do
        ---@type HeroResource
        local heroResource = self.heroList.heroResourceList:Get(index)
        isHeroCondition = true
        if self.model.quest:ContainHeroInventoryId(heroResource.inventoryId) == false then
            if condition ~= nil then
                for _, func in ipairs(condition) do
                    if func(heroResource) == false then
                        isHeroCondition = false
                    end
                end
            end
            if isHeroCondition then
                listHero:Add(heroResource)
            end
        end
    end
    return listHero
end