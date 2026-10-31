--- @class DungeonWorldFormationModel
DungeonWorldFormationModel = Class(DungeonWorldFormationModel)

function DungeonWorldFormationModel:Ctor()
    --- @type number
    self.selectedSlot = nil

    --- @type List --- UnityEngine_Vector3[]
    self.listSlotPosition = nil

    --- @type Dictionary --- {slotId, heroResource}
    self.heroSlotDict = Dictionary()

    self:ConfigTeamSlots()
end

function DungeonWorldFormationModel:ConfigTeamSlots()
    self.listSlotPosition = List()
    self.listSlotPosition:Add(U_Vector3(-8.3, -2.29, 0))
    self.listSlotPosition:Add(U_Vector3(-6.42, -3.4, 0))
    self.listSlotPosition:Add(U_Vector3(-4, -4, 0))
    self.listSlotPosition:Add(U_Vector3(-1.36, -3.4, 0))
    self.listSlotPosition:Add(U_Vector3(0.3, -2.29, 0))
end

--- @return UnityEngine_Vector3
--- @param slotId number
function DungeonWorldFormationModel:GetSlotPositionById(slotId)
    return self.listSlotPosition:Get(slotId)
end

--- @return HeroResource
--- @param slotId number
function DungeonWorldFormationModel:GetHeroResourceBySlot(slotId)
    return self.heroSlotDict:Get(slotId)
end

--- @param slotId number
--- @param heroResource HeroResource
function DungeonWorldFormationModel:SetHeroResourceBySlot(slotId, heroResource)
    self.heroSlotDict:Add(slotId, heroResource)
end