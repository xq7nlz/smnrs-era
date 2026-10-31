require("lua.client.core.network.battleFormation.BattleFormationOutBound")
require("lua.client.scene.ui.home.uiFormation.UIFormationTeamData")
--- @class ArenaTeamFormationOutBound : OutBound
ArenaTeamFormationOutBound = Class(ArenaTeamFormationOutBound, OutBound)

--- @return void
function ArenaTeamFormationOutBound:Ctor(dictBattle)
    ---@type Dictionary
    self.dictBattle = dictBattle
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function ArenaTeamFormationOutBound:Serialize(buffer)
    buffer:PutByte(self.dictBattle:Count())
    ---@param v BattleFormationOutBound
    for i, v in pairs(self.dictBattle:GetItems()) do
        buffer:PutInt(i)
        BattleFormationOutBound(UIFormationTeamData.CreateByTeamFormationInBound(v)):Serialize(buffer)
    end
end