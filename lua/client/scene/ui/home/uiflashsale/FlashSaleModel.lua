--- @class FlashSaleModel
FlashSaleModel = Class(FlashSaleModel)

function FlashSaleModel:Ctor()
--[[    --- @type boolean
    self.hasData = nil
    --- @type EventTimeData
    self.timeData = nil
    --- @type number
    self.lastTimeRequest = nil]]
    UIBase.Ctor(self)
end

--[[
--- @class FlashSaleTab
FlashSaleTab = {
    WelcomePackage01 = 1,
    SummonerPackage02 = 2,
    ChosenPackage03 = 3,
    UpgradePackage04 = 4,
    StonePackage05 = 5,
    DestinyPackage06 = 6,
    ResourcePackage07 = 7
}]]
