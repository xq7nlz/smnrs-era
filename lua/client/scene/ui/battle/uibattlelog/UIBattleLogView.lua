require "lua.client.scene.ui.common.BattleLogItemView"

--- @class UIBattleLogView : UIBaseView
UIBattleLogView = Class(UIBattleLogView, UIBaseView)

--- @param model UIBattleLogModel
function UIBattleLogView:Ctor(model)
    --- @type BattleLogConfig
    self.config = nil
    --- @type List
    self.attacker = List()
    --- @type List
    self.defender = List()
    UIBaseView.Ctor(self, model)
    --- @type UIBattleLogModel
    self.model = self.model
end

function UIBattleLogView:OnReadyCreate()
    --- @type BattleLogConfig
    self.config = UIBaseConfig(self.uiTransform)
    self:InitButtonListener()
end

function UIBattleLogView:InitLocalization()
    self.config.textAttacker.text = LanguageUtils.LocalizeCommon("attacker")
    self.config.textDefender.text = LanguageUtils.LocalizeCommon("defender")
end

function UIBattleLogView:InitButtonListener()
    self.config.bgClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

--- @param result { battleResult : BattleResult, clientLogDetail : ClientLogDetail}
function UIBattleLogView:OnReadyShow(result)
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    self:Init(result)
end

--- @return void
--- @param result { battleResult : BattleResult, clientLogDetail : ClientLogDetail}
function UIBattleLogView:Init(result)
    self.model.result = result.battleResult
    self.model.clientLogDetail = result.clientLogDetail

    self.model.maxDmg = 0
    self.model.maxHp = 0

    local attackerHeroes = self.model.clientLogDetail.attackerTeam.baseHeroList:GetItems()
    local defenderHeroes = self.model.clientLogDetail.defenderTeam.baseHeroList:GetItems()
    ---@param hero BaseHero
    for _, hero in ipairs(attackerHeroes) do
        self:UpdateMaxDmgAndHp(hero)
    end

    ---@param hero BaseHero
    for _, hero in ipairs(defenderHeroes) do
        self:UpdateMaxDmgAndHp(hero)
    end

    ---@param hero BaseHero
    for _, hero in ipairs(attackerHeroes) do
        self:SetBattleLogItemView(hero, self.attacker, self.config.elementL)
    end

    ---@param hero BaseHero
    for _, hero in ipairs(defenderHeroes) do
        self:SetBattleLogItemView(hero, self.defender, self.config.elementR)
    end
end

--- @return void
---@param hero BaseHero
function UIBattleLogView:UpdateMaxDmgAndHp(hero)
    ---@type HeroStatistics
    local heroStatistics = self.model.result.heroStatisticsDict[tostring(hero:GetHeroUnique())]
    if self.model.maxDmg < heroStatistics.damageDeal then
        self.model.maxDmg = heroStatistics.damageDeal
    end
    if self.model.maxHp < heroStatistics.hpHeal then
        self.model.maxHp = heroStatistics.hpHeal
    end
end

---@param hero BaseHero
---@param list List
---@param transform UnityEngine_Transform
function UIBattleLogView:SetBattleLogItemView(hero, list, transform)
    if hero.isDummy == false then
        ---@type HeroStatistics
        local heroStatistics = self.model.result.heroStatisticsDict[tostring(hero:GetHeroUnique())]
        ---@type BattleLogItemView
        local battleLogItemView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.BattleLogItemView, transform)
        if hero.isSummoner then
            battleLogItemView.config.transform:SetAsFirstSibling()
        end
        battleLogItemView:SetData(hero, heroStatistics.damageDeal, heroStatistics.damageDeal / self.model.maxDmg,
                heroStatistics.hpHeal, heroStatistics.hpHeal / self.model.maxHp)
        list:Add(battleLogItemView)
    end
end

--- @return void
function UIBattleLogView:Hide()
    UIBaseView.Hide(self)
    ---@param v BattleLogItemView
    for _, v in pairs(self.attacker:GetItems()) do
        v:ReturnPool()
    end
    self.attacker:Clear()
    ---@param v BattleLogItemView
    for _, v in pairs(self.defender:GetItems()) do
        v:ReturnPool()
    end
    self.defender:Clear()
end