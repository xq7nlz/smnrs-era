require "lua.client.battleShow.LogDetail.ClientEffectDetail"
require "lua.client.battleShow.LogDetail.ClientDrowningMarkEffectDetail"
require "lua.client.battleShow.LogDetail.DivineShieldEffectDetail"
--- @class ClientEffectLogDetailBuilder
ClientEffectLogDetailBuilder = {}

--- @return ClientEffectDetail
--- @param effectLogType EffectLogType
--- @param initiator BaseHero
function ClientEffectLogDetailBuilder.Create(effectLogType,initiator)
    if effectLogType == EffectLogType.DROWNING_MARK then
        return ClientDrowningMarkEffectDetail(effectLogType)
    end
    if effectLogType == EffectLogType.DIVINE_SHIELD then
        return DivineShieldEffectDetail(effectLogType,initiator)
    end
    return ClientEffectDetail(effectLogType)
end

return ClientEffectLogDetailBuilder