require "lua.client.scene.ui.utils.uiSelect.UISelectCustomSprite"
require "lua.client.scene.ui.common.heroList.HeroListView"
--- @class HeroListView4 : HeroListView
HeroListView4 = Class(HeroListView4, HeroListView)

--- @return void
--- @param transform UnityEngine_Transform
function HeroListView4:Ctor(transform)
	HeroListView.Ctor(self, transform)
	--- @type EventBossChallengeModel
	self.eventModel = nil
end

--- @return void
function HeroListView4:_FilterHeroDataBase()
	self.heroInUseList:Clear()
	local faction = self.factionSort.indexTab
	if faction ~= nil and faction > 1 then
		faction = faction - 1
	else
		faction = nil
	end
	local star = self.starSort.indexTab
	if self:IsStarBottom() then
		if star ~= nil and star > 1 then
			star = star - 1
		else
			star = nil
		end
	end
	--- @param heroResource HeroResource
	for heroIndex, heroResource in ipairs(self.heroResourceList:GetItems()) do
		if (self.filterConditionOr ~= nil and self.filterConditionOr(heroIndex, heroResource)) or
				((self.filterConditionAnd == nil or self.filterConditionAnd(heroIndex, heroResource)) and
						(self.filterFactionCondition == nil or self.filterFactionCondition(heroIndex, faction, heroResource)) and
						(self.filterStarCondition == nil or self.filterStarCondition(heroIndex, star, heroResource))) then
			self.heroInUseList:Add(heroIndex)
		end
	end
	self.heroInUseList:Reverse()
end
