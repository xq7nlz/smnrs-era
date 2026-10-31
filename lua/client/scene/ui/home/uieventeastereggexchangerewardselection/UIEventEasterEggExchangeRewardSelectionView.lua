require "lua.client.scene.ui.home.uiPreviewServerWeekFragment.UIPreviewServerWeekFragmentView"
--- @class UIEventEasterEggExchangeRewardSelectionView : UIPreviewServerWeekFragmentView
UIEventEasterEggExchangeRewardSelectionView = Class(UIEventEasterEggExchangeRewardSelectionView, UIPreviewServerWeekFragmentView)
function UIEventEasterEggExchangeRewardSelectionView:InitLocalization()
	self.config.textTitle.text = LanguageUtils.LocalizeCommon("select_hero_fragment")
	self.config.textItem.text = LanguageUtils.LocalizeCommon("available_hero_fragment")
	self.config.textSelect.text = LanguageUtils.LocalizeCommon("select")
end

function UIEventEasterEggExchangeRewardSelectionView:OnClickSelect()
	if self.selectedIndex == nil or self.selectedIndex <= 0 then
		SmartPoolUtils.ShowShortNotification(string.format(LanguageUtils.LocalizeCommon("select_hero_bundle"), self.numberSelect))
		return
	end
	self.selectItems = List()
	self.selectItems:Add(self.selectedIndex)
	local onSuccess = function()
		self.callBackSelectSuccess(self.selectItems)
		self:OnClickBackOrClose()
	end
	NetworkUtils.RequestAndCallback(self.opCode,UnknownOutBound.CreateInstance(PutMethod.Int,self.packId,
			PutMethod.Int,self.selectedIndex -1) , onSuccess)
end
