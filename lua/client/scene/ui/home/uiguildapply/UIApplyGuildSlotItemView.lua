--- @class UIApplyGuildSlotItemView : IconView
UIApplyGuildSlotItemView = Class(UIApplyGuildSlotItemView, IconView)

function UIApplyGuildSlotItemView:Ctor()
    ---@type string
    self.localizeMemberX = ""
    --- @type GuildIconView
    self.guildIconView = nil
    IconView.Ctor(self)
end

--- @return void
function UIApplyGuildSlotItemView:InitLocalization()
    self.localizeMemberX = LanguageUtils.LocalizeCommon("member_x")
    self.config.textApply.text = LanguageUtils.LocalizeCommon("apply")
end

--- @return void
function UIApplyGuildSlotItemView:SetPrefabName()
    self.prefabName = 'apply_guild_slot_item'
    self.uiPoolType = UIPoolType.ApplyGuildSlotItemView
end

--- @param transform UnityEngine_Transform
function UIApplyGuildSlotItemView:SetConfig(transform)
    --- @type UIApplyGuildSlotItemConfig
    self.config = UIBaseConfig(transform)
end

--- @param guildSearchInfo GuildSearchInfo
function UIApplyGuildSlotItemView:SetData(guildSearchInfo)
    self.config.textGuildLevel.text = LanguageUtils.LocalizeCommon("level") .. " ".. guildSearchInfo.guildLevel
    self.config.guildName.text = guildSearchInfo.guildName

    --- @type GuildLevelUnit
    local guildLevelUnitConfig = ResourceMgr.GetGuildDataConfig().guildLevel:GetGuildLevelUnitConfig(guildSearchInfo.guildLevel)
    self.config.textGuildMember.text = string.format(self.localizeMemberX, string.format("<color=#73ED21>%d/%d</color>", guildSearchInfo.sizeOfGuildMember, guildLevelUnitConfig.maxMember))
    self.config.guildId.text = "Id: " .. guildSearchInfo.guildId

    if self.guildIconView == nil then
        self.guildIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.GuildIconView, self.config.avatarAnchor)
    end
    local spriteAvatar = ResourceLoadUtils.LoadGuildIcon(guildSearchInfo.guildAvatar)
    self.guildIconView:SetData(spriteAvatar, guildSearchInfo.guildLevel)
end

--- @param func function
function UIApplyGuildSlotItemView:AddApplyListener(func)
    self.config.buttonApply.onClick:RemoveAllListeners()
    self.config.buttonApply.onClick:AddListener(function()
        if func ~= nil then
            func()
        end
    end)
end

function UIApplyGuildSlotItemView:ReturnPool()
    IconView.ReturnPool(self)
    if self.guildIconView ~= nil then
        self.guildIconView:ReturnPool()
        self.guildIconView = nil
    end
end

return UIApplyGuildSlotItemView