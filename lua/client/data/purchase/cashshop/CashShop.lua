require "lua.client.data.Purchase.CashShop.RawProduct"
require "lua.client.data.Purchase.CashShop.LimitedProduct"
require "lua.client.data.Purchase.CashShop.SubscriptionProduct"
require "lua.client.data.Purchase.CashShop.LevelPassProduct"
require "lua.client.data.Purchase.CashShop.ProgressGroupPackOfProducts"
require "lua.client.data.Purchase.GroupPackOfProducts"
require "lua.client.data.Purchase.CashShop.ProgressProduct"
require "lua.client.data.Purchase.ComebackProducts"
require "lua.client.data.Purchase.SkinRawProducts"
require "lua.client.data.Purchase.CashShop.CustomizeProduct"
require "lua.client.data.Purchase.CashShop.BoostFirstPurchasePackOfProducts"
require "lua.client.data.Purchase.CashShop.BoostFirstPurchaseProduct"
require "lua.client.data.Purchase.CashShop.FlashSaleEvolveProduct"

local PURCHASE_RAW_PACK_PATH = "csv/purchase/raw_pack.csv"
local PURCHASE_SUBSCRIPTION_PACK_PATH = "csv/purchase/subscription_pack.csv"
local PURCHASE_LIMITED_PACK_PATH = "csv/purchase/limited_pack_new.csv"
local PURCHASE_GROWTH_PACK_PATH = "csv/purchase/growth_pack/growth_pack.csv"
local PURCHASE_PROGRESS_PACK_PATH = "csv/purchase/progress/progress_pack.csv"
local PURCHASE_PROGRESS_GROUP_PATH = "csv/purchase/progress/progress_group.csv"
local COMEBACK_BUNDLE_PATH = "csv/comeback/data_%s/bundle_pack.csv"
local SKIN_RAW_PACK_PATH = "csv/item/skin/skin_bundle.csv"
local CUSTOMIZE_DAILY_BUNDLE_PATH = "csv/purchase/customize_bundle.csv"
local PURCHASE_BOOST_FIRST_PATH = "csv/purchase/boost_first_purchase/boost_first_purchase_pack.csv"
local FLASH_SALE_EVOLVE_PATH = "csv/purchase/flash_sale_evolve/flash_sale_evolve_product.csv"

--- @class CashShop : PurchaseStore
CashShop = Class(CashShop, PurchaseStore)

--- @return void
function CashShop:Ctor()
    PurchaseStore.Ctor(self)
end

function CashShop:InitPack()
    self.packConfigDict = Dictionary()
    self.packConfigDict:Add(OpCode.PURCHASE_RAW_PACK, PackOfProducts(OpCode.PURCHASE_RAW_PACK, RawProduct, PURCHASE_RAW_PACK_PATH))
    self.packConfigDict:Add(OpCode.PURCHASE_LIMITED_PACK, PackOfProducts(OpCode.PURCHASE_LIMITED_PACK, LimitedProduct, PURCHASE_LIMITED_PACK_PATH))
    self.packConfigDict:Add(OpCode.PURCHASE_SUBSCRIPTION_PACK, PackOfProducts(OpCode.PURCHASE_SUBSCRIPTION_PACK, SubscriptionProduct, PURCHASE_SUBSCRIPTION_PACK_PATH))
    self.packConfigDict:Add(OpCode.PURCHASE_GROWTH_PACK, PackOfProducts(OpCode.PURCHASE_GROWTH_PACK, LevelPassProduct, PURCHASE_GROWTH_PACK_PATH))
    self.packConfigDict:Add(OpCode.COMEBACK_BUNDLE_PURCHASE, ComebackProducts(OpCode.COMEBACK_BUNDLE_PURCHASE, LimitedProduct, COMEBACK_BUNDLE_PATH))
    self.packConfigDict:Add(OpCode.ITEM_SKIN_BUNDLE_PURCHASE, SkinRawProducts(OpCode.ITEM_SKIN_BUNDLE_PURCHASE, ProductConfig, SKIN_RAW_PACK_PATH))
    self.packConfigDict:Add(OpCode.CUSTOMIZE_BUNDLE_PURCHASE, PackOfProducts(OpCode.CUSTOMIZE_BUNDLE_PURCHASE, CustomizeProduct, CUSTOMIZE_DAILY_BUNDLE_PATH))
    self.packConfigDict:Add(OpCode.PURCHASE_BOOST_FIRST_PACK, BoostFirstPurchasePackOfProducts(OpCode.PURCHASE_BOOST_FIRST_PACK, BoostFirstPurchaseProduct, PURCHASE_BOOST_FIRST_PATH))
    self.packConfigDict:Add(OpCode.PURCHASE_FLASH_SALE_EVOLVE_PACK, PackOfProducts(OpCode.PURCHASE_FLASH_SALE_EVOLVE_PACK, FlashSaleEvolveProduct, FLASH_SALE_EVOLVE_PATH))
