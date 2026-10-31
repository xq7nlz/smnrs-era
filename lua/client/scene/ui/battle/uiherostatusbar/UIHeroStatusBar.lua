--- @class UIHeroStatusBar
UIHeroStatusBar = Class(UIHeroStatusBar)

--- @param transform UnityEngine_Transform
function UIHeroStatusBar:Ctor(transform)
    --- @type UIHeroStatusBarConfig
    self.config = UIBaseConfig(transform)
    --- @type UnityEngine_Vector2
    self.originHealthSize = self.config.healthBarRect.sizeDelta

    self._tweenHealth = nil
    self._tweenPower = nil

    self._maxVisibleIcon = 4
    self._tweenDuration = 0.15
    self._offsetSortingOrder = 100

    --- @type UnityEngine_GameObject
    self.fxPower = nil

    --- @type boolean
    self.isBossType = false

    --- @type number
    self.lastHealthRate = nil

    self:InitDefaultIcon()
end

function UIHeroStatusBar:InitCanvas(renderingMode, camera)
    renderingMode = renderingMode or UnityEngine.RenderMode.WorldSpace
    camera = camera or UnityEngine.Camera.main

    self.config.canvas.renderMode = renderingMode
    self.config.canvas.worldCamera = camera
end

--- @param clientHero ClientHero
function UIHeroStatusBar:SetTarget(clientHero)
    self.config.transform.position = clientHero.components:GetAnchorPosition(ClientConfigUtils.HEAD_ANCHOR)
    self.config.transform:SetParent(clientHero.gameObject.transform)

    local baseHero = clientHero.baseHero
    self.fxPower = self.config.fxPower
    self.isBossType = baseHero.isBoss
    self.config.redHealthBar.gameObject:SetActive(self.isBossType == true)

    if baseHero.isBoss == false then
        self.config.bgHealthBar.sizeDelta = U_Vector2(130, 13)
        self.config.bgPowerBar.sizeDelta = U_Vector2(130, 8)
        self._maxVisibleIcon = 4
    else
        self.config.bgHealthBar.sizeDelta = U_Vector2(212, 13)
        self.config.bgPowerBar.sizeDelta = U_Vector2(212, 8)
        self.fxPower = self.config.fxPowerBoss
        self._maxVisibleIcon = 6
    end
    self.originHealthSize = self.config.bgHealthBar.sizeDelta - U_Vector2(3, 3)
    self.config.healthBarRect.sizeDelta = U_Vector2(self.originHealthSize.x, self.originHealthSize.y)
    if self.config.redHealthBar.gameObject.activeSelf == true then
        self.config.redHealthBar.sizeDelta = U_Vector2(self.originHealthSize.x, self.originHealthSize.y)
    end
    self.config.transform.localScale = 0.01 * U_Vector3.one
    self.config.transform.localEulerAngles = U_Vector3.zero
end

--- @param level number
--- @param factionId number
function UIHeroStatusBar:InitStatusBar(level, factionId)
    self.config.levelText.text = tostring(level)
    self.config.factionBorder.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.formationNumber, factionId)
    self:SetActive(true)
    self.config.redHealthBar.gameObject:SetActive(self.isBossType == true)
end

--- @param healthRate number
function UIHeroStatusBar:InitHealth(healthRate)
    if self.isBossType == true then
        self.lastHealthRate = healthRate
        local showHealth
        --- @type UnityEngine_RectTransform
        local showHealthBar = self.config.redHealthBar
        self.config.redHealthBar.gameObject:SetActive(true)
        self.config.healthBarRect.gameObject:SetActive(healthRate >= 0.5)

        if healthRate >= 0.5 then
            self.config.redHealthBar.sizeDelta = U_Vector2(self.originHealthSize.x, self.originHealthSize.y)
            showHealth = (healthRate - 0.5) * 2
            showHealthBar = self.config.healthBarRect
        else
            showHealth = healthRate * 2
        end
        showHealthBar.sizeDelta = U_Vector2(showHealth * self.originHealthSize.x, self.originHealthSize.y)
    else
        self.config.healthBarRect.sizeDelta = U_Vector2(healthRate * self.originHealthSize.x, self.originHealthSize.y)
    end
