--- @class KazetsuTowerTrailItem : MotionIconView
KazetsuTowerTrailItem = Class(KazetsuTowerTrailItem, MotionIconView)

--- @return void
function KazetsuTowerTrailItem:Ctor()
	---@type List -- <RootIconView>
	MotionIconView.Ctor(self)
	--- @type number
	self.stage = nil
end

--- @return void
function KazetsuTowerTrailItem:SetPrefabName()
	self.prefabName = 'kazetsu_tower_item'
	self.uiPoolType = UIPoolType.KazetsuTowerTrailItem
end

--- @return void
--- @param transform UnityEngine_Transform
function KazetsuTowerTrailItem:SetConfig(transform)
	MotionIconView.SetConfig(self, transform)
	--- @type KazetsuTowerItemConfig
	self.config = UIBaseConfig(transform)
end
--- @param dataCampaign DefenderTeamData
function KazetsuTowerTrailItem:FillData(dataCampaign)
	if dataCampaign ~= nil then
		if dataCampaign.stage ~= nil then
			self.stage = dataCampaign.stage
			if dataCampaign.stage == 1 then
				self.config.floorImage.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.kazetsuTower,
						"floor_" .. 0)
				self.config.island.gameObject:SetActive(true)
				local highlightName = string.format("floor_%d_highlight", 0)
				self.config.highlight.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.kazetsuTower,
						highlightName)
				self.config.rect.sizeDelta = Vector2(265,500)
				return
			else
				self.config.rect.sizeDelta = Vector2(265,318)
			end
			if dataCampaign.stage == 15 then
				self.config.floorImage.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.kazetsuTower,
						"floor_" .. 5)
				self.config.island.gameObject:SetActive(false)
				local highlightName = string.format("floor_%d_highlight", 5)
				self.config.highlight.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.kazetsuTower,
						highlightName)
				return
			end
			local stage = dataCampaign.stage % 5
			self:SetSprite(stage)
		end
	end
end

function KazetsuTowerTrailItem:SetSprite(id)
	if id == 0 then
		id = 1
	end
	self.config.island.gameObject:SetActive(false)
	self.config.floorImage.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.kazetsuTower, "floor_" .. id)
	local highlightName = string.format("floor_%d_highlight", id)
	self.config.highlight.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.kazetsuTower,
			highlightName)
end

function KazetsuTowerTrailItem:SetTile(tile)
end

--- @return void
function KazetsuTowerTrailItem:SetClaim(isClaimed)
end

function KazetsuTowerTrailItem:EnableHighlight()
	self.config.highlight.gameObject:SetActive(true)
end

function KazetsuTowerTrailItem:DisableHighlight()
	self.config.highlight.gameObject:SetActive(false)
end

--- @return void
function KazetsuTowerTrailItem:RegisterShowInfo()
end

--- @return void
---@param func function
function KazetsuTowerTrailItem:AddListener(func)
	self:EnableButton(true)
	self.config.towerButton.onClick:AddListener(func)
end

--- @return void
function KazetsuTowerTrailItem:RemoveAllListeners()
	self:EnableButton(false)
	self.config.towerButton.onClick:RemoveAllListeners()
end

--- @return void
--- @param enabled boolean
function KazetsuTowerTrailItem:EnableButton(enabled)
	UIUtils.SetInteractableButton(self.config.towerButton, enabled)
end

--- @return void
function KazetsuTowerTrailItem:ReturnPool()
	MotionIconView.ReturnPool(self)
	self:DisableHighlight()
	self:ReturnPoolItem()
end

function KazetsuTowerTrailItem:ReturnPoolItem()
end

return KazetsuTowerTrailItem