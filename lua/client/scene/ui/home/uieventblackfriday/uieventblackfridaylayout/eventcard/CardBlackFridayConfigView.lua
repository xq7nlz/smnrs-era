--- @class CardBlackFridayConfigView
CardBlackFridayConfigView = Class(CardBlackFridayConfigView)
local CALCULATOR_TYPE = {
    ADD = 1,
    MULTIPLY = 2,
}
local FACTOR_TYPE = {
    VIP_LEVEL = 1,
    LEVEL_SUMMON = 2,
}
--- @param transform UnityEngine_Transform
function CardBlackFridayConfigView:Ctor(transform)
    ---@type CardCalculatorConfig
    self.config = UIBaseConfig(transform)
end

function CardBlackFridayConfigView:ShowCard(factor, calculator)
    --XDebug.Log("FACTOR " .. tostring(factor) .. " CAL " .. tostring(calculator))
    if factor == FACTOR_TYPE.VIP_LEVEL then
        self.config.vipIcon:SetActive(true)
        self.config.lvIcon:SetActive(false)
    elseif factor == FACTOR_TYPE.LEVEL_SUMMON then
        self.config.vipIcon:SetActive(false)
        self.config.lvIcon:SetActive(true)
    else
        self.config.gameObject:SetActive(false)
        return
    end

    if calculator== CALCULATOR_TYPE.ADD then
        self.config.addIcon:SetActive(true)
        self.config.multiIcon:SetActive(false)
    elseif calculator == CALCULATOR_TYPE.MULTIPLY then
        self.config.addIcon:SetActive(false)
        self.config.multiIcon:SetActive(true)
    else
        self.config.gameObject:SetActive(false)
    end
--[[    --self.config.transform.position = position
    if factor == FACTOR_TYPE.VIP_LEVEL then
        self.config.vipIcon:SetActive(true)
        self.config.lvIcon:SetActive(false)
    elseif factor == FACTOR_TYPE.LEVEL_SUMMON then
        self.config.vipIcon:SetActive(false)
        self.config.lvIcon:SetActive(true)
    end

    if calculator== CALCULATOR_TYPE.ADD then
        self.config.addIcon:SetActive(true)
        self.config.multiIcon:SetActive(false)
    elseif calculator == CALCULATOR_TYPE.MULTIPLY then
        self.config.addIcon:SetActive(false)
        self.config.multiIcon:SetActive(true)
    end]]
end