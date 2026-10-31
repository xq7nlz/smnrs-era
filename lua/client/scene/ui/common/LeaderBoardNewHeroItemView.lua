--- @class LeaderBoardNewHeroItemView : MotionIconView
LeaderBoardNewHeroItemView = Class(LeaderBoardNewHeroItemView, MotionIconView)
LeaderBoardNewHeroItemView.MaxTopRankHasIcon = 3

function LeaderBoardNewHeroItemView:Ctor()
    --- @type VipIconView
    self.vipIconView = nil
    --- @type HeroIconView
    self.heroIconView = nil
    --- @type ItemsTableView
    self.itemsTableView = nil
    MotionIconView.Ctor(self)
end

function LeaderBoardNewHeroItemView:SetPrefabName()
    self.prefabName = 'leader_board_new_hero_item'
    self.uiPoolType = UIPoolType.LeaderBoardNewHeroItemView
end

--- @param transform UnityEngine_Transform
function LeaderBoardNewHeroItemView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    --- @type LeaderBoardItemConfig
    self.config = UIBaseConfig(transform)
end

function LeaderBoardNewHeroItemView:ReturnPool()
    MotionIconView.ReturnPool(self)
    if self.heroIconView ~= nil then
        self.heroIconView:ReturnPool()
        self.heroIconView = nil
    end
    if self.vipIconView ~= nil then
        self.vipIconView:ReturnPool()
        self.vipIconView = nil
    end
    if self.itemsTableView ~= nil then
        self.itemsTableView:Hide()
    end
    self.config.guildLevel.gameObject:SetActive(false)
    self.config.localizeLevel.gameObject:SetActive(false)
    self.config.rankIcon.sprite = nil
    self:SetIconGuild(nil)
end

--- @param rankValue string
function LeaderBoardNewHeroItemView:SetRankValue(rankValue)
    self.config.rank.text = rankValue
end

--- @param name string
function LeaderBoardNewHeroItemView:SetName(name)
    self.config.name.text = name
end

function LeaderBoardNewHeroItemView:SetGuildLevel(guildLevel)
    self.config.localizeLevel.text = LanguageUtils.LocalizeCommon("level")
    self.config.guildLevel.text = tostring(guildLevel)
    self.config.guildLevel.gameObject:SetActive(true)
    self.config.localizeLevel.gameObject:SetActive(true)
end

--- @param rankIcon UnityEngine_Sprite
function LeaderBoardNewHeroItemView:SetRankIcon(rankIcon)
    self.config.rankIcon.enabled = rankIcon ~= nil
    if rankIcon ~= nil then
        self.config.rankIcon.sprite = rankIcon
        self.config.rankIcon:SetNativeSize()
    end
end

--- @param recordInfo string
function LeaderBoardNewHeroItemView:SetRecordInfo(recordInfo)
    self.config.recordDay.text = recordInfo
end


function LeaderBoardNewHeroItemView:SetPower(power)
    self.config.recordDay.text = tostring(power)
end

--- @param rankTittle string
function LeaderBoardNewHeroItemView:SetRankTitle(rankTittle)
    self.config.rankTittle.text = rankTittle
end

--- @param rankInfo string
function LeaderBoardNewHeroItemView:SetRankInfo(rankInfo)
    self.config.rankInfo.text = rankInfo
end

--- @return {}
--- @param uiPoolType UIPoolType
function LeaderBoardNewHeroItemView:InitAvatarInfo(uiPoolType)
    self.vipIconView = SmartPool.Instance:SpawnLuaUIPool(uiPoolType, self.config.avatarAnchor)
    return self.vipIconView
end

--- @return ItemsTableView
function LeaderBoardNewHeroItemView:InitItemTableView()
    self.itemsTableView = ItemsTableView(self.config.rewardAnchor)
    return self.itemsTableView
end

--- @param isUser boolean
function LeaderBoardNewHeroItemView:SetBgText(isUser)
    local changeColor_1 = isUser and UIUtils.white or UIUtils.brown
    local changeColor_2 = isUser and UIUtils.green_light or UIUtils.color2 -- for time
    if self.config.rankTittle ~= nil then
        self.config.rankTittle.text = UIUtils.SetColorString(changeColor_1,self.config.rankTittle.text)
    end
    if self.config.name ~= nil then
        self.config.name.text = UIUtils.SetColorString(changeColor_1,self.config.name.text)
    end
    --if self.config.recordDay ~= nil then
    --    self.config.recordDay.text = UIUtils.SetColorString(changeColor_2,self.config.recordDay.text)
    --end
    if self.config.rankInfo ~= nil then
        self.config.rankInfo.text = UIUtils.SetColorString(changeColor_2,self.config.rankInfo.text)
    end
    self.config.bgGrown:SetActive(not isUser)
    self.config.bgYellow:SetActive(isUser)
end

--- @param position UnityEngine_Vector3
function LeaderBoardNewHeroItemView:SetRankInfoAnchorPosition(position)
    self.config.rankInfoAnchor.anchoredPosition3D = position
end

--- @param size UnityEngine_Vector2
function LeaderBoardNewHeroItemView:SetItemSize(size)
    self.config.transform.sizeDelta = size
end

--- @param iconGuild UnityEngine_Sprite
function LeaderBoardNewHeroItemView:SetIconGuild(iconGuild)
    self.config.bgGuildLogo:SetActive(iconGuild ~= nil)
    self.config.iconGuild.sprite = iconGuild
    self.config.iconGuild:SetNativeSize()
end

return LeaderBoardNewHeroItemView