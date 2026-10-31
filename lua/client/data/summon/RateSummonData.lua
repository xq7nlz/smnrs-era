--- @class RateSummonData
RateSummonData = Class(RateSummonData)

function RateSummonData:Ctor(data, group)
    self.heroId = tonumber(data['hero_id'])
    self.star = tonumber(data['star'])
    self.heroRate = tonumber(data['hero_rate'])
    self.group = group
end

--- @class GroupRateSummonData
GroupRateSummonData = Class(GroupRateSummonData)

function GroupRateSummonData:Ctor(group, rate)
    self.group = group
    self.groupRate = rate
    ---@type List -- <RateSummonData>
    self.listRate = List()
    self.totalRate = 0
end

---@param rateSummon RateSummonData
function GroupRateSummonData:Add(rateSummon)
    self.listRate:Add(rateSummon)
    self.totalRate = self.totalRate + rateSummon.heroRate
end

---@return number
function GroupRateSummonData:GetTotalRate(star)
    local rate = 0
    ---@param v RateSummonData
    for _, v in pairs() do
        if star == nil or star == v.star then
            rate = rate + v.heroRate
        end
    end
    return rate
end

--- @class ListGroupRateSummonData
ListGroupRateSummonData = Class(ListGroupRateSummonData)

function ListGroupRateSummonData:Ctor()
    ---@type Dictionary
    self.dictRateStar = Dictionary()
end

---@return number
function ListGroupRateSummonData:GetRateByStar(star)
    local rate = 0
    if self.dictRateStar:IsContainKey(star) then
        rate = self.dictRateStar:Get(star)
    end
    return rate
end

---@return number
function ListGroupRateSummonData:GetRateStringByStar(star)
    return math.floor(self:GetRateByStar(star) * 10000) / 100
end

---@return ListGroupRateSummonData
---@param csv string
function ListGroupRateSummonData.CreateByCsv(csv)
    ---@type ListGroupRateSummonData
    local listGroupRateSummonData = ListGroupRateSummonData()
    local dataParse = CsvReaderUtils.ReadAndParseLocalFile(csv)
    ---@type List
    local listRate = List()
    local totalRate = 0
    ---@type GroupRateSummonData
    local groupCache = nil
    for _, v in ipairs(dataParse) do
        local group =  v['group']
        local groupRate =  v['group_rate']
        if group ~= nil and groupRate ~= nil then
            totalRate = totalRate + groupRate
            groupCache = GroupRateSummonData(tonumber(group), tonumber(groupRate))
            listRate:Add(groupCache)
        end
        if groupCache ~= nil then
            ---@type RateSummonData
            local rateSummon = RateSummonData(v, groupCache.groupRate)
            groupCache:Add(rateSummon)
        end
    end

    ---@param group GroupRateSummonData
    for _, group in pairs(listRate:GetItems()) do
        group.groupRate = group.groupRate / totalRate
        ---@param summonRate RateSummonData
        for _, summonRate in pairs(group.listRate:GetItems()) do
            summonRate.heroRate = summonRate.heroRate / group.totalRate
            local rate = summonRate.heroRate * group.groupRate
            if listGroupRateSummonData.dictRateStar:IsContainKey(summonRate.star) then
                rate = rate + listGroupRateSummonData.dictRateStar:Get(summonRate.star)
            end
            listGroupRateSummonData.dictRateStar:Add(summonRate.star, rate)
        end
    end
    return listGroupRateSummonData
end