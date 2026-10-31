--- @class UIEventBirthdayDarkLightVersusLayout : UIEventBirthdayLayout
UIEventBirthdayDarkLightVersusLayout = Class(UIEventBirthdayDarkLightVersusLayout, UIEventBirthdayLayout)

--- @param view UIEventNewYearView
--- @param newYearTab LunarNewYearTab
--- @param anchor UnityEngine_RectTransform
function UIEventBirthdayDarkLightVersusLayout:Ctor(view, tab, anchor)
    --- thay type bằng type config của từng layout
    --- @type BirthdayDarkLightVersusLayoutConfig
    self.layoutConfig = nil
    UIEventBirthdayLayout.Ctor(self ,view, tab, anchor)
    --- thay op code neu co
    self.opCode = OpCode.EVENT_BIRTHDAY_SELECT_SIDE
    --- @type boolean
    self.isLightSide = false
    --- @type List -- HeroIconNodeView
    self.listHeroNodes = List()

    self.listChainNode = nil

    self.listRewardInfo = List()
end

function UIEventBirthdayDarkLightVersusLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("birthday_dark_light_versus", self.anchor)
    UIEventBirthdayLayout.InitLayoutConfig(self, inst)
    self:InitButtonListener()
    self:InitLocalization()
end

function UIEventBirthdayDarkLightVersusLayout:SetUpLayout()
    UIEventBirthdayLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventBirthdayDarkLightVersusLayout:OnShow()
    UIEventBirthdayLayout.OnShow(self)
    self:CheckDarkOrLight()
    self:UpdateProgressQuestBar()
    self:UpdateDarkLightPointBar()
    self:InitHeroNodes()
    self:UpdateNotification()
end

function UIEventBirthdayDarkLightVersusLayout:InitButtonListener()
    self.layoutConfig.buttonClaim.onClick:RemoveAllListeners()
    self.layoutConfig.buttonClaim.onClick:AddListener(function()
        self:ClaimQuest()
    end)
    self.layoutConfig.bgCoverReward.onClick:AddListener( function()
        self:HideReward()
    end)
end

function UIEventBirthdayDarkLightVersusLayout:InitLocalization()
    self.layoutConfig.textClaim.text = LanguageUtils.LocalizeCommon("claim")
end

function UIEventBirthdayDarkLightVersusLayout:CheckDarkOrLight()
    self.isLightSide = self.eventModel.selectSideId == HeroFactionType.LIGHT

    if self.isLightSide then
        self.selectionId = 1
        self.listChainNode = self.layoutConfig.listLightChainNode
    else
        self.selectionId = 2
        self.listChainNode = self.layoutConfig.listDarkChainNode
    end

    self.layoutConfig.listLightChainNode.gameObject:SetActive(self.isLightSide)
    self.layoutConfig.bgLight:SetActive(self.isLightSide)

    self.layoutConfig.bgDark:SetActive(not self.isLightSide)
    self.layoutConfig.listDarkChainNode.gameObject:SetActive(not self.isLightSide)
end

function UIEventBirthdayDarkLightVersusLayout:UpdateProgressQuestBar()
    local questUnitInBound  = self:GetCurrentQuest()
    local currentPoint = InventoryUtils.Get(ResourceType.Money, MoneyType.EVENT_BIRTHDAY_RIVAL_POINT)
    local targetPoint = questUnitInBound.config:GetMainRequirementTarget()
    self.layoutConfig.barProgressPercent.fillAmount = currentPoint / targetPoint
    self.layoutConfig.textProgressPercent.text = currentPoint  .."/" .. targetPoint
    self.layoutConfig.iconMoneyProgress.sprite = ResourceLoadUtils.LoadMoneyIcon(MoneyType.EVENT_BIRTHDAY_RIVAL_POINT)
end

function UIEventBirthdayDarkLightVersusLayout:CalculateRateRelativeDarkLight()
    if self.eventModel.seasonLightRivalPoint == self.eventModel.seasonDarkRivalPoint and self.eventModel.seasonLightRivalPoint == 0 then
        return 0.5
    end
    local targetPoint = self.eventModel.seasonLightRivalPoint + self.eventModel.seasonDarkRivalPoint
    local rate = self.eventModel.seasonLightRivalPoint / targetPoint
    rate = rate > 0.8 and 0.8 or rate
    rate = rate < 0.2 and 0.2 or rate
    return rate
end

function UIEventBirthdayDarkLightVersusLayout:UpdateDarkLightPointBar()
    local fillAmount = self:CalculateRateRelativeDarkLight()
    self.layoutConfig.barLightProgressPercent.fillAmount = fillAmount

    self.layoutConfig.barLightProgressPercentHeader.anchorMin = U_Vector2(fillAmount, 0.5)
    self.layoutConfig.barLightProgressPercentHeader.anchorMax = U_Vector2(fillAmount, 0.5)

    self.layoutConfig.textLightProgressPercent.text = string.format("%s: %s", LanguageUtils.LocalizeCommon("light"), self.eventModel.seasonLightRivalPoint)
    self.layoutConfig.textDarkProgressPercent.text = string.format("%s: %s", LanguageUtils.LocalizeCommon("dark"), self.eventModel.seasonDarkRivalPoint)

    self.layoutConfig.textLightProgressPercent.rectTransform.anchorMin = U_Vector2(fillAmount/2, 0.5)
    self.layoutConfig.textLightProgressPercent.rectTransform.anchorMax = U_Vector2(fillAmount/2, 0.5)

    self.layoutConfig.textDarkProgressPercent.rectTransform.anchorMin = U_Vector2( (1 - fillAmount)/2 + fillAmount, 0.5)
    self.layoutConfig.textDarkProgressPercent.rectTransform.anchorMax = U_Vector2( (1 - fillAmount)/2 + fillAmount, 0.5)
    end

