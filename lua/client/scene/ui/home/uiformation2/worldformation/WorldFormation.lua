require "lua.client.scene.ui.home.uiFormation2.worldFormation.WorldTeamFormation"
require "lua.client.scene.ui.home.uiFormation2.worldFormation.WorldFormationModel"
require "lua.client.scene.ui.home.uiFormation2.heroSlotWorldFormation.HeroSlotWorldFormation"

--- @class WorldFormation
WorldFormation = Class(WorldFormation)

--- @param transform UnityEngine_Transform
function WorldFormation:Ctor(transform)
    --- @type WorldFormationConfig
    self.config = UIBaseConfig(transform)
    self.model = WorldFormationModel()

    --- @type BattleView
    self.battleView = nil
    --- @type WorldTeamFormation
    self.attackerWorldFormation = nil
    --- @type WorldTeamFormation
    self.defenderWorldFormation = nil

    --- @type HeroSlotWorldFormation
    self.dragHeroSlot = nil

    --- @type table
    self.removeCallback = nil
    --- @type table
    self.swapCallback = nil
    --- @type table
    self.selectSummonerCallback = nil

    self:InitButtonListener()
    transform:SetParent(zgUnity.transform)
end

function WorldFormation:InitButtonListener()
    self.config.buttonCancelSelect.onClick:RemoveAllListeners()
    self.config.buttonCancelSelect.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
        self:ResetButtonSlot()
    end)
end

function WorldFormation:InitReferences()
    self.attackerWorldFormation = WorldTeamFormation(self, true)
    self.attackerWorldFormation.btnCallbackSelect = function(isAttackerTeam, positionTable)
        self:CallbackSelectHero(isAttackerTeam, positionTable)
    end
    self.attackerWorldFormation.btnCallbackChange = function(isAttackerTeam, positionTable)
        self:CallbackChange(isAttackerTeam, positionTable)
    end
    self.attackerWorldFormation.btnCallbackRemove = function(isAttackerTeam, positionTable)
        self:CallbackRemoveHero(isAttackerTeam, positionTable)
    end
    self.attackerWorldFormation.btnCallbackSwap = function(isAttackerTeam, positionTable)
        self:CallbackSwapHero(isAttackerTeam, positionTable)
    end
    self.attackerWorldFormation.btnCallbackSelectSummoner = function()
        self:CallbackSelectSummoner()
    end

    self.attackerWorldFormation.btnTriggerPointerDown = function(isAttackerTeam, positionTable)
        self:SlotTriggerPointerDown(isAttackerTeam, positionTable)
    end
    self.attackerWorldFormation.btnTriggerPointerUp = function(isAttackerTeam, position)
        self:SlotTriggerPointerUp(isAttackerTeam, position)
    end
    self.attackerWorldFormation.btnTriggerPointerDrag = function(isAttackerTeam, position)
        self:SlotTriggerPointerDrag(isAttackerTeam, position)
    end
    self.defenderWorldFormation = WorldTeamFormation(self, false)
end

--- @param isAttackerTeam boolean
--- @param isFrontLine boolean
--- @param position number
--- @param heroResource HeroResource
function WorldFormation:SetHeroAtPosition(isAttackerTeam, isFrontLine, position, heroResource)
    if isAttackerTeam == true then
        self.model:SetHeroResourceByPosition(isAttackerTeam, heroResource, isFrontLine, position)
        self.attackerWorldFormation:SetHeroAtPosition(isFrontLine, position, heroResource)
    end
end

--- @param isAttackerTeam boolean
--- @param isFrontLine boolean
--- @param position
function WorldFormation:RemoveHeroAtPosition(isAttackerTeam, isFrontLine, position)
    if isAttackerTeam == true then
        self:SetHeroAtPosition(true, isFrontLine, position, nil)
    else
        self.defenderWorldFormation:RemoveHeroAtPosition(isFrontLine, position)
    end
end

--- @param detailTeamFormation DetailTeamFormation
function WorldFormation:ShowAttackerPredefineTeam(detailTeamFormation)
    if detailTeamFormation == nil then
        return
    end
    self.model.attackerTeamFormation = detailTeamFormation
    self.attackerWorldFormation:ShowTeamHeroPredefine(detailTeamFormation)
end

--- @param summonerId number
function WorldFormation:ShowAttackerSummoner(summonerId, star)
    local heroResource = HeroResource()
    heroResource.heroId = summonerId
    heroResource.heroStar = star
    heroResource.heroLevel = 0
    self.attackerWorldFormation:ShowSummoner(heroResource, star > 3)
end

