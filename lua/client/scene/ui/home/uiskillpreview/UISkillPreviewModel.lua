
--- @class UISkillPreviewModel
UISkillPreviewModel = Class(UISkillPreviewModel, UIBaseModel)

--- @return void
function UISkillPreviewModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UISkillPreview, "skill_preview")
	---@type number
	self.heroId = nil
	---@type number
	self.skillId = nil
	---@type number
	self.class = nil
	---@type number
	self.star = nil
	---@type number
	self.level = nil
	---@type number
	self.unlock = nil
	---@type UnityEngine_Vector2
	self.anchor = nil
	---@type UnityEngine_Vector3
	self.position = nil
end

