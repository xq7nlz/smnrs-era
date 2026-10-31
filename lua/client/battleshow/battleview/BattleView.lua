--- @class BattleView
BattleView = Class(BattleView)
BattleView.minRatio = 1.333
BattleView.maxRatio = 2.165

BattleView.minScaler = 1
BattleView.maxScaler = 1.2

BattleView.mainViewSize = U_Vector2(9.65, 5)
BattleView.typeScaleMin = 1
BattleView.typeScaleMax = 2

BattleView.FIXED_BATTLE_VIEW_SIZE = 7.2

--- @param transform UnityEngine_Transform
function BattleView:Ctor(transform)
    --- @type BattleViewConfig
    self.config = UIBaseConfig(transform)

    --- @type string
    self.bgAnchorTopPrefabName = nil
    self.bgAnchorBotPrefabName = nil

    --- @type UnityEngine_Transform
    self.bgAnchorTop = nil
    self.bgAnchorBot = nil

    self.typeScale = BattleView.typeScaleMax

    --- @type DG_Tweening_Tweener
    self._shakeTweener = nil
    --- @type DG_Tweening_Tweener
    self._coverTweener = nil
end

--- @param bgAnchorTopPrefabName string
--- @param bgAnchorBotPrefabName string
function BattleView:ShowBgAnchor(bgAnchorTopPrefabName, bgAnchorBotPrefabName)
    self:DespawnBgAnchor()

    self.bgAnchorTopPrefabName = bgAnchorTopPrefabName
    self.bgAnchorTop = SmartPool.Instance:SpawnTransform(AssetType.Background, self.bgAnchorTopPrefabName)

    if bgAnchorBotPrefabName ~= nil then
        self.bgAnchorBotPrefabName = bgAnchorBotPrefabName
        self.bgAnchorBot = SmartPool.Instance:SpawnTransform(AssetType.Background, self.bgAnchorBotPrefabName)
    end
end

function BattleView:ShowBg(isShow)
    if self.bgAnchorTop ~= nil then
        self.bgAnchorTop.gameObject:SetActive(isShow)
    end
    if self.bgAnchorBot ~= nil then
        self.bgAnchorBot.gameObject:SetActive(isShow)
    end
end

function BattleView:AdjustBackgroundCameraSize()
    if self.bgAnchorTop ~= nil then
        self.bgAnchorTop.localScale = 1.3 * U_Vector3.one

        self.bgAnchorTop:SetParent(self.config.transform)
        self.bgAnchorTop.localPosition = U_Vector3.zero
        self.bgAnchorTop.gameObject:SetActive(true)
    end
    if self.bgAnchorBot ~= nil then
        self.bgAnchorBot.position = U_Vector3.down * BattleView.FIXED_BATTLE_VIEW_SIZE
        self.bgAnchorBot.localScale = self.bgAnchorTop.localScale
        self.bgAnchorBot:SetParent(self.config.transform)
        self.bgAnchorBot.gameObject:SetActive(true)
    end
end

function BattleView:AdjustMainCameraSize()
    local screenRatio = U_Screen.width / U_Screen.height
    local fixedViewRatio = BattleView.mainViewSize.x / BattleView.mainViewSize.y
    if (self.typeScale == BattleView.typeScaleMax and fixedViewRatio < screenRatio)
            or (self.typeScale == BattleView.typeScaleMin and fixedViewRatio > screenRatio) then
        self.config.mainCamera.orthographicSize = BattleView.mainViewSize.y
    else
        self.config.mainCamera.orthographicSize = BattleView.mainViewSize.x / screenRatio
    end
end

function BattleView:UpdateView()
    self:AdjustMainCameraSize()
    self:AdjustBackgroundCameraSize()
end

function BattleView:OnHide()
    self:DespawnBgAnchor()
    self:EnableMainCamera(false)
    ClientConfigUtils.KillTweener(self._coverTweener)
    self.config.battleCover.gameObject:SetActive(false)
    self:SetActive(false)
end

function BattleView:DespawnBgAnchor()
    if self.bgAnchorTop ~= nil then
        SmartPool.Instance:DespawnGameObject(AssetType.Background, self.bgAnchorTopPrefabName, self.bgAnchorTop)
        self.bgAnchorTop = nil
    end
    if self.bgAnchorBot ~= nil then
        SmartPool.Instance:DespawnGameObject(AssetType.Background, self.bgAnchorBotPrefabName, self.bgAnchorBot)
        self.bgAnchorBot = nil
    end
end

--- @param isEnable boolean
function BattleView:EnableMainCamera(isEnable)
    self.config.mainCamera.enabled = isEnable
end

--- @param isEnable boolean
function BattleView:EnableBgCamera(isEnable)
    self.bgCamera.enabled = isEnable
end

--- @param fixedLocalPos UnityEngine_Vector3
function BattleView:FixBackAnchorTopLocalPos(fixedLocalPos)
    self.bgAnchorTop.localPosition = fixedLocalPos
end

--- @param isActive boolean
function BattleView:SetActive(isActive)
    self.config.gameObject:SetActive(isActive)
end

--- @param shakeTable {duration, strengthX, strengthY, vibrato, randomness}
function BattleView:DoShakeCamera(shakeTable)
    ClientConfigUtils.KillTweener(self._shakeTweener)
    self.config.cameraTrans.position = U_Vector3(0, 0, self.config.cameraTrans.position.z)
    self._shakeTweener = self.config.cameraTrans:DOShakePosition(shakeTable[1], U_Vector3(shakeTable[2], shakeTable[3]), shakeTable[4], shakeTable[5])
end

--- @param coverDuration number
--- @param fadeInDuration number
--- @param fadeOutDuration number
--- @param coverAlpha number
--- @param onEndFadeIn function
--- @param onEndFade function
function BattleView:DoCoverBattle(coverDuration, fadeInDuration, fadeOutDuration, coverAlpha, onEndFadeIn, onEndFade)
    coverAlpha = coverAlpha or ClientConfigUtils.DEFAULT_COVER_ALPHA
    ClientConfigUtils.KillTweener(self._coverTweener)
    self._coverTweener = self.config.battleCover:DOFade(0, 0)
    self.config.battleCover.gameObject:SetActive(true)
    self._coverTweener = self.config.battleCover:DOFade(coverAlpha, fadeInDuration):OnComplete(function()
        if onEndFadeIn ~= nil then
            onEndFadeIn()
        end
        if self.config.battleCover == nil then
            return
        end
        self._coverTweener = self.config.battleCover:DOFade(0, fadeOutDuration):SetDelay(coverDuration):OnComplete(function()
            self.config.battleCover.gameObject:SetActive(false)
        end)                     :OnStart(function()
            if onEndFade ~= nil then
                onEndFade()
            end
        end)
    end)
end

--- @return UnityEngine_Vector3
--- @param position UnityEngine_Vector3
function BattleView:WorldToScreenPoint(position)
    return self.config.mainCamera:WorldToScreenPoint(position)
end

--- @return UnityEngine_Vector3
--- @param position UnityEngine_Vector3
function BattleView:ScreenToWorldPoint(position)
    return self.config.mainCamera:ScreenToWorldPoint(position)
end


--- @return UnityEngine_Camera
function BattleView:GetMainCamera()
    return self.config.mainCamera
end

return BattleView