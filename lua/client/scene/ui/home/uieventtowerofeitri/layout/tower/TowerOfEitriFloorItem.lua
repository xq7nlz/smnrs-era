--- @class TowerOfEitriFloorItem
TowerOfEitriFloorItem = Class(TowerOfEitriFloorItem)

--- @return void
------ @param transform UnityEngine_Transform
function TowerOfEitriFloorItem:Ctor(transform)
    ---@type TowerOfEitriFloorItemConfig
    self.config = UIBaseConfig(transform)
    --self.config.floorNumber.gameObject:SetActive(false)
end

function TowerOfEitriFloorItem:AddListener(func)
    self.config.button.onClick:AddListener(function()
        func()
    end)
end

function TowerOfEitriFloorItem:SetFloorItemButtonInteractable(isInteractable)
    self.config.button.interactable = isInteractable
end

function TowerOfEitriFloorItem:EnableGoldenFloorFx(isEnable)
    self.config.floorGoldenFx:SetActive(isEnable)
end

function TowerOfEitriFloorItem:EnableGoldenFloor(isEnable)
    self.config.floorGoldenAnchor:SetActive(isEnable)
end

function TowerOfEitriFloorItem:EnableBuildFloorFx(isEnable)
    self.config.floorAppear:SetActive(isEnable)
end

function TowerOfEitriFloorItem:EnableFloorSprite(isEnable)
    self.config.floorNormal:SetActive(isEnable)
end

function TowerOfEitriFloorItem:PlayAnimBuildFloor(isEnable)
    self.config.floorAnim.gameObject:SetActive(isEnable)
    if isEnable then
        self.config.floorAnim.AnimationState:SetAnimation(1, "active", false)
    end
end

function TowerOfEitriFloorItem:AnimationClearTracks()
    self.config.floorAnim:ClearState()
    self.config.floorAnim.AnimationState:ClearTracks()
    self.config.floorAnim.skeleton:SetToSetupPose()
end

function TowerOfEitriFloorItem:SetFloorNumber(number)
    self.config.floorNumber.text = number
end

function TowerOfEitriFloorItem:SetFloorEnable(isEnable)
    self.config.gameObject:SetActive(isEnable)
end

function TowerOfEitriFloorItem:SetItemData(data)
    ---@type boolean
    local isGoldenFloor = false
    if data.floorId > 0 and data.floorId % data.goldenFloorConfig == 0 then
        isGoldenFloor = true
    end
    self:SetFloorNumber(data.floorId)
    self:EnableGoldenFloorFx(isGoldenFloor)
    self:EnableGoldenFloor(true)
end

function TowerOfEitriFloorItem:ClearFloorCache()
    self:AnimationClearTracks()
    self:EnableFloorSprite(false)
    self:SetFloorEnable(false)
end
