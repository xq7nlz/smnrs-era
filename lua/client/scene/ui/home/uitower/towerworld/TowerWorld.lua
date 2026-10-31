require "lua.client.scene.ui.home.uiTower.towerWorld.TowerWorldModel"
require "lua.client.scene.ui.home.uiTower.towerWorld.FloorTowerWorld"

--- @class TowerWorld
TowerWorld = Class(TowerWorld)

local maxTowerWorldY = 1700
local minTowerWorldY = 600
local minBorderLeftView = -10

--- @param transform UnityEngine_Transform
--- @param uiTowerView UITowerView
function TowerWorld:Ctor(transform, uiTowerView)
    --- @type TowerWorldConfig
    self.config = UIBaseConfig(transform)
    --- @type TowerWorldModel
    self.towerWorldModel = TowerWorldModel(self.config)

    --- @type UITowerView
    self.view = uiTowerView
    --- @type UITowerModel
    self.model = self.view.model

    self:Init()
end

function TowerWorld:Init()
    UIUtils.SetParent(self.config.transform, zgUnity.transform)

    self.towerWorldModel:SetUpCamStat(self.config.camera.fieldOfView, math.abs(self.config.cameraTransform.localPosition.x))
    self.towerWorldModel:SetMaxLevel(ResourceMgr.GetTowerConfig().maxFloor)

    self.config.topFloor.localPosition = U_Vector3(0, self.towerWorldModel.maxFloorLevel * TowerWorldModel.FLOOR_HEIGHT + TowerWorldModel.OFFSET_HEIGHT, 0)

    self:FitCamViewPosition()
end

function TowerWorld:FitCamViewPosition()
    local camPos = self.config.cameraTransform.position
    local fieldOfView = self.config.camera.fieldOfView
    local hFov = fieldOfView * self.config.camera.aspect
    local rad = math.rad(hFov / 2)
    local range = math.tan(rad) * math.abs(camPos.z)
    local borderLeft = camPos.x - range
    if borderLeft > minBorderLeftView then
        self.config.cameraTransform.position = U_Vector3(camPos.x - (borderLeft - minBorderLeftView), camPos.y, camPos.z)
    end
end

--- @param scrollBarValue number
function TowerWorld:OnShow(scrollBarValue)
    self.config.comingSoonText.text = LanguageUtils.LocalizeCommon("coming_soon")
    self:InitBuildFloor()
    self:Update(scrollBarValue)
    self.config.gameObject:SetActive(true)
end

function TowerWorld:OnHide()
    self.towerWorldModel:OnHide()
    self.config.gameObject:SetActive(false)
end

--- @param scrollBarValue number
function TowerWorld:Update(scrollBarValue)
    self:SetCamPos(scrollBarValue)
    self:CheckFloorView()
    self:SetBgAnchorPos(scrollBarValue)
end

--- @param scrollBarValue number
function TowerWorld:SetCamPos(scrollBarValue)
    local camPos = self.config.cameraTransform.localPosition
    camPos.y = self.towerWorldModel.camMoveLength * scrollBarValue + self.towerWorldModel.clampCamBot
    self.config.cameraTransform.localPosition = camPos

    self.towerWorldModel.topView = camPos.y + self.towerWorldModel.camViewHeight / 2
    self.towerWorldModel.botView = camPos.y - self.towerWorldModel.camViewHeight / 2
end

function TowerWorld:CheckFloorView()
    if self.towerWorldModel.topView > (self.towerWorldModel.topFloorLevel - 1) * TowerWorldModel.FLOOR_HEIGHT then
        if self.towerWorldModel.topFloorLevel < self.towerWorldModel.maxFloorLevel then
            self:ExtendUp()
            self.view:OnExtendFloor(self.towerWorldModel.topFloorLevel)
            self:CheckFloorView()
        end
    elseif self.towerWorldModel.botView < self.towerWorldModel.botFloorLevel * TowerWorldModel.FLOOR_HEIGHT then
        if self.towerWorldModel.botFloorLevel > 1 then
            self:ExtendDown()
            self.view:OnExtendFloor(self.towerWorldModel.botFloorLevel)
            self:CheckFloorView()
        end
    end
