require "lua.client.scene.ui.home.uiPreviewServerWeekFragment.UIPreviewServerWeekFragmentView"
--- @class UIPreviewTigerHeroFragmentView : UIPreviewServerWeekFragmentView
UIPreviewTigerHeroFragmentView = Class(UIPreviewTigerHeroFragmentView, UIPreviewServerWeekFragmentView)
function UIPreviewTigerHeroFragmentView:InitLocalization()
	self.config.textTitle.text = LanguageUtils.LocalizeCommon("select_hero_fragment")
	self.config.textItem.text = LanguageUtils.LocalizeCommon("available_hero_fragment")
	self.config.textSelect.text = LanguageUtils.LocalizeCommon("select")
end

function UIPreviewTigerHeroFragmentView:OnClickSelect()
	if self.selectedIndex == nil or self.selectedIndex <= 0 then
		SmartPoolUtils.ShowShortNotification(string.format(LanguageUtils.LocalizeCommon("select_hero_bundle"), self.numberSelect))
		return
	end
	local selectIdInList = self.selectedIndex
	---@type RewardInBound
	local selectHeroReward = self.listReward:Get(selectIdInList)
	local selectId = selectHeroReward.indexId
	self.selectItems = List()
	self.selectItems:Add(selectId)
	local onSuccess = function()
		self.callBackSelectSuccess(self.selectItems)
		self:OnClickBackOrClose()
	end
	NetworkUtils.RequestAndCallback(self.opCode,UnknownOutBound.CreateInstance(PutMethod.Int,self.selectedIndex) , onSuccess)
end
