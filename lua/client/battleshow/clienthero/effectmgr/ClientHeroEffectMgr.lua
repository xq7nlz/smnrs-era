require "lua.client.battleShow.ClientHero.effectMgr.EffectIconBarMgr"
require "lua.client.battleShow.ClientHero.effectMgr.EffectOnMarkBarMgr"
require "lua.client.battleShow.ClientHero.effectMgr.HardCcEffectMgr"
require "lua.client.battleShow.ClientHero.effectMgr.EffectMarkOnBodyMgr"

--- @class ClientHeroEffectMgr
ClientHeroEffectMgr = Class(ClientHeroEffectMgr)

--- @param clientHero ClientHero
function ClientHeroEffectMgr:Ctor(clientHero)
    --- @type ClientHero
    self.clientHero = clientHero
    --- @type UIHeroStatusBar
    self.uiHeroStatusBar = clientHero.uiHeroStatusBar

    --- @type ClientBattleShowController
    self.clientBattleShowController = zg.battleMgr.clientBattleShowController

    self.hardCcEffectMgr = HardCcEffectMgr(self)
    self.effectIconBarMgr = EffectIconBarMgr(self)
    self.effectOnMarBarMgr = EffectOnMarBarMgr(self)
    self.effectMarkOnBodyMgr = EffectMarkOnBodyMgr(self)
end

--- @param effectChangeResult EffectChangeResult
--- @param serverRound number
function ClientHeroEffectMgr:UpdateCCEffect(effectChangeResult, serverRound)
    self.hardCcEffectMgr:UpdateCCEffect(effectChangeResult, serverRound)
end

--- @param effectLogType EffectLogType
--- @param clientEffectDetail ClientEffectDetail
function ClientHeroEffectMgr:UpdateEffectIconType(effectLogType, clientEffectDetail)
    self.effectIconBarMgr:UpdateEffectIconType(effectLogType, clientEffectDetail)
end

--- @param effectLogType EffectLogType
--- @param clientEffectDetail ClientEffectDetail
function ClientHeroEffectMgr:UpdateEffectMarkIconByType(effectLogType, clientEffectDetail)
    self.effectOnMarBarMgr:UpdateEffectMarkIconByType(effectLogType, clientEffectDetail)
end

--- @param effectLogType EffectLogType
--- @param clientEffectDetail ClientEffectDetail
function ClientHeroEffectMgr:UpdateEffectMarkType(effectLogType, clientEffectDetail)
    self.effectMarkOnBodyMgr:UpdateEffectMarkOnBody(effectLogType, clientEffectDetail)
end

function ClientHeroEffectMgr:RemoveAllEffectShow()
    self.effectMarkOnBodyMgr:Release()
    self.effectOnMarBarMgr:Release()
    self.effectIconBarMgr:Release()
    self.hardCcEffectMgr:Release()

    self.clientHero:RemoveFreezedByType(EffectLogType.PETRIFY)
end

--- @param effectLogType EffectLogType
function ClientHeroEffectMgr:OnAddCcEffect(effectLogType)
    self.hardCcEffectMgr:OnAddCcEffect(effectLogType)
end

--- @return EffectLogType
function ClientHeroEffectMgr:PriorityEffectShow()
    return self.hardCcEffectMgr:PriorityEffectShow()
end

--- @param effectLogType EffectLogType
function ClientHeroEffectMgr:GetCcEffectTable(effectLogType)
    return self.hardCcEffectMgr:GetCcEffectTable(effectLogType)
end