--- @param battleTeamInfo BattleTeamInfo
function WorldFormation:SetDefenderPredefineTeamData(battleTeamInfo)
    self.model.defenderBattleTeamInfo = battleTeamInfo
end

function WorldFormation:OnShow(allowDrag)
    if allowDrag ~= nil then
        self.allowDrag = allowDrag
    else
        self.allowDrag = true
    end

    self:InitReferences()
    self:ShowBackground()
    self.config.gameObject:SetActive(true)

    self.listenerApplicationPause = RxMgr.applicationPause:Subscribe(RxMgr.CreateFunction(self, self.OnApplicationPause))
end

function WorldFormation:InitBattleView()
    if self.battleView == nil then
        self.battleView = zg.battleMgr:GetBattleView()
    end
    self.attackerWorldFormation:SetMainCamera(self.battleView:GetMainCamera())
end

function WorldFormation:ShowBackground()
    self:InitBattleView()

    self.battleView:EnableMainCamera(true)
    self.battleView:SetActive(true)
end

function WorldFormation:OnHide()
    self.attackerWorldFormation:OnHide()
    self.defenderWorldFormation:OnHide()
    SmartPool.Instance:DespawnGameObject(AssetType.UI, "world_formation", self.config.transform)
    if self.battleView ~= nil then
        self.battleView:OnHide()
        self.battleView = nil
    end
    self.model:ClearData()
    self:HideDragHeroSlot()
    self:EnableButtonCancel(false)

    if self.listenerApplicationPause ~= nil then
        self.listenerApplicationPause:Unsubscribe()
        self.listenerApplicationPause = nil
    end
end

--- @param isEnable boolean
function WorldFormation:EnableDefenderTeamView(isEnable)
    local onFinish = function() end
    if isEnable == true then
        self.defenderWorldFormation:ShowBattleTeamInfo(self.model.defenderBattleTeamInfo, onFinish)
        self.defenderWorldFormation:DisableSlotBuffStat()
        self.model.isShowDefender = true
        if self.defenderWorldFormation.summonerSlot ~= nil then
            self.defenderWorldFormation.summonerSlot:EnableBtnChange(false)
        end
    end
    self.defenderWorldFormation:EnableTeamView(isEnable)
end

--- @param formationId number
function WorldFormation:SetAttackerFormation(formationId)
    self.attackerWorldFormation:SetFormation(formationId)
end

--- @param isAttackerTeam boolean
--- @param positionTable {isFrontLine, positionId}
function WorldFormation:CallbackSelectHero(isAttackerTeam, positionTable)
    self.model.selectedSlot = positionTable
    self.attackerWorldFormation:EnableSwapOnOtherSlot(positionTable)
    self:EnableButtonCancel(true)
end

--- @param isAttackerTeam boolean
--- @param positionTable {isFrontLine, positionId}
function WorldFormation:CallbackChange(isAttackerTeam, positionTable)
    self.attackerWorldFormation:EnableSwapOnOtherSlot(positionTable)
    self:EnableButtonCancel(true)
end

--- @param isAttackerTeam boolean
--- @param positionTable {isFrontLine, positionId}
function WorldFormation:CallbackSwapHero(isAttackerTeam, positionTable)
    if positionTable == self.model.selectedSlot then
        return
    end
    local selectedHeroResource = self.model.attackerTeamFormation:GetHeroResourceByPosition(self.model.selectedSlot.isFrontLine, self.model.selectedSlot.positionId)
    local swapHeroResource = self.model.attackerTeamFormation:GetHeroResourceByPosition(positionTable.isFrontLine, positionTable.positionId)
    --self.model.attackerTeamFormation:SetHeroResourceByPosition(selectedHeroResource, positionTable.isFrontLine, positionTable.positionId)
    --self.model.attackerTeamFormation:SetHeroResourceByPosition(swapHeroResource, self.model.selectedSlot.isFrontLine, self.model.selectedSlot.positionId)

    self:SetHeroAtPosition(true, self.model.selectedSlot.isFrontLine, self.model.selectedSlot.positionId, swapHeroResource)
    self:SetHeroAtPosition(true, positionTable.isFrontLine, positionTable.positionId, selectedHeroResource)

    if self.swapCallback ~= nil then
        self.swapCallback(self.model.selectedSlot, positionTable)
    end
    self:ResetButtonSlot()
end

--- @param isAttackerTeam boolean
--- @param positionTable {isFrontLine, positionId}
function WorldFormation:CallbackRemoveHero(isAttackerTeam, positionTable)
    if self.removeCallback ~= nil then
        self.removeCallback(positionTable)
    end
    self:SetHeroAtPosition(true, positionTable.isFrontLine, positionTable.positionId, nil)

    self:ResetButtonSlot()
    self.model:ClearSlotStuff()
