require "lua.client.battleShow.LogDetail.ActionDetail.ClientActionDetail"
require "lua.client.battleShow.LogDetail.ActionDetail.GatherDamageClientActionDetail"
require "lua.client.battleShow.LogDetail.ActionDetail.HealClientActionDetail"
require "lua.client.battleShow.LogDetail.ActionDetail.EffectClientActionDetail"
require "lua.client.battleShow.LogDetail.ActionDetail.RegenerateClientActionDetail"
require "lua.client.battleShow.LogDetail.ActionDetail.GeneralClientActionDetail"
require "lua.client.battleShow.LogDetail.ActionDetail.BouncingDamageClientActionDetail"

--- @class ClientActionDetailBuilder
ClientActionDetailBuilder = {}

--- @return ClientActionDetail
--- @param type ActionResultType
function ClientActionDetailBuilder.Create(type)
    if ClientActionResultUtils.IsChangeEffect(type) then
        return EffectClientActionDetail(type)
    elseif ClientActionResultUtils.IsDamageActionType(type) then
        return GatherDamageClientActionDetail(type)
    elseif type == ActionResultType.BOUNCING_DAMAGE then
        return GatherDamageClientActionDetail(type)
    elseif ClientActionResultUtils.IsHeal(type) then
        return HealClientActionDetail(type)
    elseif type == ActionResultType.REGENERATE then
        return RegenerateClientActionDetail(type)
    else
        return GeneralClientActionDetail(type)
    end
end

return ClientActionDetailBuilder