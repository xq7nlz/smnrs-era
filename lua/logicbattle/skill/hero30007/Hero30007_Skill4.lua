--- @class Hero30007_Skill4 Zygor
Hero30007_Skill4 = Class(Hero30007_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30007_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type SubActiveSkillHelper
    self.subActiveSkillHelper = nil

    --- @type BaseTargetSelector
    self.targetSelector = nil

    --- @type number
    self.reviveHpPercent = 0

    --- @type boolean
    self.isTrigger = false
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30007_Skill4:CreateInstance(id, hero)
    return Hero30007_Skill4(id, hero)
end

--- @return void
function Hero30007_Skill4:Init()
    self.reviveHpPercent = self.data.reviveHpPercent

    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition, TargetTeamType.ENEMY, self.data.targetNumber)

    self.subActiveSkillHelper = SubActiveSkillHelper(self)
    self.subActiveSkillHelper:SetInfo(self.data.damage)

    local listener = EventListener(self.myHero, self, self.OnHeroDead)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_DEAD, listener)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param eventData table
function Hero30007_Skill4:OnHeroDead(eventData)
    if eventData.target == self.myHero then
        if self.isTrigger == false then
            self.isTrigger = true
            local targetList = self.targetSelector:SelectTarget(self.myHero.battle)
            self.subActiveSkillHelper:UseSubActiveSkill(targetList)

            self:Revive()
        end
    end
end

--- @return void
function Hero30007_Skill4:Revive()
    if self.myHero.hp:Revive(self.myHero) == true then
        self.myHero.hp:SetStatPercent(self.reviveHpPercent)

        local result = ReviveActionResult(self.myHero, self.myHero)
        ActionLogUtils.AddLog(self.myHero.battle, result)
    end
end

return Hero30007_Skill4