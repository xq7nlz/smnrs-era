require "lua.client.core.iap.IAPReceipt"

--- @class IAPReceiptFactory
IAPReceiptFactory = {}

function IAPReceiptFactory.GetReceipt(content)
    --- @type IAPReceipt
    local receipt
    if IS_ANDROID_PLATFORM then
        require("lua.client.core.iap.AndroidIAPReceipt")
        receipt = AndroidIAPReceipt(content)
    elseif IS_IOS_PLATFORM then
        require("lua.client.core.iap.iOSIAPReceipt")
        receipt = iOSIAPReceipt(content)
    else
        require("lua.client.core.iap.EditorIAPReceipt")
        receipt = EditorIAPReceipt(content)
    end
    return receipt
end
