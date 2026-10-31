--- @class VipBenefitState
VipBenefitState = {
    NO_CHANGE = 0,
    UPGRADE = 1,
    NEW = 2
}

--- @class VipBenefitData
VipBenefitData = Class(VipBenefitData)

function VipBenefitData:Ctor()
    --- @type number
    self.index = nil
    --- @type string
    self.content = nil
    --- @type VipBenefitState
    self.vipState = nil
end

function VipBenefitData.CreateByParams(index, content, vipBenefitState)
    local data = VipBenefitData()
    data.index = index
    data.content = content
    data.vipState = vipBenefitState

    return data;
end