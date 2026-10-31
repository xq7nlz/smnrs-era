--- @class CrewBattleHeroOutBound : OutBound
CrewBattleHeroOutBound = Class(CrewBattleHeroOutBound, OutBound)

function CrewBattleHeroOutBound:Ctor()
    --- @type number
    self.memberId = nil
    --- @type number
    self.inventoryHeroId = nil
    --- @type boolean
    self.isFrontLine = nil
    --- @type number
    self.position = nil
end

--- @param buffer UnifiedNetwork_ByteBuf
function CrewBattleHeroOutBound:Serialize(buffer)
    buffer:PutLong(self.memberId)
    buffer:PutLong(self.inventoryHeroId)
    buffer:PutBool(self.isFrontLine)
    buffer:PutInt(self.position)
end

--- @param heroData {heroResource:HeroResource, isFrontLine : boolean, position:number}
function CrewBattleHeroOutBound:SetHeroData(heroData)
    self.memberId = heroData.heroResource.memberId
    self.inventoryHeroId = heroData.heroResource.inventoryId
    self.isFrontLine = heroData.isFrontLine
    self.position = heroData.position
    --XDebug.Log(LogUtils.ToDetail(self))
end