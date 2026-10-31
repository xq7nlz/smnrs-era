--- @class Hero40008_Skill2 Lass
Hero40008_Skill2 = Class(Hero40008_Skill2, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40008_Skill2:CreateInstance(id, hero)
    return Hero40008_Skill2(id, hero)
end

--- @return void
function Hero40008_Skill2:Init()
    local statPerFactionBuffType = self.data.statPerFactionBuffType
    local statPerFactionBuffAmount = self.data.statPerFactionBuffAmount

    local attackerTeam, defenderTeam = self.myHero.battle:GetTeam()

    local numberMultiBuff = 0
    local enemyTeam = TargetSelectorUtils.GetEnemyTeam(attackerTeam, defenderTeam, self.myHero.teamId)
    local enemyList = enemyTeam:GetHeroList()
    local i = 1
    while i <= enemyList:Count() do
        local enemy = enemyList:Get(i)
        if enemy.originInfo.faction == HeroFactionType.DARK
                or enemy.originInfo.faction == HeroFactionType.FIRE
                or enemy.originInfo.faction == HeroFactionType.ABYSS then
            numberMultiBuff = numberMultiBuff + 1
        end
        i = i + 1
    end

    if numberMultiBuff > 0 then
        local statChangeEffect = StatChangerEffect(self.myHero, self.myHero, true)
        local statChanger = StatChanger(true)
        statChanger:SetInfo(statPerFactionBuffType, StatChangerCalculationType.PERCENT_ADD, statPerFactionBuffAmount * numberMultiBuff)
        statChangeEffect:AddStatChanger(statChanger)
        statChangeEffect:SetPersistentType(EffectPersistentType.PERMANENT)
        self.myHero.effectController:AddEffect(statChangeEffect)
    end
end

return Hero40008_Skill2