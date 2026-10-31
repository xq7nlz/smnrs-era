require "lua.client.scene.ui.home.uiFormation2.worldFormation.WorldTeamFormation"
require "lua.client.scene.ui.home.uiFormation2.dungeonWorldFormation.DungeonWorldFormationModel"
require "lua.client.scene.ui.home.uiFormation2.heroSlotWorldFormation.HeroSlotWorldFormation"

--- @class RaiseLevelWorldFormation
RaiseLevelWorldFormation = Class(RaiseLevelWorldFormation)

--- @param transform UnityEngine_Transform
function RaiseLevelWorldFormation:Ctor(transform)
    --- @type RaiseLevelFormationConfig
    self.config = UIBaseConfig(transform)
    self.model = DungeonWorldFormationModel()

    --- @type BattleViewRaiseLevel
    self.battleView = nil
    --- @type WorldTeamFormation
    self.attackerDungeonWorldFormation = nil

    --- @type List -- HeroSlotWorldFormation[]
    self.listHeroWorldSlot = List()
    --- @type table
    ---@type List
    self.listHeroResource = List()
    ---@type PlayerRaiseLevelInbound
    self.playerRaiseLevelInbound = zg.playerData:GetRaiseLevelHero()
    UIUtils.SetParent(transform, zgUnity.transform)
end

function RaiseLevelWorldFormation:OnCreate()
    self:InitLocalization()
    self:ConfigTeamSlots()
end

function RaiseLevelWorldFormation:UpdateHeroResources()
    self.playerRaiseLevelInbound = zg.playerData:GetRaiseLevelHero()
    local pentaGram = self.playerRaiseLevelInbound.pentaGram
    self.listHeroResource:Clear()
    for i = 1, pentaGram.pentaGramHeroList:Count() do
        local heroResource = InventoryUtils.GetHeroResourceByInventoryId(pentaGram.pentaGramHeroList:Get(i))
        self:SetHeroAtSlot(i, heroResource)
    end
    local isEnable = pentaGram.pentaGramHeroList:Count() >= ResourceMgr.GetRaiseHeroConfig():GetBaseConfig():GetPentaSlot()
    self.config.centerPosition:SetActive(isEnable)
end

function RaiseLevelWorldFormation:InitLocalization()
end

function RaiseLevelWorldFormation:InitBattleView()
    if self.battleView == nil then
        self.battleView = zg.battleMgr:GetBattleViewRaiseLevel()
        self.battleView:ShowBgAnchor("dungeon_back_anchor_top_raise_level", "dungeon_back_anchor_bot")
        self.battleView:UpdateView()
    end
    local cam = self.battleView:GetMainCamera()
    for i = 1, self.listHeroWorldSlot:Count() do
        --- @type HeroSlotWorldFormation
        local heroSlotWorldFormation = self.listHeroWorldSlot:Get(i)
        heroSlotWorldFormation:SetMainCamera(cam)
    end
end

function RaiseLevelWorldFormation:ConfigTeamSlots()
    self.listSlotPosition = List()
    self.listSlotPosition:Add(U_Vector3(-8.3, -2.29, 0))
    self.listSlotPosition:Add(U_Vector3(-6.42, -3.4, 0))
    self.listSlotPosition:Add(U_Vector3(0.3, -2.29, 0))
    self.listSlotPosition:Add(U_Vector3(-1.36, -3.4, 0))
    self.listSlotPosition:Add(U_Vector3(-4, -4, 0))
end

--- @return UnityEngine_Vector3
--- @param slotId number
function RaiseLevelWorldFormation:GetSlotPositionById(slotId)
    return self.listSlotPosition:Get(slotId)
end

function RaiseLevelWorldFormation:InitSlots()
    self.listHeroWorldSlot = List()
    local spriteBg = ResourceLoadUtils.LoadTexture(ResourceLoadUtils.iconBattleEffect, "icon_dungeon_formation", ComponentName.UnityEngine_Sprite)
    for i = 1, 5 do
        local slot = self:GetMoreHeroWorldSlot()
        local slotLocalPos = self:GetSlotPositionById(i)
        local pos = self.config.transform.position + slotLocalPos
        slot:SetPosition(pos, true, i)
        slot:FixedBgSlot(spriteBg)
    end
end

--- @param slotId number
--- @param heroResource HeroResource
function RaiseLevelWorldFormation:SetHeroAtSlot(slotId, heroResource)
    self.model:SetHeroResourceBySlot(slotId, heroResource)

    --- @type HeroSlotWorldFormation
    local heroWorldSlot = self.listHeroWorldSlot:Get(slotId)
    heroWorldSlot:SetHeroSlot(heroResource)
end

function RaiseLevelWorldFormation:OnShow()
    self:InitSlots()
    self:ShowBackground()
    self:SetActive(true)
    self:UpdateHeroResources()
end

function RaiseLevelWorldFormation:ShowBackground()
    self:InitBattleView()
    self.battleView:EnableMainCamera(true)
    self.battleView:FixBackAnchorTopLocalPos(U_Vector3.zero)
    self.battleView:SetActive(true)
end

function RaiseLevelWorldFormation:OnHide()
    self:SetActive(false)
    if self.battleView ~= nil then
        self.battleView:OnHide()
        self.battleView = nil
    end
    for i = 1, self.listHeroWorldSlot:Count() do
        --- @type HeroSlotWorldFormation
        local slot = self.listHeroWorldSlot:Get(i)
        slot:ReturnPool()
    end
    self.listHeroWorldSlot = List()
end

--- @param isAttackerTeam boolean
--- @param positionTable {isFrontLine, positionId}
function RaiseLevelWorldFormation:CallbackSelectHero(isAttackerTeam, positionTable)
    self.model.selectedSlot = positionTable
    self.attackerDungeonWorldFormation:EnableSwapOnOtherSlot(positionTable)
end

--- @param slotId {slotId}
function RaiseLevelWorldFormation:CallbackRemoveHero(slotId)
    self.model:SetHeroResourceBySlot(slotId, nil)
    --- @type HeroSlotWorldFormation
    local slot = self.listHeroWorldSlot:Get(slotId)
    slot:SetHeroSlot(nil)
end

function RaiseLevelWorldFormation:ResetButtonSlot()
    self.attackerDungeonWorldFormation:ResetButtonSlot()
end

--- @return HeroSlotWorldFormation
function RaiseLevelWorldFormation:GetMoreHeroWorldSlot()
    --- @type HeroSlotWorldFormation
    local script = SmartPool.Instance:SpawnLuaGameObject(AssetType.UIPool, UIPoolType.HeroSlotWorldFormation)
    script:Init(self.config.transform)
    script:FlipLeft(false)
    script:EnableTextLevel(false)
    script:EnableTextSlot(false)
    script:EnableBuffStat(false)
    self.listHeroWorldSlot:Add(script)
    script:SetEnable(true)
    return script
end

function RaiseLevelWorldFormation:SetActive(isActive)
    self.config.gameObject:SetActive(isActive)
end