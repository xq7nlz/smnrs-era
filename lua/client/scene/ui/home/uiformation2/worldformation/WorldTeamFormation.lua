require "lua.client.scene.ui.home.uiFormation2.heroSlotWorldFormation.HeroSlotWorldFormation"

--- @class WorldTeamFormation
WorldTeamFormation = Class(WorldTeamFormation)

--- @param worldFormation WorldFormation
--- @param isAttackerTeam boolean
function WorldTeamFormation:Ctor(worldFormation, isAttackerTeam)
	--- @type WorldFormation
	self.worldFormation = worldFormation
	--- @type boolean
	self.isAttackerTeam = isAttackerTeam
	--- @type number
	self.teamId = nil
	if isAttackerTeam == true then
		self.teamId = BattleConstants.ATTACKER_TEAM_ID
	else
		self.teamId = BattleConstants.DEFENDER_TEAM_ID
	end
	--- @type number
	self.formationId = nil

	--- @type HeroSlotWorldFormation
	self.summonerSlot = nil
	--- @type Dictionary {positionId, HeroSlotWorldFormation}
	self.frontLineDict = Dictionary()
	--- @type Dictionary {positionId, HeroSlotWorldFormation}
	self.backLineDict = Dictionary()

	--- @func {isAttacker, {isFrontLine, positionId}}
	self.btnCallbackSelect = nil
	--- @func {isAttacker, {isFrontLine, positionId}}
	self.btnCallbackRemove = nil
	--- @func {isAttacker, {isFrontLine, positionId}}
	self.btnCallbackSwap = nil
	--- @func {isAttacker, {isFrontLine, positionId}}
	self.btnTriggerPointerDown = nil
	--- @func {isAttacker, position}
	self.btnTriggerPointerUp = nil
	--- @func {isAttacker, position}
	self.btnTriggerPointerDrag = nil

	self.btnCallbackSelectSummoner = nil

	self.heroSlotWorldFormationType = UIPoolType.HeroSlotWorldFormation
end

--- @param formationId number
function WorldTeamFormation:SetFormation(formationId)
	self.formationId = formationId

	local poolSlot = List()
	for _, v in pairs(self.frontLineDict:GetItems()) do
		poolSlot:Add(v)
	end
	for _, v in pairs(self.backLineDict:GetItems()) do
		poolSlot:Add(v)
	end
	self.frontLineDict = Dictionary()
	self.backLineDict = Dictionary()
	if poolSlot:Count() < 5 then
		for _ = 1, 5 - poolSlot:Count() do
			poolSlot:Add(self:GetMoreHeroWorldSlot())
		end
	end

	local teamPosition = FormationPositionConfig.GetTeamFormation(self.teamId, formationId)

	--- @type FormationData
	local formationData = ResourceMgr.GetServiceConfig():GetHeroes():GetFormationData(formationId)
	local hp, atk = ClientConfigUtils.GetFormationBuff(self.formationId)
	hp = math.floor(hp * 100)
	atk = math.floor(atk * 100)

	local slotIndex = 1
	for i = 1, formationData.frontLine do
		slotIndex = i
		--- @type HeroSlotWorldFormation
		local slot = poolSlot:Get(1)
		poolSlot:RemoveByIndex(1)
		self.frontLineDict:Add(i, slot)
		local position = teamPosition:GetPosition(true, i)
		slot:SetPosition(position, true, i)
		slot:SetHeroSlot(nil)
		slot:EnableTextSlot(true, slotIndex)
		slot:EnableBuffStat(true, hp)
		slot:ResetButtonSlot()
	end
	for i = 1, formationData.backLine do
		slotIndex = slotIndex + 1
		--- @type HeroSlotWorldFormation
		local slot = poolSlot:Get(1)
		poolSlot:RemoveByIndex(1)
		self.backLineDict:Add(i, slot)
		local position = teamPosition:GetPosition(false, i)
		slot:SetPosition(position, false, i)
		slot:SetHeroSlot(nil)
		slot:EnableTextSlot(true, slotIndex)
		slot:EnableBuffStat(true, atk)

		slot:ResetButtonSlot()
	end
