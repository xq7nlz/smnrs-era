--- @class SmallInputNumberView : IconView
SmallInputNumberView = Class(SmallInputNumberView, IconView)

--- @return void
function SmallInputNumberView:Ctor()
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
    ---@type function(value)
    self.onAdd = nil
    ---@type function(value)
    self.onSub = nil

    IconView.Ctor(self)
end
--- @return void
function SmallInputNumberView:SetPrefabName()
    self.prefabName = 'small_input_number_view'
    self.uiPoolType = UIPoolType.SmallInputNumberView
end

--- @return void
--- @param transform UnityEngine_Transform
function SmallInputNumberView:SetConfig(transform)
    assert(transform)
    --- @type UIInputConfig
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
function SmallInputNumberView:InputEnd()
    local input = tonumber(self.config.inputNumber.text)
    local lastValue = self.value
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
        self.onChangeInput( self.value - lastValue)
    end
end

--- @return void
function SmallInputNumberView:SetData(value, minValue, maxValue, step)
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
function SmallInputNumberView:UpdateUI()
    self.config.inputNumber.text = tostring(self.value)
end

--- @return void
function SmallInputNumberView:OnClickSub()
    local lastValue = self.value
    self.value = self.value - self.step
    if self.minValue ~= nil and self.value < self.minValue then
        self.value = self.minValue
    end
    self:UpdateUI()
    if self.onSub ~= nil and self.value ~= lastValue then
        self.onSub(self.step)
    end
end

--- @return void
function SmallInputNumberView:OnClickAdd()
    local lastValue = self.value
    self.value = self.value + self.step
    if self.maxValue ~= nil and self.value > self.maxValue then
        self.value = self.maxValue
    end
    self:UpdateUI()
    if self.onAdd ~= nil and self.value ~= lastValue then
        self.onAdd(self.step)
    else
        SmartPoolUtils.ShowShortNotification(
                LanguageUtils.LocalizeCommon("max_item_limit"))
    end
end

--- @return void
function SmallInputNumberView:OnClickBack()
    local lastValue = self.value
    self.value = self.minValue
    self:UpdateUI()
    if self.onSub ~= nil and self.value ~= lastValue then
        self.onSub(lastValue - self.value)
    end
end

--- @return void
function SmallInputNumberView:OnClickNext()
    local lastValue = self.value
    self.value = self.maxValue
    self:UpdateUI()
    if self.onAdd ~= nil and self.value ~= lastValue then
        self.onAdd(self.value - lastValue)
    else
        SmartPoolUtils.ShowShortNotification(
                LanguageUtils.LocalizeCommon("max_item_limit"))
    end
end

return SmallInputNumberView


