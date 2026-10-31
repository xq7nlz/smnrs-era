require "lua.client.scene.ui.home.uiFormation2.heroSlotWorldFormation.HeroSlotWorldFormation"

--- @class DomainWorldTeamFormation
DomainWorldTeamFormation = Class(DomainWorldTeamFormation)


--- @param worldFormation WorldFormation
function DomainWorldTeamFormation:Ctor(worldFormation)
    --- @type WorldFormation
    self.worldFormation = worldFormation
    --- @type Dictionary
    self.heroSlotWorldFormationDict = Dictionary()

    self:InitHeroSlot()
end

function DomainWorldTeamFormation:InitHeroSlot()
    for i = 1, 2 do
        --- @type HeroSlotWorldFormation
        local script = SmartPool.Instance:SpawnLuaGameObject(AssetType.UIPool, UIPoolType.HeroSlotWorldFormation)
        script:Init(self.worldFormation.config.transform, true)

        script:OnRemoveSlot()
        script:EnableBuffStat(false)
        script:EnableTextSlot(false)

        if i == 1 then
            script:SetPosition(U_Vector3(-1.4, -2.72, 0))
        elseif i == 2 then
            script:SetPosition(U_Vector3(-5.98, -2.72, 0))
        end

        self.heroSlotWorldFormationDict:Add(i, script)
    end
end

function DomainWorldTeamFormation:PreviewHero(slot, heroResource)
    --- @type HeroSlotWorldFormation
    local script = self.heroSlotWorldFormationDict:Get(slot)
    if script == nil then
        return
    end
    if heroResource ~= nil then
        script:SetHeroSlot(heroResource)
        script:EnableTextLevel(true)
        script:FlipLeft(false)
    else
        script:OnRemoveSlot()
    end
end

function DomainWorldTeamFormation:OnHide()
    --- @param v HeroSlotWorldFormation
    for _, v in pairs(self.heroSlotWorldFormationDict:GetItems()) do
        v:ReturnPool()
    end
    self.heroSlotWorldFormationDict:Clear()
end