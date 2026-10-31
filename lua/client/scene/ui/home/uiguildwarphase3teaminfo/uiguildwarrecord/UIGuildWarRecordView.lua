--- @class UIGuildWarRecordView
UIGuildWarRecordView = Class(UIGuildWarRecordView)

--- @return void
--- @param scroll UnityEngine_UI_LoopScrollRect
function UIGuildWarRecordView:Ctor(scroll)
    ---@type List
    self.listRecord = nil

    --- @param obj GuildWarRecordItemView
    --- @param index number
    local onUpdateItem = function(obj, index)
        obj:SetIconData(self.listRecord:Get(index + 1))
    end

    self.uiScroll = UILoopScroll(scroll, UIPoolType.GuildWarRecordItemView, onUpdateItem, onUpdateItem)
end

--- @return void
--- @param listRecord List
function UIGuildWarRecordView:Show(listRecord)
    self.listRecord = listRecord

    self.uiScroll:Resize(self.listRecord:Count())
end

--- @return void
function UIGuildWarRecordView:ReturnPool()
    self.uiScroll:Hide()
end