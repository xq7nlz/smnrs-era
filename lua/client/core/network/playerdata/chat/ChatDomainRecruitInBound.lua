--- @class ChatDomainRecruitInBound :ChatInBound
ChatDomainRecruitInBound = Class(ChatDomainRecruitInBound, ChatInBound)

function ChatDomainRecruitInBound:Ctor()
    ChatInBound.Ctor(self, ChatChanel.DOMAINS_RECRUIT)
end