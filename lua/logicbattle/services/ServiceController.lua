--- @class ServiceController
ServiceController = Class(ServiceController)

--- @return void
function ServiceController:Ctor()
    --- @type BattleService
    self.battleService = nil

    --- @type HeroDataService
    self.heroDataService = nil

    --- @type ItemDataService
    self.itemDataService = nil

    --- @type DungeonDataService
    self.dungeonDataService = nil

    --- @type PredefineTeamDataService
    self.predefineDataService = nil

    --- @type HeroLinkingDataService
    self.heroLinkingDataService = nil
end

--- @return boolean bind done, without error
function ServiceController:BindDependencies()
    self.battleService:SetDependencies(self.heroDataService, self.itemDataService,
            self.dungeonDataService, self.predefineDataService, self.heroLinkingDataService)

    self.heroDataService:Validate()
    self.heroLinkingDataService:Validate()

    self.predefineDataService:SetDependencies(self.heroDataService)
    return true
end

--- @return void
--- @param heroDataService HeroDataService
function ServiceController:SetHeroDataService(heroDataService)
    self.heroDataService = heroDataService
end

--- @return void
--- @param battleService BattleService
function ServiceController:SetBattleService(battleService)
    self.battleService = battleService
end

--- @return void
--- @param itemDataService ItemDataService
function ServiceController:SetItemDataService(itemDataService)
    self.itemDataService = itemDataService
end

--- @return void
--- @param dungeonDataService DungeonDataService
function ServiceController:SetDungeonDataService(dungeonDataService)
    self.dungeonDataService = dungeonDataService
end

--- @return void
--- @param predefineDataService PredefineTeamDataService
function ServiceController:SetPredefineDataService(predefineDataService)
    self.predefineDataService = predefineDataService
end

--- @return void
--- @param luaPath string
function ServiceController:LoadDynamicRequire(luaPath)
    require(luaPath)
end

--- @return void
--- @param heroLinkingDataService HeroLinkingDataService
function ServiceController:SetHeroLinkingDataService(heroLinkingDataService)
    self.heroLinkingDataService = heroLinkingDataService
end