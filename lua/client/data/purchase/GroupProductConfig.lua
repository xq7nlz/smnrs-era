--- @class GroupProductConfig
GroupProductConfig = Class(GroupProductConfig)

function GroupProductConfig:Ctor(data)
    self.groupId = tonumber(data.group)
    self.duration = tonumber(data.duration)
    --- init when product is progress pack
    self:ProgressCtor(data)
    --- @type List | ProductConfig
    self.listProductConfig = List()
end



function GroupProductConfig:ProgressCtor(data)
    if data.view_type then
        --- @type PackViewType
        self.viewType = tonumber(data.view_type)
    end
    if data.auto_show then
        --- @type boolean
        self.autoShow = MathUtils.ToBoolean(data.auto_show)
    end
    if data.priority then
        --- @type number
        self.priority = tonumber(data.priority)
    end
end

--- @param productConfig ProductConfig
function GroupProductConfig:AddProductConfig(productConfig)
    self.listProductConfig:Add(productConfig)
end

--- @return List
function GroupProductConfig:GetListProductConfig()
    return self.listProductConfig
end

--- @return ProductConfig
--- @param packId number
function GroupProductConfig:FindProductConfigByPackId(packId)
    for i = 1, self.listProductConfig:Count() do
        --- @type ProductConfig
        local productConfig = self.listProductConfig:Get(i)
        if productConfig.id == packId then
            return productConfig
        end
    end
    return nil
end

--- @return boolean
--- @param createdTime number
function GroupProductConfig:IsActiveByDuration(createdTime)
    return createdTime + self.duration > zg.timeMgr:GetServerTime()
end

--- @param x GroupProductConfig
--- @param y GroupProductConfig
function GroupProductConfig.SortByPriority(x, y)
    if x.priority < y.priority then
        return -1
    end
    return 1
end