end

function WorldFormation:CallbackSelectSummoner()
    if self.selectSummonerCallback ~= nil then
        self.selectSummonerCallback()
    end
end

--- @param isAttackerTeam boolean
--- @param positionTable {isFrontLine, positionId}
function WorldFormation:SlotTriggerPointerDown(isAttackerTeam, positionTable)
    self.model.isStartDrag = false
    self.model.selectedSlot = positionTable
end

--- @param isAttackerTeam boolean
--- @param position UnityEngine_Vector3
function WorldFormation:SlotTriggerPointerUp(isAttackerTeam, position)
    if self.model.isStartDrag == false or self.battleView == nil then
        return
    end
    self.model.isStartDrag = false

    local pos = self.battleView:ScreenToWorldPoint(U_Vector3(position.x, position.y, self.battleView:GetMainCamera().nearClipPlane))
    pos = pos + WorldFormationModel.OFFSET_DRAG
    local newSlot = self.attackerWorldFormation:GetNearestSlotFromPos(pos, WorldFormationModel.RANGE_TO_GET_SLOT)
    if newSlot ~= nil
            and (newSlot.isFrontLine ~= self.model.selectedSlot.isFrontLine or newSlot.positionId ~= self.model.selectedSlot.positionId) then
        self:CallbackSwapHero(true, newSlot)
        if self.model.tempSwapHero ~= nil and self.model.tempSwapSlot ~= nil and newSlot ~= self.model.tempSwapSlot then
            self:SetHeroAtPosition(true, self.model.tempSwapSlot.isFrontLine, self.model.tempSwapSlot.positionId, self.model.tempSwapHero)
        end
    else
        local heroResource = self.model.attackerTeamFormation:GetHeroResourceByPosition(
                self.model.selectedSlot.isFrontLine, self.model.selectedSlot.positionId)
        self:SetHeroAtPosition(true,
                self.model.selectedSlot.isFrontLine,
                self.model.selectedSlot.positionId, heroResource)
        if self.model.tempSwapHero ~= nil and self.model.tempSwapSlot ~= nil then
            self:SetHeroAtPosition(true, self.model.tempSwapSlot.isFrontLine, self.model.tempSwapSlot.positionId, self.model.tempSwapHero)
        end
    end

    self.model:ClearSlotStuff()
    if self.dragHeroSlot ~= nil then
        self.dragHeroSlot:SetEnable(false)
    end
    self.model.tempSwapSlot = nil
    self.model.tempSwapHero = nil
    self.attackerWorldFormation:EnableLinking(false)
end

--- @param position UnityEngine_Vector3
function WorldFormation:GetNearestSlotFromPos(position)
    local pos = self.battleView:ScreenToWorldPoint(U_Vector3(position.x, position.y, self.battleView:GetMainCamera().nearClipPlane))
    pos = pos + WorldFormationModel.OFFSET_DRAG
    local newSlot = self.attackerWorldFormation:GetNearestSlotFromPos(pos, WorldFormationModel.RANGE_TO_GET_SLOT)
    return newSlot
end

--- @param position UnityEngine_Vector3
function WorldFormation:CheckOverlapSlot(position, isFrontLine, positionId)
    local slot = self.attackerWorldFormation:GetSlotByPosition(isFrontLine, positionId)
    local buttonSelect = slot.config.buttonSelect
    --- @type UnityEngine_RectTransform
    local btnRect = buttonSelect:GetComponent(ComponentName.UnityEngine_RectTransform)

    local width = btnRect.sizeDelta.x
    local height = btnRect.sizeDelta.y

    local screenPoint = self.battleView:WorldToScreenPoint(btnRect.position)
    local upperLeftPos = U_Vector2(screenPoint.x, screenPoint.y) - U_Vector2(width / 2, height / 2)
    local rect = U_Rect(upperLeftPos.x, upperLeftPos.y, width, height)
    return rect:Contains(position)
end

