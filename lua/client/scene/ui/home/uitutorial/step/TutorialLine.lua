--- @class TutorialLine : TutorialNode
TutorialLine = Class(TutorialLine, TutorialNode)

--- @return void
function TutorialLine:Ctor()
    ---@type List --<TutorialNode>
    self.listTutorialNode = List()
end

--- @return void
function TutorialLine.Create(...)
    ---@type TutorialLine
    local tutorial = TutorialLine()
    local args = { ... }
    for i = 1, #args do
        ---@type TutorialNode
        local t = args[i]
        if t ~= nil then
            if i < #args then
                t:SetData(tutorial, args[i + 1])
            else
                t:SetData(tutorial)
            end
            tutorial.listTutorialNode:Add(t)
        else
            XDebug.Log("Nil tutorial")
        end
    end
    return tutorial
end

--- @return TutorialSingle
function TutorialLine:AddNode(...)
    local args = { ... }
    if #args > 0 and self.listTutorialNode:Count() > 0 then
        ---@type TutorialNode
        local t = self.listTutorialNode:Get(self.listTutorialNode:Count())
        t:SetData(self, args[1])
    end
    for i = 1, #args do
        ---@type TutorialNode
        local t = args[i]
        if t ~= nil then
            if i < #args then
                t:SetData(self, args[i + 1])
            else
                t:SetData(self)
            end
            self.listTutorialNode:Add(t)
        else
            XDebug.Log("Nil tutorial")
        end
    end
end

--- @return TutorialSingle
function TutorialLine:GetStartNode()
    ---@type TutorialNode
    local stat = self.listTutorialNode:Get(1)
    return stat:GetStartNode()
end