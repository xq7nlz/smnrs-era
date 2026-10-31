--- @class TutorialNode
TutorialNode = Class(TutorialNode) -- step in tutorial

--- @return void
function TutorialNode:Ctor()
    ---@type TutorialNode
    self.parentNode = nil
    ---@type TutorialNode
    self.nextNode = nil
    ---@type TutorialNode
    self.option1 = nil
    ---@type TutorialNode
    self.option2 = nil
end

--- @return void
--- @param parentNode TutorialNode
--- @param nextNode TutorialNode
--- @param option1 TutorialNode
--- @param option2 TutorialNode
function TutorialNode:SetData(parentNode, nextNode, option1, option2)
    self.parentNode = parentNode
    self.nextNode = nextNode
    self.option1 = option1
    self.option2 = option2
end

--- @return TutorialNode
function TutorialNode:Next()
    if self.nextNode ~= nil then
        return self.nextNode
    elseif self.parentNode ~= nil then
        return self.parentNode:Next()
    else
        return nil
    end
end

--- @return TutorialNode
function TutorialNode:Option1()
    if self.option1 ~= nil then
        return self.option1
    elseif self.parentNode ~= nil then
        return self.parentNode:Option1()
    else
        return nil
    end
end

--- @return TutorialNode
function TutorialNode:Option2()
    if self.option2 ~= nil then
        return self.option2
    elseif self.parentNode ~= nil then
        return self.parentNode:Option2()
    else
        return nil
    end
end

--- @return TutorialSingle
function TutorialNode:GetStartNode()
    return nil
end
