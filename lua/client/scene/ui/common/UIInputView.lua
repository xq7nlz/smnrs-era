---COMMENT_CONFIG_COMMON    require "lua.client.scene.ui.common.UIInputConfig"

--- @class UIInputView
UIInputView = Class(UIInputView)

--- @return void
--- @param transform UnityEngine_Transform
function UIInputView:Ctor(transform, onChangeInput)
    ---@type UIInputConfig
    ---@type UIInputConfig
    self.config = UIBaseConfig(transform)
    ---@type number
    self.value = 0
    ---@type number
    self.step = 1
    ---@type number
    self.minValue = math.mininteger
    ---@type number
    self.maxValue = math.maxinteger
    ---@type function(value)
    self.onChangeInput = onChangeInput

    self.config.inputNumber.text = tostring(self.value)

    self.config.buttonAdd.onClick:AddListener(function ()
        self:OnClickAdd()
    end)
    self.config.buttonSub.onClick:AddListener(function ()
        self:OnClickSub()
    end)
    self.config.inputNumber.onEndEdit:AddListener(function ()
        self:InputEnd()
    end)
end

--- @return void
function UIInputView:InputEnd()
    local input = tonumber(self.config.inputNumber.text)
    if input ~= nil then
        if self.minValue ~= nil and input < self.minValue then
            self.value = self.minValue
        elseif self.maxValue ~= nil and input > self.maxValue then
            self.value = self.maxValue
        else
            self.value = input
        end
    end
    self:UpdateUI()
    if self.onChangeInput ~= nil then
        self.onChangeInput(self.value)
    end
end

--- @return void
function UIInputView:SetData(value, minValue, maxValue, step)
    self.value = value
    self.minValue = minValue
    self.maxValue = maxValue
    if step ~= nil then
        self.step = step
    end
    self:UpdateUI()
end

--- @return void
function UIInputView:UpdateUI()
    self.config.inputNumber.text = tostring(self.value)
end

--- @return void
function UIInputView:OnClickSub()
    local lastValue = self.value
    self.value = self.value - self.step
    if self.minValue ~= nil and self.value < self.minValue then
        self.value = self.minValue
    end
    self:UpdateUI()
    if self.onChangeInput ~= nil and self.value ~= lastValue then
        self.onChangeInput(self.value)
    end
end

--- @return void
function UIInputView:OnClickAdd()
    local lastValue = self.value
    self.value = self.value + self.step
    if self.maxValue ~= nil and self.value > self.maxValue then
        self.value = self.maxValue
    end
    self:UpdateUI()
    if self.onChangeInput ~= nil and self.value ~= lastValue then
        self.onChangeInput(self.value)
    end
end