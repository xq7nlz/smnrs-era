--- @class TutorialOption : TutorialNode
TutorialOption = Class(TutorialOption, TutorialNode)

--- @return void
function TutorialOption:Ctor()
    ---@type TutorialNode
    self.startStep = nil
    ---@type TutorialNode
    self.option1 = nil
    ---@type TutorialNode
    self.option2 = nil
end

--- @return void
---@param startStep TutorialNode
---@param option1 TutorialNode
---@param option2 TutorialNode
function TutorialOption.Create(startStep, option1, option2)
    ---@type TutorialOption
    local tutorial = TutorialOption()
    tutorial.startStep = startStep
    tutorial.option1 = option1
    tutorial.option2 = option2
    if tutorial.startStep ~= nil then
        tutorial.startStep:SetData(tutorial, nil, tutorial.option1, tutorial.option2)
    end
    if tutorial.option1 ~= nil then
        tutorial.option1:SetData(tutorial)
    end
    if tutorial.option2 ~= nil then
        tutorial.option2:SetData(tutorial)
    end
    return tutorial
end

--- @return TutorialSingle
function TutorialOption:GetStartNode()
    return self.startStep:GetStartNode()
end