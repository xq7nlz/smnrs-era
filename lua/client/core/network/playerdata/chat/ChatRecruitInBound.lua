--- @class ChatRecruitInBound :ChatInBound
ChatRecruitInBound = Class(ChatRecruitInBound, ChatInBound)

function ChatRecruitInBound:Ctor()
    ChatInBound.Ctor(self, ChatChanel.RECRUIT)
end