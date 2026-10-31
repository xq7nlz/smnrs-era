--- @class BuyUtils
BuyUtils = {}

---@type Subscription
local onPurchaseListener

--- @return void
function BuyUtils.InitListener(onComplete, onFail)
    if onPurchaseListener ~= nil then
        onPurchaseListener:Unsubscribe()
    end
    onPurchaseListener = RxMgr.buyCompleted:Subscribe(function(isSuccess)
        if isSuccess == true then
            onComplete()
        else
            if onFail then
                onFail()
            end
        end
        onPurchaseListener:Unsubscribe()
        onPurchaseListener = nil
    end)
end