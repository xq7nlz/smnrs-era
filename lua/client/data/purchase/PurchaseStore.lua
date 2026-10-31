--- @class PurchaseStore
PurchaseStore = Class(PurchaseStore)

--- @return void
function PurchaseStore:Ctor()
    --- @type Dictionary
    self.packConfigDict = nil
end

function PurchaseStore:InitPack()
    XDebug.Error("Need override this method")
end

function PurchaseStore:SetKey()
    XDebug.Error("Need override this method")
end

--- @return PackOfProducts
--- @param id number
function PurchaseStore:GetPack(id)
    local data = self.packConfigDict:Get(id)
    if data == nil then
        XDebug.Error(string.format("pack is nil: %s", tostring(id)))
    end
    return data
end

function PurchaseStore:InitProgressPack(id)
    XDebug.Error("Need override this method")
end

--- @return ProductConfig
--- @param packId number
function PurchaseStore:GetPackById(packId, productId)
    return self:GetPack(packId):GetPackBase(productId)
end

--- @return Dictionary
function PurchaseStore:GetAllPacks()
    return self.packConfigDict
end