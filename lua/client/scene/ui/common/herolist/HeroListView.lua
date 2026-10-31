require "lua.client.scene.ui.utils.uiSelect.UISelectCustomSprite"

--- @class HeroListView
HeroListView = Class(HeroListView)

--- @return void
--- @param transform UnityEngine_Transform
function HeroListView:Ctor(transform)
    ---@type HeroListConfig
    self.config = UIBaseConfig(transform)

    ----------------Formation Sort ----------------

    --- @type List <number>
    self.heroInUseList = List()
    --- @type List
    self.heroResourceList = nil
    --- @type number
    self.currentFactionSort = 0
    --- @type function
    self.onCreateItem = nil
    --- @type function
    self.onUpdateItem = nil
    --- @type function
    self.buttonListener = nil
    --- @type function
    self.filterConditionOr = nil
    --- @type function
    self.filterConditionAnd = nil
    --- @type function
    self.filterFactionCondition = nil
    --- @type function
    self.filterStarCondition = nil

    --- @type UISelect
    self.factionSort = nil
    --- @type UISelect
    self.starSort = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    ---@type boolean
    self.showClass = false

    self:_CreateFormationHero()
    self:_CreateSortButton()
    self:InitLocalizes()
end
function HeroListView:InitLocalizes()
    if self.config.textEmpty ~= nil then
        self.config.textEmpty.text = LanguageUtils.LocalizeCommon("empty")
    end
end
--- @return void
--- @param buttonListener function (index, HeroIconView, HeroResource)
--- @param filterConditionOr function
--- @param filterConditionAnd function
--- @param filterFactionCondition function
--- @param filterStarCondition function
--- @param onCreateItem function (index, HeroIconView, HeroResource)
--- @param onUpdateItem function (index, HeroIconView, HeroResource)
function HeroListView:Init(buttonListener, filterConditionOr, filterConditionAnd, filterFactionCondition, filterStarCondition, onCreateItem, onUpdateItem)
    self.onCreateItem = onCreateItem or nil
    self.onUpdateItem = onUpdateItem or nil
    self.buttonListener = buttonListener
    self.filterConditionOr = filterConditionOr
    self.filterConditionAnd = filterConditionAnd
    self.filterFactionCondition = filterFactionCondition
    self.filterStarCondition = filterStarCondition
    if self.filterFactionCondition == nil then
        --- @return boolean
        --- @param heroIndex number
        --- @param faction number
        ---@param heroResource HeroResource
        self.filterFactionCondition = function(heroIndex, faction, heroResource)
            local factionId = ClientConfigUtils.GetFactionIdByHeroId(heroResource.heroId)
            if faction == nil or factionId == faction then
                return true
            end
            return false
        end
    end
    if self.filterStarCondition == nil then
        --- @return boolean
        --- @param heroIndex number
        --- @param star number
        ---@param heroResource HeroResource
        self.filterStarCondition = function(heroIndex, star, heroResource)
            if star == nil or star == heroResource.heroStar then
                return true
            end
            return false
        end
    end
end

--- @return List UIFormationButtonHero
function HeroListView:GetHeroList()
    return self.uiScroll.dict:GetItems()
end

--- @return void
--- @param heroResourceList List <HeroResource>
function HeroListView:SetData(heroResourceList, canPlayMotion, sortFaction, sortStar)
    self.canPlayMotion = canPlayMotion or false
    self.heroResourceList = heroResourceList
    self.factionSort:Select(sortFaction or 1)
    if self:IsStarBottom() then
        self.starSort:Select(sortStar or 1)
    else
        self.starSort:Select(sortStar)
    end
    self:_FilterHero()
end

--- @return void
function HeroListView:IsStarBottom()
    return self.config.star2 ~= nil and self.config.star2.gameObject.activeSelf
end

--- @return void
function HeroListView:ReturnPool()
    self.uiScroll:Hide()
    self.showClass = false
end