end

--- @param isEnable boolean
function WorldTeamFormation:EnableTeamView(isEnable)
	for _, v in pairs(self.frontLineDict:GetItems()) do
		v:SetEnable(isEnable)
	end
	for _, v in pairs(self.backLineDict:GetItems()) do
		v:SetEnable(isEnable)
	end
	self:EnableSummonerSlot(isEnable)
end

function WorldTeamFormation:EnableSummonerSlot(isEnable)
	if self.summonerSlot ~= nil then
		self.summonerSlot:SetEnable(isEnable)
	end
end

function WorldTeamFormation:DisableSlotBuffStat()
	--- @param v HeroSlotWorldFormation
	for _, v in pairs(self.frontLineDict:GetItems()) do
		v:EnableBuffStat(false)
	end
	--- @param v HeroSlotWorldFormation
	for _, v in pairs(self.backLineDict:GetItems()) do
		v:EnableBuffStat(false)
	end
end

--- @param isFrontLine boolean
--- @param position number
--- @param heroResource HeroResource
function WorldTeamFormation:SetHeroAtPosition(isFrontLine, position, heroResource, onFinish, allowScale)
	--- @type HeroSlotWorldFormation
	local heroSlotWorldFormation
	if isFrontLine == true and self.frontLineDict:IsContainKey(position) == true then
		heroSlotWorldFormation = self.frontLineDict:Get(position)
	elseif isFrontLine == false and self.backLineDict:IsContainKey(position) == true then
		heroSlotWorldFormation = self.backLineDict:Get(position)
	end
	if heroSlotWorldFormation ~= nil then
		heroSlotWorldFormation:SetHeroSlot(heroResource, onFinish, allowScale)
	end
end

--- @param isFrontLine boolean
--- @param position number
function WorldTeamFormation:RemoveHeroAtPosition(isFrontLine, position)
	local slot = self:GetSlotByPosition(isFrontLine, position)
	slot:OnRemoveSlot()
	self:ResetButtonSlot()
end

--- @param detailTeamFormation DetailTeamFormation
function WorldTeamFormation:ShowTeamHeroPredefine(detailTeamFormation)
	local onFinish = function()
	end
	for k, v in pairs(detailTeamFormation.frontLineDict:GetItems()) do
		if self.frontLineDict:IsContainKey(k) then
			--- @type HeroSlotWorldFormation
			local slot = self.frontLineDict:Get(k)
			slot:SetHeroSlot(v, onFinish)
		end
	end
	for k, v in pairs(detailTeamFormation.backLineDict:GetItems()) do
		if self.backLineDict:IsContainKey(k) then
			--- @type HeroSlotWorldFormation
			local slot = self.backLineDict:Get(k)
			slot:SetHeroSlot(v, onFinish)
		end
	end
end

--- @param battleTeamInfo BattleTeamInfo
function WorldTeamFormation:ShowBattleTeamInfo(battleTeamInfo, onFinish)
	local formationId = battleTeamInfo.formation
	self:SetFormation(formationId)

	local bossCount = 0
	local listHeroInfo = battleTeamInfo.listHeroInfo
	local heroCount = listHeroInfo:Count()
	for i = 1, heroCount do
		--- @type HeroBattleInfo
		local heroBattleInfo = listHeroInfo:Get(i)
		if heroBattleInfo.isBoss then
			bossCount = bossCount + 1
		end
	end
	local allowScale = bossCount < 5

	for i = 1, heroCount do
		--- @type HeroBattleInfo
		local heroBattleInfo = listHeroInfo:Get(i)
		self:SetHeroAtPosition(heroBattleInfo.isFrontLine, heroBattleInfo.position,
				self:CreateHeroResourceFromHeroBattleInfo(heroBattleInfo), onFinish, allowScale)
	end

	local summonerBattleInfo = battleTeamInfo.summonerBattleInfo
	if summonerBattleInfo.isDummy == false then
		local heroResource = HeroResource()
		heroResource.heroId = summonerBattleInfo.summonerId
		heroResource.heroStar = summonerBattleInfo.star
		heroResource.heroLevel = 0
		heroResource.heroItem = summonerBattleInfo.items
		self:ShowSummoner(heroResource, heroResource.heroStar > 3, onFinish)
	end