end

--- @return number
function CashShop:GetProgressPackConfigID()
    local val = zg.playerData:GetABTesting(FirebaseRemoteConfigKey.ProgressPack)
    if (val == nil) then
        val = -1
    end
    print(">>>> Client Used Progress Pack DataId ", val)
    return math.floor(val)
end

function CashShop:InitProgressPack(id)
    if id == nil or id < 0 or id > 3 then
        self.packConfigDict:Add(OpCode.PURCHASE_PROGRESS_PACK, ProgressGroupPackOfProducts(OpCode.PURCHASE_PROGRESS_PACK, ProgressProduct, PURCHASE_PROGRESS_PACK_PATH, PURCHASE_PROGRESS_GROUP_PATH))
    else
        local path = string.format(CsvPathConstants.PURCHASE_PROGRESS_PACK_AB_TEST_PATH, id)
        self.packConfigDict:Add(OpCode.PURCHASE_PROGRESS_PACK, ProgressGroupPackOfProducts(OpCode.PURCHASE_PROGRESS_PACK, ProgressProduct, path, PURCHASE_PROGRESS_GROUP_PATH))
    end
end

function CashShop:SetKey()
    --- @param purchasePack PackOfProducts
    for _, purchasePack in pairs(self.packConfigDict:GetItems()) do
        --- @param pack ProductConfig
        for _, pack in pairs(purchasePack:GetAllPackBase():GetItems()) do
            pack:SetKey()
        end
    end
end

--- @return ProductConfig
function CashShop:GetSubscription(packId)
    return self:GetPackById(OpCode.PURCHASE_SUBSCRIPTION_PACK, packId)
end

--- @return ComebackProducts
function CashShop:GetComebackProducts()
    return self.packConfigDict:Get(OpCode.COMEBACK_BUNDLE_PURCHASE)
end

--- @return PackOfProducts -- <CustomizeProduct>
function CashShop:GetCustomizeProducts()
    return self.packConfigDict:Get(OpCode.CUSTOMIZE_BUNDLE_PURCHASE)
end

--- @return PackOfProducts -- <CustomizeProduct>
function CashShop:GetProgressPack()
    return self.packConfigDict:Get(OpCode.PURCHASE_PROGRESS_PACK)
end

--- @return PackOfProducts -- <CustomizeProduct>
function CashShop:GetProgressPackWithId(id)
    return self:GetProgressPack().packDict:Get(id)
end

--- @return PackOfProducts -- <CustomizeProduct>
function CashShop:GetBoostFirstPurchasePack()
    return self.packConfigDict:Get(OpCode.PURCHASE_BOOST_FIRST_PACK)
end

--- @return PackOfProducts
function CashShop:GetFlashSaleEvolvePack()
    return self.packConfigDict:Get(OpCode.PURCHASE_FLASH_SALE_EVOLVE_PACK)
end

--- @return ProductConfig
--- @param packId number
function CashShop:GetFlashSaleEvolveProductConfig(packId)
    return self:GetFlashSaleEvolvePack():GetPackBase(packId)
end

--- @param rewardInBound RewardInBound
function CashShop:AddRewardToFlashSaleEvolvePack(packId, rewardInBound)
    ---@type FlashSaleEvolveProduct
    local flashSaleEvolveProduct = self:GetFlashSaleEvolveProductConfig(packId)
    flashSaleEvolveProduct:AddRewardToProduct(rewardInBound)
end

--- @param rewardInBound RewardInBound
function CashShop:RemoveRewardFromFlashSaleEvolvePack(packId, rewardInBound)
    ---@type FlashSaleEvolveProduct
    local flashSaleEvolveProduct = self:GetFlashSaleEvolveProductConfig(packId)
    flashSaleEvolveProduct:RemoveRewardFromProduct(rewardInBound)
end

--- @return boolean
function CashShop:IsNotificationDailyDeal()
    local noti = false
    --- @param v LimitedProduct
    for i, v in ipairs(self:GetPack(OpCode.PURCHASE_LIMITED_PACK).packList:GetItems()) do
        if v.isFree == true and zg.playerData:GetIAP():GetLimitedPackStatisticsInBound(v.id).numberOfBought < v.stock then
            noti = true
            break
        end
    end
    return noti
end

--- @return boolean
--- @param iapShopRegularTab IapShopRegularTab
function CashShop:IsNotificationFrequentlyDeal(iapShopRegularTab)
    local packViewType = 30 + iapShopRegularTab
    local noti = false
    --- @param v LimitedProduct
    for i, v in ipairs(self:GetPack(OpCode.PURCHASE_LIMITED_PACK).packList:GetItems()) do
        if v.viewType == packViewType and v.isFree == true and zg.playerData:GetIAP():GetLimitedPackStatisticsInBound(v.id).numberOfBought < v.stock then
            noti = true
            break
        end
    end
    return noti
end