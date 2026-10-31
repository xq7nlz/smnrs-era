require "lua.client.scene.ui.common.UITabItem"
require "lua.client.scene.ui.home.uiWiki.herorecommend.UIHeroRecommendLayout"
require "lua.client.scene.ui.home.uiWiki.resourceMapping.UIResourceMappingLayout"
require "lua.client.scene.ui.home.uiWiki.featureUnlock.UIFeatureUnlockLayout"
require "lua.client.scene.ui.home.uiWiki.formation.UIWikiFormationLayout"

local tabCount = 4

local GuideBookTab = {
    FeatureUnlock = 1,
    Formation = 2,
    HeroRecommend = 3,
    ResourceMapping = 4,
}

--- @class CommunityGuideBookLayout
CommunityGuideBookLayout = Class(CommunityGuideBookLayout)

--- @return void
--- @param transform UnityEngine_Transform
function CommunityGuideBookLayout:Ctor(view, transform)
    --- @type UICommunityTotalView
    self.view = view
    ---@type CommunityGuideBookConfig
    self.config = UIBaseConfig(transform)
    --- @type UISelect
    self.tab = nil
    self.selectTab = nil
    ---@type Dictionary
    self.heroRecommendDict = Dictionary()
    ---@type List
    self.gameMode = List()
    ---@type List
    self.mostHero = List()
    self:InitContent()
    self:InitTab()
    self:InitLocalize()
end

--- @return void
function CommunityGuideBookLayout:InitContent()
    self.contentFeature = UIFeatureUnlockLayout(self, self.config.contentFeature)
    self.contentFormation = UIWikiFormationLayout(self, self.config.contentFormation)
    self.contentHeroRecommend = UIHeroRecommendLayout(self, self.config.contentHeroRecommend)
    self.contentResource = UIResourceMappingLayout(self, self.config.contentResource)
end

function CommunityGuideBookLayout:InitLocalize()
    self.config.textTabFeature.text = LanguageUtils.LocalizeCommon("wiki_feature_unlock")
    self.config.textTabFormation.text = LanguageUtils.LocalizeCommon("formation")
    self.config.textTabHeroRecommend.text = LanguageUtils.LocalizeCommon("hero_recommend")
    self.config.textTabResource.text = LanguageUtils.LocalizeCommon("resource_mapping")
end

--- @return void
function CommunityGuideBookLayout:InitTab()
    --- @param obj UIHeroCollectionTabConfig
    --- @param isSelect boolean
    local onSelect = function(obj, isSelect, indexTab)
        if obj ~= nil then
            obj.button.interactable = not isSelect
            obj.bgOn.gameObject:SetActive(isSelect)
            if isSelect then
                self:SelectTab(indexTab)
            end
            self.config.content:GetChild(indexTab - 1).gameObject:SetActive(isSelect)
        end
    end

    local onChangeSelect = function(indexTab)
        if indexTab then
            self:SelectTab(indexTab)
        end
    end
    self.tab = UISelect(self.config.tab, UIBaseConfig, onSelect, onChangeSelect)
end

function CommunityGuideBookLayout:SelectTab(tabIndex)
    self.selectTab = tabIndex
    for i = 1, tabCount do
        if i ~= self.selectTab then
            if i == GuideBookTab.FeatureUnlock then
                if self.contentFeature then
                    self.contentFeature:Hide()
                end
            elseif i == GuideBookTab.Formation then
                if self.contentFormation then
                    self.contentFormation:Hide()
                end
            elseif i == GuideBookTab.HeroRecommend then
                if self.contentHeroRecommend then
                    self.contentHeroRecommend:Hide()
                end
            elseif i == GuideBookTab.ResourceMapping then
                if self.contentResource then
                    self.contentResource:Hide()
                end
            end
        else
            if i == GuideBookTab.FeatureUnlock then
                self.contentFeature:Show()
            elseif i == GuideBookTab.Formation then
                self.contentFormation:Show()
            elseif i == GuideBookTab.HeroRecommend then
                self:GetHeroRecommend()
                --self.contentHeroRecommend:Show()
            elseif i == GuideBookTab.ResourceMapping then
                self.contentResource:Show()
            end
        end
    end
end

function CommunityGuideBookLayout:GetHeroRecommend()
    self.heroRecommendDict:Clear()
    self.gameMode:Clear()
    self.mostHero:Clear()
    --- @param buffer UnifiedNetwork_ByteBuf
    local onBufferReading = function(buffer)
        local mostHeroSize = buffer:GetByte()
        if mostHeroSize > 0 then
            for j = 1, mostHeroSize do
                local heroData = {}
                heroData.heroId = buffer:GetInt()
                heroData.usedPercent = buffer:GetInt() / 100
                --print("Most ")
                --print("heroData id :" .. LogUtils.ToDetail(heroData.id))
                self.mostHero:Add(heroData)
            end
            self.gameMode:Add("most")
            self.heroRecommendDict:Add(1, self.mostHero)
        end
        local dictSize = buffer:GetByte()
        -- print("dictSize :" .. dictSize)
        for i = 1, dictSize do
            local key = buffer:GetString()
            --print("Mode : ".. key)
            self.gameMode:Add(key)
            --print("key :" .. key)
            local listSize = buffer:GetByte()
            --print("listSize :" .. listSize)
            --- @type List
            local listHero = List()
            for j = 1, listSize do
                local heroData = {}
                heroData.heroId = buffer:GetInt()
                heroData.usedPercent = buffer:GetInt() / 100
                --print("heroData id  :" .. LogUtils.ToDetail(heroData.heroId))
                listHero:Add(heroData)
            end
            self.heroRecommendDict:Add(i + 1, listHero)
        end
    end

    local onSuccess = function()
        self.contentHeroRecommend:Show()
    end
    NetworkUtils.RequestAndCallback(OpCode.HERO_STATISTIC_DATA_GET,
            nil,
            onSuccess,
            function(error)
                XDebug.Error("Error Sync Time: " .. tostring(error))
            end,
            onBufferReading)
end

--- @param isEnable boolean
function CommunityGuideBookLayout:EnableEmpty(isEnable)
    self.config.empty:SetActive(isEnable)
end

--- @return void
function CommunityGuideBookLayout:OnShow()
    self.config.gameObject:SetActive(true)
    self:InitLocalize()
    self.tab:Select(GuideBookTab.FeatureUnlock)
end

--- @return void
function CommunityGuideBookLayout:OnHide()
    self.config.gameObject:SetActive(false)
end

return CommunityGuideBookLayout