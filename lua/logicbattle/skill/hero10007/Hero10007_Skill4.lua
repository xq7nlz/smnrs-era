--- @class Hero10007_Skill4 Osse
Hero10007_Skill4 = Class(Hero10007_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10007_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BondSkillHelper
    self.bondSkillHelper = nil

    --- @type BaseTargetSelector
    self.targetSelector = nil

    --- @type number
    self.bondDamagePercent = nil

    --- @type number
    self.bondCcChance = nil

    --- @type number
    self.hpLower = nil

    --- @type boolean
    self.isTrigger = false

    --- @type List<BaseHero>
    self.enemyList = List()
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10007_Skill4:CreateInstance(id, hero)
    return Hero10007_Skill4(id, hero)
end

--- @return void
function Hero10007_Skill4:Init()
    self.hpLower = self.data.hpLower

    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)

    self.bondDamagePercent = self.data.bondDamagePercent
    self.bondCcChance = self.data.bondCcChance

    self.bondSkillHelper = Hero10007_BondSkillHelper(self)
    self.bondSkillHelper:SetInfo(false, self.data.bondDuration)

    local skill = self.myHero.skillController.passiveSkills:Get(3)
    self.bondSkillHelper:BindingWithSkill_3(skill)

    local listener = EventListener(self.myHero, self, self.OnHpChange)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_TAKE_DAMAGE, listener)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param eventData BaseHero
function Hero10007_Skill4:OnHpChange(eventData)
    if self.myHero:IsDead() == false then
        if eventData.target == self.myHero and self.isTrigger == false and self.myHero.hp:GetStatPercent() <= self.hpLower then
            local targetList = self.targetSelector:SelectTarget(self.myHero.battle)
            if targetList:Count() > 1 then
                self.isTrigger = true
                local bond = Hero10007_Skill2_Bond(self.myHero)
                bond:SetInfo(self.bondDamagePercent, self.bondCcChance)
                self.bondSkillHelper:UseBondSkill(targetList, bond)
            end
        end
    end
end

return Hero10007_Skill4