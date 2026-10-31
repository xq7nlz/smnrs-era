--- @class StatChangerDungeonHelper
StatChangerDungeonHelper = Class(StatChangerDungeonHelper)

--- @return void
--- @param team BattleTeam
function StatChangerDungeonHelper:Ctor(team)
    ---@type BattleTeam
    self.team = team

    ---@type DungeonDataService
    self.dungeonDataService = nil
end

------------------------------------------ DUNGEON -------------------------------------
--- @return void
--- @param dungeonDataService DungeonDataService
function StatChangerDungeonHelper:InitDungeonBuff(dungeonDataService)
    self.dungeonDataService = dungeonDataService
    if self.team:GetDungeonBuff():Count() > 0 then
        local dungeonBuff = self.team:GetDungeonBuff():GetItems()
        --print(LogUtils.ToDetail(dungeonBuff))
        for idBuff, number in pairs(dungeonBuff) do
            self:AddBuffDungeon(idBuff, number)
        end
    end
end

--- @return void
--- @param idBuff Number
--- @param numberBuffApply number
function StatChangerDungeonHelper:AddBuffDungeon(idBuff, numberBuffApply)
    local buff = self.dungeonDataService:GetPassiveBuff(idBuff, numberBuffApply)
    local allHeroInTeam = self.team:GetHeroList()
    local i = 1
    while i <= allHeroInTeam:Count() do
        local hero = allHeroInTeam:Get(i)
        buff:ApplyToHero(hero, numberBuffApply)
        i = i + 1
    end
end
