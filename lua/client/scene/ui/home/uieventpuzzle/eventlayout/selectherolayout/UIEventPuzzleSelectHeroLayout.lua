require "lua.client.core.network.playerData.unknown.DictionaryOutBound"
--- @class UIEventPuzzleSelectHeroLayout : UIEventPuzzleLayout
UIEventPuzzleSelectHeroLayout = Class(UIEventPuzzleSelectHeroLayout, UIEventPuzzleLayout)

--- @param view UIEventPuzzleView
function UIEventPuzzleSelectHeroLayout:Ctor(view, tab, anchor)
    self.anchor = anchor
    self.tab = tab
    ---@type UIEventPuzzleSelectLayoutConfig
    self.layoutConfig = nil

    self.scrollHeroCard = nil
    --- @type OpCode
    self.opCode = nil
    --- @type ActionType
    self.actionType = nil
    --- @type Dictionary
    self.dictHeroItemPool = Dictionary()
    --- @type Dictionary
    self.dictHeroPool = Dictionary()
    --- @type Dictionary
    self.dictHeroItemSelected = Dictionary()
    --- @type List
    self.listHeroSelected = List()
    --- @type Dictionary
    self.dictHeroDefaultSelected = Dictionary()
    --- @type number
    self.amountDefaultHero = 1

    UIEventPuzzleLayout.Ctor(self, view, tab, anchor)
end

--- @param objectView UnityEngine_GameObject
function UIEventPuzzleSelectHeroLayout:InitLayoutConfig(objectView)
    local inst = PrefabLoadUtils.Instantiate("event_puzzle_select_hero_layout", self.anchor)
    UIEventPuzzleLayout.InitLayoutConfig(self, inst)

    self:InitButtons()
    self:InitData()
    self:InitHiddenCard()
    self:InitScroll()
    self:InitLocalization()
end

function UIEventPuzzleSelectHeroLayout:SetUpLayout()
    UIEventPuzzleLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventPuzzleSelectHeroLayout:InitData()
    self.dictHeroDefaultSelected = self.eventConfig:GetHeroSelectedDefault();
    self.dictHeroPool = self.eventConfig:GetHeroPool();
end

function UIEventPuzzleSelectHeroLayout:InitHiddenCard()
    --- @param obj HiddenCardItemView
    --- @param index number
    local onUpdateItem = function(obj, index)
        ---@type HeroResource
        if self.dictHeroDefaultSelected:IsContainKey(index + 1) then
            ---@type HeroResource
            local heroIdSelected = self.dictHeroDefaultSelected:Get(index + 1)
            if heroIdSelected then
                obj:SetHeroIdData(heroIdSelected)
                obj:AddListener(function()
                    SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("can_not_change_hero_this_slot"))
                end)
            end
        end
        if self.dictHeroSelected:IsContainKey(index + 1) then
            ---@type HeroResource
            local heroIdSelected = self.dictHeroSelected:Get(index + 1)
            if heroIdSelected then
                obj:SetHeroIdData(heroIdSelected)
            end
        end
    end

    --- @param obj HiddenCardItemView
    --- @param index number
    local onCreateItem = function(obj, index)
        onUpdateItem(obj, index)
        if index + 1 ~= 1 then
            obj:AddListener(function()
                self:SelectItem(index + 1)
            end)
            obj:SetActiveNotify(not self.dictHeroSelected:IsContainKey(index + 1))
        end
        if self.eventModel:IsCompletePuzzle() then
            obj:AddListener(function()
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("hero_puzzle_complete"))
            end)
            obj:SetActiveCompleteBackground(self.eventModel:IsCompletePuzzle())
        end
    end

    self.scrollHeroCard = UILoopScroll(self.layoutConfig.horizontalScroll, UIPoolType.HiddenCardItemView, onCreateItem, onUpdateItem)
end

