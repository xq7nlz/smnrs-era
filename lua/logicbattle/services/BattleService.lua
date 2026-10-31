--- @class BattleService
BattleService = Class(BattleService)

--- @return void
function BattleService:Ctor()
    --- @type HeroDataService
    self._heroDataService = nil

    --- @type ItemDataService
    self._itemDataService = nil

    --- @type DungeonDataService
    self._dungeonDataService = nil

    --- @type PredefineTeamDataService
    self._predefineTeamDataService = nil

    --- @type HeroLinkingDataService
    self._heroLinkingDataService = nil
end

--- @return HeroDataService
function BattleService:GetHeroDataService()
    return self._heroDataService
end

--- @return ItemDataService
function BattleService:GetItemDataService()
    return self._itemDataService
end

--- @return DungeonDataService
function BattleService:GetDungeonDataService()
    return self._dungeonDataService
end

--- @return PredefineTeamDataService
function BattleService:GetPredefineTeamDataService()
    return self._predefineTeamDataService
end

--- @return HeroLinkingDataService
function BattleService:GetHeroLinkingDataService()
    return self._heroLinkingDataService
end

--- @return void
--- @param heroDataService HeroDataService
--- @param itemDataService ItemDataService
--- @param dungeonDataService DungeonDataService
--- @param predefineTeamDataService PredefineTeamDataService
--- @param heroLinkingDataService HeroLinkingDataService
function BattleService:SetDependencies(heroDataService, itemDataService,
                                       dungeonDataService, predefineTeamDataService, heroLinkingDataService)
    self._heroDataService = heroDataService
    self._itemDataService = itemDataService
    self._dungeonDataService = dungeonDataService
    self._predefineTeamDataService = predefineTeamDataService
    self._heroLinkingDataService = heroLinkingDataService
end

--- @return BattleResult
--- @param battle Battle
--- @param runMode RunMode
--- @param includePower boolean
function BattleService:CalculateBattleResult(battle, runMode, includePower)
    battle:SetRunMode(runMode)
    battle:PrepareBattle(self)

    local attackerPower = 0
    local defenderPower = 0
    if includePower then
        attackerPower = TeamPowerCalculator.CalculateTeamPower(battle, BattleConstants.ATTACKER_TEAM_ID)
        defenderPower = TeamPowerCalculator.CalculateTeamPower(battle, BattleConstants.DEFENDER_TEAM_ID)
    end

    battle:OnStartBattle()
    battle:Resolve()
    battle:OnEndBattle()

    local battleResult = battle:GetResult()
    battleResult.attackerPower = attackerPower
    battleResult.defenderPower = defenderPower

    return battleResult
end