--- @param isAttackerTeam boolean
--- @param position UnityEngine_Vector3
function WorldFormation:SlotTriggerPointerDrag(isAttackerTeam, position)
    if self.model.selectedSlot == nil then
        self:SlotTriggerPointerUp(isAttackerTeam, position)
        self.model:ClearSlotStuff()
        if self.dragHeroSlot ~= nil then
            self.dragHeroSlot:SetEnable(false)
        end
        return
    end
    if self.model.isStartDrag == false then
        self.model.isStartDrag = true
        self:SetUpDragSlot()
    end
    self.dragHeroSlot:UpdateLayer(0, 10000)
    local pos = self.battleView:ScreenToWorldPoint(U_Vector3(position.x, position.y, self.battleView:GetMainCamera().nearClipPlane))
    pos = pos + WorldFormationModel.OFFSET_DRAG
    self.dragHeroSlot:SetPosition(U_Vector3(pos.x, pos.y, 0))

    --- @type {isFrontLine, positionId}
    local newSlot = self.attackerWorldFormation:GetNearestSlotFromPos(pos, WorldFormationModel.RANGE_TO_GET_SLOT)
    if newSlot ~= nil and newSlot ~= self.model.tempSwapSlot then
        --- @type HeroSlotWorldFormation
        local newHeroWorldSlot = self.attackerWorldFormation:GetSlotByPosition(newSlot.isFrontLine, newSlot.positionId)
        local selectedHeroWorldSlot = self.attackerWorldFormation:GetSlotByPosition(self.model.selectedSlot.isFrontLine, self.model.selectedSlot.positionId)

        if newSlot ~= self.model.selectedSlot then
            newHeroWorldSlot:EnableLinking(true)
            if self.model.tempSwapSlot ~= nil then
                local tempHeroWorldSlot = self.attackerWorldFormation:GetSlotByPosition(self.model.tempSwapSlot.isFrontLine, self.model.tempSwapSlot.positionId)
                tempHeroWorldSlot:SetHeroSlot(self.model.tempSwapHero)
                tempHeroWorldSlot:EnableLinking(false)
                self.model.tempSwapSlot = newSlot
            else

            end
            local newHeroResource = newHeroWorldSlot.heroResource
            self.model.tempSwapHero = newHeroResource
            self.model.tempSwapSlot = newSlot

            selectedHeroWorldSlot:SetHeroSlot(newHeroResource)
            newHeroWorldSlot:SetHeroSlot(nil)
        elseif newSlot == self.model.selectedSlot then
            newHeroWorldSlot:EnableLinking(false)
            selectedHeroWorldSlot:SetHeroSlot(nil)
            if self.model.tempSwapSlot ~= nil then
                local tempHeroWorldSlot = self.attackerWorldFormation:GetSlotByPosition(self.model.tempSwapSlot.isFrontLine, self.model.tempSwapSlot.positionId)
                tempHeroWorldSlot:SetHeroSlot(self.model.tempSwapHero)
                tempHeroWorldSlot:EnableLinking(false)
            end
            self.model.tempSwapHero = nil
            self.model.tempSwapSlot = nil
        end
    elseif newSlot == nil then
        if self.model.tempSwapSlot ~= nil then
            local heroWorldSlot = self.attackerWorldFormation:GetSlotByPosition(self.model.tempSwapSlot.isFrontLine, self.model.tempSwapSlot.positionId)
            heroWorldSlot:SetHeroSlot(self.model.tempSwapHero)
            heroWorldSlot:EnableLinking(false)
        end
        self.model.tempSwapSlot = nil
        self.model.tempSwapHero = nil

        local selectedHeroWorldSlot = self.attackerWorldFormation:GetSlotByPosition(self.model.selectedSlot.isFrontLine, self.model.selectedSlot.positionId)
        selectedHeroWorldSlot:SetHeroSlot(nil)
    end
end

function WorldFormation:SetUpDragSlot()
    local slot = self.attackerWorldFormation:GetSlotByPosition(self.model.selectedSlot.isFrontLine, self.model.selectedSlot.positionId)
    if slot then
        slot:SetHeroSlot(nil)
    else
        XDebug.Error(string.format("Error Slot: is_front: %s, position: %s", tostring(self.model.selectedSlot.isFrontLine), tostring(self.model.selectedSlot.positionId)))
    end

    if self.dragHeroSlot == nil then
        --- @type HeroSlotWorldFormation
        self.dragHeroSlot = SmartPool.Instance:SpawnLuaGameObject(AssetType.UIPool, UIPoolType.HeroSlotWorldFormation)
        self.dragHeroSlot.config.buffIcon.gameObject:SetActive(false)
        self.dragHeroSlot:EnableTextSlot(false)
        self.dragHeroSlot:EnableBuffStat(false)
        self.dragHeroSlot:Init(self.config.transform)
    end
    self.dragHeroSlot:SetMainCamera(self.battleView:GetMainCamera())

    local heroResource = self.model.attackerTeamFormation:GetHeroResourceByPosition(
            self.model.selectedSlot.isFrontLine,
            self.model.selectedSlot.positionId)
    self.dragHeroSlot:SetHeroSlot(heroResource)
    self.dragHeroSlot:SetEnable(true)