end

--- @param healthRate number
function UIHeroStatusBar:UpdateHealth(healthRate)
    ClientConfigUtils.KillTweener(self._tweenHealth)
    if self.isBossType == true then
        local showHealthRate = healthRate * 2
        if showHealthRate < 0.015 and showHealthRate > 0 then
            showHealthRate = 0.015
        end

        local showHealthBar = self.config.redHealthBar
        if (healthRate >= 0.5 and self.lastHealthRate >= 0.5)
                or (healthRate < 0.5 and self.lastHealthRate < 0.5) then
            if healthRate >= 0.5 then
                showHealthBar = self.config.healthBarRect
                showHealthRate = (healthRate - 0.5) * 2
            end
            local targetSize = U_Vector2(showHealthRate * self.originHealthSize.x, self.originHealthSize.y)
            self._tweenHealth = DOTweenUtils.DOSizeDelta(showHealthBar, targetSize, self._tweenDuration)
        elseif healthRate >= 0.5 and self.lastHealthRate < 0.5 then
            if healthRate >= 0.5 then
                showHealthRate = (healthRate - 0.5) * 2
            end
            local targetSize = U_Vector2(self.originHealthSize.x, self.originHealthSize.y)
            self._tweenHealth = DOTweenUtils.DOSizeDelta(self.config.redHealthBar, targetSize, self._tweenDuration / 2, function()
                self.config.healthBarRect.sizeDelta = U_Vector2(0, self.originHealthSize.y)
                self.config.healthBarRect.gameObject:SetActive(true)

                targetSize = U_Vector2(showHealthRate * self.originHealthSize.x, self.originHealthSize.y)
                self._tweenHealth = DOTweenUtils.DOSizeDelta(self.config.healthBarRect, targetSize, self._tweenDuration / 2)
            end)
        elseif healthRate < 0.5 and self.lastHealthRate >= 0.5 then
            local targetSize = U_Vector2(0, self.originHealthSize.y)
            self._tweenHealth = DOTweenUtils.DOSizeDelta(self.config.healthBarRect, targetSize, self._tweenDuration / 2, function()
                self.config.healthBarRect.gameObject:SetActive(false)
                targetSize = U_Vector2(showHealthRate * self.originHealthSize.x, self.originHealthSize.y)
                self._tweenHealth = DOTweenUtils.DOSizeDelta(self.config.redHealthBar, targetSize, self._tweenDuration / 2)
            end)
        end
        self.lastHealthRate = healthRate
    else
        if healthRate < 0.03 and healthRate > 0 then
            healthRate = 0.03
        end

        local targetSize = U_Vector2(healthRate * self.originHealthSize.x, self.originHealthSize.y)
        self._tweenHealth = DOTweenUtils.DOSizeDelta(self.config.healthBarRect, targetSize, self._tweenDuration)
    end
end

--- @param powerRate number
--- @param useTween boolean
function UIHeroStatusBar:UpdatePower(powerRate, useTween)
    ClientConfigUtils.KillTweener(self._tweenPower)
    if useTween == true then
        self._tweenPower = DOTweenUtils.DOFillAmount(self.config.powerBarImage, powerRate, self._tweenDuration, function()
            self.fxPower:SetActive(self.config.powerBarImage.fillAmount == 1)
            self._tweenPower = nil
        end)
    else
        self.config.powerBarImage.fillAmount = powerRate
        if self.fxPower ~= nil then
            self.fxPower:SetActive(powerRate == 1)
        end
    end
end

--- @param isActive boolean
function UIHeroStatusBar:SetActive(isActive)
    self.config.gameObject:SetActive(isActive)
end

--- @param battleEffectIcon UIBattleEffectIcon
function UIHeroStatusBar:AddEffectIcon(battleEffectIcon)
    battleEffectIcon:SetParent(self.config.effectBarRect)
    battleEffectIcon.config.transform.localScale = U_Vector3(1, 1, 1)
    battleEffectIcon:SetActive(true)
