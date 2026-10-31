--- @class Hero50003_Skill4 LifeKeeper
Hero50003_Skill4 = Class(Hero50003_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50003_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.reviveChance = nil

    --- @type number
    self.reviveHpPercent = nil

    --- @type List<BaseHero>
    self.reviveList = List()

    --- @type ReviveSkillHelper
    self.reviveSkillHelper = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50003_Skill4:CreateInstance(id, hero)
    return Hero50003_Skill4(id, hero)
end

--- @return void
function Hero50003_Skill4:Init()
    self.reviveHpPercent = self.data.reviveHpPercent

    self.reviveSkillHelper = ReviveSkillHelper(self)
    self.reviveSkillHelper:SetReviveChance(self.data.reviveChance)

    local listener = EventListener(self.myHero, self, self.OnHeroDead)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_DEAD, listener)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param eventData table
function Hero50003_Skill4:OnHeroDead(eventData)
    local target = eventData.target

    if self.reviveSkillHelper:IsCanRevive(target) and self:IsReviveTargetBefore(target) == false then
        self.reviveList:Add(target)

        local isSuccess, result = self.reviveSkillHelper:UseReviveSkill(target)
        if isSuccess == true then
            target.hp:SetStatPercent(self.reviveHpPercent)
            result:RefreshHeroStatus()
        end
    end
end

--- @return boolean
--- @param target BaseHero
function Hero50003_Skill4:IsReviveTargetBefore(target)
    if self.reviveList:IsContainValue(target) then
        return true
    end

    return false
end

return Hero50003_Skill4