end

function TowerWorld:ExtendUp()
    local botFloor = self.towerWorldModel.usingFloorDict:Get(self.towerWorldModel.botFloorLevel)
    if botFloor ~= nil then
        self.towerWorldModel:PushFloorIntoPool(botFloor)
    end
    self.towerWorldModel.usingFloorDict:RemoveByKey(self.towerWorldModel.botFloorLevel)
    self.towerWorldModel:ExtendUp()
    self.towerWorldModel:GetInsFloorTowerWorld(self.towerWorldModel.topFloorLevel)
end

function TowerWorld:ExtendDown()
    local topFloor = self.towerWorldModel.usingFloorDict:Get(self.towerWorldModel.topFloorLevel)
    if topFloor ~= nil then
        self.towerWorldModel:PushFloorIntoPool(topFloor)
    end
    self.towerWorldModel.usingFloorDict:RemoveByKey(self.towerWorldModel.topFloorLevel)

    self.towerWorldModel:ExtendDown()
    self.towerWorldModel:GetInsFloorTowerWorld(self.towerWorldModel.botFloorLevel)
end

function TowerWorld:InitBuildFloor()
    self.towerWorldModel:SetUpModel(self.model.availableFloor)
    for i = self.towerWorldModel.botFloorLevel, self.towerWorldModel.topFloorLevel do
        self.towerWorldModel:GetInsFloorTowerWorld(i)
        self.view:OnExtendFloor(i)
    end
end

function TowerWorld:SetBgAnchorPos(scrollBarValue)
    local bgPos = self.config.bgAnchor.localPosition
    self.config.bgAnchor.localPosition = U_Vector3(bgPos.x, minTowerWorldY + ((maxTowerWorldY - minTowerWorldY) * scrollBarValue), bgPos.z)
end

--- @return number
--- @param screenPoint UnityEngine_Vector2
function TowerWorld:FindTowerClicked(screenPoint)
    local worldPoint = self.config.camera:ScreenToWorldPoint(U_Vector3(screenPoint.x, screenPoint.y, -self.config.camera.transform.localPosition.z))

    local minDistance = 10000
    local nearestFloor
    --- @param k number
    --- @param v FloorTowerWorld
    for k, v in pairs(self.towerWorldModel.usingFloorDict:GetItems()) do
        local pos = v:GetCenterPosition()
        local dis = (worldPoint - pos).sqrMagnitude
        if dis < minDistance then
            minDistance = dis
            nearestFloor = k
        end
    end
    if nearestFloor ~= nil and minDistance <= TowerWorldModel.DISTANCE_TO_SELECT then
        return nearestFloor
    end
    return nil
end

--- @param towerLevel number
function TowerWorld:SetHighlightFloor(towerLevel)
    self.config.highlight.gameObject:SetActive(false)
    self.config.arrowPointer.gameObject:SetActive(false)

    --- @type FloorTowerWorld
    local floorTowerWorld = self.towerWorldModel.usingFloorDict:Get(towerLevel)
    if floorTowerWorld ~= nil then
        self.towerWorldModel:SetHighlightSpriteByLevel(towerLevel)
        floorTowerWorld:SetHighlight(self.config.highlight.transform, self.config.arrowPointer, towerLevel)
        self.config.highlight.gameObject:SetActive(true)
        self.config.arrowPointer.gameObject:SetActive(true)
    end
end

--- @param itemIconData ItemIconData
function TowerWorld:SetReward(towerLevel, itemIconData)
    --- @type FloorTowerWorld
    local floorTowerWorld = self.towerWorldModel.usingFloorDict:Get(towerLevel)
    if floorTowerWorld ~= nil then
        floorTowerWorld:SetReward(itemIconData,
                towerLevel <= zg.playerData:GetMethod(PlayerDataMethod.TOWER).levelCurrent, U_Vector2(135, 135))
    end
end

--- @return boolean
--- @param towerLevel number
function TowerWorld:IsUsingFloor(towerLevel)
    return self.towerWorldModel.usingFloorDict:IsContainKey(towerLevel)
end

function TowerWorld:Destroy()
    U_Object.Destroy(self.config.gameObject)
end