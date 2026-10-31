require "lua.client.utils.Rx.Subject"

--- @class Number : SubjectLegacy
Number = Class(Number, SubjectLegacy)

--- @return void
function Number:Ctor()
    SubjectLegacy.Ctor(self)
    self._onIncrease = List()
    self._onDecrease = List()
    self:Assign(0)
end

--- @return number
function Number:GetValue()
    return self._value
end


--- @return number
--- @param valueChange number
function Number:Assign(valueChange)
    if type(valueChange) ~= "number" then
        assert(false, "valueChange must be number")
    end
    return SubjectLegacy.Assign(self, valueChange)
end

--- @return number
--- @param valueChange number
function Number:Increase(valueChange)

    if valueChange > 0 then
        self._value = self._value + valueChange
        self:_OnIncrease(valueChange)
        self:_OnValueChange()
    end

    return self._value
end

--- @return void
function Number:_OnIncrease(valueChange)
    if self._onIncrease:Count() > 0 then
        for _, method in ipairs(self._onIncrease:GetItems()) do
            method(self._value, valueChange)
        end
    end
end

--- @return number
--- @param valueChange number
function Number:Decrease(valueChange)

    if valueChange > 0 then
        self._value = self._value - valueChange
        self:_OnDecrease(valueChange)
        self:_OnValueChange()
    end

    return self._value
end

--- @return void
function Number:_OnDecrease(valueChange)
    if self._onDecrease:Count() > 0 then
        for _, method in ipairs(self._onDecrease:GetItems()) do
            method(self._value, valueChange)
        end
    end
end

--- @return void
--- @param method method
function Number:IncreaseSubscribe(method)
    if method == nil then
        assert(false, "method cant be nil")
    end
    self._onIncrease:Add(method)
end

--- @return void
--- @param method method
function Number:DecreaseSubscribe(method)
    if method == nil then
        assert(false, "holder or method cant be nil")
    end
    self._onDecrease:Add(method)
end

--- @return void
function Number:Unsubscribe()
    SubjectLegacy.Unsubscribe(self)
    self._onIncrease:Clear()
    self._onDecrease:Clear()
end