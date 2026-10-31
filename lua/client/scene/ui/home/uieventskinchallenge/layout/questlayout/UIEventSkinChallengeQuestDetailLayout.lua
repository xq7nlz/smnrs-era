--- @class UIEventSkinChallengeQuestDetailLayout
UIEventSkinChallengeQuestDetailLayout = Class(UIEventSkinChallengeQuestDetailLayout)

function UIEventSkinChallengeQuestDetailLayout:Ctor(view, anchor)
    --- @type UIEventSkinChallengeQuestLayout
    self.view = view
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type UIEventSkinChallengeQuestDetailLayoutConfig
    self.config = nil
    --- @type WorldSpaceHeroView
    self.worldSpaceHeroView = nil
    --- @type EventSkinChallengeModel
    self.eventModel = nil
    --- @type EventSkinChallengeConfig
    self.eventConfig = nil
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_SKIN_CHALLENGE
    --- @type ItemsTableView
    self.rewardTableView = nil
    self:GetModelConfig()
    self:InitLayoutConfig()
    self:InitButtonListener()
    --self:InitPreviewHero()
    self:DisablePreviewHero()
end

--- @param objectView UnityEngine_GameObject
function UIEventSkinChallengeQuestDetailLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("ui_event_skin_challenge_quest_detail_layout", self.anchor)
    UIUtils.SetParent(inst.transform, self.anchor)
    self.config = UIBaseConfig(inst.transform)
    self.anchor.gameObject:SetActive(false)
end

function UIEventSkinChallengeQuestDetailLayout:InitButtonListener()
    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

--- @return void
--- Create view for preview hero
function UIEventSkinChallengeQuestDetailLayout:InitPreviewHero()
    if self.eventModel.selectionId then
        if self.worldSpaceHeroView == nil then
            ---@type UnityEngine_Transform
            local trans = SmartPool.Instance:SpawnTransform(AssetType.Battle, "world_space_hero_view")
            self.worldSpaceHeroView = WorldSpaceHeroView(trans)
            local renderTexture = U_RenderTexture(800, 800, 24, U_RenderTextureFormat.ARGB32)
            self.config.rawImageHero.texture = renderTexture
            self.worldSpaceHeroView:Init(renderTexture)
        end
        self.heroResourcePreview = HeroResource()
    end
end

function UIEventSkinChallengeQuestDetailLayout:DisablePreviewHero()
    self.config.rawImageHero.gameObject:SetActive(false)
end

--- @return void
--- Add hero and background to view preview hero
function UIEventSkinChallengeQuestDetailLayout:ShowPreviewHero()
    local skinId = self.eventConfig:GetSkinIdBySelectionId(self.eventModel.selectionId)
    if skinId then
        self.heroResourcePreview:SetData(-1, ClientConfigUtils.GetHeroIdBySkinId(skinId), 1, 1)
        self.heroResourcePreview.heroItem:Add(HeroItemSlot.SKIN, self.eventConfig:GetSkinIdBySelectionId(self.eventModel.selectionId))

        self.worldSpaceHeroView:ShowHero(self.heroResourcePreview)
        self.worldSpaceHeroView.config.transform.position = U_Vector3(99000, 99000, 0)
        if self.worldSpaceHeroView ~= nil then
            self.worldSpaceHeroView.config.bg:SetActive(false)
        end
    else
        if self.worldSpaceHeroView ~= nil then
            self.worldSpaceHeroView.config.gameObject:SetActive(false)
        end
    end
end

--- @param eventPopupModel EventPopupModel
function UIEventSkinChallengeQuestDetailLayout:OnShow(data)
    self.view.layoutConfig.buttonBundle.gameObject:SetActive(false)
    self.view.layoutConfig.buttonExchange.gameObject:SetActive(false)
    self:GetModelConfig()
    self:SyncLocalization()
    --self:InitPreviewHero()
    --self:ShowPreviewHero()
    self:ShowPreviewReward(data.listRewardPreview)
    self:SetStateReward(data.rewardState)
    self:UpdateListQuest(data)
    self:InitMoneyBar()
    self.anchor.gameObject:SetActive(true)
end

function UIEventSkinChallengeQuestDetailLayout:InitMoneyBar()
    if self.moneyBarView == nil then
        self.moneyBarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.config.moneyAnchor)
        self.moneyBarView:SetIconData(MoneyType.SKIN_BADGE)
    end
end

function UIEventSkinChallengeQuestDetailLayout:ReturnPoolMoneyBar()
    if self.moneyBarView ~= nil then
        self.moneyBarView:ReturnPool()
        self.moneyBarView = nil
    end
