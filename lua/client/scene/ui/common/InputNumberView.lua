--- @class InputNumberView : IconView
InputNumberView = Class(InputNumberView, IconView)

--- @return void
function InputNumberView:Ctor()
    ---@type number
    self.value = 0
    ---@type number
    self.step = 1
    ---@type number
    self.minValue = math.mininteger
    ---@type number
    self.maxValue = math.maxinteger
    ---@type function(value)
    self.onChangeInput = nil

    IconView.Ctor(self)
end
--- @return void
function InputNumberView:SetPrefabName()
    self.prefabName = 'input_number_view'
    self.uiPoolType = UIPoolType.InputNumberView
end

--- @return void
--- @param transform UnityEngine_Transform
function InputNumberView:SetConfig(transform)
    assert(transform)
    --- @type UIInputConfig
    ---@type UIInputConfig
    self.config = UIBaseConfig(transform)
    self.config.inputNumber.text = tostring(self.value)
    self.config.buttonAdd.onClick:AddListener(function ()
        self:OnClickAdd()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
    self.config.buttonSub.onClick:AddListener(function ()
        self:OnClickSub()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
    self.config.buttonBack.onClick:AddListener(function ()
        self:OnClickBack()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
    self.config.buttonNext.onClick:AddListener(function ()
        self:OnClickNext()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
    self.config.inputNumber.onEndEdit:AddListener(function ()
        self:InputEnd()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
end

--- @return void
function InputNumberView:InputEnd()
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
function InputNumberView:SetData(value, minValue, maxValue, step)
    self.minValue = minValue
    self.maxValue = maxValue
    if self.minValue ~= nil and value < self.minValue then
        self.value = self.minValue
    elseif self.maxValue ~= nil and value > self.maxValue then
        self.value = self.maxValue
    else
        self.value = value
    end
    if step ~= nil then
        self.step = step
    end
    self:UpdateUI()
    if self.onChangeInput ~= nil then
        self.onChangeInput(self.value)
    end
end

--- @return void
function InputNumberView:UpdateUI()
    self.config.inputNumber.text = tostring(self.value)
end

--- @return void
function InputNumberView:OnClickSub()
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
function InputNumberView:OnClickAdd()
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

--- @return void
function InputNumberView:OnClickBack()
    local lastValue = self.value
    self.value = self.minValue
    self:UpdateUI()
    if self.onChangeInput ~= nil and self.value ~= lastValue then
        self.onChangeInput(self.value)
    end
end

--- @return void
function InputNumberView:OnClickNext()
    local lastValue = self.value
    self.value = self.maxValue
    self:UpdateUI()
    if self.onChangeInput ~= nil and self.value ~= lastValue then
        self.onChangeInput(self.value)
    end
end

return InputNumberView


