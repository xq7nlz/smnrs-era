--- @class UIFreeGemOptionView
UIFreeGemOptionView = Class(UIFreeGemOptionView)

--- @return void
--- @param transform UnityEngine_Transform
function UIFreeGemOptionView:Ctor(transform)
    --- @type UnityEngine_GameObject
    self.gameObject = transform.gameObject
    --- @type UnityEngine_Transform
    self.transform = transform.transform
    self.gameObject:SetActive(true)

    --- @type UnityEngine_UI_Text
    self.textTitle = self.transform:Find("text_title"):GetComponent(ComponentName.UnityEngine_UI_Text)
    --- @type UIBarPercentView
    self.rectPercent = UIBarPercentView(self.transform:Find("content/Layout/bar_percent"))
    self.rectPercent.maxSize = 1080
    --- @type UnityEngine_UI_Text
    self.textDetails = self.transform:Find("text_details"):GetComponent(ComponentName.UnityEngine_UI_Text)
    --- @type UnityEngine_Transform
    self.bonusItem = self.transform:Find("bonusItem")
    --- @type UnityEngine_UI_Button
    self.buttonClaim = self.transform:Find("content/Layout/bg_button_green"):GetComponent(ComponentName.UnityEngine_UI_Button)
    --- @type UnityEngine_UI_Text
    self.textClaim = self.buttonClaim.transform:Find("text_register"):GetComponent(ComponentName.UnityEngine_UI_Text)
    --- @type UnityEngine_RectTransform
    self.rewardsTrans = self.transform:Find("content/Layout/Rewards"):GetComponent(ComponentName.UnityEngine_RectTransform)
    --- @type List<RootIconView>
    self.rewardItems = List()
    self.chestBtn = nil
    self.chestTick = nil
    self.videoData = nil
    self.rewardConfig = nil
    self.rewards = nil
end

--- @return void
function UIFreeGemOptionView:Init()
    self.textTitle.text = LanguageUtils.LocalizeCommon("free_gem_title")
    self.textDetails.text = LanguageUtils.LocalizeCommon("free_gem_details")
    self.textClaim.text = LanguageUtils.LocalizeCommon("confirm")
    self.buttonClaim.onClick:RemoveAllListeners()
    self.buttonClaim.onClick:AddListener(function()
        self:Claim()
    end)

    self.max = self.rewardsTrans.childCount

    --- @type VideoRewardedInBound
    self.videoData = zg.playerData:GetMethod(PlayerDataMethod.REWARD_VIDEO)
    self.rewardConfig = ResourceMgr.GetVideoRewardedConfig()
    self.rewards = self.rewardConfig:Init()
    self:UpdateView()

    if self.rewardConfig.dataAB == 1 then
        self.chestBtn = self.transform:Find("content/Layout/Rewards/6/Chest")
        self.chestTick = self.chestBtn:GetChild(0).gameObject
        --- @type UnityEngine_UI_Button
        self.chestBtn = self.chestBtn:GetComponent(ComponentName.UnityEngine_UI_Button)
        if self.chestBtn ~= nil then
            self.chestBtn.onClick:RemoveAllListeners()
            self.chestBtn.onClick:AddListener(function()
                self:PreviewChest()
            end)
        end
    end
end

--- @return void
function UIFreeGemOptionView:Claim()
    VideoRewardedUtils.SetType(0)
    VideoRewardedUtils.SetAction(function()
        self:UpdateView()
    end)
    IapDataInBound.Validate(function()
        if VideoRewardedUtils.AllowSkipVideo() then
            TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.MAIN_FEATURES, "watch_video", 0)
            VideoRewardedUtils.RequestToServer()
        else
            VideoRewardedUtils.OpenRewarded(AdsPlacement.DAILY_GEM_POPUP)
        end
    end)
end

