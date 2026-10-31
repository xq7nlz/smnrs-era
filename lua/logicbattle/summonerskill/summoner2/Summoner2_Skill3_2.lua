--- @class Summoner2_Skill3_2 : BaseSkill Warrior
Summoner2_Skill3_2 = Class(Summoner2_Skill3_2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner2_Skill3_2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    ---@type BaseTargetSelector
    self.buffTargetSelector = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner2_Skill3_2:CreateInstance(id, hero)
    return Summoner2_Skill3_2(id, hero)
end

--- @return void
function Summoner2_Skill3_2:Init()
    self.buffChance = self.data.buffChance
    self.blockChance = self.data.blockChance
    self.blockDuration = self.data.blockDuration
    self.blockAmount = self.data.blockAmount

    self.buffTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.buffTargetPosition,
            TargetTeamType.ALLY, self.data.buffTargetNumber)

    local listener = EventListener(self.myHero, self, self.OnHeroTakeDamage)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_TAKE_DAMAGE, listener)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param eventData table
function Summoner2_Skill3_2:OnHeroTakeDamage(eventData)
    local reason = eventData.reason
    local defender = eventData.target

    if self.myHero:IsAlly(defender) then
        if reason == TakeDamageReason.ATTACK_DAMAGE or reason == TakeDamageReason.SKILL_DAMAGE then
            if self.myHero.randomHelper:RandomRate(self.buffChance) then
                local targetList = self.buffTargetSelector:SelectTarget(self.myHero.battle)
                local i = 1
                while i <= targetList:Count() do
                    local target = targetList:Get(i)

                    local magicShieldList = target.effectController:GetEffectWithType(EffectType.MAGIC_SHIELD)
                    --- @type BaseEffect
                    local magicShield
                    local hasShield = false
                    for j = 1, magicShieldList:Count() do
                        magicShield = magicShieldList:Get(j)
                        if magicShield.initiator == self.myHero then
                            hasShield = true
                            break
                        end
                    end

                    if hasShield == false then
                        magicShield = MagicShield(self.myHero, target, self.blockChance, self.blockAmount)
                        magicShield:SetDuration(self.blockDuration)
                        target.effectController:AddEffect(magicShield)
                    else
                        magicShield:SetDuration(self.blockDuration)
                    end
                    i = i + 1
                end
            end
        end
    end
end

return Summoner2_Skill3_2