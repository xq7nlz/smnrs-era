--- @class MailActionOutBound : OutBound
MailActionOutBound = Class(MailActionOutBound, OutBound)

--- @return void
---@param isAll boolean
function MailActionOutBound:Ctor(isAll, isPlayerMail, mailId)
    ---@type boolean
    self.isAll = isAll
    ---@type boolean
    self.isPlayerMail = isPlayerMail
    ---@type string
    self.mailId = mailId
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function MailActionOutBound:Serialize(buffer)
    buffer:PutBool(self.isAll)
    if self.isAll == false then
        buffer:PutString(self.mailId)
    else
        buffer:PutBool(self.isPlayerMail)
    end
end