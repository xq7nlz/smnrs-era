--- @class TimeUtils
TimeUtils = {}

TimeUtils.SecondADay = 86400
TimeUtils.SecondAHour = 3600
TimeUtils.SecondAMin = 60
TimeUtils.DayOfMonth = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }
TimeUtils.DELAY_REQUEST_10 = 10
TimeUtils.DayAWeek = 7

TimeUtils.TimeZone = -2

--- @return string
--- @param second number
function TimeUtils.GetTimeFromSecond(second)
    return os.date("%X", second)
end

--- @return number
--- @param timestamp number
function TimeUtils.GetDateMonthYearFromTimestamp(timestamp)
    return os.date("%d/%m/%Y", timestamp)
end

--- @return number
--- @param timestamp number
function TimeUtils.GetMonthFromTimestamp(timestamp)
    return tonumber(os.date("%m", timestamp))
end

--- @return string
--- @param time number
function TimeUtils.GetTimeFromDateTime(time)
    return os.date("%m/%d/%Y %I:%M %p", time)
end

--- @return {year, month, day, hour, min, sec, wday, yday, isdst}
--- @param time number
function TimeUtils.GetOsDateFromSecWithFormatT(time)
    return os.date("*t", time)
end

--- @return {year, month, day, hour, min, sec, wday, yday, isdst}
--- @param month number
--- @param year number
function TimeUtils.GetDayOfMonth(month, year)
    local dayOfMonth = TimeUtils.DayOfMonth[month]
    if month == 2 and year % 4 ~= 0 then
        return dayOfMonth + 1
    end
    return dayOfMonth
end

--- @return string
--- @param deltaTime number
--- @param number number
function TimeUtils.GetDeltaTime(deltaTime, number)
    -- TODO need check performance this function
    ---@type List
    local list = List()
    list:Add({ ["k"] = "d ", ["v"] = math.floor(deltaTime / TimeUtils.SecondADay) })
    list:Add({ ["k"] = "h ", ["v"] = math.floor((deltaTime % TimeUtils.SecondADay) / TimeUtils.SecondAHour) })
    list:Add({ ["k"] = "m ", ["v"] = math.floor((deltaTime % TimeUtils.SecondAHour) / TimeUtils.SecondAMin) })
    list:Add({ ["k"] = "s", ["v"] = deltaTime % TimeUtils.SecondAMin })
    local str = ""
    local index = 1
    ---@param v {k,v}
    for _, v in ipairs(list:GetItems()) do
        if v.v > 0 then
            str = string.format("%s%s%s", str, v.v, v.k)
            if number ~= nil and index > number then
                break
            end
            index = index + 1
        end
    end
    return str
end

--- @return string
--- @param time number
function TimeUtils.GetDeltaTimeAgo(time)
    ---@type number
    local d = math.floor(time / TimeUtils.SecondADay)
    time = time % TimeUtils.SecondADay
    ---@type number
    local h = math.floor(time / TimeUtils.SecondAHour)
    time = time % TimeUtils.SecondAHour
    ---@type number
    local m = math.floor(time / TimeUtils.SecondAMin)
    time = time % TimeUtils.SecondAMin
    ---@type number
    local s = math.floor(time)
    if d > 0 then
        return StringUtils.FormatLocalize(LanguageUtils.LocalizeCommon("day_ago_format"), d, h)
    elseif h > 0 then
        return StringUtils.FormatLocalize(LanguageUtils.LocalizeCommon("hour_ago_format"), h, m)
    elseif m > 0 then
        return StringUtils.FormatLocalize(LanguageUtils.LocalizeCommon("min_ago_format"), m, s)
    else
        return StringUtils.FormatLocalize(LanguageUtils.LocalizeCommon("second_ago_format"), s)
    end
end

--- ví dụ: nếu thời gian server trả về là 1661394632 (zg.timeMgr:GetServerTime) - 25/08/2022 2h30min23s
--- thì ta có kết quả là 2*60*60 + 30*60 + 23 = 9023 (TimeUtils.GetCurrentSecond(zg.timeMgr:GetServerTime))
--- @return number Lấy thời gian trong ngày (kết quả luôn < 86400)
function TimeUtils.GetCurrentSecond(serverTime)
    local date = os.date("!*t", serverTime + TimeUtils.TimeZone * 60 * 60)
    return date.hour * TimeUtils.SecondAHour + date.min * TimeUtils.SecondAMin + date.sec
end

--- ví dụ: nếu thời gian server trả về là 1661394632 (zg.timeMgr:GetServerTime) | 25/08/2022 2h30min23s
--- thì ta có kết quả là 1661394632 - 9023 = 1661385609 | 25/08/2022 0h0m0s (TimeUtils.GetCurrentSecond(zg.timeMgr:GetServerTime))
--- @return number Thời gian server tại đầu ngày hiện tại (0h0m0s)
function TimeUtils.GetTimeStartDayFromSec(serverTime)
    return serverTime - TimeUtils.GetCurrentSecond(serverTime)
end

function TimeUtils.GetTimeEndDayFromSec(serverTime) -- thoi gian server cuoi ngay
    return TimeUtils.GetTimeStartDayFromSec(serverTime) + TimeUtils.SecondADay
end

function TimeUtils.SecondsToClock(seconds)
    if MathUtils.IsInteger(seconds) then
        if seconds <= 0 then
            return "00:00:00"
        else
            local hours = math.floor(seconds / TimeUtils.SecondAHour)
            local secs = seconds % TimeUtils.SecondAMin
            local mins = math.floor(seconds / TimeUtils.SecondAMin - (hours * TimeUtils.SecondAMin))
            return string.format("%02d:%02d:%02d", hours, mins, secs)
        end
    else
        XDebug.Error(string.format("seconds is invalid: %s", tostring(seconds)))
    end
end

---@param createdTimeInSeconds number
---@return string
function TimeUtils.GetTimeFromNow(createdTimeInSeconds)
    ---@type number
    local time = math.max(0, os.difftime(os.time(), createdTimeInSeconds))
    ---@type number
    local d = math.floor(time / TimeUtils.SecondADay)
    time = time % TimeUtils.SecondADay
    ---@type number
    local h = math.floor(time / TimeUtils.SecondAHour)
    time = time % TimeUtils.SecondAHour
    ---@type number
    local m = math.floor(time / TimeUtils.SecondAMin)
    time = time % TimeUtils.SecondAMin
    ---@type number
    local s = math.floor(time)
    if d > 0 then
        return StringUtils.FormatLocalize(LanguageUtils.LocalizeCommon("day_ago_format"), d, h)
    elseif h > 0 then
        return StringUtils.FormatLocalize(LanguageUtils.LocalizeCommon("hour_ago_format"), h, m)
    elseif m > 0 then
        return StringUtils.FormatLocalize(LanguageUtils.LocalizeCommon("min_ago_format"), m, s)
    else
        return StringUtils.FormatLocalize(LanguageUtils.LocalizeCommon("second_ago_format"), s)
    end
end