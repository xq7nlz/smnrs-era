--- @class UIGuildDungeonModel : UIBaseModel
UIGuildDungeonModel = Class(UIGuildDungeonModel, UIBaseModel)

--- @return void
function UIGuildDungeonModel:Ctor()
    UIBaseModel.Ctor(self, UIPopupName.UIGuildDungeon, "guild_dungeon")
    --- @type UIPopupType
    self.type = UIPopupType.NO_BLUR_POPUP
    --- @type number
    self.checkOutStage = nil
    --- @type boolean
    self.isSeasonOpen = nil
    --- @type number
    self.seasonTimeReach = nil
end

--- @return BattleTeamInfo
--- @param guildDungeonDefenderTeamInBound GuildDungeonDefenderTeamInBound
function UIGuildDungeonModel.PrepareBattleTeamInfo(guildDungeonDefenderTeamInBound)
    --- @type BattleTeamInfo
    local battleTeamInfo = DefenderTeamData.GetBattleTeamInfoByPredefineTeam(guildDungeonDefenderTeamInBound.predefineTeamData)
    --- @param v HeroStateInBound
    for _, v in pairs(guildDungeonDefenderTeamInBound.listHeroState:GetItems()) do
        battleTeamInfo:SetState(GameMode.GUILD_DUNGEON, v.isFrontLine, v.position, v.hp, v.power)
    end
    return battleTeamInfo
end

