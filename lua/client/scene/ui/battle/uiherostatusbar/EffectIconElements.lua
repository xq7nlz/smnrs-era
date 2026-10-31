--- @class EffectIconElements
EffectIconElements = Class(EffectIconElements)

--- @return void
--- @param transform UnityEngine_Transform
function EffectIconElements:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform.transform
	--- @type UnityEngine_UI_Text
	self.stackText = self.transform:Find("stack"):GetComponent(ComponentName.UnityEngine_UI_Text)
	--- @type UnityEngine_UI_Image
	self.iconImage = self.transform:Find(""):GetComponent(ComponentName.UnityEngine_UI_Image)
	--- @type UnityEngine_RectTransform
	self.transStack = self.transform:Find("stack"):GetComponent(ComponentName.UnityEngine_RectTransform)
end