end

function WorldTeamFormation:OnHide()
	if self.frontLineDict ~= nil then
		--- @param v HeroSlotWorldFormation
		for _, v in pairs(self.frontLineDict:GetItems()) do
			v:ReturnPool()
		end
	end
	if self.backLineDict ~= nil then
		--- @param v HeroSlotWorldFormation
		for _, v in pairs(self.backLineDict:GetItems()) do
			v:ReturnPool()
		end
	end
	if self.summonerSlot ~= nil then
		self.summonerSlot:ReturnPool()
	end
end

--- @return HeroSlotWorldFormation
function WorldTeamFormation:GetMoreHeroWorldSlot()
	--- @type HeroSlotWorldFormation
	local script = SmartPool.Instance:SpawnLuaGameObject(AssetType.UIPool, self.heroSlotWorldFormationType)
	script:Init(self.worldFormation.config.transform, self.isAttackerTeam)
	script:EnableBuffIcon(true)

	script.btnCallbackRemove = function(positionTable)
		self:BtnCallbackRemove(positionTable)
	end
	script.btnCallbackSelect = function(positionTable)
		self:BtnCallbackSelect(positionTable)
	end
	script.btnCallbackSwap = function(positionTable)
		self:BtnCallbackSwap(positionTable)
	end
	script.triggerPointerDown = function(positionTable)
		self:BtnTriggerPointerDown(positionTable)
	end
	script.triggerPointerUp = function(position, deltaDrag)
		self:BtnTriggerPointerUp(position, deltaDrag)
	end
	script.triggerPointerDrag = function(position)
		self:BtnTriggerPointerDrag(position)
	end
	script:FlipLeft(not self.isAttackerTeam)
	return script
end

--- @param positionTable {isFrontLine, positionId}
function WorldTeamFormation:BtnCallbackSelect(positionTable)
	if self.btnCallbackSelect ~= nil then
		self.btnCallbackSelect(self.isAttackerTeam, positionTable)
	end
end

--- @param positionTable {isFrontLine, positionId}
function WorldTeamFormation:BtnCallbackRemove(positionTable)
	if self.btnCallbackRemove ~= nil then
		self.btnCallbackRemove(self.isAttackerTeam, positionTable)
	end
end

--- @param positionTable {isFrontLine, positionId}
function WorldTeamFormation:BtnCallbackSwap(positionTable)
	if self.btnCallbackSwap ~= nil then
		self.btnCallbackSwap(self.isAttackerTeam, positionTable)
	end
end

--- @param positionTable {isFrontLine, positionId}
function WorldTeamFormation:BtnTriggerPointerDown(positionTable)
	if self.btnTriggerPointerDown ~= nil then
		self.btnTriggerPointerDown(self.isAttackerTeam, positionTable)
	end
end

--- @param position UnityEngine_Vector3
function WorldTeamFormation:BtnTriggerPointerUp(position)
	if self.btnTriggerPointerUp ~= nil then
		self.btnTriggerPointerUp(self.isAttackerTeam, position)
	end
end

--- @param position UnityEngine_Vector3
function WorldTeamFormation:BtnTriggerPointerDrag(position)
	if self.btnTriggerPointerDrag ~= nil then
		self.btnTriggerPointerDrag(self.isAttackerTeam, position)
	end
