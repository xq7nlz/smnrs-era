--- @class EditorIAPReceipt
EditorIAPReceipt = Class(EditorIAPReceipt, IAPReceipt)

function EditorIAPReceipt:Ctor(content)
    IAPReceipt.Ctor(self, content)

    self.is_test = true

    self:SetReceipt(content)
    IAPReceipt.SetProductConfig(self)
end

function EditorIAPReceipt:SetReceipt(content)
    self.transaction_id = ""
    self.receipt = ""
    self.pack_name = content
end