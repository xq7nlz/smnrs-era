require "lua.client.data.Quest.QuestTree.QuestTreeNode"

--- @class QuestTree
QuestTree = Class(QuestTree)

function QuestTree:Ctor()
    --- @type Dictionary {nodeConfig : QuestTreeNodeConfig}
    self.nodeDict = Dictionary()
end

--- @param sourceId number
--- @param questTreeNodeConfig QuestTreeNode
function QuestTree:AddNodeConfig(sourceId, questTreeNodeConfig)
    self.nodeDict:Add(sourceId, questTreeNodeConfig)
end

--- @return QuestTreeNode
--- @param sourceId number
function QuestTree:GetQuestTreeNodeConfigBySource(sourceId)
    return self.nodeDict:Get(sourceId)
end

--- @return List
--- @param sourceId number
function QuestTree:GetAllLinesIdFromSourceNode(sourceId)
    --- @type QuestTreeNode
    local questTreeNodeConfig = self.nodeDict:Get(sourceId)
    if questTreeNodeConfig ~= nil then
        return questTreeNodeConfig:GetAllLinesFromSource()
    end
    return List()
end

--- @return List
function QuestTree:GetAllLinesIdFromTree()
    local lines = List()
    --- @param k number
    --- @param v QuestTreeNode
    for k, v in pairs(self.nodeDict:GetItems()) do
        local nodeLines = self:GetAllLinesIdFromSourceNode(k)
        for i = 1, nodeLines:Count() do
            lines:Add(nodeLines:Get(i))
        end
    end
    return lines
end
