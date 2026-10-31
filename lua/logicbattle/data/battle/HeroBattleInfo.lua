--- @class HeroBattleInfo
HeroBattleInfo = Class(HeroBattleInfo)

--- @return void
function HeroBattleInfo:Ctor()
    --- @type number
    self.heroId = nil
    --- @type number
    self.teamId = nil

    --- @type boolean
    self.isFrontLine = nil
    --- @type number
    self.position = nil

    --- @type number
    self.level = nil
    --- @type number
    self.star = nil

    --- @type HeroState
    self.startState = HeroState()

    --- @type boolean
    self.isBoss = false
    --- @type BossStatPredefine
    self.bossStat = nil

    --- @type Dictionary Dictionary<number, List<number>> key = class
    self.masteries = Dictionary()

    --- @type Dictionary Dictionary<number, number> key: HeroItemSlot, value: itemId
    self.items = Dictionary()

    --- @type boolean
    self.isInitialize = true
end

---------------------------------------- Setters ----------------------------------------
---@return void
---@param teamId number
---@param heroId number
---@param star number
---@param level number
function HeroBattleInfo:SetInfo(teamId, heroId, star, level)
    self.heroId = heroId
    self.teamId = teamId
    self.star = star
    self.level = level
    self:ValidateAfterSet()
end

---@return void
---@param isFrontLine boolean
---@param positionId number
function HeroBattleInfo:SetPosition(isFrontLine, positionId)
    self.isFrontLine = isFrontLine
    self.position = positionId
end

---@return void
---@param isBoss boolean
---@param bossStatPredefine BossStatPredefine
function HeroBattleInfo:SetBoss(isBoss, bossStatPredefine)
    self.isBoss = isBoss
    self.bossStat = bossStatPredefine
end

---@return void
---@param teamMasteries Dictionary
function HeroBattleInfo:SetMasteries(teamMasteries)
    self.masteries = teamMasteries
end

---@return void
---@param hpPercent number
---@param powerValue number
function HeroBattleInfo:SetState(hpPercent, powerValue)
    self.startState:SetState(hpPercent, powerValue)

    if hpPercent <= 0 then
        self.isInitialize = false
    end
end

---@return void
---@param item Dictionary
function HeroBattleInfo:SetItemsDict(item, isHideSkin)
    for i, v in pairs(item:GetItems()) do
        self.items:Add(i, v)
    end
    self.isHideSkin = isHideSkin
end

--- @return void
function HeroBattleInfo:ValidateAfterSet()
    if MathUtils.IsNumber(self.heroId) == false or self.heroId < 0 then
        assert(false)
    end

    if MathUtils.IsNumber(self.teamId) == false or self.teamId < 0 then
        assert(false)
    end

    if MathUtils.IsNumber(self.star) == false or self.star < 0 then
        assert(false)
    end

    if MathUtils.IsNumber(self.level) == false and self.level < 0 then
        assert(false)
    end
end

------------------------------------------CSV----------------------------------------------------
--- @return void
--- @param masteryDataList Dictionary<number, List<number>>
function HeroBattleInfo:SetMasteryDataList(masteryDataList)
    self.myHero.masteryDataList = masteryDataList
end

--- @return void
function HeroBattleInfo:ValidateBeforeParseCsv(data)
    if data.hero_id == nil then
        assert(false)
    end

    if data.team_id == nil then
        assert(false)
    end

    if data.is_front == nil then
        assert(false)
    end

    if data.position == nil then
        assert(false)
    end

    if data.star == nil then
        assert(false)
    end

    if data.level == nil then
        assert(false)
    end
end

-------------------------------------IN BATTLE-----------------------------------------
--- @return BaseHero
function HeroBattleInfo:CreateHero()
    if self.startState:GetHpPercent() ~= 0 then
        local heroLuaFile = require(string.format(LuaPathConstants.HERO_PATH, self.heroId, self.heroId))
        --- @type BaseHero
        local hero = heroLuaFile:CreateInstance()
        self:FillData(hero)
        hero.masteryDataList = self.masteries
        hero.startState = self.startState

        return hero
    else
        return nil
    end
end

--- @return void
--- @param baseHero BaseHero
function HeroBattleInfo:FillData(baseHero)
    baseHero.id = self.heroId
    baseHero.teamId = self.teamId

    baseHero.star = self.star
    baseHero.level = self.level

    baseHero.isBoss = self.isBoss
    baseHero.isSummoner = false
    baseHero.isDummy = false

    baseHero.bossStat = self.bossStat
    baseHero.positionInfo:SetPosition(self.isFrontLine, self.position)

    for slot, item in pairs(self.items:GetItems()) do
        baseHero.equipmentController:AddItem(slot, item)
    end
    baseHero.equipmentController.isHideSkin = self.isHideSkin
end
