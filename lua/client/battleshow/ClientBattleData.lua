--- @class ClientBattleData
ClientBattleData = {}
--- @type Battle
ClientBattleData.battle = nil
--- @type ClientLogDetail
ClientBattleData.clientLogDetail = nil
--- @type BattleResult
ClientBattleData.battleResult = nil
--- @type boolean
ClientBattleData.skipForReplay = false
--- @type function
ClientBattleData.calculationBattle = nil

--- @return boolean
function ClientBattleData.IsValidData()
    if ClientBattleData.clientLogDetail ~= nil
            and ClientBattleData.battleResult ~= nil then
        return true
    end
    return false
end

--- @return boolean
function ClientBattleData.SetCalculationBattle(calculationBattle)
    ClientBattleData.calculationBattle = calculationBattle
    ClientBattleData.battleResult = nil
    ClientBattleData.clientLogDetail = nil
end