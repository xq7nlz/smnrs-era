--- @class Hero20001_Skill4 Icarus
Hero20001_Skill4 = Class(Hero20001_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20001_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.time_reborn = nil
    --- @type number
    self.round_reborn = nil

    --- @type RebornSkillHelper
    self.rebornSkillHelper = nil

    --- @type boolean
    self.isReborn = false
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20001_Skill4:CreateInstance(id, hero)
    return Hero20001_Skill4(id, hero)
end

--- @return void
function Hero20001_Skill4:Init()
    -- reborn
    self.rebornSkillHelper = RegenerateSkillHelper(self)
    self.rebornSkillHelper:SetActionPerTarget(self.ChangeState)

    local listener = EventListener(self.myHero, self, self.OnDead)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_DEAD, listener)
end

--- @return void
--- @param eventData table
function Hero20001_Skill4:OnDead(eventData)
    local reason = eventData.reason

    if eventData.target == self.myHero then
        if self.isReborn == false then
            self.rebornSkillHelper:UseRebornSkill(reason)
            self.isReborn = true
        end
    end
end

function Hero20001_Skill4:ChangeState(target)
    self.myHero.isSpecialState = true
end

return Hero20001_Skill4