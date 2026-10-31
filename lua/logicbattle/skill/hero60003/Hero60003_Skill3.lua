--- @class Hero60003_Skill3 ShadowBlade
Hero60003_Skill3 = Class(Hero60003_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60003_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type boolean
    self.isAdd = false

    --- @type number
    self.numberBuff = 0

    --- @type StatChangerEffect
    self.effectBuffPassive = nil

    --- @type StatChanger
    self.statFirstBuff = nil

    --- @type StatChanger
    self.statSecondBuff = nil

    --- @type StatChanger
    self.statThirdBuff = nil

    --- @type number
    self.percentTrigger = 0

    --- @type number
    self.statFirstBuffType = 0

    --- @type number
    self.statFirstBuffAmount = 0

    --- @type number
    self.statSecondBuffType = 0

    --- @type number
    self.statSecondBuffAmount = 0

    --- @type number
    self.statThirdType = 0

    --- @type number
    self.statThirdAmount = 0
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60003_Skill3:CreateInstance(id, hero)
    return Hero60003_Skill3(id, hero)
end

--- @return void
function Hero60003_Skill3:Init()
    self.percentTrigger = self.data.percentTrigger
    self.statFirstBuffType = self.data.statFirstBuffType
    self.statFirstBuffAmount = self.data.statFirstBuffAmount

    self.statSecondBuffType = self.data.statSecondBuffType
    self.statSecondBuffAmount = self.data.statSecondBuffAmount

    self.statThirdType = self.data.statThirdType
    self.statThirdAmount = self.data.statThirdAmount

    self.effectBuffPassive = StatChangerEffect(self.myHero, self.myHero, true)
    self.effectBuffPassive:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL)

    self.statFirstBuff = StatChanger(true)
    self.statFirstBuff:SetInfo(self.statFirstBuffType, StatChangerCalculationType.PERCENT_ADD, self.statFirstBuffAmount)

    self.statSecondBuff = StatChanger(true)
    self.statSecondBuff:SetInfo(self.statSecondBuffType, StatChangerCalculationType.PERCENT_ADD, self.statSecondBuffAmount)

    self.statThirdBuff = StatChanger(true)
    self.statThirdBuff:SetInfo(self.statThirdType, StatChangerCalculationType.PERCENT_ADD, self.statThirdAmount)

    self.effectBuffPassive:AddStatChanger(self.statFirstBuff)
    self.effectBuffPassive:AddStatChanger(self.statSecondBuff)
    self.effectBuffPassive:AddStatChanger(self.statThirdBuff)

    self.myHero.hp:BindingWithSkill_3(self)
end

---------------------------------------- BATTLE -----------------------------------
--- @return number
--- @param initiator BaseHero
--- @param reason TakeDamageReason
--- @param changeNumber number
function Hero60003_Skill3:OnChangeHP(initiator, reason, changeNumber)
    if self.myHero:IsDead() == false then
        local multiBuff = math.floor((1 - self.myHero.hp:GetStatPercent()) / self.percentTrigger)
        self:BuffStat(multiBuff)
    else
        self.isAdd = false
    end
end

--- @return void
--- @param multiBuff number
function Hero60003_Skill3:BuffStat(multiBuff)
    if self.isAdd == true then
        -- fake add and remove effect
        if multiBuff == 0 then
            if self.numberBuff > 0 then
                local i = 1
                while i <= self.effectBuffPassive.statChangerList:Count() do
                    local statChanger = self.effectBuffPassive.statChangerList:Get(i)

                    local effectLogType = EffectConstants.STAT_CHANGER_EFFECT_START_ID + statChanger.statAffectedType

                    local result = EffectChangeResult(self.effectBuffPassive, effectLogType,
                            self.effectBuffPassive.persistentType, self.effectBuffPassive.isBuff, EffectChangeType.REMOVE)
                    ActionLogUtils.AddLog(self.myHero.battle, result)
                    i = i + 1
                end
            end
        else
            if self.numberBuff == 0 then
                local i = 1
                while i <= self.effectBuffPassive.statChangerList:Count() do
                    local statChanger = self.effectBuffPassive.statChangerList:Get(i)

                    local effectLogType = EffectConstants.STAT_CHANGER_EFFECT_START_ID + statChanger.statAffectedType

                    local result = EffectChangeResult(self.effectBuffPassive, effectLogType,
                            self.effectBuffPassive.persistentType, self.effectBuffPassive.isBuff, EffectChangeType.ADD)
                    ActionLogUtils.AddLog(self.myHero.battle, result)
                    i = i + 1
                end
            end
        end
    end

    if multiBuff ~= self.numberBuff then
        self.numberBuff = multiBuff
        self.statFirstBuff:SetInfo(self.statFirstBuffType, StatChangerCalculationType.PERCENT_ADD,
                self.statFirstBuffAmount * multiBuff)
        self.statSecondBuff:SetInfo(self.statSecondBuffType, StatChangerCalculationType.PERCENT_ADD,
                self.statSecondBuffAmount * multiBuff)
        self.statThirdBuff:SetInfo(self.statThirdType, StatChangerCalculationType.PERCENT_ADD,
                self.statThirdAmount * multiBuff)
        if self.isAdd == false then
            self.myHero.effectController:AddEffect(self.effectBuffPassive)
            self.isAdd = true
        else
            self.effectBuffPassive:Recalculate()
        end
    end
end

return Hero60003_Skill3