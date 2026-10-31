--- @class Hero50009_Skill3 Aris
Hero50009_Skill3 = Class(Hero50009_Skill3, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50009_Skill3:CreateInstance(id, hero)
    return Hero50009_Skill3(id, hero)
end

--- @return void
function Hero50009_Skill3:Init()
    local attackerTeam, defenderTeam = self.myHero.battle:GetTeam()

    local numberLight = 0
    local allyTeam = TargetSelectorUtils.GetAllyTeam(attackerTeam, defenderTeam, self.myHero.teamId)
    local allyList = allyTeam:GetHeroList()
    local i = 1
    while i <= allyList:Count() do
        local ally = allyList:Get(i)
        if ally.originInfo.faction == HeroFactionType.LIGHT then
            numberLight = numberLight + 1
        end
        i = i + 1
    end

    local numberDark = 0
    local enemyTeam = TargetSelectorUtils.GetEnemyTeam(attackerTeam, defenderTeam, self.myHero.teamId)
    local enemyList = enemyTeam:GetHeroList()
    i = 1
    while i <= enemyList:Count() do
        local enemy = enemyList:Get(i)
        if enemy.originInfo.faction == HeroFactionType.DARK then
            numberDark = numberDark + 1
        end
        i = i + 1
    end

    local statChangeEffect = StatChangerEffect(self.myHero, self.myHero, true)
    if numberLight > 0 then
        local statChangerWithLight = StatChanger(true)
        statChangerWithLight:SetInfo(self.data.statPerLightBuffType, StatChangerCalculationType.PERCENT_ADD,
                self.data.statPerLightBuffAmount * numberLight)
        statChangeEffect:AddStatChanger(statChangerWithLight)
    end

    if numberDark > 0 then
        local statChangerWithDark = StatChanger(true)
        statChangerWithDark:SetInfo(self.data.statPerDarkBuffType, StatChangerCalculationType.PERCENT_ADD,
                self.data.statPerDarkBuffAmount * numberDark)
        statChangeEffect:AddStatChanger(statChangerWithDark)
    end

    if statChangeEffect.statChangerList:Count() > 0 then
        statChangeEffect:SetPersistentType(EffectPersistentType.PERMANENT)
        self.myHero.effectController:AddEffect(statChangeEffect)
    end
end

return Hero50009_Skill3