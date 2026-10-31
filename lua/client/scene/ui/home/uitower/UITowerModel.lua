require "lua.client.data.Tower.TowerData"

--- @class UITowerModel : UIBaseModel
UITowerModel = Class(UITowerModel, UIBaseModel)

--- @return void
function UITowerModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UITower, "ui_tower")
    --- @type UIPopupType
    self.type = UIPopupType.NO_BLUR_POPUP
    --- @type number
    self.availableFloor = nil
    --- @type number
    self.minFloor = nil
    --- @type number
    self.maxFloor = nil

    --- @type List
    self.listFloorToShow = nil

    --- @type BattleTeamInfo
    self.battleTeamInfo = nil

    --- @type number
    self.selectedFloorNum = nil
    --- @type List -- <ItemIconData>
    self.listSelectedFloorReward = nil

    self.bgDark = false
end

function UITowerModel:SetAvailableFloor(availableFloor)
    self.minFloor = 1

    self.availableFloor = math.min(availableFloor, ResourceMgr.GetTowerConfig().maxFloor)
    self.maxFloor = ResourceMgr.GetTowerConfig().maxFloor
    if self.availableFloor > ResourceMgr.GetTowerConfig().maxFloor then
        self.availableFloor = ResourceMgr.GetTowerConfig().maxFloor
    end

    self.selectedFloorNum = availableFloor

    self:UpdateListTowerShowData()
end

function UITowerModel:UpdateListTowerShowData()
    self.listFloorToShow = List()
    for i = self.maxFloor, self.minFloor, -1 do
        self.listFloorToShow:Add(i)
    end
end


