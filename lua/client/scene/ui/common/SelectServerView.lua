---COMMENT_CONFIG_COMMON    require "lua.client.scene.ui.common.SelectServerConfig"

--- @class SelectServerView : IconView
SelectServerView = Class(SelectServerView, IconView)

SelectServerView.prefabName = 'select_server'

--- @return void
function SelectServerView:Ctor(component)
    IconView.Ctor(self)
    ---@type number
    self.clusterId = nil
    ---@type PlayerServerData
    self.playerServerData = nil
    ---@type VipIconView
    self.heroIconVIew = nil
end

--- @return void
function SelectServerView:InitLocalization()
    self.config.textNew.text = LanguageUtils.LocalizeCommon("new")
end

--- @return void
function SelectServerView:SetPrefabName()
    self.prefabName = 'select_server'
    self.uiPoolType = UIPoolType.SelectServerView
end

--- @return void
--- @param transform UnityEngine_Transform
function SelectServerView:SetConfig(transform)
    assert(transform)
    --- @type SelectServerConfig
    ---@type SelectServerConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
function SelectServerView:ReturnPool()
    IconView.ReturnPool(self)
    self:RemoveAvatar()
end

--- @return void
---@param func function
function SelectServerView:AddListener(func)
    self:EnableButton(true)
    self.config.button.onClick:AddListener(func)
end

--- @return void
function SelectServerView:RemoveAllListeners()
    self.config.button.onClick:RemoveAllListeners()
end

--- @return void
--- @param isEnabled boolean
function SelectServerView:EnableButton(isEnabled)
    UIUtils.SetInteractableButton(self.config.button, isEnabled)
end

--- @return void
function SelectServerView:SetPlayerServerData(playerServerData)
    self.playerServerData = playerServerData
    self.clusterId = zg.playerData:GetServerListInBound():GetCluster(self.playerServerData.serverId)

    if self.playerServerData.serverId == PlayerSettingData.serverId then
        --- @type BasicInfoInBound
        local basicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
        self.playerServerData.playerName = basicInfoInBound.name
        --self.playerServerData.playerAvatar = basicInfoInBound.avatarData:GetMyPlayerAvatar()
        self.playerServerData.avatarData = playerServerData.avatarData
        self.playerServerData.playerLevel = basicInfoInBound.level
        self:ActiveCurrent(true)
    else
        self:ActiveCurrent(false)
    end

    self.config.textNameServer.text = string.format("S%s", self.clusterId)

    if self.heroIconVIew == nil then
        self.heroIconVIew = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.VipIconView, self.config.avatarTuong)
    end
    self.heroIconVIew:SetData2(self.playerServerData.avatarData:GetOtherPlayerAvatar(), self.playerServerData.playerLevel)
    self.config.textNameUser.gameObject:SetActive(true)
    self.config.textNameUser.text = self.playerServerData.playerName
    self.config.new:SetActive(false)
end

--- @return void
---@param clusterId number
function SelectServerView:SetClusterId(clusterId)
    self.clusterId = clusterId
    if zg.playerData:GetServerListInBound().newCluster == self.clusterId then
        self.config.new:SetActive(true)
    else
        self.config.new:SetActive(false)
    end
    self.playerServerData = nil
    self.config.textNameServer.text = string.format("S%s", clusterId)
    self:RemoveAvatar()
    self.config.textNameUser.gameObject:SetActive(false)
    self:ActiveCurrent(false)
end

--- @return void
---@param active boolean
function SelectServerView:ActiveCurrent(active)
    if active then
        self.config.effectServerDuocChon.gameObject:SetActive(true)
        self:EnableButton(false)
    else
        self.config.effectServerDuocChon.gameObject:SetActive(false)
        self:EnableButton(true)
    end
end

--- @return void
function SelectServerView:RemoveAvatar()
    if self.heroIconVIew ~= nil then
        self.heroIconVIew:ReturnPool()
        self.heroIconVIew = nil
    end
end

return SelectServerView