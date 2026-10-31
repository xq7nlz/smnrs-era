--- @class UIObjectList
UIObjectList = Class(UIObjectList)

--- @return void
--- @param root UnityEngine_RectTransform
--- @param uiPoolType UIPoolType
--- @param onCreateItem function
function UIObjectList:Ctor(root, uiPoolType, onCreateItem)
    --- @type List object
    self.list = List()
    --- @type UnityEngine_RectTransform
    self.root = root
    --- @type UIPoolType
    self.uiPoolType = uiPoolType
    --- @type method
    self.onCreateItem = onCreateItem
end

--- @return void
--- @param size number
function UIObjectList:Resize(size)
    self:Clear()
    for i = 1, size do
        --- @type IconView
        local iconView = SmartPool.Instance:SpawnLuaUIPool(self.uiPoolType, self.root)
        if self.onCreateItem ~= nil then
            self.onCreateItem(iconView, i)
        end
    end
end

--- @return void
function UIObjectList:Clear()
    --- @param v IconView
    for k, v in pairs(self.list) do
        v:ReturnPool()
    end
    self.list:Clear()
end

--- @return void
function UIObjectList:OnDisabled()
    self:Clear()
end