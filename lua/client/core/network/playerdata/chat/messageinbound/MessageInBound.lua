--- @class MessageInBound
MessageInBound = Class(MessageInBound)

--- @return MessageInBound
function MessageInBound:Ctor()
    --- @type string
    self.message = nil
end

--- @param json table
function MessageInBound:CreateByJson(json)
    self.message = json['0']
end

---@param message string
---@return MessageInBound
function MessageInBound:CreateByString(message)
    self.message = message
end