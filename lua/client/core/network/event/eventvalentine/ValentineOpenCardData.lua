--- @class ValentineOpenCardData
ValentineOpenCardData = Class(ValentineOpenCardData)

--- @param buffer UnifiedNetwork_ByteBuf
function ValentineOpenCardData:Ctor(buffer)
    --- @type number
    self.reachedRound = buffer:GetByte()
    local size = buffer:GetByte()
    --- @type List
    self.wishCardHistories = List()
    for i = 1, size do
        self.wishCardHistories:Add(buffer:GetInt())
    end
    local size = buffer:GetByte()
    --- @type Dictionary
    self.cardPositionOpenMap = Dictionary()
    for i = 1, size do
        self.cardPositionOpenMap:Add(buffer:GetInt(), buffer:GetInt())
    end
    --- @type number
    self.wishCardSelected = buffer:GetInt()
    --- @type boolean
    self.isCanNextRound = buffer:GetBool()
end

---@return boolean
function ValentineOpenCardData:CheckCanOpenCard(index)
    if self.cardPositionOpenMap:IsContainKey(index) == false then
        if self.reachedRound == 0 and self.wishCardSelected <= 0 then
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("need_select_card_wish"))
            return false
        else
            return true
        end
    else
        return false
    end
end