
--- @class UIWorldMapModel : UIBaseModel
UIWorldMapModel = Class(UIWorldMapModel, UIBaseModel)

--- @return void
function UIWorldMapModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIWorldMap, "ui_world_map")
	--- @type UIPopupType
	self.type = UIPopupType.NO_BLUR_POPUP
	--- @type {diff : CampaignDifficultLevel, mapId : number, stageId, number}
	self.playerData = nil
	--- @type {diff : CampaignDifficultLevel, mapId : number, stageId, number}
	self.clientData = nil
	--- @type number
	self.currentMapCount = nil
end

--- @param difficultLevel CampaignDifficultLevel
--- @param mapId number
--- @param stage number
function UIWorldMapModel:SetPlayerData(difficultLevel, mapId, stage)
	self.playerData = {}
	self.playerData.diff = difficultLevel
	self.playerData.mapId = mapId
	self.playerData.stageId = stage

	self:SetClientData(difficultLevel, mapId, stage)
end

--- @param difficultLevel CampaignDifficultLevel
--- @param mapId number
--- @param stage number
function UIWorldMapModel:SetClientData(difficultLevel, mapId, stage)
	self.clientData = {}
	self.clientData.diff = difficultLevel
	self.clientData.mapId = mapId
	self.clientData.stageId = stage

	self.currentMapCount = ResourceMgr.GetCampaignDataConfig():GetCampaignStageConfig():GetNumberOfMapOfDifficultLevel(difficultLevel)
end

