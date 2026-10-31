local DEFAULT_SIZE = U_Vector2(165, 165)

require "lua.client.scene.ui.common.UxMotionItem"

--- @class IconView : UIPrefabView
IconView = Class(IconView, UIPrefabView)

--- @return void
--- @param transform UnityEngine_RectTransform
function IconView:Ctor(transform)
    self.iconData = nil
    ---@type Dictionary
    self.effectPoolDict = Dictionary()
    ---@type List
    self.listPoolType = List()
    ---@type Dictionary
    self.uiPoolDict = Dictionary()
    UIPrefabView.Ctor(self, transform)
end

--- @return void
--- @param parent UnityEngine_RectTransform
function IconView:SetParent(parent)
    UIUtils.SetUIParent(self.config.transform, parent)
end

--- @return UnityEngine_RectTransform
--- @param poolType UIPoolType
--- @param isActive boolean
--- @param callbackActive function
--- @param parent UnityEngine_RectTransform
function IconView:ActiveUIPool(poolType, isActive, size, callbackActive, parent)
    if parent == nil then
        parent = self.config.transform
    end
    ---@type UnityEngine_RectTransform
    local effect = self.uiPoolDict:Get(poolType)
    if isActive == true then
        if effect == nil then
            effect = IconView._SpawnUIPool(poolType, parent)
            effect.localEulerAngles = U_Vector3.zero
            self.uiPoolDict:Add(poolType, effect)
        else
            effect:SetAsLastSibling()
        end
        if size ~= nil then
            effect.sizeDelta = size
        end
        effect.gameObject:SetActive(true)
        if callbackActive ~= nil then
            callbackActive(effect)
        end
        return effect
    elseif isActive == false and effect ~= nil then
        SmartPool.Instance:DespawnGameObject(AssetType.UIPool, poolType, effect)
        self.uiPoolDict:RemoveByKey(poolType)
        return nil
    end
end

--- @return UnityEngine_RectTransform
---@param poolType EffectPoolType
---@param isActive boolean
---@param callbackActive function
function IconView:ActiveEffectPool(poolType, isActive, size, callbackActive, parent)
    parent = parent or self.config.transform
    ---@type UnityEngine_RectTransform
    local effect = self.effectPoolDict:Get(poolType)
    if isActive == true then
        if effect == nil then
            effect = SmartPool.Instance:SpawnUIEffectPool(poolType, parent)
            effect.localEulerAngles = U_Vector3.zero
            self.effectPoolDict:Add(poolType, effect)
        end
        if size ~= nil then
            effect.sizeDelta = size
        end
        effect.gameObject:SetActive(true)
        if callbackActive ~= nil then
            callbackActive(effect)
        end
        return effect
    elseif isActive == false and effect ~= nil then
        SmartPool.Instance:DespawnUIEffectPool(poolType, effect)
        self.effectPoolDict:RemoveByKey(poolType)
        return nil
    end
end

--- @return UnityEngine_RectTransform
---@param poolType EffectPoolType
---@param isActive boolean
---@param callbackActive function
function IconView:ActiveMultiEffectPool(poolType, isActive, size, callbackActive, parent, number)
    if not number or number == 0 then
        return
    end
    if isActive then
        self.listPoolType:Add(poolType)
        self.listPoolType:SetItemAtIndex(poolType, 1)
        local count = 0
        for k, v in pairs(self.effectPoolDict:GetItems()) do
            if k == poolType then
                v.gameObject:SetActive(true)
                if callbackActive ~= nil then
                    callbackActive(v)
                end
                if size ~= nil then
                    v.sizeDelta = size
                end
                self.listPoolType:Add(v)
                count = count + 1
                if count >= number then
                    return
                end
            end
        end
        for i = count, number do
            local effect = SmartPool.Instance:SpawnUIEffectPool(poolType, parent)
            effect.localEulerAngles = U_Vector3.zero
            effect.gameObject:SetActive(true)
            if callbackActive ~= nil then
                callbackActive(effect)
            end
            if size ~= nil then
                effect.sizeDelta = size
            end
            self.listPoolType:Add(effect)
        end
        return
    else
        for _, v in pairs(self.listPoolType:GetItems()) do
            SmartPool.Instance:DespawnUIEffectPool(poolType, v)
        end
        self.listPoolType:Clear()
        self.effectPoolDict:RemoveByKey(poolType)
        return nil
    end
