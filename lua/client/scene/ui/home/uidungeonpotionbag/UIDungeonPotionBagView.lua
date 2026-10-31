
--- @class UIDungeonPotionBagView : UIBaseView
UIDungeonPotionBagView = Class(UIDungeonPotionBagView, UIBaseView)

--- @return void
--- @param model UIDungeonPotionBagModel
function UIDungeonPotionBagView:Ctor(model)
	--- @type UIDungeonPotionBagConfig
	self.config = nil
	--- @type UILoopScroll
	self.uiScroll = nil
	--- @type List
	self.rewardList = nil

	UIBaseView.Ctor(self, model)
	--- @type UIDungeonPotionBagModel
	self.model = model
end

--- @return void
function UIDungeonPotionBagView:OnReadyCreate()
	---@type UIDungeonPotionBagConfig
	self.config = UIBaseConfig(self.uiTransform)

	self:_InitButtonListener()
	self:_InitScrollView()
end

--- @return void
function UIDungeonPotionBagView:InitLocalization()
	self.config.textEmpty.text = LanguageUtils.LocalizeCommon("empty")
	self.config.textTitle.text = LanguageUtils.LocalizeCommon("potion")
	self.config.textClose.text = LanguageUtils.LocalizeCommon("close")
end

function UIDungeonPotionBagView:_InitButtonListener()
	self.config.buttonClose.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
end

function UIDungeonPotionBagView:_InitScrollView()
	--- @param obj DungeonBuffCardView
	--- @param index number
	local onUpdateItem = function(obj, index)
		---@type RewardInBound
		local reward = self.rewardList:Get(index + 1)
		obj.choose = true
		obj:SetIconData(reward)
	end
	--- @param obj DungeonBuffCardView
	--- @param index number
	local onCreateItem = function(obj, index)
		onUpdateItem(obj, index)
		obj:AddListener(nil, function()
			local onUseActiveBuffComplete = function()
				RxMgr.pickDungeonBuff:Next({
					['buffData'] = obj.buffData,
					['isActiveBuff'] = obj:IsActiveBuff(),
					['sourceRect'] = obj.config.iconItemDungeonBuff:GetComponent(ComponentName.UnityEngine_RectTransform),
					['useOnHero'] = true,
					['onComplete'] = function ()
						--- update hero info
					end,
				})

				if obj.iconData.number > 0 then
					obj.iconData.number = obj.iconData.number - 1
				end
				if obj.iconData.number == 0 then
					self.server.activeBuff:RemoveByKey(obj.iconData.id)
					self.rewardList:RemoveByIndex(index + 1)
					self.uiScroll:RefreshCells(self.rewardList:Count())
				else
					self.uiScroll:RefreshCells()
				end
				self.config.empty:SetActive(self.rewardList:Count() == 0)
			end

			local onUseActiveBuffFailed = function(logicCode)
				if logicCode == LogicCode.DUNGEON_BUFF_ITEM_CAN_NOT_USE then
					local activeBuff = ResourceMgr.GetServiceConfig():GetDungeon():GetActiveBuff(obj.iconData.id)
					if activeBuff.type == DungeonBuffType.ACTIVE_BUFF_NORMAL then
						if activeBuff.hpPercent >= 0 then
							SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("hp_full"))
						elseif activeBuff.power >= 0 then
							SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("power_full"))
						end
					elseif activeBuff.type == DungeonBuffType.ACTIVE_BUFF_REVIVE then
						SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("hero_alive"))
					end
				else
					SmartPoolUtils.LogicCodeNotification(logicCode)
				end
			end
			DungeonRequest.UseActiveBuff(self.server.selectedHero - 1, obj.iconData.id, onUseActiveBuffComplete, onUseActiveBuffFailed)
		end)
	end
	--- @type UILoopScroll
	self.uiScroll = UILoopScroll(self.config.loopScrollRect, UIPoolType.DungeonBuffCardView, onCreateItem, onUpdateItem)
end

--- @return void
function UIDungeonPotionBagView:OnReadyShow()
	zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
	self.canPlayMotion = true
	--- @type DungeonInBound
	self.server = zg.playerData:GetMethod(PlayerDataMethod.DUNGEON)
	self:SetRewardData()
	--self:FakeRewardData()
	self:UpdateView()
end

function UIDungeonPotionBagView:UpdateView()
	local count = self.rewardList:Count()
	self.uiScroll:Resize(count)
	if self.canPlayMotion == true then
		self.canPlayMotion = false
		self.uiScroll:PlayMotion()
	end
	self.config.empty:SetActive(count == 0)
end

function UIDungeonPotionBagView:SetRewardData()
	self.rewardList = List()
	--- @param v RewardInBound
	for _, v in pairs(self.server.activeBuff:GetItems()) do
		self.rewardList:Add(v)
	end
end

function UIDungeonPotionBagView:FakeRewardData()
	local potionIdList = {1006, 2001, 2008, 3001, 3002, 4001, 4003, 4005, }
	self.rewardList = List()
	for i, v in ipairs(potionIdList) do
		self.rewardList:Add(RewardInBound.CreateBySingleParam(ResourceType.DungeonItemActiveBuff, v, 3))
	end
end

function UIDungeonPotionBagView:Hide()
	UIBaseView.Hide(self)
	self.uiScroll:Hide()
end

