require "lua.client.scene.ui.home.WorldSpaceHeroView.WorldSpaceMultiHeroView"
require "lua.client.scene.ui.home.uiEventNewHero.eventHeroNewLayout.leaderBoard.EventType45TagName"

--- @class UIEventNewHeroBossLeaderBoardLayout : UIEventNewHeroLayout
UIEventNewHeroBossLeaderBoardLayout = Class(UIEventNewHeroBossLeaderBoardLayout, UIEventNewHeroLayout)

function UIEventNewHeroBossLeaderBoardLayout:Ctor(view, eventTimeType, anchor)
    --- @type EventNewHeroBossLeaderBoardModel
    self.eventModel = nil
    --- @type UINewHeroBossLeaderBoardLayoutConfig
    self.layoutConfig = nil

    ---@type WorldSpaceMultiHeroView
    self.worldSpaceMultiHeroView = nil

    --- @type Dictionary
    self.tagNameDict = Dictionary()

    UIEventNewHeroLayout.Ctor(self, view, eventTimeType, anchor)

    self:InitTagName()
end

function UIEventNewHeroBossLeaderBoardLayout:InitTagName()
    self.tagNameDict:Add(1, EventType45TagName(self.layoutConfig.tagName1))
    self.tagNameDict:Add(2, EventType45TagName(self.layoutConfig.tagName2))
    self.tagNameDict:Add(3, EventType45TagName(self.layoutConfig.tagName3))
end

function UIEventNewHeroBossLeaderBoardLayout:OnShow()
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    self.dataId = self.eventModel.timeData.dataId
    UIEventNewHeroLayout.OnShow(self)

    self:ShowBossView()

    self:InitLocalization()

    self:ShowTopPlayerWorld()

    self:ShowScrollOtherTop()
end

function UIEventNewHeroBossLeaderBoardLayout:GetModelConfig()

end

function UIEventNewHeroBossLeaderBoardLayout:SetUpLayout()
    UIEventNewHeroLayout.SetUpLayout(self)
    --- @param obj UITopNewHeroItemView
    --- @param index number
    local onCreateItem = function(obj, index)
        local top = index + 4
        --- @type EventBossChallengeLeaderBoardInBound
        local eventBossChallengeLeaderBoardInBound = self.eventModel.listRanking:Get(top)
        obj:SetData(top, eventBossChallengeLeaderBoardInBound.playerName, eventBossChallengeLeaderBoardInBound.summonerClass)
        obj.config.button.onClick:RemoveAllListeners()
        obj.config.button.onClick:AddListener(function ()
            eventBossChallengeLeaderBoardInBound:ShowInfo()
        end)
    end

    ---@type UILoopScroll
    self.uiScroll = UILoopScroll(self.layoutConfig.scroll, UIPoolType.UITopNewHeroItemView, onCreateItem, onCreateItem)
end

function UIEventNewHeroBossLeaderBoardLayout:ShowBossView()
    if self.worldSpaceMultiHeroView == nil then
        ---@type UnityEngine_Transform
        local trans = SmartPool.Instance:SpawnTransform(AssetType.Battle, "world_space_multi_hero_view")
        self.worldSpaceMultiHeroView = WorldSpaceMultiHeroView(trans)
        local renderTexture = U_RenderTexture(1500, 1500, 24, U_RenderTextureFormat.ARGB32)
        self.layoutConfig.boss3View.texture = renderTexture
        self.worldSpaceMultiHeroView:Init(renderTexture)
    end
end

function UIEventNewHeroBossLeaderBoardLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("new_hero_boss_leader_board", self.anchor)
    UIEventNewHeroLayout.InitLayoutConfig(self, inst)
end

function UIEventNewHeroBossLeaderBoardLayout:InitLocalization()
    self.layoutConfig.textTitle.text = LanguageUtils.LocalizeCommon("new_hero_boss_leader_board_title_" .. self.dataId)
    self.layoutConfig.textDesc.text = LanguageUtils.LocalizeCommon("new_hero_boss_leader_board_desc_" .. self.dataId)
end

function UIEventNewHeroBossLeaderBoardLayout:OnHide()
    UIEventNewHeroLayout.OnHide(self)
    if self.worldSpaceMultiHeroView ~= nil then
        self.worldSpaceMultiHeroView:OnHide()
        self.worldSpaceMultiHeroView = nil
    end
    if self.uiScroll ~= nil then
        self.uiScroll:Hide()
    end
end

function UIEventNewHeroBossLeaderBoardLayout:ShowTopPlayerWorld()
    for i = 1, 3 do
        --- @type EventType45TagName
        local tagName = self.tagNameDict:Get(i)
        if i <= self.eventModel.listRanking:Count() then
            --- @type EventBossChallengeLeaderBoardInBound
            local eventBossChallengeLeaderBoardInBound = self.eventModel.listRanking:Get(i)
            local heroResource = HeroResource()
            heroResource:SetData(-1, eventBossChallengeLeaderBoardInBound.summonerClass,
                    eventBossChallengeLeaderBoardInBound.star, 1)
            self.worldSpaceMultiHeroView:ShowHeroByIndex(i, heroResource)

            tagName:SetActive(true)
            tagName:SetName(eventBossChallengeLeaderBoardInBound.playerName,
                    eventBossChallengeLeaderBoardInBound.guildName)
            if tagName.button ~= nil then
                tagName.button.onClick:RemoveAllListeners()
                tagName.button.onClick:AddListener(function ()
                    eventBossChallengeLeaderBoardInBound:ShowInfo()
                end)
            end
        else
            self.worldSpaceMultiHeroView:ShowHeroByIndex(i, nil)

            tagName:SetActive(false)
        end
    end
end

function UIEventNewHeroBossLeaderBoardLayout:ShowScrollOtherTop()
    if self.eventModel.listRanking:Count() > 3 then
        self.uiScroll:Resize(self.eventModel.listRanking:Count() - 3)
    end
end