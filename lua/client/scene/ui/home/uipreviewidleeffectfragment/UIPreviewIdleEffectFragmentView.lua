require "lua.client.core.network.event.eventMergeServer.SelectItemBundleOutBound"
require "lua.client.scene.ui.home.uiPreviewServerWeekFragment.UIPreviewServerWeekFragmentView"
--- @class UIPreviewIdleEffectFragmentView : UIPreviewServerWeekFragmentView
UIPreviewIdleEffectFragmentView = Class(UIPreviewIdleEffectFragmentView, UIPreviewServerWeekFragmentView)
function UIPreviewIdleEffectFragmentView:InitLocalization()
	self.config.textTitle.text = LanguageUtils.LocalizeCommon("select_idle_effect_fragment")
	self.config.textItem.text = LanguageUtils.LocalizeCommon("available_idle_effect_fragment")
	self.config.textSelect.text = LanguageUtils.LocalizeCommon("select")
end

function UIPreviewIdleEffectFragmentView:OnClickSelect()
	if self.selectedIndex == nil or self.selectedIndex <= 0 then
		SmartPoolUtils.ShowShortNotification(string.format(LanguageUtils.LocalizeCommon("select_item_idle_effect_bundle"), self.numberSelect))
		--[[		SmartPoolUtils.ShowShortNotification(
                        LanguageUtils.LocalizeCommon("select_an_artifact"))]]
		return
	end
	local selectIdInList = self.selectedIndex
	---@type RewardInBound
	local selectHeroReward = self.listReward:Get(selectIdInList)
	local selectId = selectHeroReward.indexId
	self.selectItems = List()
	self.selectItems:Add(selectId)
	--[[	self.selectItems:Add(2, selectId)
        for i = 1,self.selectItems:Count() do
            local value = self.selectItems:Get(i)
            --XDebug.Log("LIST SELECT HERE " .. tostring(i) .. " ___ " .. tostring(value))
        end]]
	local onSuccess = function()
		self.callBackSelectSuccess(self.selectItems)
		self:OnClickBackOrClose()
	end

	local outBound = SelectItemBundleOutBound(self.packId,
			self.selectItems)
	--XDebug.Log("CALL OPCODE " .. tostring(self.opCode))
	NetworkUtils.RequestAndCallback(self.opCode, outBound, onSuccess)
end
