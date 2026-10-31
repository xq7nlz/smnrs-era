require "lua.client.scene.ui.utils.uiSelect.UISelectCustomSprite"
require "lua.client.scene.ui.common.heroList.HeroListView"
--- @class HeroListView2 : HeroListView
HeroListView2 = Class(HeroListView2, HeroListView)

--- @return void
--- @param transform UnityEngine_Transform
function HeroListView2:Ctor(transform)
	HeroListView.Ctor(self, transform)
	--- @type function
	self.choseKazetsu = nil
	--- @type EventKazetsuModel
	self.kazetsuModel = nil
end

function HeroListView2:UpdateKazetsuEventModel(kazetsuModel)
	self.kazetsuModel = kazetsuModel
end

------------------- Formation Hero ----------------------------------------
--- @return void
function HeroListView2:_CreateFormationHero()
	--- @param obj HeroIconView2
	--- @param index number
	local onUpdateItem = function(obj, index)
		--- @type number
		local heroIndex = self.heroInUseList:Get(index + 1)
		---@type HeroResource
		local heroResource = self.heroResourceList:Get(heroIndex)
		--- @type IconView
		local data = HeroIconData.CreateByHeroResource(heroResource)
		obj:SetIconData(data)
		--if  self.kazetsuModel == nil then
		self.kazetsuModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_KAZETSU)
		--end
		local heroInfo = self.kazetsuModel:ConvertHeroWithStateToDict():Get(heroResource.inventoryId)
		obj:UpdateBarView(heroInfo.hpPercent, heroInfo.power)
		if self.showClass then
			obj:ShowClassHero()
		end
		if self.onUpdateItem ~= nil then
			self.onUpdateItem(heroIndex, obj, heroResource)
		end
	end
	--- @param obj HeroIconView2
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
		if heroResource.heroId == HeroConstants.KAZETSU_HERO_ID then
			self.choseKazetsu = function()
				self.buttonListener(heroIndex, obj, heroResource)
			end
		end
		if self.onCreateItem ~= nil then
			self.onCreateItem(heroIndex, obj, heroResource)
		end
		onUpdateItem(obj, index)
	end
	self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.HeroIconView2, onCreateItem, onUpdateItem)
	self.uiScroll:SetUpMotion(MotionConfig(0, 0, 0, 0.01))
end