end

--- @return UnityEngine_RectTransform
---@param poolType UIPoolType
---@param isActive boolean
---@param callbackActive function
function IconView:ActiveUIPoolLastSibling(poolType, isActive, size, callbackActive)
    ---@param effect UnityEngine_RectTransform
    return self:ActiveUIPool(poolType, isActive, size, function(effect)
        effect:SetAsLastSibling()
        if callbackActive ~= nil then
            callbackActive(effect)
        end
    end)
end

--- @return UnityEngine_RectTransform
---@param poolType UIPoolType
---@param isActive boolean
---@param callbackActive function
function IconView:ActiveUIPoolFirstSibling(poolType, isActive, size, callbackActive)
    ---@param effect UnityEngine_RectTransform
    return self:ActiveUIPool(poolType, isActive, size, function(effect)
        effect:SetAsFirstSibling()
        if callbackActive ~= nil then
            callbackActive(effect)
        end
    end)
end

--- @return UnityEngine_RectTransform
---@param poolType EffectPoolType
---@param isActive boolean
---@param callbackActive function
function IconView:ActiveEffectPoolLastSibling(poolType, isActive, size, callbackActive)
    ---@param effect UnityEngine_RectTransform
    return self:ActiveEffectPool(poolType, isActive, size, function(effect)
        effect:SetAsLastSibling()
        if callbackActive ~= nil then
            callbackActive(effect)
        end
    end)
end

--- @return UnityEngine_RectTransform
---@param poolType EffectPoolType
---@param isActive boolean
---@param callbackActive function
function IconView:ActiveEffectPoolFirstSibling(poolType, isActive, size, callbackActive)
    ---@param effect UnityEngine_RectTransform
    return self:ActiveEffectPool(poolType, isActive, size, function(effect)
        effect:SetAsFirstSibling()
        if callbackActive ~= nil then
            callbackActive(effect)
        end
    end)
end

--- @return void
--- @param size UnityEngine_Vector2
function IconView:ActiveMaskSelect(isActive, size)
    --if isActive then
    --    print(debug.traceback())
    --end
    self:ActiveUIPoolLastSibling(UIPoolType.MaskSelected, isActive, size)
end

--- @return void
--- @param size UnityEngine_Vector2
function IconView:ActiveBorderTalent(isActive, size)
    self:ActiveUIPoolLastSibling(UIPoolType.BorderTalent, isActive, size)
end

--- @return void
--- @param hp number
function IconView:ActiveHpBar(hp)
    ---@type UnityEngine_UI_Image
    local hpBar = self:ActiveUIPoolLastSibling(UIPoolType.HpBar, hp ~= nil, nil)
    if hpBar ~= nil then
        hpBar = hpBar.transform:GetChild(0):GetChild(0):GetComponent(ComponentName.UnityEngine_UI_Image)
        hpBar.fillAmount = hp
    end
end

--- @return void
--- @param size UnityEngine_Vector2
function IconView:ActiveSkillSelect(isActive, size)
    self:SetActiveColor2(not isActive)
    self:ActiveUIPoolLastSibling(UIPoolType.SkillSelected, isActive, size)
end

--- @return void
--- @param size UnityEngine_Vector2
function IconView:ActiveTickSelect(isActive, size)
    self:SetActiveColor2(not isActive)
    self:ActiveUIPoolLastSibling(UIPoolType.TickSelected, isActive, size)
end

--- @return void
--- @param size UnityEngine_Vector2
function IconView:ActiveMaskClose(isActive, size)
    self:ActiveUIPoolLastSibling(UIPoolType.MaskClose, isActive, size)
end

--- @return void
--- @param size UnityEngine_Vector2
function IconView:ActiveSoftTut(isActive)
    self:ActiveUIPoolLastSibling(UIPoolType.SoftTut, isActive)
end

--- @return void
function IconView:ActiveMask(isActive, size)
    self:ActiveUIPoolLastSibling(UIPoolType.Mask, isActive, size)
end

--- @return void
function IconView:ActiveMaskLock(isActive, size)
    self:ActiveUIPoolLastSibling(UIPoolType.MaskLock, isActive, size)
