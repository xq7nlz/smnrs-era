---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiSwitchServer.UISwitchServerConfig"

--- @class UISwitchServerView : UIBaseView
UISwitchServerView = Class(UISwitchServerView, UIBaseView)

--- @return void
--- @param model UISwitchServerModel
function UISwitchServerView:Ctor(model)
	---@type UISwitchServerConfig
	self.config = nil
	---@type UILoopScroll
	self.uiScroll = nil

	self.callbackSwitchServer = nil

	-- init variables here
	UIBaseView.Ctor(self, model)
	--- @type UISwitchServerModel
	self.model = model
end

--- @return void
function UISwitchServerView:OnReadyCreate()
	---@type UISwitchServerConfig
	self.config = UIBaseConfig(self.uiTransform)

	--- @param obj SelectServerView
	--- @param index number
	local onUpdateItem = function(obj, index)
		if index < self.model.listPlayerServerData:Count() then
			obj:SetPlayerServerData(self.model.listPlayerServerData:Get(index + 1))
		else
			local clusterId = self.model.listClusterCanCreateAccount:Get(index - self.model.listPlayerServerData:Count() + 1)
			obj:SetClusterId(clusterId)
			if clusterId == self.model.currentClusterId then
				obj:ActiveCurrent(true)
			else
				obj:ActiveCurrent(false)
			end
		end
	end
	--- @param obj SelectServerView
	--- @param index number
	local onCreateItem = function(obj, index)
		onUpdateItem(obj, index)
		obj:AddListener(function ()
			if zg.playerData:GetMethod(PlayerDataMethod.SERVER_LIST) ~= nil then
				self:OnSwitchServer(obj)
			else
				self:OnSwitchServerStartGame(obj)
			end
			zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		end)
	end
	self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.SelectServerView, onCreateItem, onUpdateItem)

	self.config.buttonClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.backGround.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
end

--- @return void
function UISwitchServerView:InitLocalization()
	self.config.titleSwitchServer.text = LanguageUtils.LocalizeCommon("switch_server")
	self.config.localizeTapToClose.gameObject:SetActive(false)
end

--- @return void
function UISwitchServerView:OnReadyShow(data)
	zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
	if data ~= nil then
		self.callbackSwitchServer = data.callbackSwitchServer
		self.model.currentClusterId = data.currentClusterId
	end
	self.model:InitData()
	self.uiScroll:Resize(self.model.listPlayerServerData:Count() + self.model.listClusterCanCreateAccount:Count())
end

--- @return void
function UISwitchServerView:Hide()
	UIBaseView.Hide(self)
	self.callbackSwitchServer = nil
	self.model.currentClusterId = nil
	self.uiScroll:Hide()
end

--- @return void
---@param server SelectServerView
function UISwitchServerView:OnSwitchServer(server)
	local notification = ""
	local serverId
    if server.playerServerData ~= nil then
		serverId = server.playerServerData.serverId
		if serverId == PlayerSettingData.serverId then
			SmartPoolUtils.ShowShortNotification("You are in current server")
			return
		end
		notification = LanguageUtils.LocalizeCommon("want_to_switch_server")
	else
		notification = LanguageUtils.LocalizeCommon("want_to_new_server")
		---@type List
		local listServerId = zg.playerData:GetServerListInBound():GetServers(server.clusterId)
		serverId = listServerId:Get(listServerId:Count())
	end
	local yesCallback = function()
		zg.audioMgr:PlaySfxUi(SfxUiType.CONFIRM)
		local switchSuccess = function()
			PlayerSettingData.serverId = serverId
			PlayerSetting.SaveData()
			SceneMgr.RequestAndResetToMainArea()
		end
		LoginUtils.SwitchServer(serverId, switchSuccess)
	end
	PopupUtils.ShowPopupNotificationYesNo(notification, nil, yesCallback)
end

--- @return void
---@param server SelectServerView
function UISwitchServerView:OnSwitchServerStartGame(server)
	if server.clusterId ~= self.model.currentClusterId then
		local yesCallback = function()
			if self.callbackSwitchServer ~= nil then
				self.callbackSwitchServer(server.clusterId)
			end
			PopupMgr.HidePopup(UIPopupName.UISwitchServer)
		end
		PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("want_to_switch_server"), nil, yesCallback)
	end
end