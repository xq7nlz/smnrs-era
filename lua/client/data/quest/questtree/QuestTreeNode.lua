--- @class QuestTreeNode
QuestTreeNode = Class(QuestTreeNode)

function QuestTreeNode:Ctor()
    --- @type Dictionary
    self.childNodeLineConfigDict = Dictionary()
end

--- @param decodeData string
function QuestTreeNode:InitConfig(decodeData)
    for k, v in pairs(decodeData) do
        local listLine = List()
        for i = 1, #v do
            listLine:Add(v[i])
        end
        self.childNodeLineConfigDict:Add(k, listLine)
    end
end

--- @return List
function QuestTreeNode:GetAllLinesFromSource()
    local listLines = List()
    --- @param v List
    for _, v in pairs(self.childNodeLineConfigDict:GetItems()) do
        for i = 1, v:Count() do
            listLines:Add(v:Get(i))
        end
    end
    return listLines
end