--- @return void
function UIFreeGemOptionView:InitItems()
    local nextReward = nil
    if self:IsFull() then
        nextReward = self.rewardConfig:GetPrize(self.videoData.numberVideoView):Get(1)
    else
        nextReward = self.rewardConfig:GetPrize(self.videoData.numberVideoView + 1):Get(1)
    end
    if self.prevItem == nil then
        ---@type RootIconView
        self.prevItem = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.bonusItem)
    end
    --- @type RewardInBound
    local dataItem = ItemIconData.CreateInstance(
            nextReward.type, nextReward.id,
            nextReward.number)
    self.prevItem:SetIconData(dataItem)
    self.prevItem:RegisterShowInfo()

    if self.rewardItems:Count() == 0 then
        local posY = 100
        local maxSize = self.rewardsTrans.rect.size
        for i = 1, self.max do
            if i == 6 then
                break
            end
            local checkPoint = self.rewardsTrans:GetChild(i - 1)
            local pointRect = checkPoint:GetComponent(ComponentName.UnityEngine_RectTransform)
            local posX = (i / self.max) * maxSize.x - (self.rewardConfig.dataAB == 1 and 50 or 100)
            pointRect.anchoredPosition = U_Vector2(posX, 0)

            ---@type RootIconView
            local item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, checkPoint)
            item.config.rectTransform.anchoredPosition = U_Vector2(0, posY)

            --- @type List<RewardInBound>
            local res = self.rewards:Get(i)
            if res == nil then
                break
            end
            --- @type RewardInBound
            res = res:Get(1)
            if res ~= nil then
                item:SetIconData(ItemIconData.CreateInstance(res.type, res.id, res.number))
                item:RegisterShowInfo()
            end

            self.rewardItems:Add(item)
        end
    end
end

--- @return void
function UIFreeGemOptionView:UpdateView()
    self:InitItems()

    if self:IsFull() then
        self.rectPercent:SetPercent(1)
    elseif self.videoData.numberVideoView == 0 then
        self.rectPercent:SetPercent(0)
    else
        --- @type UnityEngine_RectTransform
        local checkPoint = self.rewardsTrans:GetChild(self.videoData.numberVideoView - 1)
                :GetComponent(ComponentName.UnityEngine_RectTransform)
        self.rectPercent.rectPercent.sizeDelta = U_Vector2(checkPoint.anchoredPosition.x,
                self.rectPercent.rectPercent.sizeDelta.y)
    end
    self:UpdateCheckPoint()

    for i = 1, self.rewardItems:Count() do
        --- @type RootIconView
        local item = self.rewardItems:Get(i)
        item:ActiveUIPool(UIPoolType.MaskSelected, i <= self.videoData.numberVideoView)
    end

    local canClick = not self:IsFull()
    self.buttonClaim.interactable = canClick
    UIUtils.SetActiveColor(self.buttonClaim.gameObject, canClick)
    if self.chestTick ~= nil then
        self.chestTick:SetActive(not canClick)
    end
end

--- @return void
function UIFreeGemOptionView:PreviewChest()
    local data = {}
    data.current = self.videoData.numberVideoView
    data.max = self.max
    data.rewardList = List()
    local dataChest = {}
    dataChest['res_type'] = 2
    dataChest['res_id'] = 1
    dataChest['res_number'] = 100
    data.rewardList:Add(RewardInBound.CreateByParams(dataChest))
    data.price = 0
    data.callbackMove = function()
        PopupMgr.HidePopup(UIPopupName.UIRewardPreview)
        self:OnClickMove()
    end
    PopupMgr.ShowPopup(UIPopupName.UIRewardPreview, data)
end

--- @return boolean
function UIFreeGemOptionView:IsFull()
    if self.videoData.numberVideoView == self.rewardConfig:GetLimit() then
        return true
    else
        return self.videoData.numberVideoView == self.max
    end
end

--- @return void
function UIFreeGemOptionView:UpdateCheckPoint()
    for i = 1, self.max do
        local checkPoint = self.rewardsTrans:GetChild(i - 1)
        checkPoint:GetChild(0).gameObject:SetActive(i <= self.videoData.numberVideoView)
    end
    self.prevItem:ActiveUIPool(UIPoolType.MaskSelected, self:IsFull())
end

--- @return void
function UIFreeGemOptionView:Hide()
    if self.prevItem ~= nil then
        self.prevItem:ReturnPool()
        self.prevItem = nil
    end
    if self.rewardItems:Count() > 0 then
        for i = 1, self.rewardItems:Count() do
            self.rewardItems:Get(i):ReturnPool()
        end
        self.rewardItems = List()
    end
end