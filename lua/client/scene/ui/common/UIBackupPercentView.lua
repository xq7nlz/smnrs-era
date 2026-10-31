--- @class UIBackupPercentView
UIBackupPercentView = Class(UIBackupPercentView)

--- @return void
--- @param transform UnityEngine_Transform
function UIBackupPercentView:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform.transform
	--- @type UnityEngine_UI_Text
	self.textPercent = self.transform:Find("text_percent"):GetComponent(ComponentName.UnityEngine_UI_Text)
	--- @type UnityEngine_RectTransform
	self.rectPercent = self.transform:Find("rect_percent"):GetComponent(ComponentName.UnityEngine_RectTransform)
end
