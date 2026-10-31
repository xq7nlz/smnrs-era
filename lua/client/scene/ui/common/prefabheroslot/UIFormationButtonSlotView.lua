--- @class UIFormationButtonSlotView
UIFormationButtonSlotView = Class(UIFormationButtonSlotView)

--- @return void
--- @param uiTransform UnityEngine_RectTransform
--- @param index number
function UIFormationButtonSlotView:Ctor(uiTransform, index)
    --- @type {gameObject, rectTransform : UnityEngine_RectTransform, button : UnityEngine_UI_Button, image : UnityEngine_UI_Image}
    self.config = nil
    --- @type UnityEngine_UI_Image
    self.image = nil
    --- @type number
    self.index = index
    --- @type number
    self.heroIndex = nil
    --- @type HeroIconView
    self.iconView = nil
    --- @type Vector2
    self.deltaPos = nil
    --- @type function
    self.onSelectSlot = nil

    self:_SetConfig(uiTransform)
    self:_ResetPosHeroInfo()
end

--- @return void
--- @param uiTransform UnityEngine_RectTransform
function UIFormationButtonSlotView:_SetConfig(uiTransform)
    self.config = {}
    self.config.rectTransform = uiTransform
    --- @type UnityEngine_UI_Button
    self.config.button = uiTransform:GetComponent(ComponentName.UnityEngine_UI_Button)
    --- @type UnityEngine_UI_Image
    self.config.image = uiTransform:GetComponent(ComponentName.UnityEngine_UI_Image)
    self.config.image.color = U_Color(1,1,1,0)
    self.config.image.raycastTarget = false
end

--- @return void
function UIFormationButtonSlotView:OnDisabled()
    UIUtils.SetInteractableButton(self.config.button, false)
    self.config.image.raycastTarget = false
    self.heroData = nil
    self.heroIndex = nil
    if self.iconView ~= nil then
        self.iconView:ReturnPool()
        self.iconView = nil
    end
end

--- @return void
--- @param uiPoolType UIPoolType
--- @param heroIndex number
--- @param heroBattleInfo HeroBattleInfo
--- @param position UnityEngine_Vector3
function UIFormationButtonSlotView:SpawnHeroIcon(uiPoolType, heroIndex, heroBattleInfo, position, isShowHp)
    self.heroIndex = heroIndex
    self.iconView = SmartPool.Instance:SpawnLuaUIPool(uiPoolType, self.config.rectTransform)
    local iconData = (uiPoolType == UIPoolType.HeroIconView)
            and HeroIconData.CreateByHeroBattleInfo(heroBattleInfo)
            or DungeonBindingHeroInBound.CreateByHeroBattleInfo(heroBattleInfo)
    self.iconView:SetIconData(iconData)
    if isShowHp == true and heroBattleInfo.startState ~= nil then
        self.iconView:ActiveHpBar(heroBattleInfo.startState.hpPercent)
    end
    self.iconView:EnableButton(false)
    self.iconView:DefaultShow()

    local icon = self.iconView.config.transform

    if position ~= nil then
        icon.position = position
        icon:DOMove(self.config.rectTransform.position, 0.2):OnComplete(function()
            UIUtils.SetInteractableButton(self.config.button, true)
        end)
    else
        icon.localPosition = U_Vector3.zero
        UIUtils.SetInteractableButton(self.config.button, true)
    end
end

--- @return void
--- @param position UnityEngine_Vector3
function UIFormationButtonSlotView:RemoveIcon(position, onFinish)
    if self.iconView ~= nil then
        UIUtils.SetInteractableButton(self.config.button, false)
        self.iconView.config.transform:SetParent(uiCanvas.config.uiPopup)
        local remove = function ()
            self.iconView:ReturnPool()
            self.iconView = nil
            if onFinish ~= nil then
                onFinish()
            end
        end
        if position ~= nil then
            DOTweenUtils.DOMove(self.iconView.config.transform, position, 0.2, U_Ease.Linear, remove)
        else
            remove()
        end
    end
end

--- @return void
function UIFormationButtonSlotView:_ResetPosHeroInfo()
    if self.iconView ~= nil then
        UIUtils.SetInteractableButton(self.config.button, true)
        self.iconView.config.transform:SetParent(self.config.rectTransform)
        self.iconView.config.transform.localPosition = U_Vector3.zero
    else
        UIUtils.SetInteractableButton(self.config.button, false)
    end
end

--- @param onSelectSlot function
function UIFormationButtonSlotView:SetOnSelectSlotCallback(onSelectSlot)
    self.onSelectSlot = onSelectSlot
    self:EnableRaycast(onSelectSlot ~= nil)
end

--- @param enable BondCreatedResult
function UIFormationButtonSlotView:EnableRaycast(enable)
    self.config.image.raycastTarget = enable
end