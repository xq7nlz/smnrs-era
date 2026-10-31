--- @class TutorialOutBound : OutBound
TutorialOutBound = Class(TutorialOutBound, OutBound)

--- @return void
function TutorialOutBound:Ctor()
    --- @type List
    self.listStep = List()
end

--- @return void
---@param step number
function TutorialOutBound:AddStep(step)
    self.listStep:Add(step)
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function TutorialOutBound:Serialize(buffer)
    buffer:PutShort(self.listStep:Count())
    for _, v in ipairs(self.listStep:GetItems()) do
        buffer:PutInt(v)
    end
end