--- @class UISwitchServerModel : UIBaseModel
UISwitchServerModel = Class(UISwitchServerModel, UIBaseModel)

--- @return void
function UISwitchServerModel:Ctor()
    UIBaseModel.Ctor(self, UIPopupName.UISwitchServer, "switch_server")
    ---@type List
    self.listPlayerServerData = nil
    ---@type List
    self.listClusterCanCreateAccount = nil
    ---@type number
    self.currentClusterId = nil
    ---@type number
    self.serverLock = "S9S10"

    self.bgDark = true
end

--- @return void
function UISwitchServerModel:InitData()
    self.listClusterCanCreateAccount = List()
    local serverListInBound = zg.playerData:GetServerListInBound()
    ---@type List
    local listClusterHaveAccount = List()
    ---@type PlayerServerListInBound
    local serverList = zg.playerData:GetMethod(PlayerDataMethod.SERVER_LIST)
    if serverList ~= nil then
        self.listPlayerServerData = List()
        ---@param v PlayerServerData
        for i, v in ipairs(serverList.listPlayer:GetItems()) do
            if PlayerSetting.IsCanShowServer(v.serverId) then
                self.listPlayerServerData:Add(v)
            end
        end
        self.listPlayerServerData:SortWithMethod(UISwitchServerModel.SortPlayerServerData)
        ---@param v PlayerServerData
        for _, v in pairs(serverList.listPlayer:GetItems()) do
            local clusterId = serverListInBound:GetCluster(v.serverId)
            if listClusterHaveAccount:IsContainValue(clusterId) == false then
                listClusterHaveAccount:Add(clusterId)
            end
        end
    else
        self.listPlayerServerData = List()
    end

    for serverId, featureUnlockInBound in pairs(serverListInBound.serverDict:GetItems()) do
        local clusterId = featureUnlockInBound.cluster
        if PlayerSetting.IsCanShowServer(serverId)
                and self.listClusterCanCreateAccount:IsContainValue(clusterId) == false
                and listClusterHaveAccount:IsContainValue(clusterId) == false then
            self.listClusterCanCreateAccount:Add(clusterId)
        end
    end
    self.listClusterCanCreateAccount:SortWithMethod(SortUtils.SortCluster)
    if self.currentClusterId == nil then
        if PlayerSettingData.serverId ~= nil then
            self.currentClusterId = serverListInBound:GetCluster(PlayerSettingData.serverId)
        else
            self.currentClusterId = self.listClusterCanCreateAccount:Get(1)
        end
    end
    --XDebug.Log(self.currentClusterId)
end

--- @return number
---@param x PlayerServerData
---@param y PlayerServerData
function UISwitchServerModel.SortPlayerServerData(x, y)
    if (x.serverId == PlayerSettingData.serverId) then
        return -1
    elseif (y.serverId == PlayerSettingData.serverId) then
        return 1
    else
        local serverList = zg.playerData:GetServerListInBound()
        if (serverList:GetCluster(x.serverId) > serverList:GetCluster(y.serverId)) then
            return -1
        elseif (serverList:GetCluster(x.serverId) < serverList:GetCluster(y.serverId)) then
            return 1
        else
            if (x.playerLevel > y.playerLevel) then
                return -1
            else
                return 1
            end
        end
    end
end