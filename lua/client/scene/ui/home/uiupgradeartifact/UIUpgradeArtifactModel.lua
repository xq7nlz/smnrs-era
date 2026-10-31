
--- @class UIUpgradeArtifactModel : UIBaseModel
UIUpgradeArtifactModel = Class(UIUpgradeArtifactModel, UIBaseModel)

--- @return void
function UIUpgradeArtifactModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIUpgradeArtifact, "upgrade_artifact_2")
	--- @type HeroResource
	self.heroResource = nil
	--- @type number
	self.artifactId = nil
	---@type Dictionary  --<id, number>
	self.artifactResource = Dictionary()
	--- @type List <id>
	self.itemSort = List()
	---@type Dictionary --<id, number>
	self.artifactSelect = Dictionary()
	---@type Dictionary --<slot, id>
	self.listIdSelect = Dictionary()
	---@type number
	self.currentExp = 0
	---@type number
	self.totalExp = 0

	self.bgDark = true
end

--- @return void
function UIUpgradeArtifactModel:LoadData()
	self.artifactResource:Clear()
	---@type ClientResourceDict
	local itemDic = InventoryUtils.Get(ResourceType.ItemArtifact)
	for k, v in pairs(itemDic:GetItems()) do
		if v > 0 then
			self.artifactResource:Add(k, v)
		end
	end
	self.itemSort = InventoryUtils.GetArtifact(-1)
	self.artifactSelect:Clear()
	self.listIdSelect:Clear()
end