end

--- @return HeroSlotWorldFormation
--- @param isFrontLine boolean
--- @param positionId number
function WorldTeamFormation:GetSlotByPosition(isFrontLine, positionId)
	if isFrontLine == true then
		return self.frontLineDict:Get(positionId)
	else
		return self.backLineDict:Get(positionId)
	end
end

--- @param selectedSlot {isFrontLine, positionId}
function WorldTeamFormation:EnableSwapOnOtherSlot(selectedSlot)
	for _, v in pairs(self.frontLineDict:GetItems()) do
		v:EnableBtnSelect(false)
		v:EnableBtnSwap(true)
	end
	for _, v in pairs(self.backLineDict:GetItems()) do
		v:EnableBtnSelect(false)
		v:EnableBtnSwap(true)
	end
	local slot = self:GetSlotByPosition(selectedSlot.isFrontLine, selectedSlot.positionId)
	slot:EnableBtnSwap(false)
	slot:EnableBtnRemove(true)
	--self:CheckCanRemove(slot)
end

function WorldTeamFormation:CheckCanRemove(slot)
	if zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_KAZETSU) then
		if slot.heroResource.heroId == HeroConstants.KAZETSU_HERO_ID then
			slot:DisableRemoveButton()
		end
	end
end

function WorldTeamFormation:ResetButtonSlot()
	--- @param v HeroSlotWorldFormation
	for _, v in pairs(self.frontLineDict:GetItems()) do
		v:ResetButtonSlot()
	end
	for _, v in pairs(self.backLineDict:GetItems()) do
		v:ResetButtonSlot()
	end
end

--- @param heroResource HeroResource
--- @param enableBtnChange boolean
function WorldTeamFormation:ShowSummoner(heroResource, enableBtnChange)
	if heroResource == nil then
		return
	end
	if self.summonerSlot == nil then
		self.summonerSlot = self:GetMoreHeroWorldSlot()
		self.summonerSlot:EnableTextSlot(false)
		self.summonerSlot:EnableBuffStat(false)

		self.summonerSlot.config.buttonSwap.onClick:RemoveAllListeners()
		self.summonerSlot.config.buttonRemove.onClick:RemoveAllListeners()

		local summonerPos = FormationPositionConfig.GetSummonerPosition(self.isAttackerTeam)
		self.summonerSlot:SetPosition(summonerPos, nil, nil)
	end
	if heroResource ~= nil then
		self.summonerSlot:SetSummonerSlot(heroResource)
		self.summonerSlot:EnableBtnChange(enableBtnChange and heroResource.heroStar > 3)
		if enableBtnChange == true then
			self.summonerSlot:EnableModification(true)
			self.summonerSlot.btnChangeCallback = function()
				if self.btnCallbackSelectSummoner ~= nil then
					self.btnCallbackSelectSummoner()
				end
			end
		end
	else
		self.summonerSlot:OnRemoveSlot()
	end
end

--- @return HeroResource
--- @param heroBattleInfo HeroBattleInfo
function WorldTeamFormation:CreateHeroResourceFromHeroBattleInfo(heroBattleInfo)
	local heroResource = HeroResource()
	heroResource.heroId = heroBattleInfo.heroId
	heroResource.heroLevel = heroBattleInfo.level
	heroResource.heroStar = heroBattleInfo.star
	heroResource.isBoss = heroBattleInfo.isBoss
	heroResource.heroItem = heroBattleInfo.items
	heroResource.isHideSkin = heroBattleInfo.isHideSkin
	return heroResource
end

