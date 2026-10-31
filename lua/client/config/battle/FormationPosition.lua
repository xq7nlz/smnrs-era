---@class FormationPosition
FormationPosition = Class(FormationPosition)

---@return void
function FormationPosition:Ctor()
    self.frontLine = {}
    self.backLine = {}
end

---@return void
---@param isFrontLine boolean
---@param positionId number
---@param position Vector2
function FormationPosition:AddPosition(isFrontLine, positionId, position)
    if isFrontLine then
        self.frontLine[positionId] = position
    else
        self.backLine[positionId] = position
    end
end

---@return Vector2
---@param isFrontLine boolean
---@param positionId number
function FormationPosition:GetPosition(isFrontLine, positionId)
    if isFrontLine then
        return self.frontLine[positionId]
    else
        return self.backLine[positionId]
    end
end

function FormationPosition:Print()
    XDebug.Log("Front Line")
    for i, v in pairs(self.frontLine) do
        XDebug.Log(i..v:__tostring())
    end
    XDebug.Log("Back Line")
    for i, v in pairs(self.backLine) do
        XDebug.Log(i..v:__tostring())
    end
end