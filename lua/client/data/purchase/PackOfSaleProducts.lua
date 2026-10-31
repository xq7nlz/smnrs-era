--- @class PackOfSaleProducts : PackOfProducts
PackOfSaleProducts = Class(PackOfSaleProducts, PackOfProducts)

--- @return SaleOffProductConfig
function PackOfSaleProducts:FindSaleProduct(originPackId, opCode)
    for i = 1, self.packList:Count() do
        --- @type SaleOffProductConfig
        local saleOffPack = self.packList:Get(i)
        if saleOffPack:CompareToOriginPack(originPackId, opCode) then
            return saleOffPack
        end
    end
    return nil
end