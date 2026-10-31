--- @class ArenaBootCampLeaderBoardItemView : MotionIconView
ArenaBootCampLeaderBoardItemView = Class(ArenaBootCampLeaderBoardItemView, MotionIconView)
ArenaBootCampLeaderBoardItemView.MaxTopRankHasIcon = 3
local TEXT_USER_COLOR = "815329" --U_Color(0.3019608, 0.2666667, 0.2117647, 1)
local TEXT_COMMON_COLOR = "554938" -- U_Color(0.5058824, 0.3254902, 0.1607843, 1)
function ArenaBootCampLeaderBoardItemView:Ctor()
    --- @type VipIconView
    self.vipIconView = nil
    --- @type HeroIconView
    self.heroIconView = nil
    --- @type ItemsTableView
    self.itemsTableView = nil
    --- @type ArenaBootCampLeaderBoardItemConfig
    self.config = nil

    MotionIconView.Ctor(self)


end



function ArenaBootCampLeaderBoardItemView:SetDataReward(listRewardIcon)
    self:InitItemTableView()
    self.itemsTableView:SetData(listRewardIcon)
end

--[[--- @param name string
function ArenaBootCampLeaderBoardItemView:SetName(name)
    self.config.name.text = name
end]]

function ArenaBootCampLeaderBoardItemView:SetPrefabName()
    self.prefabName = 'arena_bootcamp_leader_board_item'
    self.uiPoolType = UIPoolType.UIArenaBootCampLeaderBoardItem
end

--- @param transform UnityEngine_Transform
function ArenaBootCampLeaderBoardItemView:SetConfig(transform)
    --XDebug.Log("SET CONFIG HERE HOANGPL")
    MotionIconView.SetConfig(self, transform)
    --- @type ArenaBootCampLeaderBoardItemConfig
    self.config = UIBaseConfig(transform)
end

function ArenaBootCampLeaderBoardItemView:ReturnPool()
    MotionIconView.ReturnPool(self)
    if self.heroIconView ~= nil then
        self.heroIconView:ReturnPool()
        self.heroIconView = nil
    end
    if self.vipIconView ~= nil then
        self.vipIconView:ReturnPool()
        self.vipIconView = nil
    end
    self:ReturnPoolListReward()
    --self.config.guildLevel.gameObject:SetActive(false)
    --self.config.localizeLevel.gameObject:SetActive(false)
    self.config.rankIcon.sprite = nil
end

--- @param rankValue string
function ArenaBootCampLeaderBoardItemView:SetRankValue(rankValue,isUser)
    local colorNoRank = isUser and TEXT_USER_COLOR or TEXT_COMMON_COLOR
    local uColor = UIUtils.white
    local colorRank =  colorNoRank
    if (rankValue > 0 and rankValue <= LeaderBoardItemView.MaxTopRankHasIcon) then
        colorRank = uColor
    end
    local  rankValueText = rankValue >= 0 and tostring(rankValue) or  LanguageUtils.LocalizeCommon("ranking_NA")

     self.config.rank.text =  UIUtils.SetColorString(colorRank,rankValueText)
end


--- @param rankIcon UnityEngine_Sprite
function ArenaBootCampLeaderBoardItemView:SetRankIcon(rankIcon)
    self.config.rankIcon.enabled = rankIcon ~= nil
    if rankIcon ~= nil then
        self.config.rankIcon.sprite = rankIcon
        self.config.rankIcon:SetNativeSize()
    end
end

--- @param recordInfo string
function ArenaBootCampLeaderBoardItemView:SetRecordInfo(point,isUser)
    --self.config.recordDay.gameObject:SetActive(point > 0)
    local colorBase =  isUser and TEXT_USER_COLOR or TEXT_COMMON_COLOR

    if point <= 0 then
        self.config.recordDay.text = UIUtils.SetColorString(colorBase ,LanguageUtils.LocalizeCommon("server_open_week_no_arena_point"))
        else
        self.config.recordDay.text = string.format(UIUtils.SetColorString(colorBase ,LanguageUtils.LocalizeCommon("server_open_week_arena_point")), UIUtils.SetColorString(UIUtils.green_normal,  point))
    end

end

--[[--- @param rankTittle string
function ArenaBootCampLeaderBoardItemView:SetRankTitle(rankTittle)
    self.config.rankTittle.text = rankTittle
end

--- @param rankInfo string
function ArenaBootCampLeaderBoardItemView:SetRankInfo(rankInfo)
    self.config.rankInfo.text = rankInfo
end]]

--- @return {}
--- @param uiPoolType UIPoolType
function ArenaBootCampLeaderBoardItemView:InitAvatarInfo(uiPoolType)
    self.vipIconView = SmartPool.Instance:SpawnLuaUIPool(uiPoolType, self.config.avatarAnchor)
    return self.vipIconView
end

--- @return ItemsTableView
function ArenaBootCampLeaderBoardItemView:InitItemTableView()
    if (self.itemsTableView == nil) then
        self.itemsTableView = ItemsTableView(self.config.rewardAnchor)
    end
end



--- @param isUser boolean
function ArenaBootCampLeaderBoardItemView:SetBgText(isUser,_playerName)
    --0.3019608 0.2666667 0.2117647 1  common
    --0.5058824 0.3254902 0.1607843 1 user

    local textColorMain = isUser and TEXT_USER_COLOR or TEXT_COMMON_COLOR
    local changeColor_1 = isUser and UIUtils.white or UIUtils.brown
    local changeColor_2 = isUser and UIUtils.green_light or UIUtils.color2 -- for time
--[[    if self.config.rankTittle ~= nil then
        self.config.rankTittle.text = UIUtils.SetColorString(changeColor_1,self.config.rankTittle.text)
    end]]
    if self.config.name ~= nil then
        self.config.name.text = UIUtils.SetColorString(textColorMain,_playerName)
    end
--[[    if self.config.recordDay ~= nil then
       -- self.config.recordDay.text = UIUtils.SetColorString(changeColor_2,self.config.recordDay.text)
]]--[[        self.config.recordDay.text = changeColor_1 string.format(LanguageUtils.LocalizeCommon("server_arena_point"),
                string.format("<color=#%s>%s %s</color>", UIUtils.green_light, self.data.trialDurationInDay, LanguageUtils.LocalizeCommon("day")))]]--[[
    end]]


--[[    if self.config.rankInfo ~= nil then
        self.config.rankInfo.text = UIUtils.SetColorString(changeColor_2,self.config.rankInfo.text)
    end]]
    self.config.bgGrown:SetActive(not isUser)
    self.config.bgYellow:SetActive(isUser)
end

--- @param position UnityEngine_Vector3
function ArenaBootCampLeaderBoardItemView:SetRankInfoAnchorPosition(position)
    self.config.rankInfoAnchor.anchoredPosition3D = position
end

--- @param size UnityEngine_Vector2
function ArenaBootCampLeaderBoardItemView:SetItemSize(size)
    self.config.transform.sizeDelta = size
end

--- @param size UnityEngine_Vector2
function ArenaBootCampLeaderBoardItemView:ReturnPoolListReward()
    if self.itemsTableView ~= nil then
        self.itemsTableView:Hide()
    end
end

return ArenaBootCampLeaderBoardItemView