--- @class DivineShieldEffectDetail : ClientEffectDetail
DivineShieldEffectDetail = Class(DivineShieldEffectDetail, ClientEffectDetail)

--- @return void
--- @param effectLogType EffectLogType
--- @param initiator BaseHero
function DivineShieldEffectDetail:Ctor(effectLogType,initiator)
    self.effectChangeResult = nil
    self.initiator = initiator
    ClientEffectDetail.Ctor(self, effectLogType)
end
