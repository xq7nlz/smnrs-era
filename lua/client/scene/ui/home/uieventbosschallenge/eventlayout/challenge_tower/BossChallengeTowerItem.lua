--- @class BossChallengeTowerItem : MotionIconView
BossChallengeTowerItem = Class(BossChallengeTowerItem, MotionIconView)

--- @return void
function BossChallengeTowerItem:Ctor()
	---@type List -- <RootIconView>
	MotionIconView.Ctor(self)
	--- @type number
	self.stage = nil
end

--- @return void
function BossChallengeTowerItem:SetPrefabName()
	self.prefabName = 'boss_challenge_tower_item'
	self.uiPoolType = UIPoolType.BossChallengeTowerItem
end

--- @return void
--- @param transform UnityEngine_Transform
function BossChallengeTowerItem:SetConfig(transform)
	MotionIconView.SetConfig(self, transform)
	--- @type BossChallengeTowerItemConfig
	self.config = UIBaseConfig(transform)
end
--- @param dataCampaign DefenderTeamData
function BossChallengeTowerItem:FillData(stage)
	if stage ~= nil then
		self.stage = stage
		if self.stage == 1 then
			self.config.floorImage.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.kazetsuTower,
					"floor_" .. 0)
			self.config.island.gameObject:SetActive(true)
			local highlightName = string.format("floor_%d_highlight", 0)
			self.config.highlight.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.kazetsuTower,
					highlightName)
			self.config.rect.sizeDelta = Vector2(265, 500)
			return
		else
			self.config.rect.sizeDelta = Vector2(265, 318)
		end
		if self.stage == 35 then
			self.config.floorImage.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.kazetsuTower,
					"floor_" .. 5)
			self.config.island.gameObject:SetActive(false)
			local highlightName = string.format("floor_%d_highlight", 5)
			self.config.highlight.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.kazetsuTower,
					highlightName)
			return
		end
		local stage = self.stage % 5
		self:SetSprite(stage)
	end
end

function BossChallengeTowerItem:SetSprite(id)
	if id == 0 then
		id = 1
	end
	self.config.island.gameObject:SetActive(false)
	self.config.floorImage.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.kazetsuTower, "floor_" .. id)
	local highlightName = string.format("floor_%d_highlight", id)
	self.config.highlight.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.kazetsuTower,
			highlightName)
end

function BossChallengeTowerItem:SetTile(tile)
end

--- @return void
function BossChallengeTowerItem:SetClaim(isClaimed)
end

function BossChallengeTowerItem:EnableHighlight()
	self.config.highlight.gameObject:SetActive(true)
end

function BossChallengeTowerItem:DisableHighlight()
	self.config.highlight.gameObject:SetActive(false)
end

--- @return void
function BossChallengeTowerItem:RegisterShowInfo()
end

--- @return void
---@param func function
function BossChallengeTowerItem:AddListener(func)
	self:EnableButton(true)
	self.config.towerButton.onClick:AddListener(func)
end

--- @return void
function BossChallengeTowerItem:RemoveAllListeners()
	self:EnableButton(false)
	self.config.towerButton.onClick:RemoveAllListeners()
end

--- @return void
--- @param enabled boolean
function BossChallengeTowerItem:EnableButton(enabled)
	UIUtils.SetInteractableButton(self.config.towerButton, enabled)
end

--- @return void
function BossChallengeTowerItem:ReturnPool()
	MotionIconView.ReturnPool(self)
	self:DisableHighlight()
	self:ReturnPoolItem()
end

function BossChallengeTowerItem:ReturnPoolItem()
end

return BossChallengeTowerItem