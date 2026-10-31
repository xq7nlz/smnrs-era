---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiTower.towerWorld.FloorTowerWorldConfig"

--- @class FloorTowerWorld
FloorTowerWorld = Class(FloorTowerWorld)

--- @param transform UnityEngine_Transform
--- @param parent UnityEngine_Transform
function FloorTowerWorld:Ctor(transform, parent)
    --- @type FloorTowerWorldConfig
    ---@type FloorTowerWorldConfig
    self.config = UIBaseConfig(transform)
    if parent ~= nil then
        self.config.transform:SetParent(parent)
    end

    --- @type RootIconView
    self.rootIconView = nil
end

--- @param isActive boolean
function FloorTowerWorld:SetActive(isActive)
    self.config.gameObject:SetActive(isActive)
end

--- @param pos UnityEngine_Vector3
function FloorTowerWorld:SetPosition(pos)
    self.config.transform.localPosition = pos
end

--- @return UnityEngine_Vector3
function FloorTowerWorld:GetCenterPosition()
    return self.config.transform.position + U_Vector3.up * 2
end

--- @param level number
function FloorTowerWorld:SetLevel(level)
    self.config.textLevel.text = LanguageUtils.LocalizeCommon("floor") .. " " .. level
    self.config.sprite.sortingOrder = -level
end

--- @param sprite UnityEngine_Sprite
--- @param color UnityEngine_Color
function FloorTowerWorld:SetSprite(sprite, color)
    self.config.sprite.sprite = sprite
    self.config.sprite.color = color
end

--- @param highlightTrans UnityEngine_Transform
--- @param pointerTrans UnityEngine_RectTransform
--- @param towerLevel number
function FloorTowerWorld:SetHighlight(highlightTrans, pointerTrans, towerLevel)
    highlightTrans:SetParent(self.config.transform)
    pointerTrans:SetParent(self.config.transform)
    pointerTrans.anchoredPosition3D = U_Vector3(0, 2, 0)
    if towerLevel == 1 then
        highlightTrans.localPosition = U_Vector3(0, 2, 0)
    else
        highlightTrans.localPosition = U_Vector3(0, 2.18, 0)
    end
end

--- @param itemIconData ItemIconData
--- @param isActiveMaskSelect boolean
--- @param size UnityEngine_Vector2
function FloorTowerWorld:SetReward(itemIconData, isActiveMaskSelect, size)
    if itemIconData ~= nil then
        self.rootIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.rewardAnchor)
        self.rootIconView:SetIconData(itemIconData)
        self.rootIconView:RegisterShowInfo()
        self.config.floorRewardPointer:SetActive(true)
        self.rootIconView:ActiveMaskSelect(isActiveMaskSelect, size)
    end
end

function FloorTowerWorld:OnHide()
    if self.rootIconView ~= nil then
        self.rootIconView:ReturnPool()
        self.rootIconView = nil
    end
    self.config.floorRewardPointer:SetActive(false)
    self.config.gameObject:SetActive(false)
end