--- @class UIHeroRecommendLayout
UIHeroRecommendLayout = Class(UIHeroRecommendLayout)

--- @return void
--- @param transform UnityEngine_Transform
--- @param view UICommunityTotalView
function UIHeroRecommendLayout:Ctor(view, transform)
    --- @type UICommunityTotalView
    self.view = view
    ---@type List --<id>
    self.itemDic = List()
    ---@type List --<id>
    self.quickBattleTicket = List()
    ---@type UIHeroRecommendConfig
    self.config = UIBaseConfig(transform)
    self:InitScroll()
end

function UIHeroRecommendLayout:InitScroll()
    --- @param obj ListHeroRecommendItemView
    --- @param index number
    local onCreateItem = function(obj, index)
        obj:SetData(self.view.heroRecommendDict:Get(index + 1),self.view.gameMode:Get(index + 1))
    end
    self.uiScroll = UILoopScroll(self.config.scroll,
            UIPoolType.ListHeroRecommendItemView, onCreateItem)
    self.uiScroll:SetUpMotion(MotionConfig(0, 0, 0, 0.02, 3))
end


--- @return void
function UIHeroRecommendLayout:Show()
    local itemCount = self.view.heroRecommendDict:Count()
    self.uiScroll:Resize(itemCount)
    self.view:EnableEmpty(itemCount == 0)
end


--- @return void
function UIHeroRecommendLayout:Hide()
    self.uiScroll:Hide()
end