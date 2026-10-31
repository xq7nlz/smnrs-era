--- @class ChatSystemInBound :ChatInBound
ChatSystemInBound = Class(ChatSystemInBound, ChatInBound)

function ChatSystemInBound:Ctor()
    ChatInBound.Ctor(self, ChatChanel.SYSTEM)
end