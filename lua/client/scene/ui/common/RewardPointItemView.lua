--- @class RewardPointItemView : IconView
RewardPointItemView = Class(RewardPointItemView, IconView)

--- @return void
function RewardPointItemView:Ctor()
    ---@type ServerOpenProgress
    self.serverOpenProgress = nil
    self.target = nil
    ---@type boolean
    self.isUnlock = nil
    ---@type boolean
    self.isClaim = nil

    IconView.Ctor(self)
end

--- @return void
function RewardPointItemView:SetPrefabName()
    self.prefabName = 'event_rewarded_point'
    self.uiPoolType = UIPoolType.RewardPointItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function RewardPointItemView:SetConfig(transform)
    --- @type RewardPointItemConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
---@param serverOpenProgress ServerOpenProgress
function RewardPointItemView:SetIconData(serverOpenProgress)
    self.serverOpenProgress = serverOpenProgress
    self.id = serverOpenProgress.id
    self.target = serverOpenProgress.moneyData.quantity
    self.config.textEventPoint.text = ClientConfigUtils.FormatNumber(self.target)
end

--- @param target number
function RewardPointItemView:SetTarget(id, target)
    self.id = id
    self.target = target
    self.config.textEventPoint.text = ClientConfigUtils.FormatNumber(target)
end

--- @return void
---@param func function
function RewardPointItemView:AddListener(func)
    self.config.button.onClick:RemoveAllListeners()
    self.config.button.onClick:AddListener(function ()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        func()
    end)
end

---@param isUnlock boolean
---@param isClaim boolean
function RewardPointItemView:UpdateStateView(isUnlock, isClaim)
    self.isUnlock = isUnlock
    self.isClaim = isClaim
    if self.isUnlock == true then
        if self.isClaim == true then
            self.config.off:SetActive(false)
            self.config.on:SetActive(false)
            self.config.open:SetActive(true)
        else
            self.config.off:SetActive(false)
            self.config.on:SetActive(true)
            self.config.open:SetActive(false)
        end
    else
        self.config.off:SetActive(true)
        self.config.on:SetActive(false)
        self.config.open:SetActive(false)
    end
end

return RewardPointItemView