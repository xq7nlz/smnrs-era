--- @class TowerWorldModel
TowerWorldModel = Class(TowerWorldModel)

TowerWorldModel.FLOOR_HEIGHT = 3.85
TowerWorldModel.CAM_DISTANCE = 10
TowerWorldModel.MAX_SPAWNED_FLOOR = 5
TowerWorldModel.OFFSET_HEIGHT = 1
TowerWorldModel.DISTANCE_TO_SELECT = 2.25

TowerWorldModel.GRAY_COLOR = U_Color(0.75, 0.75, 0.75, 1)
TowerWorldModel.N_COLOR = U_Color(1, 1, 1, 1)

--- @param towerWorldConfig TowerWorldConfig
function TowerWorldModel:Ctor(towerWorldConfig)
    --- @type TowerWorldConfig
    self.config = towerWorldConfig
    --- @type UnityEngine_Transform
    self.towerAnchor = towerWorldConfig.floorAnchor

    --- @type Dictionary
    self.usingFloorDict = Dictionary()

    --- @type number
    self.maxFloorLevel = nil
    --- @type number
    self.botFloorLevel = 1
    self.topFloorLevel = 2
    self.availableLevel = nil

    self.floorPrefab = towerWorldConfig.floorPrefab

    --- @type number
    self.clampCamBot = nil
    self.clampCamTop = nil
    self.camMoveLength = nil
    self.topView = nil
    self.botView = nil
    self.camViewHeight = nil

    self:_InitFloorPool()
end

function TowerWorldModel:_InitFloorPool()
    --- @type List
    self.listPooledFloor = List()
    for _ = 1, self.config.floorPool.childCount do
        local child = self.config.floorPool:GetChild(0)
        local floorTowerWorld = FloorTowerWorld(child, self.config.floorAnchor)
        self:PushFloorIntoPool(floorTowerWorld)
    end
end

function TowerWorldModel:SetUpCamStat(fieldOfView, camDistance)
    self.camViewHeight = 2 * math.tan((fieldOfView / 2) / 180 * 3.1428) * camDistance
end

function TowerWorldModel:SetMaxLevel(maxLevel)
    self.maxFloorLevel = maxLevel
    self.clampCamBot = 3.8
    self.clampCamTop = TowerWorldModel.FLOOR_HEIGHT * maxLevel
    self.camMoveLength = self.clampCamTop - self.clampCamBot
end

--- @param availableLevel number
function TowerWorldModel:SetUpModel(availableLevel)
    self.availableLevel = availableLevel
    self.botFloorLevel = math.max(availableLevel - 1, 1)
    self.topFloorLevel = self.botFloorLevel + TowerWorldModel.MAX_SPAWNED_FLOOR
    if self.topFloorLevel > self.maxFloorLevel then
        self.topFloorLevel = self.maxFloorLevel
    end
    self.botFloorLevel = self.topFloorLevel - TowerWorldModel.MAX_SPAWNED_FLOOR
end

--- @return FloorTowerWorld
--- @param level number
function TowerWorldModel:GetInsFloorTowerWorld(level)
    local floorTowerWorld = self:PopupFloorFromPool()
    if floorTowerWorld ~= nil then
        self.usingFloorDict:Add(level, floorTowerWorld)
        if level == 1 then
            floorTowerWorld:SetPosition(U_Vector3(0, (level - 1) * TowerWorldModel.FLOOR_HEIGHT + 0.54, 0))
        else
            floorTowerWorld:SetPosition(U_Vector3(0, (level - 1) * TowerWorldModel.FLOOR_HEIGHT + TowerWorldModel.OFFSET_HEIGHT, 0))
        end
        floorTowerWorld:SetLevel(level)
        local color = TowerWorldModel.N_COLOR
        if level <= zg.playerData:GetMethod(PlayerDataMethod.TOWER).levelCurrent then
            color = TowerWorldModel.GRAY_COLOR
        end
        floorTowerWorld:SetSprite(self:GetSpriteByLevel(level), color)
        if PLATFORM == U_RuntimePlatform.WindowsEditor
                or PLATFORM == U_RuntimePlatform.OSXEditor then
            floorTowerWorld.config.gameObject.name = "floor_" .. level
        end
        floorTowerWorld:SetActive(true)
    end
    return floorTowerWorld
end

--- @return UnityEngine_Sprite
--- @param level number
function TowerWorldModel:GetSpriteByLevel(level)
    if level == 1 then
        return self:GetSpriteFloorById(0)
    end
    local mod = math.fmod(level, 10)
    mod = math.fmod(mod, 5)
    if mod == 1 or mod == 3 then
        return self:GetSpriteFloorById(1)
    elseif mod == 2 then
        return self:GetSpriteFloorById(3)
    elseif mod == 4 then
        return self:GetSpriteFloorById(4)
    elseif mod == 0 then
        return self:GetSpriteFloorById(5)
    end
    return self:GetSpriteFloorById(1)
end

--- @param level number
function TowerWorldModel:SetHighlightSpriteByLevel(level)
    local sprite = self:GetHighlightSpriteByLevel(level)
    self.config.highlight.sprite = sprite
end

--- @return UnityEngine_Sprite
--- @param level number
function TowerWorldModel:GetHighlightSpriteByLevel(level)
    if level == 1 then
        return self:GetHighlightSpriteFloorById(0)
    end
    local mod = math.fmod(level, 10)
    mod = math.fmod(mod, 5)
    if mod == 1 or mod == 3 then
        return self:GetHighlightSpriteFloorById(1)
    elseif mod == 2 then
        return self:GetHighlightSpriteFloorById(3)
    elseif mod == 4 then
        return self:GetHighlightSpriteFloorById(4)
    elseif mod == 0 then
        return self:GetHighlightSpriteFloorById(5)
    end
    return self:GetHighlightSpriteFloorById(1)
end

--- @param id number
function TowerWorldModel:GetSpriteFloorById(id)
    local spriteName = string.format("floor_%d", id)
    return ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.floorSprite, spriteName)
end

--- @param id number
function TowerWorldModel:GetHighlightSpriteFloorById(id)
    local spriteName = string.format("floor_%d_highlight", id)
    return ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.floorSprite, spriteName)
end

--- @return FloorTowerWorld
function TowerWorldModel:PopupFloorFromPool()
    local poolCount = self.listPooledFloor:Count()
    if poolCount > 0 then
        local floor = self.listPooledFloor:Get(poolCount)
        self.listPooledFloor:RemoveByIndex(poolCount)
        return floor
    end
    --- @type UnityEngine_GameObject
    local instance = U_GameObject.Instantiate(self.floorPrefab, self.towerAnchor)
    local floorIns = FloorTowerWorld(instance.transform)
    return floorIns
end

--- @param floorTowerWorld FloorTowerWorld
function TowerWorldModel:PushFloorIntoPool(floorTowerWorld)
    floorTowerWorld:OnHide()
    self.listPooledFloor:Add(floorTowerWorld)
end

function TowerWorldModel:ExtendUp()
    self.botFloorLevel = self.botFloorLevel + 1
    self.topFloorLevel = self.topFloorLevel + 1
end

function TowerWorldModel:ExtendDown()
    self.botFloorLevel = self.botFloorLevel - 1
    self.topFloorLevel = self.topFloorLevel - 1
end

function TowerWorldModel:OnHide()
    --- @param v FloorTowerWorld
    for key, v in pairs(self.usingFloorDict:GetItems()) do
        self:PushFloorIntoPool(v)
        self.usingFloorDict:RemoveByKey(key)
    end
end

return TowerWorldModel