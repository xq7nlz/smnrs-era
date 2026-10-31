---COMMENT_CONFIG_COMMON    require "lua.client.scene.ui.common.prefabHeroInfo.StatInformationConfig"

--- @class StatInformationView : IconView
StatInformationView = Class(StatInformationView, IconView)

--- @return void
function StatInformationView:Ctor()
    IconView.Ctor(self)
end
--- @return void
function StatInformationView:SetPrefabName()
    self.prefabName = 'stats_information'
    self.uiPoolType = UIPoolType.StatInformationView
end

--- @return void
--- @param transform UnityEngine_Transform
function StatInformationView:SetConfig(transform)
    assert(transform)
    --- @type StatInformationConfig
    ---@type StatInformationConfig
    self.config = UIBaseConfig(transform)
    --- @type UnityEngine_EventSystems_EventTrigger
    local trigger = transform:GetComponent(ComponentName.UnityEngine_EventSystems_EventTrigger)
    --- @type UnityEngine_EventSystems_EventTrigger_Entry
    local entryPointUp = U_EventSystems.EventTrigger.Entry()
    entryPointUp.eventID = U_EventSystems.EventTriggerType.PointerClick
    entryPointUp.callback:AddListener(function(data)
        transform.gameObject:SetActive(false)
    end
    )
    if trigger then
        trigger.triggers:Add(entryPointUp)
    end
end

--- @return void
--- @param statDict Dictionary
function StatInformationView:SetData(statDict)
    assert(statDict)
    self.config.gameObject:SetActive(true)
    local setStatHero = function(index, statType)
        self.config.content:GetChild(index):GetChild(0):GetComponent(ComponentName.UnityEngine_UI_Text).text = LanguageUtils.LocalizeStat(statType)
        self.config.content:GetChild(index):GetChild(1):GetComponent(ComponentName.UnityEngine_UI_Text).text = ClientConfigUtils.GetValueStringStat(statDict, statType)
    end

    setStatHero(0, StatType.ATTACK)
    setStatHero(1, StatType.DEFENSE)
    setStatHero(2, StatType.HP)
    setStatHero(3, StatType.SPEED)
    setStatHero(4, StatType.CRIT_RATE)
    setStatHero(5, StatType.CRIT_DAMAGE)
    setStatHero(6, StatType.ACCURACY)
    setStatHero(7, StatType.DODGE)
    setStatHero(8, StatType.PURE_DAMAGE)
    setStatHero(9, StatType.SKILL_DAMAGE)
    setStatHero(10, StatType.ARMOR_BREAK)
    setStatHero(11, StatType.CC_RESISTANCE)
    setStatHero(12, StatType.DAMAGE_REDUCTION)
    setStatHero(13, StatType.REDUCE_DAMAGE_REDUCTION)
end

return StatInformationView