end

--- @return void
function IconView:ActiveMaskLockMini(isActive, size)
    self:ActiveUIPoolLastSibling(UIPoolType.MaskLockMini, isActive, size)
end

--- @return void
function IconView:ActiveAdd(isActive, size)
    self:ActiveUIPoolLastSibling(UIPoolType.Add, isActive, size)
end

--- @return void
function IconView:ActiveEffectSelect(isActive)
    self:ActiveUIPool(UIPoolType.EffectSelected, isActive)
end

--- @return void
function IconView:ActiveEffectGlowItem(isActive)
    self:ActiveEffectPoolFirstSibling(EffectPoolType.EffectGlow, isActive)
end

--- @return void
function IconView:ActiveEffectHeroTraining(isActive)
    self:ActiveEffectPoolLastSibling(EffectPoolType.EffectHeroTraining, isActive)
end

--- @return void
function IconView:ActiveEffectSpin(isActive)
    self:ActiveEffectPoolLastSibling(EffectPoolType.EffectSpin, isActive)
end

--- @return void
function IconView:ActiveEffectRose(isActive)
    self:ActiveEffectPoolLastSibling(EffectPoolType.EffectRose, isActive)
end

--- @return void
function IconView:ActiveEffectExchange(isActive)
    self:ActiveEffectPoolLastSibling(EffectPoolType.EffectExchange, isActive)
end

--- @return void
function IconView:ActiveNotification(isActive)
    self:ActiveUIPoolLastSibling(UIPoolType.NotificationItem, isActive)
end

--- @return void
function IconView:ActiveEffectItemIcon(isActive)
    self:ActiveEffectPoolFirstSibling(EffectPoolType.ItemIconBottom, isActive)
    self:ActiveEffectPoolLastSibling(EffectPoolType.ItemIconTop, isActive)
end

--- @return void
function IconView:ActiveEffectHeroIcon(isActive)
    self:ActiveEffectPoolFirstSibling(EffectPoolType.SummonIconBottom, isActive)
    self:ActiveEffectPoolLastSibling(EffectPoolType.SummonIconTop, isActive)
end

--- @return void
function IconView:ActiveEffectHeroIconNormal(isActive)
    self:ActiveEffectPoolFirstSibling(EffectPoolType.SummonIconTopNormal, isActive)
end

--- @return void
function IconView:ActiveEffectHeroIconTierA(isActive)
    self:ActiveEffectPoolFirstSibling(EffectPoolType.SummonIconBottomTierA, isActive)
    self:ActiveEffectPoolLastSibling(EffectPoolType.SummonIconTopTierA, isActive)
end

--- @return void
function IconView:ActiveEffectVip2(isActive)
    self:ActiveEffectPoolFirstSibling(EffectPoolType.BlackSmithIconBottom1, isActive)
    self:ActiveEffectPoolLastSibling(EffectPoolType.ItemIconTop, isActive)
end

--- @return UnityEngine_RectTransform
function IconView:ActiveTimeCountDown(isActive)
    return self:ActiveUIPoolLastSibling(UIPoolType.TimeCountDown, isActive)
end

--- @return void
function IconView:ActiveEffectUnlock(isActive)
    self:ActiveEffectPoolFirstSibling(EffectPoolType.Unlock, isActive)
end

--- @return void
function IconView:ActiveEffectOpenCard(isActive)
    self:ActiveEffectPoolLastSibling(EffectPoolType.OpenCard, isActive)
end

--- @return void
function IconView:ActiveEffectUpgrade(isActive)
    self:ActiveEffectPoolLastSibling(EffectPoolType.Upgrade, isActive)
end

--- @return void
function IconView:ActiveEffectResetItem(isActive)
    self:ActiveEffectPoolLastSibling(EffectPoolType.ResetItem, isActive)
end

--- @return void
--- @param x number
--- @param y number
function IconView:SetSize(x, y)
    if x == nil or y == nil then
        self.config.transform.sizeDelta = DEFAULT_SIZE
        return
    end
    self.config.transform.sizeDelta = U_Vector2(x, y)
end

--- @return void
--- @param itemIconData ItemIconData
function IconView:SetIconData(itemIconData)
    --assert(iconData)
    --self.iconData = itemIconData
    --self:UpdateView()
    assert(false, "override this method")
