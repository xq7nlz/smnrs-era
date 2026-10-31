---COMMENT_CONFIG_COMMON    require "lua.client.scene.ui.common.GuildDonateItemConfig"

--- @class GuildDonateItemView : IconView
GuildDonateItemView = Class(GuildDonateItemView , IconView)

function GuildDonateItemView:Ctor()
    ---@type GuildQuestExchangeData
    self.iconData = nil
    IconView.Ctor(self)
end

--- @return void
function GuildDonateItemView:SetPrefabName()
    self.prefabName = 'guild_donate_item_view'
    self.uiPoolType = UIPoolType.GuildDonateItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function GuildDonateItemView:SetConfig(transform)
    assert(transform)
    --- @type GuildDonateItemConfig
    ---@type GuildDonateItemConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
--- @param iconData GuildQuestExchangeData
function GuildDonateItemView:SetIconData(iconData)
    self.iconData = iconData
    self.config.textAppleValue.text = tostring(self.iconData.numberApple)
    self.config.textPearValue.text = tostring(self.iconData.numberPear)
end

--- @return void
function GuildDonateItemView:InitOnClickReward(onClick)
    self.config.buttonReward.onClick:RemoveAllListeners()
    self.config.buttonReward.onClick:AddListener(onClick)
end

---@param isUnlock boolean
---@param isClaim boolean
function GuildDonateItemView:UpdateStateView(isUnlock, isClaim)
    self.isUnlock = isUnlock
    self.isClaim = isClaim
    self.config.complete:SetActive(self.isUnlock)
    if self.isClaim == true then
        self.config.off:SetActive(false)
        self.config.on:SetActive(false)
        self.config.open:SetActive(true)
    else
        if self.isUnlock == true then
            self.config.off:SetActive(false)
            self.config.on:SetActive(true)
        else
            self.config.off:SetActive(true)
            self.config.on:SetActive(false)
        end
        self.config.open:SetActive(false)
    end
end

---@param unlockApple boolean
---@param unlockPear boolean
function GuildDonateItemView:UpdateProgress(unlockApple, unlockPear)
    self.config.iconActive2:SetActive(unlockApple)
    self.config.iconActive1:SetActive(unlockPear)
end

--- @return void
function GuildDonateItemView:ReturnPool()
    IconView.ReturnPool(self)
    self.config.off:SetActive(false)
    self.config.on:SetActive(false)
    self.config.open:SetActive(false)
end

return GuildDonateItemView