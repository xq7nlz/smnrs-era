local FORMATION_PATH = "csv/wiki/recommend_lineup.csv"
--- @class UIWikiFormationLayout
UIWikiFormationLayout = Class(UIWikiFormationLayout)

--- @return void
--- @param transform UnityEngine_Transform
--- @param view UIWikiView
function UIWikiFormationLayout:Ctor(view, transform)
    --- @type UICommunityTotalView
    self.view = view
    ---@type Dictionary<BattleTeamInfo>
    self.dictLineUpRecommend = Dictionary()
    ---@type UILoopScroll
    self.uiScroll = nil
    ---@type UIWikiFormationConfig
    self.config = UIBaseConfig(transform)

    self:GetListLineupRecommendation()
    self:InitScroll()
end

--- @return void
--- Get list recommend lineup from csv
function UIWikiFormationLayout:GetListLineupRecommendation()
    local dataParse = CsvReaderUtils.ReadAndParseLocalFile(FORMATION_PATH)
    for _, data in ipairs(dataParse) do
        if data.id ~= nil then
            local predefineTeam = PredefineTeamData.CreateByCsv(data)
            ---@type BattleTeamInfo
            local lineupTeam = ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfo(predefineTeam)
            if lineupTeam ~= nil then
                self.dictLineUpRecommend:Add(tonumber(data.id), lineupTeam)
            end
        end
    end
end


--- @return void
--- Create scroll on UI with each item is lineup item
function UIWikiFormationLayout:InitScroll()
    --- @param obj LineupItemView
    --- @param index number
    local onCreateItem = function(obj, index)
        ---@type BattleTeamInfo
        local lineupRecommend = self.dictLineUpRecommend:Get(index + 1)
        obj:SetData(lineupRecommend, index+1)
        obj:AddListener(function()
            self:OpenFormationDetailPopup(lineupRecommend, index+1)
        end)
    end
    self.uiScroll = UILoopScroll(self.config.scroll,
            UIPoolType.LineupItemView, onCreateItem)
    self.uiScroll:SetUpMotion(MotionConfig(0, 0, 0, 0.02, 3))
end

--- @return void
--- @param battleTeamInfo BattleTeamInfo
--- @param lineupId number The id lineup corresponding with BattleTeamInfo (not team_id)
--- Open Popup Team Lineup(Formation) Detail with specific battle team information
function UIWikiFormationLayout:OpenFormationDetailPopup(battleTeamInfo, lineupId)
    data = {}
    data.battleTeamInfo = battleTeamInfo
    data.lineupId = lineupId
    zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    PopupMgr.ShowPopup(UIPopupName.UILineupDetail, data)
end


--- @return void
function UIWikiFormationLayout:Show()
    local itemCount = self.dictLineUpRecommend:Count()
    self.uiScroll:Resize(itemCount)
    self.view:EnableEmpty(itemCount == 0)
end


--- @return void
function UIWikiFormationLayout:Hide()
    self.uiScroll:Hide()
end