--- @return void
--- @param slotId number
function UIEventPuzzleSelectHeroLayout:SelectItem(slotId)
    local data = {}
    if self.dictHeroItemPool:Get(slotId) == nil then
        local listItem = List()
        for i, heroId in ipairs(self.eventConfig:GetHeroPoolBySlotId(slotId):GetItems()) do
            listItem:Add(HeroIconData.CreateInstance(1, heroId, -1, -1))
        end
        self.dictHeroItemPool:Add(slotId, listItem)
    end
    
    data.listItem = self.dictHeroItemPool:Get(slotId)
    data.listItemSelect = self.eventModel.dictHeroItemSelected:Get(slotId)
    data.callbackSelect = function(listItemSelected)
        if listItemSelected:Count() >0 then
            self.eventModel.dictHeroItemSelected:Add(slotId, listItemSelected)
            for i, itemSelected in ipairs(listItemSelected:GetItems()) do
                self.dictHeroSelected:Add(slotId, itemSelected.heroId)
            end
            PopupMgr.HidePopup(UIPopupName.UISelectHeroPool)
            self.scrollHeroCard:Resize(self.dictHeroPool:Count())
        else
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("need_to_select"))
        end
    end
    PopupMgr.ShowPopup(UIPopupName.UISelectHeroPool, data)
end

function UIEventPuzzleSelectHeroLayout:InitScroll()
end

function UIEventPuzzleSelectHeroLayout:InitButtons()
    self.layoutConfig.buttonConfirm.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.CONFIRM)
        if self.dictHeroSelected:Count() < 3 then
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("need_fill_up_all_slot"))
        else
            PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("noti_confirm_select_puzzle"), nil, function()
                local onReceived = function(result)
                    --- @param buffer UnifiedNetwork_ByteBuf
                    local onBufferReading = function(buffer)
                        self:GetModelConfig()
                        self.eventModel.puzzleDataDict:Clear()
                        local listHeroIdString = ""
                        local size = buffer:GetByte()
                        for i = 1, size do
                            local slotId = buffer:GetInt()
                            local heroIdSelected = buffer:GetInt()
                            if i == size then
                                listHeroIdString = listHeroIdString .. tostring(heroIdSelected)
                            else
                                listHeroIdString = listHeroIdString .. tostring(heroIdSelected) .. ","
                            end
                            self.eventModel.puzzleDataDict:Add(slotId, PuzzlePieceOpenData.CreateInstance(heroIdSelected))
                        end
                        TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.EVENT_PUZZLE, listHeroIdString)

                        self.eventModel:UpdateCurrentPuzzleData()
                    end
                    local onSuccess = function()
                        self.eventModel.isConfirmed = true
                        self.view:SelectTab(EventPuzzleTab.PUZZLE)
                    end
                    NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
                end
                NetworkUtils.Request(OpCode.EVENT_PUZZLE_SELECT_HERO, DictionaryOutBound.CreateInstance(self.dictHeroSelected), onReceived)
            end)
        end
    end)
end

function UIEventPuzzleSelectHeroLayout:InitLocalization()
    self.layoutConfig.textConfirm.text = LanguageUtils.LocalizeCommon("confirm")
    self.layoutConfig.textFinishPuzzle.text = LanguageUtils.LocalizeCommon("event_puzzle_finished")
end

function UIEventPuzzleSelectHeroLayout:OnShow()
    UIEventPuzzleLayout.OnShow(self)
    self:OnShowData()
    self.scrollHeroCard:Resize(self.dictHeroPool:Count())
end

function UIEventPuzzleSelectHeroLayout:OnShowData()
    self.dictHeroSelected = self.eventModel.dictHeroSelected
    self.layoutConfig.buttonConfirm.gameObject:SetActive(not self.eventModel:IsCompletePuzzle())
    self.layoutConfig.textFinishPuzzle.gameObject:SetActive(self.eventModel:IsCompletePuzzle())
    self:InitLocalization()
end

function UIEventPuzzleSelectHeroLayout:OnHide()
    UIEventPuzzleLayout.OnHide(self)
    self.scrollHeroCard:Hide()
end