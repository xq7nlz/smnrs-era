--- @class ChatDomainCrewInBound :ChatInBound
ChatDomainCrewInBound = Class(ChatDomainCrewInBound, ChatInBound)

function ChatDomainCrewInBound:Ctor()
    ChatInBound.Ctor(self, ChatChanel.DOMAINS_TEAM)
end