end

function UIEventSkinChallengeQuestDetailLayout:UpdateListQuest(data)
    self.questDataInBound = zg.playerData:GetQuest()
    --- @param questUnitInBound QuestUnitInBound
    for i, questUnitInBound in ipairs(data.listQuestData:GetItems()) do
        if questUnitInBound ~= nil then
            local mainReq = questUnitInBound.config:GetMainRequirementTarget()
            local number = questUnitInBound.number
            if questUnitInBound.config:GetQuestType() == QuestType.DAILY_QUEST_COMPLETE then
                local totalHiddenQuest = self.questDataInBound.newDailyQuestInBound:GetTotalDailyHiddenQuest()
                local totalAvailableQuest = self.questDataInBound.newDailyQuestInBound:GetTotalDailyAvailableQuest()
                questUnitInBound.config:OverrideMainReq(totalAvailableQuest - 1)
                number = questUnitInBound.number - totalHiddenQuest
                mainReq = questUnitInBound.config:GetMainRequirementTarget()
            end
            local color = UIUtils.green_light
            local textObject = self.config.listQuest:GetChild(i - 1)
            textObject.gameObject:SetActive(true)

            if data.rewardState >= RewardState.AVAILABLE_TO_CLAIM then
                textObject:GetComponent(ComponentName.UnityEngine_UI_Text).text = string.format("%s: <color=#%s>%s</color>", LanguageUtils.LocalizeQuestDescription(questUnitInBound.questId, questUnitInBound.config), color, LanguageUtils.LocalizeCommon("completed"))
            else
                textObject:GetComponent(ComponentName.UnityEngine_UI_Text).text = string.format("%s: <color=#%s>%d/%d</color>", LanguageUtils.LocalizeQuestDescription(questUnitInBound.questId, questUnitInBound.config), color, number, mainReq)
            end
        end
    end
end

function UIEventSkinChallengeQuestDetailLayout:OnClickBackOrClose()
    self.view:UpdateListChallengeNode()
    self:OnHide()
end

function UIEventSkinChallengeQuestDetailLayout:ShowPreviewReward(listRewardPreview)
    if self.rewardTableView == nil then
        self.rewardTableView = ItemsTableView(self.config.rewardAnchor)
    end
    self.rewardTableView:SetData(listRewardPreview)
end

function UIEventSkinChallengeQuestDetailLayout:SetStateReward(rewardState)
    if rewardState == RewardState.CLAIMED then
        self.rewardTableView:ActiveMaskSelect(true, UIUtils.sizeItem)
        self.config.textClaim.text = LanguageUtils.LocalizeCommon("claimed")
        UIUtils.SetActiveColorByMaterial(self.config.buttonClaim.gameObject, false, "ui_disable_mat")
    else
        self.rewardTableView:ActiveMaskSelect(false)
        self.config.textClaim.text = LanguageUtils.LocalizeCommon("claim")
        UIUtils.SetActiveColorByMaterial(self.config.buttonClaim.gameObject, true, "ui_disable_mat")
    end
end

function UIEventSkinChallengeQuestDetailLayout:OnHide()
    if self.worldSpaceHeroView ~= nil then
        self.worldSpaceHeroView:OnHide()
        self.worldSpaceHeroView = nil
    end

    if self.rewardTableView then
        self.rewardTableView:Hide()
    end
    self:ReturnPoolMoneyBar()
    self.anchor.gameObject:SetActive(false)
    self.config.textQuest1.gameObject:SetActive(false)
    self.config.textQuest2.gameObject:SetActive(false)
    self.config.textQuest3.gameObject:SetActive(false)
    self.view.layoutConfig.buttonBundle.gameObject:SetActive(true)
    self.view.layoutConfig.buttonExchange.gameObject:SetActive(true)
end

function UIEventSkinChallengeQuestDetailLayout:GetModelConfig()
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    if self.eventModel ~= nil then
        self.eventConfig = self.eventModel:GetConfig()
    end
end

function UIEventSkinChallengeQuestDetailLayout:SyncLocalization()
    self.config.textEventTittle.text = LanguageUtils.LocalizeCommon("title_event_skin_challenge")
    self.config.textRequirementUnlock.text = LanguageUtils.LocalizeCommon("requirement")
end

function UIEventSkinChallengeQuestDetailLayout:AddClaimListener(func)
    self.config.buttonClaim.onClick:RemoveAllListeners()
    self.config.buttonClaim.onClick:AddListener(function()
        func()
    end)
end

return UIEventSkinChallengeQuestDetailLayout