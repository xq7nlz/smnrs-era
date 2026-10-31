
--- @class UIArtifactCollectionModel : UIBaseModel
UIArtifactCollectionModel = Class(UIArtifactCollectionModel, UIBaseModel)

--- @return void
function UIArtifactCollectionModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIArtifactCollection, "artifact_collection")
	---@type List --<id>
	self.itemDic = nil

	self.bgDark = true
end

