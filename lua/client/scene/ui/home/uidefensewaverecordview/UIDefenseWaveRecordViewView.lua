
--- @class UIDefenseWaveRecordViewView : UIBaseView
UIDefenseWaveRecordViewView = Class(UIDefenseWaveRecordViewView, UIBaseView)

--- @return void
--- @param model UIDefenseWaveRecordViewModel
function UIDefenseWaveRecordViewView:Ctor(model)
	-- init variables here
	UIBaseView.Ctor(self, model)
	--- @type UIDefenseWaveRecordViewModel
	self.model = model
end

--- @return void
function UIDefenseWaveRecordViewView:OnReadyCreate()
	---@type UIDefenseWaveRecordConfig
	self.config = UIBaseConfig(self.uiTransform)
	self:InitButtonListener()
end

function UIDefenseWaveRecordViewView:InitLocalization()
	self.config.titleChooseRival.text = LanguageUtils.LocalizeCommon("record")
end

function UIDefenseWaveRecordViewView:InitButtonListener()
	self.config.buttonPlay.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
end

--- @return void
function UIDefenseWaveRecordViewView:OnReadyShow(result)

end

