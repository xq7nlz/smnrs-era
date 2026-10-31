--- @class ChatGuildInBound :ChatInBound
ChatGuildInBound = Class(ChatGuildInBound, ChatInBound)

function ChatGuildInBound:Ctor()
    ChatInBound.Ctor(self, ChatChanel.GUILD)
end