--- @class PieceAdventureOpenCardData
PieceAdventureOpenCardData = Class(PieceAdventureOpenCardData)

--- @param buffer UnifiedNetwork_ByteBuf
function PieceAdventureOpenCardData:Ctor(buffer)
    --- @type boolean
    self.isClearedFloor = buffer:GetBool()

    -- saving position of key item in current floor
    local size = buffer:GetByte()
    --- @type Dictionary
    self.keyItemDict = Dictionary()
    for i = 1, size do
        self.keyItemDict:Add(buffer:GetInt(), buffer:GetInt())
    end
    --print("Key Item Dict : " .. LogUtils.ToDetail(self.keyItemDict:GetItems()))

    -- saving position of opened item in current floor
    size = buffer:GetByte()
    --- @type Dictionary
    self.openedCardPositionDict = Dictionary()
    for i = 1, size do
        self.openedCardPositionDict:Add(buffer:GetInt(), buffer:GetInt())
    end
    --print("Opened Card Dict : " .. LogUtils.ToDetail(self.openedCardPositionDict:GetItems()))
end

function PieceAdventureOpenCardData:AddOpenCardPosition(index, idCard)
    if not self.openedCardPositionDict:IsContainKey(index) then
        self.openedCardPositionDict:Add(index, idCard)
    end
end

---@return boolean
function PieceAdventureOpenCardData:CheckCanOpenCard(index)
    if self.openedCardPositionDict:IsContainKey(index) == false then
        return true
    end
    return false
end

function PieceAdventureOpenCardData:SetOpenedCardDict(openedCardDictInbound)
    self.openedCardPositionDict = Dictionary()
    self.openedCardPositionDict = openedCardDictInbound
end

function PieceAdventureOpenCardData:SetKeyItemsDict(keyItemDictInbound)
    self.keyItemDict = Dictionary()
    self.keyItemDict = keyItemDictInbound
end

---@return boolean
function PieceAdventureOpenCardData:CheckIsKeyItemCard(index)
    for k, v in pairs(self.keyItemDict:GetItems()) do
        if k == index then
            return true
        end
    end
    return false
end
