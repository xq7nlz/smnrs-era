--- @class Hero30011_Skill4 Skaven
Hero30011_Skill4 = Class(Hero30011_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30011_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.targetSelector = nil

    --- @type number
    self.effectAmount = nil
    --- @type EffectType
    self.effectType = nil
    --- @type number
    self.effectDuration = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30011_Skill4:CreateInstance(id, hero)
    return Hero30011_Skill4(id, hero)
end

--- @return void
function Hero30011_Skill4:Init()
    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition, TargetTeamType.ENEMY, self.data.targetNumber)

    self.effectAmount = self.data.effectAmount
    self.effectType = self.data.effectType
    self.effectDuration = self.data.effectDuration

    local listener = EventListener(self.myHero, self, self.OnHeroDead)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_DEAD, listener)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param eventData table
function Hero30011_Skill4:OnHeroDead(eventData)
    if self.myHero:IsDead() == false then
        if self.myHero:IsAlly(eventData.target) == false then
            local targetList = self.targetSelector:SelectTarget(self.myHero.battle)

            local i = 1
            while i <= targetList:Count() do
                local target = targetList:Get(i)

                if Hero30011_Utils.IsContainSkavenPoison(target, 4) == false and target:IsBoss() == false then
                    local amount = target.hp:GetMax() * self.effectAmount

                    local dotEffect = Hero30011_PoisonEffect(self.myHero, target, 4)
                    dotEffect:SetDuration(self.effectDuration)
                    dotEffect:SetDotAmount(amount)

                    target.effectController:AddEffect(dotEffect)
                end
                i = i + 1
            end
        end
    end
end

return Hero30011_Skill4