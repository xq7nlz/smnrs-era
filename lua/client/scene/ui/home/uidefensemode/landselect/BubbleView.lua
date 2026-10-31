--- @class BubbleView
BubbleView = Class(BubbleView)

local U_Quaternion = UnityEngine.Quaternion

--- @return void
function BubbleView:Ctor()

    ---@type BubbleViewConfig
    self.config = nil
    self:InitConfig()
    self:InitButton()
end

--- @return void
function BubbleView:SetPrefabName()
    self.prefabName = 'bubble_view'
    self.uiPoolType = UIPoolType.BubbleView
end

function BubbleView:InitButton()
    self.config.recievedButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickRecieved()
    end)
end

function BubbleView:SetOnClickBubble(onClickBubble)
    self.onClickBubble = onClickBubble
end

function BubbleView:OnClickRecieved()
    if self.onClickBubble ~= nil and self.idleDefenseModeData ~= nil then
        self.onClickBubble(self.idleDefenseModeData.reward:GetKey())
    else
        XDebug.Log("!!!! BubbleView:OnClickRecieved(): onClickBubble or idleDefenseModeData null")
    end
end
function BubbleView:InitConfig()
    self:SetPrefabName()
    self.gameObject = SmartPool.Instance:CreateGameObject(AssetType.UIPool, self.prefabName)
    self:SetConfig(self.gameObject.transform)
end
--- @return void
--- @param transform UnityEngine_Transform
function BubbleView:SetConfig(transform)
    --- @type DailyRewardItemConfig
    self.config = UIBaseConfig(transform)
end

function BubbleView:SetParent(transform)
    self.config.transform:SetParent(transform)
    self.config.transform.localPosition = U_Vector3.zero
    --- @type UnityEngine_Quaternion
end
function BubbleView:SetRotationSingleBubble()
    self.config.transform.rotation = U_Quaternion.identity
end
function BubbleView:SetRotationManyBubble()
    self.config.transform.localRotation = U_Quaternion.identity
end
--- @param data IdleDefenseModeData
function BubbleView:SetBubbleView(data)
    self.idleDefenseModeData = data
    if self.idleDefenseModeData ~= nil then
        if data.reward.type == ResourceType.HeroFragment then
            self.config.rewardIcon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.heroFragmentCurrencies, data.reward.id % 10)
        elseif data.reward.type == ResourceType.EvolveFoodMaterial then
            self.config.rewardIcon.sprite = ResourceLoadUtils.LoadHeroFoodNoBorderIcon(data.reward.id)
        else
            self.config.rewardIcon.sprite = ResourceLoadUtils.LoadMoneyIcon(data.reward.id)
        end
        self.config.rewardIcon:SetNativeSize()
        self.config.rewardAmount.text = data:GetNumberReward()
    end
end

function BubbleView:UpdateBubbleView()
    if self.idleDefenseModeData ~= nil then
        self.config.bubbleFill.fillAmount = self.idleDefenseModeData:GetProgress(zg.timeMgr:GetServerTime())
        self.config.rewardAmount.text = self.idleDefenseModeData:GetNumberReward()
        local isFull = self.idleDefenseModeData:IsFull(zg.timeMgr:GetServerTime())
        if isFull then
            self.config.fxUiBubleFullReward.gameObject:SetActive(true)
        else
            self.config.fxUiBubleFullReward.gameObject:SetActive(false)
        end
    else
        XDebug.Log("LandElementView:UpdateBubbleTimeAndResource(): defense mode data null ")
    end
end

function BubbleView:SetEnable(isEnable)
    self.gameObject:SetActive(isEnable)
end


--- @return void
function BubbleView:ReturnPool()
    SmartPool.Instance:DespawnLuaGameObject(AssetType.UIPool, self.uiPoolType , self)
    self:SetEnable(false)
end

return BubbleView