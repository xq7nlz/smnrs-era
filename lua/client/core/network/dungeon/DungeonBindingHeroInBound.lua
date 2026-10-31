--- @class DungeonBindingHeroInBound
DungeonBindingHeroInBound = Class(DungeonBindingHeroInBound)

--- @return void
function DungeonBindingHeroInBound:Ctor()
    --- @type HeroResource
    self.heroResource = nil
    --- @type number
    self.hpPercent = nil
    --- @type number
    self.power = nil
    --- @type number
    self.index = nil
end

function DungeonBindingHeroInBound:AddBuff(hpPercent, power)
    self.hpPercent = math.min(1, self.hpPercent + hpPercent)
    self.power = math.min(HeroConstants.MAX_HERO_POWER, self.power + power)
end

function DungeonBindingHeroInBound:IsAlive()
    return self.hpPercent > 0
end

--- @return void
function DungeonBindingHeroInBound:ToString()
    return LogUtils.ToDetail(self)
end

--- @return DungeonBindingHeroInBound
--- @param json table
function DungeonBindingHeroInBound.CreateByJson(json)
    local data = DungeonBindingHeroInBound()
    data.heroResource = HeroResource.CreateInstanceByJson(json['0'])
    data.hpPercent = json['1']['0']
    data.power = json['1']['1']
    return data
end

--- @return DungeonBindingHeroInBound
--- @param heroBattleInfo HeroBattleInfo
function DungeonBindingHeroInBound.CreateByHeroBattleInfo(heroBattleInfo)
    local data = DungeonBindingHeroInBound()
    data.heroResource = HeroResource.CreateInstanceByHeroBattleInfo(heroBattleInfo)
    data.hpPercent = heroBattleInfo.startState:GetHpPercent()
    data.power = heroBattleInfo.startState:GetPowerValue()

    return data
end