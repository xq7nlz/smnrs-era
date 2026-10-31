--- @class Hero40011_Skill3 Neutar
Hero40011_Skill3 = Class(Hero40011_Skill3, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
function Hero40011_Skill3:CreateInstance(id, hero)
    return Hero40011_Skill3(id, hero)
end

--- @return void
function Hero40011_Skill3:Init()
    self.statChangerEffect = StatChangerEffect(self.myHero, self.myHero, true)
    self.statChangerEffect:SetPersistentType(EffectPersistentType.PERMANENT)
    self.statChangerEffect:SetDuration(EffectConstants.INFINITY_DURATION)

    if self.myHero.positionInfo.isFrontLine then
        local statChanger = StatChanger(true)
        statChanger:SetInfo(self.data.frontStatType, StatChangerCalculationType.PERCENT_ADD, self.data.frontStatAmount)
        self.statChangerEffect:AddStatChanger(statChanger)
    else
        local statChanger_1 = StatChanger(true)
        statChanger_1:SetInfo(self.data.backStatType_1, StatChangerCalculationType.PERCENT_ADD, self.data.backStatAmount_1)

        local statChanger_2 = StatChanger(true)
        statChanger_2:SetInfo(self.data.backStatType_2, StatChangerCalculationType.PERCENT_ADD, self.data.backStatAmount_2)

        local statChanger_3 = StatChanger(true)
        statChanger_3:SetInfo(self.data.backStatType_3, StatChangerCalculationType.PERCENT_ADD, self.data.backStatAmount_3)

        self.statChangerEffect:AddStatChanger(statChanger_1)
        self.statChangerEffect:AddStatChanger(statChanger_2)
        self.statChangerEffect:AddStatChanger(statChanger_3)
    end
    self.myHero.effectController:AddEffect(self.statChangerEffect)
end

return Hero40011_Skill3