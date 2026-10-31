--- @class UIBarPercentView
UIBarPercentView = Class(UIBarPercentView)

--- @return void
--- @param transform UnityEngine_Transform
function UIBarPercentView:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform.transform
	--- @type UnityEngine_UI_Text
	self.textPercent = self.transform:Find("text_percent"):GetComponent(ComponentName.UnityEngine_UI_Text)
	--- @type UnityEngine_RectTransform
	self.rectPercent = self.transform:Find("rect_percent"):GetComponent(ComponentName.UnityEngine_RectTransform)
	--- @type number
	self.maxSize = self.rectPercent.rect.width
	--- @type function
	self.callback = nil
end

--- @return void
--- @param percent
function UIBarPercentView:SetPercent(percent)
	if self.callback == nil then
		self:SetText(string.format("%.1f%s", percent * 100, "%"))
		self:SetValue(percent)
	else
		self.callback(percent)
	end
end

--- @param content string
function UIBarPercentView:SetText(content)
	self.textPercent.text = content
end

--- @param percent number
function UIBarPercentView:SetValue(percent)
	self.rectPercent:SetSizeWithCurrentAnchors(U_Rect_Axis.Horizontal, percent * self.maxSize)
end

--- @param isActive boolean
function UIBarPercentView:SetActive(isActive)
	self.gameObject:SetActive(isActive)
end