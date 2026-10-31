--- @class ClientMathUtils
ClientMathUtils = {}

ClientMathUtils.randomHelper = RandomHelper()
--ClientMathUtils.randomHelper:SetSeed(0)
ClientMathUtils.randomHelper:SetSeed(math.random(0, 100000))

--- @return void
function ClientMathUtils.CalculateRate(data, rateNumber, ratePercent)
    rateNumber = rateNumber or "rateNumber"
    ratePercent = ratePercent or "ratePercent"
    local totalRate = 0
    local currentRate = 0
    for i, v in ipairs(data) do
        --XDebug.Log(LogUtils.ToDetail(v))
        totalRate = totalRate + v[rateNumber]
    end

    for i, v in ipairs(data) do
        currentRate = currentRate + v[rateNumber]
        v[ratePercent] = currentRate / totalRate
    end
end

--- @return void
--- @param data
function ClientMathUtils.RandomData(data, ratePercent)
    --for i, v in ipairs(data) do
    --    XDebug.Log("group: " .. LogUtils.ToDetail(v))
    --    for j, u in ipairs(v.rate) do
    --        XDebug.Log("data: " .. LogUtils.ToDetail(u))
    --    end
    --end
    --for i, v in ipairs(data) do
    --    XDebug.Log("data: " .. LogUtils.ToDetail(v))
    --end
    --XDebug.Log(LogUtils.ToDetail(data))
    ratePercent = ratePercent or "ratePercent"
    local rand = ClientMathUtils.randomHelper:RandomFloat01()
    --XDebug.Log(LogUtils.ToDetail(data))
    for i, v in ipairs(data) do
        --XDebug.Log(" rate percent " .. v.ratePercent .. " " .. rand)
        if v[ratePercent] >= rand then
            return v
        end
    end
    XDebug.Error("Something wrong here: " .. rand)
    return nil
end

function ClientMathUtils.OriginalRewardNotCalculation(text)
    if MathUtils.IsNumber(text) == false then
        text = string.gsub(text, 'summoner_level', 1)
        text = string.gsub(text, 'vip_level', 1)
        local func = load("return " .. text)
        y = func()
        return y
    else
        return text
    end
end


--- @return number
--- @param text string
function ClientMathUtils.ConvertingCalculation(text)
    if MathUtils.IsNumber(text) == false then
        text = string.gsub(text, 'summoner_level', zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).level)
        text = string.gsub(text, 'vip_level', zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).vipLevel)
        local func = load("return " .. text)
        y = func()
        return y
    else
        return text
    end
end

--- @return number
--- @param table table
function ClientMathUtils.GetNumberItem(table)
    local count = 0
    for _, ip in pairs(table) do
        count = count + 1
    end
    return count
end

