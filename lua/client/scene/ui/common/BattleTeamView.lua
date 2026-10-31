require "lua.client.scene.ui.common.prefabTeam.UIPrefabTeamView"

--- @class BattleTeamView
BattleTeamView = Class(BattleTeamView)

--- @return void
--- @param uiTransform UnityEngine_RectTransform
function BattleTeamView:Ctor(uiTransform)
    --- @type UnityEngine_RectTransform
    self.transform = uiTransform
    --- @type BattleTeamInfo
    self.battleTeamInfo = nil
    --- @type UIPrefabHeroSlotView
    self.uiHeroSlotView = nil
    --- @type UIPrefabTeamView
    self.uiTeamView = nil
    --- @type function
    self.onSelectHeroBySlot = nil
end

--- @return void
function BattleTeamView:_ShowHeroSlotView()
    self.uiHeroSlotView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.UIPrefabHeroSlotView, self.transform)
    self.uiHeroSlotView:Init(5)
    self.uiHeroSlotView:Show()
end

--- @return void
function BattleTeamView:_ShowTeamView()
    self.uiTeamView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.UIPrefabTeamView, self.transform)
    self.uiTeamView:Init(self.uiHeroSlotView)
    self.uiTeamView.config.mainHero:SetActive(true)

    self.uiTeamView:SetSummonerTransform(U_Vector3(-531.5, 84, 0), U_Vector3.one)
end

function BattleTeamView:HideTeamBackground()
    self.uiTeamView.config.bgDoiHinhBack.enabled = false
    self.uiTeamView.config.bgDoiHinhFront.enabled = false
end

--- @return void
--- @param uiPoolType UIPoolType
--- @param battleTeamInfo BattleTeamInfo
--- @param onClickSlot function
function BattleTeamView:SetDataDefender(uiPoolType, battleTeamInfo, onClickSlot, isShowHp)
    if battleTeamInfo == nil then
        XDebug.Error("battleTeamInfo NIL")
        return
    end
    self.battleTeamInfo = battleTeamInfo
    local formationId = battleTeamInfo.formation

    self.uiHeroSlotView:SetCanDrag(false)
    if onClickSlot ~= nil then
        --- @param slotIndex number
        self.uiHeroSlotView.onSelectSlot = function(slotIndex)
            onClickSlot(slotIndex)
        end
    else
        self.uiHeroSlotView.onSelectSlot = nil
    end

    local frontLineLength = self.uiTeamView:FrontLineLength(formationId)
    --- @param heroBattleInfo HeroBattleInfo
    for _, heroBattleInfo in ipairs(self.battleTeamInfo.listHeroInfo:GetItems()) do
        --local iconData = HeroIconData.CreateByHeroBattleInfo(heroBattleInfo)
        local slotIndex = heroBattleInfo.position + (heroBattleInfo.isFrontLine and 0 or frontLineLength)
        self.uiHeroSlotView:SpawnHeroIconAtIndex(uiPoolType, 6 - slotIndex, 1, heroBattleInfo, isShowHp)
    end

    self.uiTeamView:SetDefaultLinking()
    self.uiTeamView:SetFormation(formationId)
end

--- @return void
--- @param teamFormation TeamFormationInBound
function BattleTeamView:SetDataAttacker(teamFormation)
    assert(teamFormation)
    self.uiTeamView:SetFormation(teamFormation.formationId)
    local length = self.uiTeamView:FrontLineLength(teamFormation.formationId)
    --- @param v HeroFormationInBound
    for i, v in ipairs(teamFormation.frontLine:GetItems()) do
        local heroResource, heroIndex = InventoryUtils.GetHeroResourceByInventoryId(v.heroInventoryId)
        if heroIndex ~= nil then
            local slotIndex = 6 - v.positionId
            self.uiHeroSlotView:SpawnHeroIconAtIndex(UIPoolType.HeroIconView, slotIndex, heroIndex, HeroIconData.CreateByHeroResource(heroResource))
        end
    end

    --- @param v HeroFormationInBound
    for i, v in ipairs(teamFormation.backLine:GetItems()) do
        local heroResource, heroIndex = InventoryUtils.GetHeroResourceByInventoryId(v.heroInventoryId)
        if heroIndex ~= nil then
            local slotIndex = 6 - (v.positionId + length)
            self.uiHeroSlotView:SpawnHeroIconAtIndex(UIPoolType.HeroIconView, slotIndex, heroIndex, HeroIconData.CreateByHeroResource(heroResource))
        end
    end

    self.uiTeamView:SetDefaultLinking()
end

--- @return void
function BattleTeamView:SetDefaultLinking()
    self.uiTeamView:SetDefaultLinking()
end

--- @return void
--- @param realFormation number
function BattleTeamView:SetFormation(realFormation)
    self.uiTeamView:SetFormation(realFormation)
end

--- @return Dictionary -- <slotId,heroIndex>
function BattleTeamView:GetHeroIndexDict()
    return self.uiHeroSlotView:GetHeroIndexDict()
end

--- @return boolean
function BattleTeamView:IsFull()
    return self.uiHeroSlotView.numberSlotFilled == self.uiHeroSlotView.numberSlot
end

--- @return boolean
function BattleTeamView:CanPlay()
    return self.uiHeroSlotView.numberSlotFilled > 0
end

--- @return boolean
function BattleTeamView:CanFillSlot()
    return self.uiHeroSlotView:CanFillSlot()
end

--- @return void
function BattleTeamView:Show()
    self:_ShowHeroSlotView()
    self:_ShowTeamView()
end

--- @return void
function BattleTeamView:DisableMainHero()
    self.uiTeamView.config.mainHero:SetActive(false)
end

--- @return void
function BattleTeamView:Hide()
    if self.uiHeroSlotView ~= nil then
        self.uiHeroSlotView:ReturnPool()
        self.uiHeroSlotView = nil
    end

    if self.uiTeamView ~= nil then
        self.uiTeamView:ReturnPool()
        self.uiTeamView = nil
    end
end

--- @param position UnityEngine_Vector3
--- @param scale UnityEngine_Vector3
function BattleTeamView:SetSummonerTransform(position, scale)
    self.uiTeamView:SetSummonerTransform(position, scale)
end
