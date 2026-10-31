
--- @class SubjectLegacy
SubjectLegacy = Class(SubjectLegacy)

--- @return void
function SubjectLegacy:Ctor()
    self._value = nil
    self._onValueChange = List()
end

--- @return object
--- @param valueChange object
function SubjectLegacy:Assign(valueChange)

    if self._value ~= valueChange then
        self._value = valueChange
        self:_OnValueChange()
    end

    return self._value
end

--- @return void
function SubjectLegacy:_OnValueChange()
    if self._onValueChange:Count() > 0 then
        for _, method in ipairs(self._onValueChange:GetItems()) do
            method(self._value)
        end
    end
end

--- @return object
function SubjectLegacy:GetValue()
    return self._value
end

--- @return void
--- @param method method
function SubjectLegacy:Subscribe(method)
    if method == nil then
        assert(false, "method cant be nil")
    end
    self._onValueChange:Add(method)
end

--- @return void
function SubjectLegacy:Unsubscribe()
    self._onValueChange:Clear()
end