
--- @class UILobbyDomainModel : UIBaseModel
UILobbyDomainModel = Class(UILobbyDomainModel, UIBaseModel)

--- @return void
function UILobbyDomainModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UILobbyDomain, "lobby_domain")
end