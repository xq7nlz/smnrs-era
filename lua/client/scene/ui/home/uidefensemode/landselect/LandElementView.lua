require "lua.client.scene.ui.home.uiDefenseMode.LandSelect.TagLand"
--- @class LandElementView
LandElementView = Class(LandElementView, MotionIconView)

function LandElementView:Ctor(transform, onClickLand, id, onClickBubble, hideEffect)
    --- @type LandViewConfig
    self.config = nil

    self.landId = id
    self.idleDefenseModeData = nil
    --- @type function
    ---
    self.uiTransform = transform

    self.callBackOnClickLand = onClickLand

    self.callBackOnClickBubble = onClickBubble

    self.hideEffect = hideEffect

    self.isUnlock = false

    self.bubbleList = List()
    self:InitConfig()
    self:InitButtons()
    self:InitLocalization()
    self:InitSprites()
end

function LandElementView:InitConfig()
    self.config = UIBaseConfig(self.uiTransform)
    self.tagBuilding = TagLand(self.config.tagBuilding)
end

function LandElementView:InitLocalization()
    self.tagBuilding:InitLocalize(self.landId)
end

function LandElementView:InitButtons()
    self.config.buttonPick.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickLand()
    end)
end

function LandElementView:InitSprites()
    self.config.landView.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.defenseModeLands, self.landId)
    self.config.highLight.sprite = self.config.landView.sprite
end

function LandElementView:SetUnlock(isUnlock, condition)
    self.condition = condition
    self.isUnlock = isUnlock
    local id = self.isUnlock and self.landId or nil
    self.tagBuilding:SetFeatureIcon(id)
    self.config.highLight.gameObject:SetActive(false)
end

function LandElementView:SetBubbleDisplay(isUnlock)
    self.config.bubbleContainer.gameObject:SetActive(isUnlock)
end

function LandElementView:SetActiveButton(isEnable)
    self.config.buttonPick.enabled = isEnable
end

function LandElementView:HideLand()
    self.config.hideSprite.enabled = true
    self:SetBubbleDisplay(false)
    if self.hideEffect ~= nil then
        self.hideEffect(self.landId)
    end
end

function LandElementView:OpenLand()
    self.config.hideSprite.enabled = not self.isUnlock
    self:SetBubbleDisplay(self.isUnlock)
    if self.hideEffect ~= nil then
        self.hideEffect(self.landId, self.isUnlock)
    end
end

function LandElementView:OnClickLand()
    if self.isSelectable == true then
        if self.isUnlock and self.callBackOnClickLand ~= nil then
            self.callBackOnClickLand(self.landId)
            self:SetBubbleDisplay(false)
        else
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            self.condition()
        end
    end
end
---@param data List<IdleDefenseModeData>
function LandElementView:SetDefenseModeData(data)
    self.bubbleList:Clear()
    self:ReturnPool()
    local check = data:Count() > 1
    for i = 1, data:Count() do
        local dataView = data:Get(i)
        --- @type BubbleView
        local bubble = SmartPool.Instance:SpawnLuaGameObject(AssetType.UIPool, UIPoolType.BubbleView)
        bubble:SetEnable(true)
        bubble:SetBubbleView(dataView)
        bubble:SetParent(self.config.bubbleContainer:GetChild(i - 1))
        bubble:SetOnClickBubble(function(key)
            self.callBackOnClickBubble(self.landId, key)
        end)
        if check then
            bubble:SetRotationManyBubble()
        else
            bubble:SetRotationSingleBubble()
        end
        self.bubbleList:Add(bubble)
    end
end

function LandElementView:UpdateBubbleTimeAndResource()
    for i = 1, self.bubbleList:Count() do
        ---@type BubbleView
        local bubble = self.bubbleList:Get(i)
        bubble:UpdateBubbleView()
    end
end

function LandElementView:ReturnPool()
    for i = 1, self.bubbleList:Count() do
        ---@type BubbleView
        local bubble = self.bubbleList:Get(i)
        bubble:ReturnPool()
    end
    self.bubbleList:Clear()
end

function LandElementView:OnPointerDown()
    self.isSelectable = true
    self.config.highLight.gameObject:SetActive(true)
end

function LandElementView:OnPointerUp()
    self.config.highLight.gameObject:SetActive(false)
end

function LandElementView:OnBeginDrag()
    self.isSelectable = false
    self:OnPointerUp()
end

return LandElementView