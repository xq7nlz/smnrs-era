--- @class SeasonalSummerGameSelectHero : MotionIconView
SeasonalSummerGameSelectHero = Class(SeasonalSummerGameSelectHero, MotionIconView)

--- @return void
function SeasonalSummerGameSelectHero:Ctor(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type SeasonalSummerGameSelectHeroConfig
    self.config = UIBaseConfig(transform)
    ---@type List
    self.rewardItem = List()
    ---@type WorldSpaceHeroView
    self.worldSpaceHeroView = nil
end

---@param func function
function SeasonalSummerGameSelectHero:SelectHeroListener(func)
    self.config.buttonSelectHero.onClick:RemoveAllListeners()
    self.config.buttonSelectHero.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if func then
            func()
        end
    end)
    self.config.buttonReselectHero.onClick:RemoveAllListeners()
    self.config.buttonReselectHero.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if func then
            func()
        end
    end)
end

---@param func function
function SeasonalSummerGameSelectHero:JoinListener(func)
    self.config.buttonJoin.onClick:RemoveAllListeners()
    self.config.buttonJoin.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if func then
            func()
        end
    end)
end

function SeasonalSummerGameSelectHero:InitLocalization()
    self.config.textSelectHero.text = LanguageUtils.LocalizeCommon("select_hero")
end

function SeasonalSummerGameSelectHero:InitButtonLocalization(text)
    self.config.textJoin.text = text
end


---@param rewardState RewardState
function SeasonalSummerGameSelectHero:SetData(rewardState, callbackSelect, callbackJoin)
    self:InitLocalization()
    self:SetRewardState(rewardState)
    self:SelectHeroListener(callbackSelect)
    self:JoinListener(callbackJoin)
end

---@param rewardState RewardState
function SeasonalSummerGameSelectHero:SetRewardState(rewardState)
    self.config.noti:SetActive(rewardState == RewardState.AVAILABLE_TO_CLAIM)
    UIUtils.SetActiveColorByMaterial(self.config.buttonJoin.gameObject, rewardState ~= RewardState.CLAIMED, "ui_gray_mat")
    self.config.buttonJoin.gameObject:SetActive(rewardState ~= RewardState.CLAIMED)
    if rewardState == RewardState.NOT_AVAILABLE_TO_CLAIM then

    elseif rewardState == RewardState.AVAILABLE_TO_CLAIM then
        self.config.textJoin.text = LanguageUtils.LocalizeCommon("claim")
    elseif rewardState == RewardState.CLAIMED then
        self.config.textJoin.text = LanguageUtils.LocalizeCommon("claimed")
        self:JoinListener(function()
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("claimed"))
        end)
    end
end

function SeasonalSummerGameSelectHero:EnableStateSelectHero(isEnable)
    self.config.objSelectHero:SetActive(isEnable)
    self.config.buttonSelectHero.gameObject:SetActive(isEnable)
    self.config.rawImage.gameObject:SetActive(not isEnable)
    self.config.buttonReselectHero.gameObject:SetActive(not isEnable)
end

function SeasonalSummerGameSelectHero:ShowHero(heroId)
    self:EnableStateSelectHero(false)
    if heroId then
        if self.worldSpaceHeroView == nil then
            ---@type UnityEngine_Transform
            local trans = SmartPool.Instance:SpawnTransform(AssetType.Battle, "world_space_hero_view")
            self.worldSpaceHeroView = WorldSpaceHeroView(trans)
            local renderTexture = U_RenderTexture(800, 800, 24, U_RenderTextureFormat.ARGB32)
            self.config.rawImage.texture = renderTexture
            self.worldSpaceHeroView:Init(renderTexture)
        end
        local heroResource = HeroResource()
        heroResource:SetData(-1, heroId, 1, 1)
        self.worldSpaceHeroView:ShowHero(heroResource)
        self.worldSpaceHeroView.config.transform.position = U_Vector3(heroId, 99000, 0)
        if self.worldSpaceHeroView ~= nil then
            self.worldSpaceHeroView.config.bg:SetActive(false)
        end
    else
        self:EnableStateSelectHero(true)
        self:ReturnPoolHero()
    end
end

function SeasonalSummerGameSelectHero:ReturnPoolHero()
    if self.worldSpaceHeroView ~= nil then
        self.worldSpaceHeroView:OnHide()
        self.worldSpaceHeroView = nil
    end
end

function SeasonalSummerGameSelectHero:ReturnPool()
    self.config.textJoin.text = LanguageUtils.LocalizeCommon("join")
    self:EnableStateSelectHero(true)
    self:ReturnPoolHero()
end

return SeasonalSummerGameSelectHero