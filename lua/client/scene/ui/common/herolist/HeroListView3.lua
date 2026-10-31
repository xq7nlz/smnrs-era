require "lua.client.scene.ui.utils.uiSelect.UISelectCustomSprite"
require "lua.client.scene.ui.common.heroList.HeroListView"
--- @class HeroListView3 : HeroListView
HeroListView3 = Class(HeroListView3, HeroListView)

--- @return void
--- @param transform UnityEngine_Transform
function HeroListView3:Ctor(transform)
	HeroListView.Ctor(self, transform)
	--- @type EventBossChallengeModel
	self.eventModel = nil
end

------------------- Formation Hero ----------------------------------------
--- @return void
function HeroListView3:_CreateFormationHero()
	--- @param obj HeroIconView
	--- @param index number
	local onUpdateItem = function(obj, index)
		--- @type number
		local heroIndex = self.heroInUseList:Get(index + 1)
		---@type HeroResource
		local heroResource = self.heroResourceList:Get(heroIndex)
		--- @type IconView
		local data = HeroIconData.CreateByHeroResource(heroResource)
		obj:SetIconData(data)
		--self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BOSS_CHALLENGE)
		--local heroInfo = self.eventModel:ConvertHeroWithStateToDict():Get(heroResource.inventoryId)
		--obj:UpdateBarView(heroInfo.hpPercent, heroInfo.power)
		obj:SetActiveBarView(false)
		if self.showClass then
			obj:ShowClassHero()
		end
		if self.onUpdateItem ~= nil then
			self.onUpdateItem(heroIndex, obj, heroResource)
		end
	end
	--- @param obj HeroIconView
	--- @param index number
	local onCreateItem = function(obj, index)
		--- @type number
		local heroIndex = self.heroInUseList:Get(index + 1)
		---@type HeroResource
		local heroResource = self.heroResourceList:Get(heroIndex)
		obj.heroIndex = heroIndex
		obj:AddListener(function()
			if self.buttonListener ~= nil then
				self.buttonListener(heroIndex, obj, heroResource)
			end
		end)
		if self.onCreateItem ~= nil then
			self.onCreateItem(heroIndex, obj, heroResource)
		end
		onUpdateItem(obj, index)
	end

	self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.HeroIconView2, onCreateItem, onUpdateItem)
	self.uiScroll:SetUpMotion(MotionConfig(0, 0, 0, 0.01))
end
