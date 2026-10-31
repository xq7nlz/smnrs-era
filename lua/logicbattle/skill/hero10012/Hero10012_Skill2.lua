--- @class Hero10012_Skill2 Assassiren
Hero10012_Skill2 = Class(Hero10012_Skill2, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10012_Skill2:CreateInstance(id, hero)
    return Hero10012_Skill2(id, hero)
end

--- @return void
function Hero10012_Skill2:Init()
    local statPerFactionBuffType = self.data.statPerFactionBuffType
    local statPerFactionBuffAmount = self.data.statPerFactionBuffAmount
    local factionBuff = self.data.factionBuff

    local attackerTeam, defenderTeam = self.myHero.battle:GetTeam()

    local numberMultiBuff = 0
    local allyTeam = TargetSelectorUtils.GetAllyTeam(attackerTeam, defenderTeam, self.myHero.teamId)
    local allies = allyTeam:GetHeroList()
    local i = 1
    while i <= allies:Count() do
        local ally = allies:Get(i)
        if ally.originInfo.faction == factionBuff then
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

return Hero10012_Skill2