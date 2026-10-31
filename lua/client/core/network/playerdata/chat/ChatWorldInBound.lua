--- @class ChatWorldInBound :ChatInBound
ChatWorldInBound = Class(ChatWorldInBound, ChatInBound)

function ChatWorldInBound:Ctor()
    ChatInBound.Ctor(self, ChatChanel.WORLD)
end