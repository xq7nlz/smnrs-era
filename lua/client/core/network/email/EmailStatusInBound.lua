--- @class EmailStatusInBound
EmailStatusInBound = Class(EmailStatusInBound)

function EmailStatusInBound:Ctor()
    --- @type EmailState
    self.emailState = nil
    --- @type string
    self.email = nil
end

--- @param buffer UnifiedNetwork_ByteBuf
function EmailStatusInBound:ReadBuffer(buffer)
    --- @type EmailState
    self.emailState = buffer:GetByte()
    if self.emailState == EmailState.VERIFIED then
        --- @type string
        self.email = buffer:GetString()
    end
end

return EmailStatusInBound