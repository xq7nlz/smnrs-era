--- @class WorldFormationModel
WorldFormationModel = Class(WorldFormationModel)
WorldFormationModel.OFFSET_DRAG = U_Vector3(-1, 0, 0)
WorldFormationModel.RANGE_TO_GET_SLOT = 1.2

function WorldFormationModel:Ctor()
    --- @type {isFrontLine, positionId}
    self.selectedSlot = nil
    --- @type {isFrontLine, positionId}
    self.tempSwapSlot = nil
    --- @type HeroResource
    self.tempSwapHero = nil

    --- @type DetailTeamFormation
    self.attackerTeamFormation = nil
    --- @type BattleTeamInfo
    self.defenderBattleTeamInfo = nil
    --- @type boolean
    self.isShowDefender = false

    --- @type boolean
    self.isStartDrag = false

    --- @type number
    self.rangeToGetSlot = 1.2
end

function WorldFormationModel:ClearData()
    self.defenderBattleTeamInfo = nil
    self.attackerTeamFormation = nil
    self.isShowDefender = false

    self:ClearSlotStuff()
end

function WorldFormationModel:ClearSlotStuff()
    self.selectedSlot = nil
    self.isStartDrag = false
    self.tempSwapSlot = nil
    self.tempSwapHero = nil
end

--- @return List
--- @param teamId number
--- @param listHeroId List
function WorldFormationModel:FindListPositionByListHeroId(teamId, listHeroId)
    local listPositionTable = List()
    --- @return List
    --- @param posDict Dictionary<positionId, HeroResource}>
    local getListPositionTableFromDict = function(posDict, isFrontLine)
        --- @param positionId number
        --- @param v HeroResource
        for positionId, v in pairs(posDict:GetItems()) do
            for i = 1, listHeroId:Count() do
                local heroId = listHeroId:Get(i)
                if heroId == v.heroId then
                    --- @type {isFrontLine, positionId}
                    local positionTable = {}
                    positionTable.isFrontLine = isFrontLine
                    positionTable.positionId = positionId
                    if listPositionTable:IsContainValue(positionTable) == false then
                        listPositionTable:Add(positionTable)
                    end
                end
            end
        end
    end

    if teamId == BattleConstants.ATTACKER_TEAM_ID then
        getListPositionTableFromDict(self.attackerTeamFormation.frontLineDict, true)
        getListPositionTableFromDict(self.attackerTeamFormation.backLineDict, false)
    else
        for i = 1, self.defenderBattleTeamInfo.listHeroInfo:Count() do
            --- @type HeroBattleInfo
            local heroBattleInfo = self.defenderBattleTeamInfo.listHeroInfo:Get(i)
            for j = 1, listHeroId:Count() do
                local heroId = listHeroId:Get(j)
                if heroId == heroBattleInfo.heroId then
                    --- @type {isFrontLine, positionId}
                    local positionTable = {}
                    positionTable.isFrontLine = heroBattleInfo.isFrontLine
                    positionTable.positionId = heroBattleInfo.position
                    if listPositionTable:IsContainValue(positionTable) == false then
                        listPositionTable:Add(positionTable)
                    end
                end
            end
        end
    end
    return listPositionTable
end

function WorldFormationModel:SetHeroResourceByPosition(isAttacker, heroResource, isFrontLine, position)
    if isAttacker and self.attackerTeamFormation ~= nil then
        self.attackerTeamFormation:SetHeroResourceByPosition(heroResource, isFrontLine, position)
    end
end