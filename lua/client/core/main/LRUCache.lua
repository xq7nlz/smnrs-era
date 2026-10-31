--- @class CacheObject
CacheObject = Class(CacheObject)

function CacheObject:Ctor()
    --- @type CacheObject
    self.previous = nil
    --- @type CacheObject
    self.next = nil
    --- @type table {name, ...}
    self.value = nil
end

--- @class LRUCache
LRUCache = Class(LRUCache)

--- @param capacity number
function LRUCache:Ctor(capacity)
    --- type number
    self.capacity = capacity == nil and 100 or capacity
    --- @type number
    self.count = 0
    --- @type table
    self.hashTable = {}
    --- @type CacheObject
    self.head = nil
    --- @type CacheObject
    self.tail = nil
end

--- @return boolean
function LRUCache:IsFull()
    return self.count >= self.capacity
end

--- @return boolean
--- @param name string
function LRUCache:IsContain(name)
    return self.hashTable[name] ~= nil
end

--- @return table
function LRUCache:GetValue(name)
    if self:IsContain(name) then
        local value =  self.hashTable[name].value
        self:Refer(value)
        return value
    end
    return nil
end

function LRUCache:IsHead(name)
    if self.head == nil then
        return false
    end
    return self.head.value.name == name
end

--- @return table
--- @param object table {name, ...}
function LRUCache:Refer(object)
    assert(object)
    if self:IsContain(object.name) then
        self:Update(object)
        return
    end

    if self:IsFull() then
        return self:Replace(object)
    end

    self:Add(object)
    return
end

--- @param object table {name, ...}
function LRUCache:Add(object)
    assert(object)
    local cacheObject = CacheObject()
    cacheObject.value = object
    self:AddExist(cacheObject)
end

--- @param cacheObject CacheObject
function LRUCache:AddExist(cacheObject)
    assert(cacheObject)
    local object = cacheObject.value
    --print("add " .. object.name)
    if self:IsContain(object.name) == false then
        self.count = self.count + 1
        self.hashTable[object.name] = cacheObject
        if self.head == nil and self.tail == nil then
            self.head = cacheObject
            self.tail = cacheObject
        elseif self.head ~= nil and self.tail ~= nil then
            cacheObject.next = self.head
            self.head.previous = cacheObject
            self.head = cacheObject
        else
            assert(false)
        end
    else
        assert(false)
    end
end

--- use when object exist in hashtable
--- @param object table {name, ...}
function LRUCache:Update(object)
    assert(object)
    --print("update " .. bundleInfo.name)
    local name = object.name
    if self:IsHead(name) then
        return
    end

    local cacheObject = self:Remove(object)
    cacheObject.value = object
    self:AddExist(cacheObject)
end

--- use when reach capacity
--- @return table
--- @param object table {name, ...}
function LRUCache:Replace(object)
    assert(object)
    --print("replace " .. object.name)
    local name = object.name
    local objectRemoved
    if self:IsContain(name) == false then
        local cacheObject = self:Remove(self.tail.value)
        objectRemoved = cacheObject.value
        cacheObject.value = object
        self:AddExist(cacheObject)
    else
        assert(false)
    end
    return objectRemoved
end

--- @return CacheObject
--- @param object table {name, ...}
function LRUCache:Remove(object)
    assert(object)
    --print("remove " .. bundleInfo.name)
    local name = object.name
    if self:IsContain(name) then
        local cacheObject = self.hashTable[name]
        self.count = self.count - 1
        self.hashTable[name] = nil
        if self.head == cacheObject then
            self.head = cacheObject.next
            cacheObject.next.previous = nil
        end
        if self.tail == cacheObject then
            self.tail = cacheObject.previous
            cacheObject.previous.next = nil
        end
        if cacheObject.next and cacheObject.previous then
            cacheObject.next.previous = cacheObject.previous
            cacheObject.previous.next = cacheObject.next
        end
        cacheObject.next = nil
        cacheObject.previous = nil
        return cacheObject
    else
        assert(false)
    end
end

--- @return string
function LRUCache:ToString()
    if self.head == nil then
        return "Cache is empty"
    end
    local str = string.format("Count = %d ", self.count)
    local node = self.head
    while(node ~= nil) do
        str = str .. node.value:ToString() .. " "
        node = node.next
    end
    return str
end
