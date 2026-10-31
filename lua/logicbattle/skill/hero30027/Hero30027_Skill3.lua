--- @class Hero30027_Skill3 : BaseSkill
Hero30027_Skill3 = Class(Hero30027_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30027_Skill3:Ctor(id, hero)
    --- @type Hero30027_Skill3_Data
    self.data = nil
    BaseSkill.Ctor(self, id, hero)

    ---@type StatChanger
    self.statChanger = nil

    ---@type StatChangerEffect
    self.effect = nil

end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30027_Skill3:CreateInstance(id, hero)
    return Hero30027_Skill3(id, hero)
end

--- @return void
function Hero30027_Skill3:Init()
    self.myHero.attack:BindingWithSkill_3(self)
    self.myHero.battleListener:BindingWithSkill_3(self)
    self.statDebuffType = self.data.statDebuffType
    self.statDebuffCalculationType = self.data.statDebuffCalculationType
    self.statDebuffAmount = self.data.statDebuffAmount
    local listener = EventListener(self.myHero, self, self.OnHeroDead)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_DEAD, listener)
    self:CalculateReduceDamageStat()
end

--- @return number
function Hero30027_Skill3:GetAllyAliveCount()
    --- @type BattleTeam
    local myTeam = self.myHero.battle:GetTeamById(self.myHero.teamId)
    return myTeam:GetAllyAliveCount(self.myHero)
end

--- @return number
--- @param originAttack number
function Hero30027_Skill3:CalculateBonusAttack(originAttack)
    local numberAlliesAlive = self:GetAllyAliveCount()
    local percentBonus = numberAlliesAlive * self.data.attackPerAlly
    return originAttack * percentBonus
end

--- @return void
--- @param target BaseHero
function Hero30027_Skill3:InitDamageReductionEffect()
    self.statChanger = StatChanger(true)
    self.statChanger:SetInfo(self.statDebuffType, self.statDebuffCalculationType, self.statDebuffAmount)
    self.effect = StatChangerEffect(self.myHero, self.myHero, true)
    self.effect:SetPersistentType(EffectPersistentType.NON_PERSISTENT_NOT_DISPELLABLE)
    self.effect:SetDuration(EffectConstants.INFINITY_DURATION)
    self.effect:AddStatChanger(self.statChanger)
    self.myHero.effectController:AddEffect(self.effect)
end

--- @return void
--- @param eventData table
function Hero30027_Skill3:OnHeroDead(eventData)
    if eventData.target.teamId == self.myHero.teamId then
        self:CalculateReduceDamageStat()
    end
end


--- @return void
function Hero30027_Skill3:CalculateReduceDamageStat()
    if (self.effect == nil) then
        self:InitDamageReductionEffect()
    end
    local numberAlliesAlive = self:GetAllyAliveCount()
    self.statChanger:SetInfo(self.statDebuffType, self.statDebuffCalculationType, numberAlliesAlive * self.statDebuffAmount)
    self.effect:Recalculate()
end

return Hero30027_Skill3