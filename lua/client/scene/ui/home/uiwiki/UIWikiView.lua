require "lua.client.scene.ui.home.uiWiki.herorecommend.UIHeroRecommendLayout"
require "lua.client.scene.ui.home.uiWiki.resourceMapping.UIResourceMappingLayout"
require "lua.client.scene.ui.home.uiWiki.featureUnlock.UIFeatureUnlockLayout"
require "lua.client.scene.ui.home.uiWiki.formation.UIWikiFormationLayout"
--- @class UIWikiView : UIBaseView
UIWikiView = Class(UIWikiView, UIBaseView)

--- @return void
--- @param model UIWikiModel
function UIWikiView:Ctor(model)
    ---@type UIWikiConfig
    self.config = nil
    --- @type UISelect
    self.tab = nil
    ---@type UITabWikiConfig[]
    self.tabWikiConfig = {}
    ---@type UIHeroRecommendLayout
    self.heroRecommend = nil
    ---@type UIWikiFormationLayout
    self.formation = nil
	--- @type boolean
	self.canPlayMotion = true
    --- @type UIWikiModel
    self.model = model
    ---@type Dictionary
    self.heroRecommendDict = Dictionary()
    ---@type List
    self.gameMode = List()
    ---@type List
    self.mostHero = List()
    UIBaseView.Ctor(self, model)
end

--- @return void
function UIWikiView:OnReadyCreate()
    --- @type UITabWikiConfig
    self.config = UIBaseConfig(self.uiTransform)
    self.resourceMapping = UIResourceMappingLayout(self,
            self.config.content:GetChild(UIWikiTab.ResourceMapping - 1),
            self.model)
    self.formation = UIWikiFormationLayout(self,
            self.config.content:GetChild(UIWikiTab.Formation - 1),
            self.model)
    self.heroRecommend = UIHeroRecommendLayout(self,
            self.config.content:GetChild(UIWikiTab.HeroRecommend - 1),
            self.model)
    self.featureUnlock = UIFeatureUnlockLayout(self,
            self.config.content:GetChild(UIWikiTab.FeatureUnlock - 1),
            self.model)
    --- @param obj UITabWikiConfig
    --- @param isSelect boolean
    local onSelect = function(obj, isSelect, indexTab)
        if obj ~= nil then
            obj.button.interactable = not isSelect
            obj.bgOn.gameObject:SetActive(isSelect)
        end
        self.config.content:GetChild(indexTab - 1).gameObject:SetActive(isSelect)
    end
    local funSelectTab = { self.ShowResourceMapping, self.ShowFormation, self.ShowHeroRecommend,self.ShowFeatureUnlock}

    local funHideTab = { self.HideResourceMapping,self.HideFormation,self.HideHeroRecommend, self.HideFeatureUnlock}
    local onChangeSelect = function(indexTab, lastTab)
        if lastTab ~= nil then
            funHideTab[lastTab](self)
        end
        if indexTab ~= nil then
            funSelectTab[indexTab](self)
        end
    end
    self.tab = UISelect(self.config.tabParent, UIBaseConfig, onSelect, onChangeSelect)

    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.bgClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

function UIWikiView:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_CLOSE)
    self:OnReadyHide()
end



--- @return void
function UIWikiView:OnReadyHide()
    if self.callbackClose ~= nil then
        self.callbackClose()
    else
        PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UIWiki)
    end
end

--- @return void
function UIWikiView:InitLocalization()
    self.config.localizeHeroRecommend.text = LanguageUtils.LocalizeCommon("hero_recommend")
    self.config.localizeResourceMapping.text = LanguageUtils.LocalizeCommon("resource_mapping")
    self.config.localizeFeatureUnlock.text = LanguageUtils.LocalizeCommon("wiki_feature_unlock")
    self.config.localizeFormation.text = LanguageUtils.LocalizeCommon("formation")
    self.config.textEmpty.text = LanguageUtils.LocalizeCommon("empty")
end

function UIWikiView:OnReadyShow()
    local content = self.config.scrollTab.content
    content.anchoredPosition = U_Vector2(content.anchoredPosition.x,0)
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
	self.canPlayMotion = true
    self.tab:Select(1)
end

--- @return void
function UIWikiView:OnFinishAnimation()
    UIBaseView.OnFinishAnimation(self)
    self:CheckAndInitTutorial()
end

--- @return void
function UIWikiView:Hide()
    UIBaseView.Hide(self)
    self.tab:Select(nil)
    self:EnableEmpty(false)
end

--- @return void
function UIWikiView:ShowHeroRecommend()
    self:GetHeroRecommend()
    self.config.textTitle.text = self.config.localizeHeroRecommend.text
	if self.canPlayMotion == true then
		self.canPlayMotion = false
	end
end

--- @return void
function UIWikiView:HideHeroRecommend()
    self.heroRecommend:Hide()
end


--- @return void
function UIWikiView:ShowResourceMapping()
    self.resourceMapping:Show()
    self.config.textTitle.text = self.config.localizeResourceMapping.text
    if self.canPlayMotion == true then
        self.canPlayMotion = false
    end
end

--- @return void
function UIWikiView:HideResourceMapping()
    self.resourceMapping:Hide()
end

--- @return void
function UIWikiView:ShowFormation()
    self.formation:Show()
    self.config.textTitle.text = self.config.localizeFormation.text
    if self.canPlayMotion == true then
        self.canPlayMotion = false
    end
end

--- @return void
function UIWikiView:HideFormation()
    self.formation:Hide()
end

--- @return void
function UIWikiView:ShowFeatureUnlock()
    self.featureUnlock:Show()
    self.config.textTitle.text = self.config.localizeFeatureUnlock.text
    if self.canPlayMotion == true then
        self.canPlayMotion = false
    end
end

--- @return void
function UIWikiView:HideFeatureUnlock()
    self.featureUnlock:Hide()
end


--- @param isEnable boolean
function UIWikiView:EnableEmpty(isEnable)
    self.config.empty:SetActive(isEnable)
end

function UIWikiView:GetHeroRecommend()
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
            self.heroRecommendDict:Add(1,self.mostHero)
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
                heroData.usedPercent =  buffer:GetInt() / 100
               --print("heroData id  :" .. LogUtils.ToDetail(heroData.heroId))
                listHero:Add(heroData)
            end
            self.heroRecommendDict:Add(i+1,listHero)
        end
    end

    local onSuccess = function()
        self.heroRecommend:Show()
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
function UIWikiView:EnableEmpty(isEnable)
    self.config.empty:SetActive(isEnable)
end

UIWikiTab = {
    ResourceMapping = 1,
    Formation = 2,
    HeroRecommend = 3,
    FeatureUnlock = 4,
}