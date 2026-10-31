

--- @class UIBaseCtrl
UIBaseCtrl = Class(UIBaseCtrl)

function UIBaseCtrl:Ctor(model)
    assert(model)
    self.model = model
end

function UIBaseCtrl:Remove()
    self.model = nil
end