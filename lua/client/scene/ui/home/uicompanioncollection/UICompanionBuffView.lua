---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiCompanionCollection.UICompanionBuffConfig"

--- @class UICompanionBuffView
UICompanionBuffView = Class(UICompanionBuffView)

--- @return void
--- @param transform UnityEngine_Transform
function UICompanionBuffView:Ctor(transform)
    ---@type UICompanionBuffConfig
    self.config = UIBaseConfig(transform)
    ---@type List --<FactionCompanionView>
    self.listFactions = List()
    ---@type List --<StatCompanionView>
    self.listStats = List()
end

--- @return void
--- @param companionBuff HeroCompanionBuffData
function UICompanionBuffView:SetData(companionBuff, isChose)
    self:ReturnPool()
    if companionBuff ~= nil then
        self.config.gameObject:SetActive(true)
        self.config.textCompanionBuffName.text = LanguageUtils.LocalizeNameCompanion(companionBuff.id)
        local color
        if isChose == true then
            color = UIUtils.color2
            self.config.iconCompanionBuff.sprite = ResourceLoadUtils.LoadCompanionBuffOnIcon(companionBuff.id)
        else
            color = UIUtils.brown
            self.config.iconCompanionBuff.sprite = ResourceLoadUtils.LoadCompanionBuffOffIcon(companionBuff.id)
        end

        ---@param v StatBonus
        for _, v in ipairs(companionBuff.bonuses:GetItems()) do
            ---@type StatCompanionView
            local stat = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.StatCompanionView, self.config.stats)
            stat:SetData(v, color)
            self.listStats:Add(stat)
        end
    else
        self.config.gameObject:SetActive(false)
    end
end

--- @return void
function UICompanionBuffView:ReturnPool()
    ---@param v StatCompanionView
    for _, v in pairs(self.listStats:GetItems()) do
        v:ReturnPool()
    end
    self.listStats:Clear()
end