------------------- Formation Hero ----------------------------------------
--- @return void
function HeroListView:_CreateFormationHero()
    --- @param obj HeroIconView
    --- @param index number
    local onUpdateItem = function(obj, index)
        --- @type number
        local heroIndex = self.heroInUseList:Get(index + 1)
        ---@type HeroResource
        local heroResource = self.heroResourceList:Get(heroIndex)
        --- @type IconView
        local data = HeroIconData.CreateByHeroResource(heroResource)
        obj:SetIconData(data)
        if self.showClass then
            obj:ShowClassHero()
        end
        if self.onUpdateItem ~= nil then
            self.onUpdateItem(heroIndex, obj, heroResource)
        end
    end
    --- @param obj HeroIconView
    --- @param index number
    local onCreateItem = function(obj, index)
        --- @type number
        local heroIndex = self.heroInUseList:Get(index + 1)
        ---@type HeroResource
        local heroResource = self.heroResourceList:Get(heroIndex)
        obj.heroIndex = heroIndex
        obj:AddListener(function()
            if self.buttonListener ~= nil then
                self.buttonListener(heroIndex, obj, heroResource)
            end
        end)
        if self.onCreateItem ~= nil then
            self.onCreateItem(heroIndex, obj, heroResource)
        end
        onUpdateItem(obj, index)
    end

    self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.HeroIconView, onCreateItem, onUpdateItem)
    self.uiScroll:SetUpMotion(MotionConfig(0, 0, 0, 0.01))
end

------------------- Formation Sort ----------------------------------------

--- @return void
function HeroListView:_CreateSortButton()
    -- Select faction
    --- @param obj UnityEngine_UI_Button
    --- @param isSelect boolean
    local onSelect = function(obj, isSelect, indexTab)
        if obj ~= nil then
            UIUtils.SetInteractableButton(obj, not isSelect)
            if isSelect then
                self.config.selectFaction.gameObject:SetActive(true)
                self.config.selectFaction.transform:SetParent(obj.transform)
                self.config.selectFaction.transform.localPosition = U_Vector3.zero
            end
        end
    end

    local onChangeSelectFaction = function(indexTab, lastTab)
        self:_FilterHero()
    end
    self.factionSort = UISelectFactionFilter(self.config.faction, nil, onSelect, nil, onChangeSelectFaction)
    self.factionSort:SetSprite()

    -- Select star
    ---@type UnityEngine_Transform
    local star = nil
    ---@type UnityEngine_Transform
    local starSelect = nil
    if self:IsStarBottom() then
        star = self.config.star2
        starSelect = self.config.selectStar2
    else
        star = self.config.star
        starSelect = self.config.selectStar
    end

    local onChangeSelectStar = function(indexTab)
        if indexTab == nil then
            starSelect.gameObject:SetActive(false)
        else
            starSelect.gameObject:SetActive(true)
            starSelect.transform.position = star:GetChild(indexTab - 1).position
        end
    end
    local onClickSelectStar = function(indexTab)
        self:_FilterHero()
    end
    self.starSort = UISelect(star, nil, nil, onChangeSelectStar, onClickSelectStar)

    self.config.buttonSortStar.onClick:AddListener(function()
        self.config.buttonCloseSortStar.gameObject:SetActive(true)
        self.config.star.parent.gameObject:SetActive(true)
    end)
    self.config.buttonCloseSortStar.onClick:AddListener(function()
        self.config.buttonCloseSortStar.gameObject:SetActive(false)
        self.config.star.parent.gameObject:SetActive(false)
    end)
end

--- @return void
function HeroListView:ActiveSortStar(isActive)
    self.config.starSort:SetActive(isActive)
end

--- @return void
function HeroListView:CheckEmpty(count)
    if self.config.empty ~= nil then
        self.config.empty:SetActive(count <= 0)
    end
end

--- @return void
function HeroListView:_FilterHero()
    self:_FilterHeroDataBase()
    self.uiScroll:Resize(self.heroInUseList:Count())
    self:CheckEmpty(self.heroInUseList:Count())
    if self.canPlayMotion == true then
        self.uiScroll:PlayMotion()
        self.canPlayMotion = false
    end
end

--- @return void
function HeroListView:_FilterHeroDataBase()
    self.heroInUseList:Clear()
    local faction = self.factionSort.indexTab
    if faction ~= nil and faction > 1 then
        faction = faction - 1
    else
        faction = nil
    end
    local star = self.starSort.indexTab
    if self:IsStarBottom() then
        if star ~= nil and star > 1 then
            star = star - 1
        else
            star = nil
        end
    end
    --- @param heroResource HeroResource
    for heroIndex, heroResource in ipairs(self.heroResourceList:GetItems()) do
        if (self.filterConditionOr ~= nil and self.filterConditionOr(heroIndex, heroResource)) or
                ((self.filterConditionAnd == nil or self.filterConditionAnd(heroIndex, heroResource)) and
                        (self.filterFactionCondition == nil or self.filterFactionCondition(heroIndex, faction, heroResource)) and
                        (self.filterStarCondition == nil or self.filterStarCondition(heroIndex, star, heroResource))) then
            self.heroInUseList:Add(heroIndex)
        end
    end
end