end

--- @return void
---@param func function
function IconView:AddListener(func)
    --self.config.frame.raycastTarget = true
    --self.config.button.onClick:AddListener(func)
end

--- @return void
function IconView:RemoveAllListeners()

end

--- @return void
--- @param isEnabled boolean
function IconView:EnableButton(isEnabled)
    --self.config.button.interactable = isEnabled
    --self.config.frame.raycastTarget = isEnabled
end

--- @return void
function IconView:EnableRaycast(isEnabled)
    --self.config.frame.raycastTarget = isEnabled
end

--- @return void
function IconView:SetActiveColor(isActive)
    self:SetActiveColorObject(self.config.gameObject, isActive)
end

--- @return void
function IconView:SetActiveColorObject(gameObject, isActive)
    if isActive == false then
        self.isChangeMaterial = true
    end
    UIUtils.SetActiveColor(gameObject, isActive)
end

--- @return void
function IconView:SetActiveColor2(isActive)
    if isActive == false then
        self.isChangeMaterial = true
    end
    UIUtils.SetActiveColorByMaterial(self.config.gameObject, isActive, "ui_disable_mat")
end

--- @return void
function IconView:ReturnColor()
    if self.isChangeMaterial == true then
        self:SetActiveColor(true)
        self.isChangeMaterial = nil
    end
end

--- @return void
function IconView:ReturnPool()
    UIPrefabView.ReturnPool(self)
    self:RemoveAllListeners()
    ---@param poolType UIPoolType
    ---@param effect UnityEngine_RectTransform
    for poolType, effect in pairs(self.uiPoolDict:GetItems()) do
        SmartPool.Instance:DespawnGameObject(AssetType.UIPool, poolType, effect)
    end
    self.uiPoolDict:Clear()
    self:ClearEffectPoolDict()
    self:SetRate(nil)
    self:ReturnColor()
end

function IconView:ClearEffectPoolDict()
    for i = 2, self.listPoolType:Count() do
        SmartPool.Instance:DespawnUIEffectPool(self.listPoolType:Get(1), self.listPoolType:Get(i))
    end
    self.listPoolType:Clear()
    ---@param poolType EffectPoolType
    ---@param effect UnityEngine_RectTransform
    for poolType, effect in pairs(self.effectPoolDict:GetItems()) do
        SmartPool.Instance:DespawnUIEffectPool(poolType, effect)
    end
    self.effectPoolDict:Clear()
end

--function IconView:ClearEffectPoolDict()
--    ---@param poolType EffectPoolType
--    ---@param effect UnityEngine_RectTransform
--    for poolType, effect in pairs(self.effectPoolDict:GetItems()) do
--        SmartPool.Instance:DespawnUIEffectPool(poolType, effect)
--    end
--    self.effectPoolDict:Clear()
--end

--- @return void
function IconView:ShowInfo()
    assert(false, 'need override this method')
end

--- @return void
function IconView:SetRate(rate)
    self.rate = rate
end

--- @return void
function IconView:RegisterShowInfo()
    local showInfo = function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:ShowInfo()
    end
    self:RemoveAllListeners()
    self:AddListener(showInfo)
end

--- @return table
--- @param uiPoolType UIPoolType
--- @param parent UnityEngine_RectTransform
function IconView._SpawnUIPool(uiPoolType, parent)
    if uiPoolType == nil then
        assert(uiPoolType)
    end
    --- @type UnityEngine_RectTransform
    local ui = SmartPool.Instance:SpawnTransform(AssetType.UIPool, uiPoolType)
    UIUtils.SetUIParent(ui, parent)

    return ui
end

--- @return void
--- @param uiPoolType UIPoolType
--- @param rectTransform UnityEngine_RectTransform
function IconView.DespawnUIPool(uiPoolType, rectTransform)
    if uiPoolType == nil or rectTransform == nil then
        assert(uiPoolType and rectTransform)
    end
    --XDebug.Log("Despawn: " .. luaUI.uiPoolType .. " " .. luaUI:GetInstanceID())
    SmartPool.Instance:DespawnGameObject(AssetType.UIPool, uiPoolType, rectTransform)
end

return IconView
