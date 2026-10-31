--- @class StringUtils
StringUtils = {}

--- @return table
--- @param sSeparator string
--- @param nMax number max number of part
--- @param bRegexp string
--- Break string into parts by separator
function string:Split(sSeparator, nMax, bRegexp)
    if sSeparator == nil or #sSeparator == 0 then
        sSeparator = ','
    end

    if nMax and nMax < 1 then
        nMax = nil
    end

    local aRecord = {}

    if self:len() > 0 then
        local bPlain = not bRegexp
        nMax = nMax or -1

        local nField, nStart = 1, 1
        local nFirst, nLast = self:find(sSeparator, nStart, bPlain)
        while nFirst and nMax ~= 0 do
            aRecord[nField] = self:sub(nStart, nFirst - 1)
            nField = nField + 1
            nStart = nLast + 1
            nFirst, nLast = self:find(sSeparator, nStart, bPlain)
            nMax = nMax - 1
        end
        aRecord[nField] = self:sub(nStart)
    end

    return aRecord
end

--- @return table
--- @param sSeparator string
--- @param nMax number max number of part
--- @param bRegexp string
--- Break string into parts by separator
function string:SplitLine(sSeparator, nMax, bRegexp)
    if sSeparator == '' then
        sSeparator = '\n'
    end

    if nMax and nMax < 1 then
        nMax = nil
    end

    local aRecord = {}

    if self:len() > 0 then
        local bPlain = not bRegexp
        nMax = nMax or -1

        local nField, nStart = 1, 1
        local nFirst, nLast = self:find(sSeparator, nStart, bPlain)
        while nFirst and nMax ~= 0 do
            aRecord[nField] = self:sub(nStart, nFirst - 1)
            nField = nField + 1
            nStart = nLast + 1
            nFirst, nLast = self:find(sSeparator, nStart, bPlain)
            nMax = nMax - 1
        end
        aRecord[nField] = self:sub(nStart)
    end

    return aRecord
end

--- @return string
--- @param str string
--- Remove starting and trailing white space (include \t, \n, \r)
function StringUtils.Trim(str)
    if type(str) == 'string' then
        str = string.gsub(str, '^[ \t\n\r]+', '')
        return string.gsub(str, '[ \t\n\r]+$', '')
    end
    return nil
end

---@return string
---@param str string input string
---@param limit number max length of line
--- wrap string if it too long
function StringUtils.Wrap(str, limit)
    Lines = { }
    limit = limit or 75
    local here = 1
    return "" .. str:gsub("(%s+)()(%S+)()",
            function(sp, st, word, fi)
                if fi - here > limit then
                    here = st
                    Lines[#Lines + 1] = "\n" .. word
                    return "\n" .. word
                end

            end)
end

function StringUtils.SplitByChunk(text, chunkSize)
    local s = {}
    for i = 1, #text, chunkSize do
        s[#s + 1] = text:sub(i, i + chunkSize - 1)
    end
    return s
end

function StringUtils.SplitTooLongWord (str, limit)
    limit = limit or 75
    local results = ""
    for word in string.gmatch(str, "%S+") do
        local words = StringUtils.SplitByChunk(word, limit)
        results = results .. " " .. table.concat(words, " ")
    end
    return results
end

---@return string
function StringUtils.FormatLocalize(text, ...)
    local str = text
    local args = { ... }
    for i = 1, #args do
        str = string.gsub(str, string.format("{%s}", i - 1), tostring(args[i]), 10)
    end
    return str
end

---@return string
function StringUtils.FormatLocalizeStart1(text, ...)
    local str = text
    local args = { ... }
    for i = 1, #args do
        str = string.gsub(str, string.format("{%s}", i), tostring(args[i]), 10)
    end
    return str
end

--- @return string
--- @param str string
--- @param separator string
function StringUtils.GetLastStringSplit(str, separator)
    local arr = str:Split(separator)

    return arr[#arr]
end

---@return string
---@param email string
---@param numberHide number
function StringUtils.HideEmail(email, numberHide)
    --local str = email:Split('@')
    --local args = { ... }
    --for i = 1, #args do
    --    str = string.gsub(str, string.format("{%s}", i), tostring(args[i]),10)
    --end
    --return str
end

function StringUtils.IsNilOrEmpty(text)
    return text == nil or text == ""
end

function StringUtils.Empty()
    return ""
end