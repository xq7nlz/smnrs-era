--- @class UIDefeatGuildWarLayout : UIDefeatLayout
UIDefeatGuildWarLayout = Class(UIDefeatGuildWarLayout, UIDefeatLayout)

function UIDefeatGuildWarLayout:InitLayoutConfig()
    --- @type UIDefeatGuildWardConfig
    self.layoutConfig = UIBaseConfig(self.anchor)
end

--- @param data {}
function UIDefeatGuildWarLayout:ShowData(data)
end
