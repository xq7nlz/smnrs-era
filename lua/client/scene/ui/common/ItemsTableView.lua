--- @class ItemsTableView
ItemsTableView = Class(ItemsTableView)

--- @return void
--- @param uiTransform UnityEngine_Transform
--- @param onInitItem function
--- @param uiPoolType UIPoolType
function ItemsTableView:Ctor(uiTransform, onInitItem, uiPoolType)
	assert(uiTransform)
	self.uiTransform = uiTransform
	--- @type List --<ItemIconData>
	self.resourceList = nil
	--- @type function
	self.onInitItem = onInitItem
	--- @type UIPoolType
	self.uiPoolType = uiPoolType
	--- @type List IconView
	self.iconViewList = List()
	--- @type Dictionary
	self.eventItemDictConfig = Dictionary()
	self:GetEventItemConfig()
end

--- @return void
--- @param resourceList List -- ItemIconData
--- @param uiPoolType UIPoolType
function ItemsTableView:SetData(resourceList, uiPoolType)
	self.uiPoolType = uiPoolType or self.uiPoolType
	--for i = 1, resourceList:Count() do
	--    local iconData = resourceList:Get(i)
	--    XDebug.Log("iconData before OnDisabled" .. LogUtils.ToDetail(iconData))
	--end
	self:Hide()
	self.resourceList = resourceList
	--for i = 1, self.resourceList:Count() do
	--    local iconData = self.resourceList:Get(i)
	--    XDebug.Log("iconData after OnDisabled" .. LogUtils.ToDetail(iconData))
	--end
	self:Show()
	self:SetSize(165, 165)
end

--- @return List
function ItemsTableView:GetItems()
	return self.iconViewList
end

--- @return void
function ItemsTableView:Show()
	--- init item
	if self.resourceList ~= nil then
		local iconViewDict = {}
		local iconDataDict = {}

		local checkCondition = function(iconData, iconView)
			local eventOn = false
			if self.eventItemDictConfig:IsContainKey(iconData.itemId) then
				local value = self.eventItemDictConfig:Get(iconData.itemId)
				if value < 0 then
					iconView.config.gameObject:SetActive(false)
				elseif zg.playerData:GetEvents():GetEvent(value) ~= nil then
					iconView.config.gameObject:SetActive(true)
				end
			end
			if iconViewDict[iconView] == nil then
				iconViewDict[iconView] = iconView
			else
				XDebug.Error("Error Pool BUG item table view iconViewDict")
			end

			if iconDataDict[iconData] == nil then
				iconDataDict[iconData] = iconData
			else
				XDebug.Error("Error Pool BUG item table view iconDataDict")
			end
		end

		for i = 1, self.resourceList:Count() do
			---@type HeroIconData
			local iconData = self.resourceList:Get(i)
			--- @type HeroIconView
			local iconView
			if self.uiPoolType == nil then
				iconView = SmartPoolUtils.GetIconViewByIconData(iconData, self.uiTransform)
				checkCondition(iconData, iconView)
			elseif self.uiPoolType == UIPoolType.RateView then
				iconView = SmartPoolUtils.GetIconViewByIconDataWithRate(iconData, self.uiTransform, iconData.rate)
				checkCondition(iconData, iconView)
			else
				iconView = SmartPool.Instance:SpawnLuaUIPool(self.uiPoolType, self.uiTransform)
				iconView:SetIconData(iconData)
			end
			iconView:RegisterShowInfo()
			iconView:DefaultShow()

			self.iconViewList:Add(iconView)

			if self.onInitItem ~= nil then
				self.onInitItem(iconView, i)
			end
		end
	end
end

--- @return void
function ItemsTableView:Hide()
	--- @param iconView IconView
	for _, iconView in ipairs(self.iconViewList:GetItems()) do
		iconView:ReturnPool()
	end
	self.resourceList = nil
	self.iconViewList:Clear()
	ClientConfigUtils.KillCoroutine(self.motionCoroutine)
end

--- @return void
function ItemsTableView:ReturnPool()
	XDebug.Log("Use self:Hide() instead")
	self:Hide()
end

--- @return IconView
--- @param index number
function ItemsTableView:Get(index)
	return self.iconViewList:Get(index)
end

--- @param isActive boolean
--- @param size UnityEngine_Vector2
function ItemsTableView:ActiveMaskSelect(isActive, size)
	--- @param iconView IconView
	for _, iconView in ipairs(self.iconViewList:GetItems()) do
		iconView:ActiveMaskSelect(isActive, size)
	end
end

--- @param isActive boolean
--- @param size UnityEngine_Vector2
function ItemsTableView:ActiveMask(isActive, size)
	--- @param iconView IconView
	for _, iconView in ipairs(self.iconViewList:GetItems()) do
		iconView:ActiveMask(isActive, size)
	end
end

--- @param isActive boolean
--- @param size UnityEngine_Vector2
function ItemsTableView:ActiveEffectHeroIcon(isActive, size)
	--- @param iconView IconView
	for _, iconView in ipairs(self.iconViewList:GetItems()) do
		iconView:ActiveEffectHeroIcon(isActive, size)
	end
end

function ItemsTableView:SetSize(x, y)
	--- @param iconView IconView
	for _, iconView in ipairs(self.iconViewList:GetItems()) do
		iconView:SetSize(x, y)
	end
end

--- @param motionConfig MotionConfig
function ItemsTableView:PlayMotion(motionConfig)
	if motionConfig == nil then
		return
	end
	local delay = motionConfig.delay
	local listItems = self:GetItems()
	local deltaTime = motionConfig.deltaTime
	local offsetSpawn = motionConfig.offsetSpawn
	ClientConfigUtils.KillCoroutine(self.motionCoroutine)
	self.motionCoroutine = Coroutine.start(function()
		for i = 1, listItems:Count() do
			listItems:Get(i):SetAlpha(0)
		end
		if delay > 0 then
			coroutine.waitforseconds(delay)
		end
		--for i = 1, listItems:Count() do
		--    listItems:Get(i):PlayMotion(true)
		--    coroutine.waitforseconds(deltaTime)
		--end

		local count = listItems:Count()
		local spawnedIndex = 1
		local spawn = function()
			--- @type MotionIconView
			local iconView = listItems:Get(spawnedIndex)
			iconView:PlayMotion(true)
			spawnedIndex = spawnedIndex + 1
		end
		while count > offsetSpawn do
			for _ = 1, offsetSpawn do
				spawn()
			end
			count = count - offsetSpawn
			coroutine.waitforseconds(deltaTime)
		end
		for _ = 1, count do
			spawn()
		end
	end)
end

function ItemsTableView:EnableGlowBackground()
	--- @param iconView IconView
	for _, iconView in ipairs(self.iconViewList:GetItems()) do
		iconView:ActiveEffectGlowItem(true)
	end
end

--- @param effectPoolType EffectPoolType
function ItemsTableView:EnableEffectType(effectPoolType)
	--- @param iconView IconView
	for _, iconView in ipairs(self.iconViewList:GetItems()) do
		if effectPoolType == EffectPoolType.SummonIconTopTierA then
			iconView:ActiveEffectHeroIconTierA()
		elseif effectPoolType == EffectPoolType.ItemIconTop then
			iconView:ActiveEffectItemIcon()
		end
	end
end

function ItemsTableView:GetEventItemConfig()
	if self.eventItemDictConfig ~= nil then
		return
	end
	self.eventItemDictConfig = ClientConfigUtils.GetEventItemConfig()
end

