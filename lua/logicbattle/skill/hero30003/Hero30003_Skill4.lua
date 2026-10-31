--- @class Hero30003_Skill4 Nero
Hero30003_Skill4 = Class(Hero30003_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30003_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.statPercent = nil

    --- @type ReviveSkillHelper
    self.reviveSkillHelper = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30003_Skill4:CreateInstance(id, hero)
    return Hero30003_Skill4(id, hero)
end

--- @return void
function Hero30003_Skill4:Init()
    self.statPercent = self.data.statPercent

    self.reviveSkillHelper = ReviveSkillHelper(self)
    self.reviveSkillHelper:SetReviveChance(self.data.reviveChance)

    local listener = EventListener(self.myHero, self, self.OnHeroDead)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_DEAD, listener)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param eventData table
function Hero30003_Skill4:OnHeroDead(eventData)
    local target = eventData.target

    if self.reviveSkillHelper:IsCanRevive(target) and self:IsReviveTargetBefore(target) == false then
        if self.reviveSkillHelper:UseReviveSkill(target) == true then
            target.hp:SetCanRevive(false)

            self:SetNewOriginStat(target, self.myHero.baseStat, self.myHero.levelStats)
            self:UpdateOriginStat(target)

            local neroClonePuppet = Hero30003_ClonePuppet(self.myHero, target)
            target.effectController:AddEffect(neroClonePuppet)
        end
    end
end

--- @return void
--- @param target BaseHero
function Hero30003_Skill4:IsReviveTargetBefore(target)
    if target.effectController:IsContainEffectType(EffectType.NERO_CLONE_PUPPET) == true then
        --print("Contain Nero clone")
        return true
    end
    return false
end

---------------------------------------- Update stats ----------------------------------------
--- @return void
--- @param target BaseHero
--- @param baseStat HeroData
--- @param levelStats HeroData
function Hero30003_Skill4:SetNewOriginStat(target, baseStat, levelStats)
    target.baseStat.id = target.id
    target.baseStat.name = target.name
    target.baseStat.star = target.star
    target.baseStat.class = target.originInfo.class
    target.baseStat.faction = target.originInfo.faction

    target.baseStat = TableUtils.Clone(baseStat)
    target.levelStats = TableUtils.Clone(levelStats)
end

--- @return void
--- @param target BaseHero
function Hero30003_Skill4:UpdateOriginStat(target)
    target.attack:UpdateStatByPercent(self.statPercent)
    target.defense:UpdateStatByPercent(self.statPercent)
    target.hp:UpdateStatByPercent(self.statPercent)

    for statType, heroStat in pairs(target.heroStats:GetItems()) do
        if statType ~= StatType.ATTACK and statType ~= StatType.DEFENSE and statType ~= StatType.HP then
            heroStat:UpdateStatByPercent(1)
        end

        heroStat:Calculate()
    end

    target.power:SetToMin()
end

return Hero30003_Skill4