end

--- @param uiBattleMarkIcon UIBattleMarkIcon
function UIHeroStatusBar:AddMarkEffectIcon(uiBattleMarkIcon)
    uiBattleMarkIcon:SetParent(self.config.markBarRect)
    uiBattleMarkIcon.config.transform.localScale = U_Vector3(1, 1, 1)
    uiBattleMarkIcon:SetActive(true)
end

function UIHeroStatusBar:UpdateStatusBar()
    local totalEffectIcon = self.config.effectBarRect.childCount - 1
    --if totalEffectIcon > self._maxVisibleIcon then
    --    self.config.overStackIcon:SetAsLastSibling()
    --    self.config.overStackIcon:ShowOverStack(totalEffectIcon - self._maxVisibleIcon + 1)
    --    self.config.overStackIcon:SetActive(false)
    --
    --    for i = self._maxVisibleIcon, totalEffectIcon - 1 do
    --        self.config.effectBarRect:GetChild(i).gameObject:SetActive(false)
    --    end
    --else
    --    self.config.overStackIcon:SetActive(false)
    --end
    for i = 0, totalEffectIcon - 1 do
        self.config.effectBarRect:GetChild(i).gameObject:SetActive(i < self._maxVisibleIcon)
    end
end

--- @param pos UnityEngine_Vector3
function UIHeroStatusBar:SetPosition(pos)
    self.config.transform.position = pos
end

function UIHeroStatusBar:InitDefaultIcon()
    self.effectIconByIndexDict = Dictionary()
    local childCount = self.config.effectBarRect.childCount
    if childCount > 0 then
        for i = 1, childCount do
            local anchor = self.config.effectBarRect:GetChild(i - 1)
            local battleEffectIcon = UIBattleEffectIcon(anchor)
            self.effectIconByIndexDict:Add(i, battleEffectIcon)
            battleEffectIcon:SetActive(false)
        end
    else
        for i = 1, ClientConfigUtils.MAX_EFFECT_ICON_ON_STATUS_BAR do
            local battleEffectIcon = zg.battleEffectMgr:GetUIBattleEffectIcon()
            self:AddEffectIcon(battleEffectIcon)
            battleEffectIcon:SetActive(false)
            self:SetIconAtIndex(i, battleEffectIcon)
        end
    end
end

function UIHeroStatusBar:SetIconAtIndex(index, battleEffectIcon)
    if battleEffectIcon ~= nil and self.effectIconByIndexDict:IsContainKey(index) == false then
        self.effectIconByIndexDict:Add(index, battleEffectIcon)
    end
end

function UIHeroStatusBar:UpdateIconAtIndex(index, id, stack)
    --- @type UIBattleEffectIcon
    local icon = self.effectIconByIndexDict:Get(index)
    if id ~= nil and icon ~= nil then
        id = tonumber(id)
        local isBuff = id % 10
        if isBuff == 1 then
            isBuff = true
        else
            isBuff = false
        end
        local effectLogType = math.floor(id / 10)
        icon:ShowIcon(effectLogType, isBuff)
        icon:SetStack(stack)
        icon:SetAsFirstSibling()
        icon:SetActive(true)
    elseif id == nil and icon ~= nil then
        icon:ShowIcon(nil)
        icon:ShowOverStack(stack)
        icon:SetAsLastSibling()
        icon:SetActive(true)
    end
end

function UIHeroStatusBar:EnableIconAtIndex(index, isEnable)
    --- @type UIBattleEffectIcon
    local icon = self.effectIconByIndexDict:Get(index)
    if icon ~= nil then
        icon:SetActive(isEnable)
    end
end

function UIHeroStatusBar:HideAllIcon()
    --- @param v UIBattleEffectIcon
    for k, v in pairs(self.effectIconByIndexDict:GetItems()) do
        v:SetActive(false)
    end
end