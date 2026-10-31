--- @class Hero30021_Skill4 EarthMaster
Hero30021_Skill4 = Class(Hero30021_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30021_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type StatType
    self.statDebuffType = 0

    --- @type number
    self.statDebuffAmount = 0
    --- @type number
    self.statDebuffCalculation = 0
    --- @type number
    self.statDebuffDuration = 0
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30021_Skill4:CreateInstance(id, hero)
    return Hero30021_Skill4(id, hero)
end

--- @return void
function Hero30021_Skill4:Init()
    self.statDebuffType = self.data.statDebuffType
    self.statDebuffAmount = self.data.statDebuffAmount
    self.statDebuffCalculation = self.data.statDebuffCalculation
    self.statDebuffDuration = self.data.statDebuffDuration

    self.myHero.attackListener:BindingWithSkill_4(self)
end

---------------------------------------- BATTLE -----------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero30021_Skill4:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS then
        local statChangerEffect = StatChangerEffect(self.myHero, enemyDefender, false)
        statChangerEffect:SetDuration(self.statDebuffDuration)

        local statChanger = StatChanger(false)
        statChanger:SetInfo(self.statDebuffType, self.statDebuffCalculation, self.statDebuffAmount)

        statChangerEffect:AddStatChanger(statChanger)
        enemyDefender.effectController:AddEffect(statChangerEffect)
    end
end

return Hero30021_Skill4