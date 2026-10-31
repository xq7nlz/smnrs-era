--- @class TutorialSingle : TutorialNode
TutorialSingle = Class(TutorialSingle, TutorialNode)

--- @return void
function TutorialSingle:Ctor()
    ---@type TutorialStepData
    self.tutorialStepData = nil
end

--- @return void
---@param tutorialStepData TutorialStepData
function TutorialSingle.Create(tutorialStepData)
    ---@type TutorialSingle
    local tutorial = TutorialSingle()
    tutorial.tutorialStepData = tutorialStepData
    return tutorial
end

--- @return TutorialSingle
function TutorialSingle:GetStartNode()
    return self
end