end

function WorldFormation:ResetButtonSlot()
    self.attackerWorldFormation:ResetButtonSlot()
    self:EnableButtonCancel(false)
end

--- @return UnityEngine_UI_Button
--- @param isFrontLine boolean
--- @param position number
function WorldFormation:GetAttackerButtonSlotByPosition(isFrontLine, position)
    local heroSlotWorldFormation = self.attackerWorldFormation:GetSlotByPosition(isFrontLine, position)
    local config = heroSlotWorldFormation.config
    if config.buttonSelect.gameObject.activeSelf == true then
        return config.buttonSelect
    elseif config.buttonSwap.gameObject.activeSelf == true then
        return config.buttonSwap
    end
    return config.buttonRemove
end

--- @param isFrontLine boolean
--- @param position number
function WorldFormation:GetSummonerSlot()
    local summonerSlotWorldFormation = self.attackerWorldFormation.summonerSlot
    return summonerSlotWorldFormation.config
end

--- @return UnityEngine_Vector3
--- @param transform UnityEngine_Transform
function WorldFormation:GetPositionUI(transform)
    return uiCanvas.camIgnoreBlur:ScreenToWorldPoint(self:WorldToScreen(transform.position))
end

--- @return UnityEngine_Vector3
--- @param position UnityEngine_Vector3
function WorldFormation:WorldToScreen(position)
    return self.battleView:WorldToScreenPoint(position)
end

function WorldFormation:HideDragHeroSlot()
    if self.dragHeroSlot ~= nil then
        self.dragHeroSlot:ReturnPool()
        self.dragHeroSlot = nil
    end
end

--- @return UnityEngine_Sprite
--- @param isFrontLine boolean
--- @param char string
function WorldFormation:GetCharStatByLine(isFrontLine, char)
    if isFrontLine then
        return ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.formationNumber, "f_" .. char)
    else
        return ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.formationNumber, "b_" .. char)
    end
end

--- @param isEnable boolean
function WorldFormation:EnableButtonCancel(isEnable)
    self.config.buttonCancelSelect.gameObject:SetActive(isEnable)
end

--- @param teamId number
--- @param isEnable boolean
--- @param listHeroId List
function WorldFormation:EnableLinking(teamId, isEnable, listHeroId)
    local worldTeamFormation = self.attackerWorldFormation
    if teamId == BattleConstants.DEFENDER_TEAM_ID then
        worldTeamFormation = self.defenderWorldFormation
    end
    if isEnable == false then
        worldTeamFormation:EnableLinking(false)
    else
        local listPositionTable = self.model:FindListPositionByListHeroId(teamId, listHeroId)
        worldTeamFormation:EnableLinking(true, listPositionTable)
    end
end

function WorldFormation:RevertTempSwitch()
    if self.model.tempSwapSlot ~= nil and self.model.tempSwapHero ~= nil then
        self:SetHeroAtPosition(true, self.model.tempSwapSlot.isFrontLine, self.model.tempSwapSlot.positionId, self.model.tempSwapHero)
    end
    --- @type HeroSlotWorldFormation
    if self.model.selectedSlot ~= nil and self.dragHeroSlot ~= nil then
        local selectedHeroResource = self.dragHeroSlot.heroResource
        if selectedHeroResource ~= nil then
            self:SetHeroAtPosition(true, self.model.selectedSlot.isFrontLine, self.model.selectedSlot.positionId, selectedHeroResource)
        end
    end
    self.attackerWorldFormation:EnableLinking(false)
    self:HideDragHeroSlot()
    self.model.selectedSlot = nil
    self.model.tempSwapSlot = nil
    self.model.tempSwapHero = nil
end

--- @param prefabAnchorTopName string
--- @param prefabAnchorBotName string
function WorldFormation:ShowBgAnchor(prefabAnchorTopName, prefabAnchorBotName)
    if self.battleView ~= nil then
        self.battleView:ShowBgAnchor(prefabAnchorTopName, prefabAnchorBotName)
        self.battleView:UpdateView()
    end
end

--- @param status PauseStatus
function WorldFormation:OnApplicationPause(status)
    if status == PauseStatus.PAUSE or status == PauseStatus.FOCUS then
        if self.dragHeroSlot ~= nil then
            self:RevertTempSwitch()
        end
    end
end

--- @param isEnable boolean
function WorldFormation:EnableModification(isEnable)
    self.config.worldCanvas.enabled = isEnable
    self.attackerWorldFormation:EnableModification(isEnable)
    self.defenderWorldFormation:EnableModification(isEnable)
end