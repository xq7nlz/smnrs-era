
--- @class UIIdleEffectCollectionModel : UIBaseModel
UIIdleEffectCollectionModel = Class(UIIdleEffectCollectionModel, UIBaseModel)

--- @return void
function UIIdleEffectCollectionModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIIdleEffectCollection, "idle_effect_collection")

	self.bgDark = true
end
--- @return List
function UIIdleEffectCollectionModel:GetAllIdleEffect()
	--- @type Dictionary
	local parsedData = ResourceMgr.GetServiceConfig():GetItems().idleEffectDataEntries
	--- @type List
	local listIdleEffect = List()
	for k,v in pairs(parsedData:GetItems()) do
		if k~= nil then
			local idleEffectData = {}
			idleEffectData.idleEffectId = tonumber(k)
			listIdleEffect:Add(idleEffectData)
		end
	end
	return listIdleEffect
end

