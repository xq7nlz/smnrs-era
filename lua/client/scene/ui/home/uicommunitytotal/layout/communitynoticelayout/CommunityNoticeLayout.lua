require "lua.client.scene.ui.common.UITabItem"
--- @class CommunityNoticeLayout
CommunityNoticeLayout = Class(CommunityNoticeLayout)

local tabCount = 3

local NoticeTab = {
    RecentVersion = 1,
    NextVersion = 2,
    Maintenance = 3,
}

--- @return void
--- @param transform UnityEngine_Transform
--- @param view UIWikiView
function CommunityNoticeLayout:Ctor(view, transform)
    --- @type UICommunityTotalView
    self.view = view
    --- @type UISelect
    self.tab = nil
    ---@type CommunityNoticeConfig
    self.config = UIBaseConfig(transform)
    self:InitTab()
end

--- @return void
function CommunityNoticeLayout:InitTab()
    --- @param obj UIHeroCollectionTabConfig
    --- @param isSelect boolean
    local onSelect = function(obj, isSelect, indexTab)
        if obj ~= nil then
            obj.button.interactable = not isSelect
            obj.bgOn.gameObject:SetActive(isSelect)
            if isSelect then
                self:SelectTab(indexTab)
            end
        end
    end

    local onChangeSelect = function(indexTab)
        if indexTab then
            self:SelectTab(indexTab)
        end
    end
    self.tab = UISelect(self.config.tab, UIBaseConfig, onSelect, onChangeSelect)
end

--- @return void
function CommunityNoticeLayout:SelectTab(indexTab)
    local currentVersion = VERSION
    local nextVersion = self:CalculateNextVersion(currentVersion)
    self.selectTab = indexTab
    self.config.textPatchNote.gameObject:SetActive(self.selectTab < NoticeTab.Maintenance)
    for i = 1, tabCount do
        if i == self.selectTab then
            if i == NoticeTab.RecentVersion then
                self.config.textPatchNote.text = string.format("%s: %s",
                        LanguageUtils.LocalizeCommon("patch"), UIUtils.SetColorString(UIUtils.green_light, currentVersion))
                self.config.textNoticeContent.text = LanguageUtils.LocalizeCommon("version_notice_recent")
            elseif i == NoticeTab.NextVersion then
                self.config.textPatchNote.text = string.format("%s: %s",
                        LanguageUtils.LocalizeCommon("patch"), UIUtils.SetColorString(UIUtils.green_light, nextVersion))
                self.config.textNoticeContent.text = LanguageUtils.LocalizeCommon("version_notice_next")
            elseif i == NoticeTab.Maintenance then
                self.config.textNoticeContent.text = string.format(LanguageUtils.LocalizeCommon("version_notice_maintenance"), nextVersion)
            end
        end
    end
end

function CommunityNoticeLayout:CalculateNextVersion(currentVersion)
    local major, minor, patch = currentVersion:match("(%d+)%.(%d+)%.(%d+)")
    major = tonumber(major)
    minor = tonumber(minor)
    patch = tonumber(patch)

    if not (major and minor and patch) then
        return StringUtils.Empty() -- Invalid version format
    end

    patch = (patch + 1) % 10

    if patch == 0 then
        minor = (minor + 1) % 10
        if minor == 0 then
            major = (major + 1) % 10
        end
    end
    return string.format("%d.%d.%d", major, minor, patch)
end

function CommunityNoticeLayout:InitLocalize()
    self.config.texTabRecentVersion.text = LanguageUtils.LocalizeCommon("version_recent")
    self.config.texTabNextVersion.text = LanguageUtils.LocalizeCommon("version_next")
    self.config.texTabMaintenance.text = LanguageUtils.LocalizeCommon("maintenance")
end

--- @return void
function CommunityNoticeLayout:OnShow()
    self.config.gameObject:SetActive(true)
    self.tab:Select(NoticeTab.RecentVersion)
    self:InitLocalize()
end

--- @return void
function CommunityNoticeLayout:OnHide()
    self.config.gameObject:SetActive(false)
end
