--- @class HeroCsvParser
HeroCsvParser = Class(HeroCsvParser)

--- @return void
--- @param hero BaseHero
function HeroCsvParser:Ctor(hero)
    --- @type BaseHero
    self.myHero = hero
end

---------------------------------------- Setters ----------------------------------------
--- @return void
--- @param data string Csv line to parse
function HeroCsvParser:ParseCsv(data)
    self:ValidateBeforeParseCsv(data)

    self.myHero.id = tonumber(data.hero_id)
    self.myHero.teamId = tonumber(data.team_id)

    local isFrontLine = MathUtils.ToBoolean(data.is_front)
    assert(MathUtils.IsBoolean(isFrontLine))
    local position = tonumber(data.position)
    assert(MathUtils.IsInteger(position) and position > 0)

    self.myHero.positionInfo:SetPosition(isFrontLine, position)

    self.myHero.star = tonumber(data.star)
    self.myHero.level = tonumber(data.level)

    if data.boss_id ~= nil then
        local bossId = tonumber(data.boss_id)
        if MathUtils.IsInteger(bossId) and bossId > 0 then
            self.myHero.isBoss = true
            self.myHero.bossId = bossId
        else
            self.myHero.isBoss = false
        end
    end

    self.myHero.equipmentController:ParseCsv(data)
    self.myHero.isSummoner = false

    self:ValidateAfterParseCsv()
end

--- @return void
--- @param masteryDataList Dictionary<number, List<number>>
function HeroCsvParser:SetMasteryDataList(masteryDataList)
    self.myHero.masteryDataList = masteryDataList
end

function HeroCsvParser:ValidateBeforeParseCsv(data)
    assert(data.hero_id ~= nil)
    assert(data.team_id ~= nil)
    assert(data.is_front ~= nil)
    assert(data.position ~= nil)

    assert(data.star ~= nil)
    assert(data.level ~= nil)
end

function HeroCsvParser:ValidateAfterParseCsv()
    assert(MathUtils.IsInteger(self.myHero.id) and self.myHero.id >= 0)
    assert(self.myHero.teamId == BattleConstants.ATTACKER_TEAM_ID or self.myHero.teamId == BattleConstants.DEFENDER_TEAM_ID)

    assert(MathUtils.IsInteger(self.myHero.star) and self.myHero.star > 0)
    assert(MathUtils.IsInteger(self.myHero.level) and self.myHero.level > 0)
end