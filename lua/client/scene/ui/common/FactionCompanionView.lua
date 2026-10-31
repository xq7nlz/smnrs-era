---COMMENT_CONFIG_COMMON    require "lua.client.scene.ui.common.FactionCompanionConfig"

--- @class FactionCompanionView : IconView
FactionCompanionView = Class(FactionCompanionView, IconView)

--- @return void
function FactionCompanionView:Ctor()
    IconView.Ctor(self)
end

--- @return void
function FactionCompanionView:SetPrefabName()
    self.prefabName = 'faction_companion'
    self.uiPoolType = UIPoolType.FactionCompanionView
end

--- @return void
--- @param transform UnityEngine_Transform
function FactionCompanionView:SetConfig(transform)
    assert(transform)
    --- @type FactionCompanionConfig
    ---@type FactionCompanionConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
---@param faction HeroFactionType
---@param number number
function FactionCompanionView:SetData(faction, number)
    self.config.faction.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconFactionsFilter, faction)
    if number > 1 then
        self.config.multiple.gameObject:SetActive(true)
        self.config.multiple.text = string.format("x%s", number)
        self.config.rect.sizeDelta = U_Vector2(90, 50)
    else
        self.config.multiple.gameObject:SetActive(false)
        self.config.rect.sizeDelta = U_Vector2(50, 50)
    end
end

return FactionCompanionView