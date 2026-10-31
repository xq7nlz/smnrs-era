--- @class Hero50004_Skill4 Grimm
Hero50004_Skill4 = Class(Hero50004_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50004_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.roundStep = nil

    --- @type number
    self.effectDuration = nil

    --- @type number
    self.battleRound = nil

    --- @type number
    self.statBuffType = nil

    --- @type number
    self.statBuffAmount = nil

    --- @type EffectType
    self.effectType = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50004_Skill4:CreateInstance(id, hero)
    return Hero50004_Skill4(id, hero)
end

--- @return void
function Hero50004_Skill4:Init()
    self.roundStep = self.data.roundStep
    self.effectDuration = self.data.effectDuration
    self.effectType = self.data.effectType

    self.myHero.battleListener:BindingWithSkill_4(self)
    self.myHero:BindingWithSkill_4(self)

    self.statBuffType = self.data.statBuffType
    self.statBuffAmount = self.data.statBuffAmount
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param round BattleRound
function Hero50004_Skill4:OnStartBattleRound(round)
    self.battleRound = round

    self:CastBless()
end

--- @return void
function Hero50004_Skill4:CastBless()
    if self.myHero:IsDead() or self.myHero.effectController:IsContainCCEffect() then
        return
    end

    if math.fmod(self.battleRound, self.roundStep) == 0 then
        local attackerTeam, defenderTeam = self.myHero.battle:GetTeam()
        local targetTeam = TargetSelectorUtils.GetAllyTeam(attackerTeam, defenderTeam, self.myHero.teamId)
        local targetList = targetTeam:GetHeroList()

        local i = 1
        while i <= targetList:Count() do
            local target = targetList:Get(i)
            EffectUtils.CreateBlessEffect(self.myHero, target, self.effectType, self.effectDuration)
            i = i + 1
        end

        local statBuff = StatChanger(true)
        statBuff:SetInfo(self.data.statBuffType, StatChangerCalculationType.RAW_ADD_BASE, self.data.statBuffAmount)

        local effectBuffPassive = StatChangerEffect(self.myHero, self.myHero, true)
        effectBuffPassive:SetDuration(self.effectDuration)
        effectBuffPassive:SetPersistentType(EffectPersistentType.NON_PERSISTENT_NOT_DISPELLABLE)
        effectBuffPassive:AddStatChanger(statBuff)
        self.myHero.effectController:AddEffect(effectBuffPassive)
    end
end

return Hero50004_Skill4