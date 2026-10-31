---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiHeroSummon.UIHeroMythicalRewardConfig"
--- @class UIHeroMythicalRemake
UIHeroMythicalRemake = Class(UIHeroMythicalRemake)

--- @return void

function UIHeroMythicalRemake:Ctor(uiTransform)
    ---@type UIHeroMythicalRewardConfig
    self.config = UIBaseConfig(uiTransform)
end

--- @param summonType SummonType
function UIHeroMythicalRemake:SetupMythical(summonType)
    if summonType == SummonType.RateUp then
        --- @type EventRateUp
        local eventRateUp = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_RATE_UP):GetConfig()
        local rateSummon = eventRateUp:GetRateUpCumulative()
        local pityConfig = eventRateUp:GetPityConfig()
        if pityConfig.pity_enable == true then
            self.config.heroMythicalReward.gameObject:SetActive(true)
            self.config.starHeroRewardTxt.text = string.format(LanguageUtils.LocalizeCommon("summon_rate_up"), pityConfig.summonPoint)
            local sprite = ResourceLoadUtils.LoadMythicalAvatar(rateSummon.heroId)
            if sprite ~= nil then
                self.config.mythicalImage.sprite = sprite
            end
            self.config.mythicalImage:SetNativeSize()
            self.config.rateUpSubIcon:SetActive(true)
        else
            self.config.heroMythicalReward.gameObject:SetActive(false)
        end
    elseif summonType == SummonType.NewHero
            or summonType == SummonType.NewHero2
            or summonType == SummonType.HeroRelease then
        self.config.heroMythicalReward.gameObject:SetActive(false)
    elseif summonType == SummonType.Heroic then
        self.config.heroMythicalReward.gameObject:SetActive(true)
        self.config.starHeroRewardTxt.text = LanguageUtils.LocalizeCommon("5_star_hero_reward")
        local sprite = ResourceLoadUtils.LoadMythicalAvatar(-1)
        if sprite ~= nil then
            self.config.mythicalImage.sprite = sprite
            self.config.mythicalImage:SetNativeSize()
        end
        self.config.rateUpSubIcon:SetActive(false)
    else
        self.config.heroMythicalReward.gameObject:SetActive(false)
    end
end
