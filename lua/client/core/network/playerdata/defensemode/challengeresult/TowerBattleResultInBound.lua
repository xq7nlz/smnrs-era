--- @class TowerBattleResultInBound
TowerBattleResultInBound = Class(TowerBattleResultInBound)

function TowerBattleResultInBound:Ctor()
    --- @type boolean
    self.isWin = nil
    --- @type number
    self.attackerHp = nil
    --- @type number
    self.defenseHp = nil

    --- @type List
    self.listRoundBasicInfo = nil
end

--- @return TowerBattleResultInBound
--- @param buffer UnifiedNetwork_ByteBuf
function TowerBattleResultInBound.CreateByBuffer(buffer, isApply)
    local towerBattleResultInBound = TowerBattleResultInBound()
    towerBattleResultInBound.isWin = buffer:GetBool()
    towerBattleResultInBound.attackerHp = buffer:GetLong() / MathUtils.BILLION
    towerBattleResultInBound.defenseHp = buffer:GetLong() / MathUtils.BILLION

    --- @type RoundBasicInfo
    towerBattleResultInBound.listRoundBasicInfo = NetworkUtils.GetListDataInBound(buffer, RoundBasicInfo.CreateByBuffer)
    return towerBattleResultInBound
end

function TowerBattleResultInBound:GetArgDefenderHp()
    return self.defenseHp
end

--- @class RoundBasicInfo
RoundBasicInfo = Class(RoundBasicInfo)

function RoundBasicInfo:Ctor()
    --- @type RoundTeamState
    self.attackerTeamState = nil
    --- @type RoundTeamState
    self.defenderTeamState = nil
end

--- @return RoundBasicInfo
--- @param buffer UnifiedNetwork_ByteBuf
function RoundBasicInfo.CreateByBuffer(buffer)
    local data = RoundBasicInfo()
    data.attackerTeamState = RoundTeamState(buffer)
    data.defenderTeamState = RoundTeamState(buffer)
    return data
end

function RoundBasicInfo:GetDefenderHp()
    return self.defenderTeamState:GetArgHealth()
end

function RoundBasicInfo:GetAttackerHp()
    return self.attackerTeamState:GetArgHealth()
end

--- @class RoundTeamState
RoundTeamState = Class(RoundTeamState)

--- @param buffer UnifiedNetwork_ByteBuf
function RoundTeamState:Ctor(buffer)
    self.heroStateDict = Dictionary()
    if buffer == nil then
        return
    end
    local size = buffer:GetByte()
    for i = 1, size do
        local health = buffer:GetLong() / 10 ^ 9
        local power = buffer:GetInt()
        self.heroStateDict:Add(health, power)
    end
end

--- @return number
function RoundTeamState:GetArgHealth()
    if self.heroStateDict:Count() == 0 then
        return 0
    end
    local hp = 0
    for k, v in pairs(self.heroStateDict:GetItems()) do
        hp = hp + k
    end
    return MathUtils.RoundDecimal(hp / self.heroStateDict:Count(), 1)
end
