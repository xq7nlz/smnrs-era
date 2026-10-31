require "lua.client.scene.ui.home.uiFormation2.worldFormation.WorldTeamFormation"
require "lua.client.scene.ui.home.uiFormation2.dungeonWorldFormation.DungeonWorldFormationModel"
require "lua.client.scene.ui.home.uiFormation2.heroSlotWorldFormation.HeroSlotWorldFormation"

--- @class DungeonWorldFormation
DungeonWorldFormation = Class(DungeonWorldFormation)

--- @param transform UnityEngine_Transform
function DungeonWorldFormation:Ctor(transform)
    --- @type DungeonWorldFormationConfig
    self.config = UIBaseConfig(transform)
    self.model = DungeonWorldFormationModel()

    --- @type BattleView
    self.battleView = nil
    --- @type WorldTeamFormation
    self.attackerDungeonWorldFormation = nil

    --- @type List -- HeroSlotWorldFormation[]
    self.listHeroWorldSlot = List()

    --- @type table {slotId}
    self.removeCallback = nil
    --- @type table
    self.saveCallback = nil
    UIUtils.SetParent(transform, zgUnity.transform)
end

function DungeonWorldFormation:OnCreate()
    self.config.buttonSave.onClick:RemoveAllListeners()
    self.config.buttonSave.onClick:AddListener(function()
        if self.saveCallback ~= nil then
            self.saveCallback()
        end
    end)
    self:InitLocalization()
end

function DungeonWorldFormation:InitLocalization()
    self.config.localizeSave.text = LanguageUtils.LocalizeCommon("save")
end

function DungeonWorldFormation:InitBattleView()
    if self.battleView == nil then
        self.battleView = zg.battleMgr:GetBattleView()
        self.battleView:ShowBgAnchor("dungeon_back_anchor_top", "dungeon_back_anchor_bot")
        self.battleView:UpdateView()
    end
    local cam = zg.battleMgr:GetBattleView():GetMainCamera()
    for i = 1, self.listHeroWorldSlot:Count() do
        --- @type HeroSlotWorldFormation
        local heroSlotWorldFormation = self.listHeroWorldSlot:Get(i)
        heroSlotWorldFormation:SetMainCamera(cam)
    end
end

function DungeonWorldFormation:InitSlots()
    self.listHeroWorldSlot = List()
    local spriteBg = ResourceLoadUtils.LoadTexture(ResourceLoadUtils.iconBattleEffect, "icon_dungeon_formation", ComponentName.UnityEngine_Sprite)
    for i = 1, 5 do
        local slot = self:GetMoreHeroWorldSlot()
        local slotLocalPos = self.model:GetSlotPositionById(i)
        local pos = self.config.transform.position + slotLocalPos
        slot:SetPosition(pos, true, i)
        slot:FixedBgSlot(spriteBg)
    end
end

--- @param slotId number
--- @param heroResource HeroResource
function DungeonWorldFormation:SetHeroAtSlot(slotId, heroResource)
    self.model:SetHeroResourceBySlot(slotId, heroResource)

    --- @type HeroSlotWorldFormation
    local heroWorldSlot = self.listHeroWorldSlot:Get(slotId)
    heroWorldSlot:SetHeroSlot(heroResource)
end

--- @param slotId boolean
function DungeonWorldFormation:RemoveHeroAtSlot(slotId)
    self.model:SetHeroResourceBySlot(slotId, nil)

    --- @type HeroSlotWorldFormation
    local heroWorldSlot = self.listHeroWorldSlot:Get(slotId)
    heroWorldSlot:SetHeroSlot(nil)
end

function DungeonWorldFormation:OnShow()
    self:InitSlots()
    self:ShowBackground()
    self:SetActive(true)
end

function DungeonWorldFormation:ShowBackground()
    self:InitBattleView()
    self.battleView:EnableMainCamera(true)
    self.battleView:FixBackAnchorTopLocalPos(U_Vector3.zero)
    self.battleView:SetActive(true)
end

function DungeonWorldFormation:OnHide()
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
function DungeonWorldFormation:CallbackSelectHero(isAttackerTeam, positionTable)
    self.model.selectedSlot = positionTable
    self.attackerDungeonWorldFormation:EnableSwapOnOtherSlot(positionTable)
end

--- @param slotId {slotId}
function DungeonWorldFormation:CallbackRemoveHero(slotId)
    if self.removeCallback ~= nil then
        self.removeCallback(slotId)
    end
    self.model:SetHeroResourceBySlot(slotId, nil)
    --- @type HeroSlotWorldFormation
    local slot = self.listHeroWorldSlot:Get(slotId)
    slot:SetHeroSlot(nil)
end

function DungeonWorldFormation:ResetButtonSlot()
    self.attackerDungeonWorldFormation:ResetButtonSlot()
end

--- @return HeroSlotWorldFormation
function DungeonWorldFormation:GetMoreHeroWorldSlot()
    --- @type HeroSlotWorldFormation
    local script = SmartPool.Instance:SpawnLuaGameObject(AssetType.UIPool, UIPoolType.HeroSlotWorldFormation)
    script:Init(self.config.transform)
    script.btnCallbackSelect = function(positionTable)
        local slotId = positionTable.positionId
        self:CallbackRemoveHero(slotId)
    end
    script:FlipLeft(false)
    script:EnableTextLevel(false)
    script:EnableTextSlot(false)
    script:EnableBuffStat(false)
    self.listHeroWorldSlot:Add(script)
    script:SetEnable(true)
    return script
end

function DungeonWorldFormation:SetActive(isActive)
    self.config.gameObject:SetActive(isActive)
end