--- @return {isFrontLine, positionId}
--- @param pos UnityEngine_Vector3
--- @param rangeToGetSlot number
function WorldTeamFormation:GetNearestSlotFromPos(pos, rangeToGetSlot)
	--- @type number
	local minSqrDist = 1000
	--- @type HeroSlotWorldFormation
	local nearestSlot
	--- @param v HeroSlotWorldFormation
	for _, v in pairs(self.frontLineDict:GetItems()) do
		if v:IsModifiable() == true then
			local tempPos = v:GetPosition()
			if nearestSlot == nil then
				nearestSlot = v
				local vectorDist = pos - tempPos
				vectorDist.z = 0
				minSqrDist = vectorDist.sqrMagnitude
			else
				local vectorDist = pos - tempPos
				vectorDist.z = 0

				local sqrDist = vectorDist.sqrMagnitude
				if sqrDist < minSqrDist then
					minSqrDist = sqrDist
					nearestSlot = v
				end
			end
		end
	end
	--- @param v HeroSlotWorldFormation
	for _, v in pairs(self.backLineDict:GetItems()) do
		if v:IsModifiable() then
			local tempPos = v:GetPosition()
			local vectorDist = pos - tempPos
			vectorDist.z = 0

			local sqrDist = vectorDist.sqrMagnitude
			if sqrDist < minSqrDist then
				minSqrDist = sqrDist
				nearestSlot = v
			end
		end
	end

	if nearestSlot ~= nil then
		local vectorDist = nearestSlot:GetPosition() - pos
		vectorDist.z = 0
		local sqrDist = vectorDist.sqrMagnitude
		if sqrDist <= (rangeToGetSlot * rangeToGetSlot) then
			return nearestSlot.positionTable
		end
		return nil
	end
	return nil
end

--- @param mainCam UnityEngine_Camera
function WorldTeamFormation:SetMainCamera(mainCam)
	for _, v in pairs(self.frontLineDict:GetItems()) do
		v:SetMainCamera(mainCam)
	end
	for _, v in pairs(self.backLineDict:GetItems()) do
		v:SetMainCamera(mainCam)
	end
end

--- @param isEnable boolean
--- @param listPositionTable List<number>
function WorldTeamFormation:EnableLinking(isEnable, listPositionTable)
	if isEnable == false then
		for _, v in pairs(self.frontLineDict:GetItems()) do
			v:EnableLinking(false)
		end
		for _, v in pairs(self.backLineDict:GetItems()) do
			v:EnableLinking(false)
		end
	else
		for i = 1, listPositionTable:Count() do
			--- @type {isFrontLine, positionId}
			local positionTable = listPositionTable:Get(i)
			local heroWorldSlot = self:GetSlotByPosition(positionTable.isFrontLine, positionTable.positionId)
			heroWorldSlot:EnableLinking(isEnable)
		end
	end
end

--- @param isEnable boolean
function WorldTeamFormation:EnableModification(isEnable)
	if self.summonerSlot ~= nil
			and self.summonerSlot.heroResource.heroStar > HeroConstants.DEFAULT_SUMMONER_STAR then
		self.summonerSlot:EnableModification(isEnable)
		self.summonerSlot:EnableBtnChange(isEnable)
	end
	--- @param v HeroSlotWorldFormation
	for _, v in pairs(self.frontLineDict:GetItems()) do
		v:EnableModification(isEnable)
	end
	--- @param v HeroSlotWorldFormation
	for _, v in pairs(self.backLineDict:GetItems()) do
		v:EnableModification(isEnable)
	end
end

function WorldTeamFormation:EnableBuffStat(isEnable, value)
	--- @param v HeroSlotWorldFormation
	for _, v in pairs(self.frontLineDict:GetItems()) do
		v:EnableBuffStat(isEnable, value)
	end
	--- @param v HeroSlotWorldFormation
	for _, v in pairs(self.backLineDict:GetItems()) do
		v:EnableBuffStat(isEnable, value)
	end
end

function WorldTeamFormation:EnableLockSlot(isFrontLine, positionId, isLock)
	local slot = self:GetSlotByPosition(isFrontLine, positionId)
	if slot then
		slot:EnableLockSlot(isLock)
	end
end