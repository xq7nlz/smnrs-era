---COMMENT_CONFIG_COMMON    require "lua.client.scene.ui.common.UIInputSliderConfig"

--- @class InputSliderView : IconView
InputSliderView = Class(InputSliderView, IconView)

--- @return void
function InputSliderView:Ctor()
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
function InputSliderView:SetPrefabName()
    self.prefabName = 'input_slider_view'
    self.uiPoolType = UIPoolType.InputSliderView
end

--- @return void
--- @param transform UnityEngine_Transform
function InputSliderView:SetConfig(transform)
    assert(transform)
    --- @type UIInputSliderConfig
    ---@type UIInputSliderConfig
    self.config = UIBaseConfig(transform)
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
    self.config.inputNumber.onValueChanged:AddListener(function(value)
        self:InputChange(value)
    end)
end

--- @return void
function InputSliderView:InputChange(value)
    self.value = self.minValue + MathUtils.Round(value * (self.maxValue - self.minValue))
    if self.onChangeInput ~= nil then
        self.onChangeInput(self.value)
    end
end

--- @return void
function InputSliderView:SetData(value, minValue, maxValue, step)
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
    if self.minValue == self.maxValue then
        self.config.inputNumber.value = 1
    else
        self:UpdateUI()
        if self.onChangeInput ~= nil then
            self.onChangeInput(self.value)
        end
    end
end

--- @return void
function InputSliderView:UpdateUI()
    self.config.inputNumber.value = (self.value - self.minValue) / (self.maxValue - self.minValue)
end

--- @return void
function InputSliderView:OnClickSub()
    if self.minValue ~= self.maxValue then
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
end

--- @return void
function InputSliderView:OnClickAdd()
    if self.minValue ~= self.maxValue then
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
end

--- @return void
function InputSliderView:OnClickBack()
    if self.minValue ~= self.maxValue then
        local lastValue = self.value
        self.value = self.minValue
        self:UpdateUI()
        if self.onChangeInput ~= nil and self.value ~= lastValue then
            self.onChangeInput(self.value)
        end
    end
end

--- @return void
function InputSliderView:OnClickNext()
    if self.minValue ~= self.maxValue then
        local lastValue = self.value
        self.value = self.maxValue
        self:UpdateUI()
        if self.onChangeInput ~= nil and self.value ~= lastValue then
            self.onChangeInput(self.value)
        end
    end
end

return InputSliderView


