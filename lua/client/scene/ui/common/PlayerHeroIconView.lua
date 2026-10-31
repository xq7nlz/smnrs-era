--- @class PlayerHeroIconView : IconView
PlayerHeroIconView = Class(PlayerHeroIconView, IconView)

--- @return void
function PlayerHeroIconView:Ctor()
    --- @type HeroIconView
    self.heroIconView = nil
    --- @type function
    self.onSelectCallback = nil

    --- @type {heroResource : HeroResource, playerName, isOwnHero : boolean, friendId}
    self.itemData = nil
    IconView.Ctor(self)
end

--- @return void
function PlayerHeroIconView:SetPrefabName()
    self.prefabName = 'player_hero_icon_view'
    self.uiPoolType = UIPoolType.PlayerHeroIconView
end

--- @return void
--- @param transform UnityEngine_Transform
function PlayerHeroIconView:SetConfig(transform)
    --- @type PlayerHeroIconViewConfig
    self.config = UIBaseConfig(transform)

    self.config.button.onClick:AddListener(function ()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if self.onSelectCallback then
            self.onSelectCallback()
        end
    end)
end

--- @type {heroResource : HeroResource, playerName, isOwnHero : boolean, friendId}
function PlayerHeroIconView:SetIconData(data)
    self.itemData = data
    if self.heroIconView == nil then
        self.heroIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.HeroIconView, self.config.iconAnchor)
    end
    local heroIconData = HeroIconData.CreateByHeroResource(data.heroResource)
    self.heroIconView:SetIconData(heroIconData)
    self.config.textUserName.text = data.playerName
end

--- @return void
function PlayerHeroIconView:ReturnPool()
    IconView.ReturnPool(self)
    if self.heroIconView ~= nil then
        self.heroIconView:ReturnPool()
        self.heroIconView = nil
    end
    self.onSelectCallback = nil
end

function PlayerHeroIconView:AddClickListener(callback)
    self.onSelectCallback = callback
end

function PlayerHeroIconView:ActiveMaskSelect(isActive)
    if self.heroIconView ~= nil then
        self.heroIconView:ActiveMaskSelect(isActive)
    end
end

return PlayerHeroIconView