function UIEventBirthdayDarkLightVersusLayout:InitHeroNodes()
    for i = 1, self.listChainNode.childCount do
        ---@type HeroIconNodeView
        local node = HeroIconNodeView(self.listChainNode:GetChild(i-1))
        self.listHeroNodes:Add(node)
        local listHeroId = self.eventConfig:GetListHeroNodeConfig(self.selectionId)
        node.config.imageIconHero.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconHeroCards, string.format("hero_icon_%s_%s", listHeroId:Get(i), 1))
        node.config.buttonHeroIcon.onClick:AddListener(function()
            self:ShowReward(node.config.transform.position, i)
        end)
    end
    self:UpdateHeroNodes()
end


function UIEventBirthdayDarkLightVersusLayout:UpdateHeroNodes()
    --- @param node HeroIconNodeView
    for i, node in ipairs(self.listHeroNodes:GetItems()) do
        --- @type QuestUnitInBound
        local currentQuestUnitInBound = self.eventModel.listQuestData:Get(i)
        --- @type QuestUnitInBound
        local previousQuestUnitInBound = self.eventModel.listQuestData:Get(i-1)
        if currentQuestUnitInBound.questState == QuestState.DOING or currentQuestUnitInBound.questState == QuestState.DONE_REWARD_NOT_CLAIM then
            if previousQuestUnitInBound ~= nil and previousQuestUnitInBound.questState == QuestState.COMPLETED then
                node:EnableNextNodeHighlight()
            elseif i == 1 then
                node:EnableNextNodeHighlight()
            else
                node:DisableNodeHighlight()
            end
        elseif currentQuestUnitInBound.questState == QuestState.COMPLETED then
            node:EnableNodeHighlight()
        end
    end
end

function UIEventBirthdayDarkLightVersusLayout:SendRequestClaimQuest()
    --- @param rewardList List
    local onClaimSuccess = function(rewardList)
        PopupUtils.ClaimAndShowRewardList(rewardList)
        self:FinishStateCurrentQuest()
        self:UpdateHeroNodes()
        self:UpdateProgressQuestBar()
        self:UpdateNotification()
    end
    QuestDataInBound.RequestClaimQuest(OpCode.EVENT_BIRTHDAY_DARK_LIGHT_QUEST, self:GetCurrentQuest().questId, onClaimSuccess)
end

function UIEventBirthdayDarkLightVersusLayout:UpdateNotification()
    self.layoutConfig.notiClaim:SetActive(self.eventModel:IsDarkLightTabHasNotification())
    self.view:CheckAllNotificationTab()
end

function UIEventBirthdayDarkLightVersusLayout:ClaimQuest()
    self:SendRequestClaimQuest()
end

function UIEventBirthdayDarkLightVersusLayout:GetCurrentQuest()
    for i = 1, self.eventModel.listQuestData:Count() do
        --- @type QuestUnitInBound
        local questUnitInBound = self.eventModel.listQuestData:Get(i)
        if questUnitInBound.questState == QuestState.DOING or questUnitInBound.questState == QuestState.DONE_REWARD_NOT_CLAIM then
            return questUnitInBound
        end
    end
    return self.eventModel.listQuestData:Get(self.eventModel.listQuestData:Count())
end

function UIEventBirthdayDarkLightVersusLayout:FinishStateCurrentQuest()
    for i = 1, self.eventModel.listQuestData:Count() do
        --- @type QuestUnitInBound
        local questUnitInBound = self.eventModel.listQuestData:Get(i)
        if questUnitInBound.questState == QuestState.DONE_REWARD_NOT_CLAIM or questUnitInBound.questState == QuestState.DOING then
            questUnitInBound.questState = QuestState.COMPLETED
            return
        end
    end
end

function UIEventBirthdayDarkLightVersusLayout:ShowReward(position, questId)
    --if posId > 1000 then
    self:HideReward()
    --- @type QuestUnitInBound
    local  questUnit = self.eventModel.listQuestData:Get(questId)
    local listReward = questUnit.config:GetListReward()
    local xSize
    ---@param v RewardInBound
    for _, v in ipairs(listReward:GetItems()) do
        --- @type RootIconView
        local item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.layoutConfig.bgListReward)
        item:SetIconData(v:GetIconData())
        item:RegisterShowInfo()
        xSize = item.iconView.config.transform.sizeDelta.x
        self.listRewardInfo:Add(item)
    end

    self.layoutConfig.bgListReward.sizeDelta = U_Vector2(xSize * listReward:Count() + 10,self.layoutConfig.bgListReward.sizeDelta.y)
    self.layoutConfig.iconSelect.position = position
    self.layoutConfig.iconSelect.gameObject:SetActive(true)
    self.layoutConfig.bgCoverReward.gameObject:SetActive(true)
    --else
    -- self:HideReward()
    --end
end

function UIEventBirthdayDarkLightVersusLayout:HideReward()
    ---@param v IconView
    for _, v in pairs(self.listRewardInfo:GetItems()) do
        v:ReturnPool()
    end
    self.listRewardInfo:Clear()
    self.layoutConfig.iconSelect.gameObject:SetActive(false)
    self.layoutConfig.bgCoverReward.gameObject:SetActive(false)
end


function UIEventBirthdayDarkLightVersusLayout:OnHide()
    UIEventBirthdayLayout.OnHide(self)
    self:HideReward()
    if self.listHeroNodes ~= nil then
        self.listHeroNodes:Clear()
    end
end
