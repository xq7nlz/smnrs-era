--- @class GuildWarDefenseWorldBase
GuildWarDefenseWorldBase = Class(GuildWarDefenseWorldBase)

function GuildWarDefenseWorldBase:Ctor()
    --- @type GuildWarDefenseWorldBaseConfig
    self.config = nil
    --- @type function
    self.callbackSelect = nil
    ---@type UIBarPercentView
    self.pointBar = nil

    self:InitConfig()
end

function GuildWarDefenseWorldBase:InitConfig()
    self:SetPrefabName()
    self.gameObject = SmartPool.Instance:CreateGameObject(AssetType.UIPool, self.prefabName)
    self:SetConfig(self.gameObject.transform)
end

function GuildWarDefenseWorldBase:SetPrefabName()
    self.prefabName = 'guild_war_defense_world_base'
    self.uiPoolType = UIPoolType.GuildWarDefenseWorldBase
end

--- @param transform UnityEngine_Transform
function GuildWarDefenseWorldBase:SetConfig(transform)
    --- @type GuildWarDefenseWorldBaseConfig
    self.config = UIBaseConfig(transform)
    self.pointBar = UIBarPercentView(self.config.barPercent)
    self.config.buttonSelect.onClick:AddListener(function ()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if self.callbackSelect ~= nil and self.isSelectable == true then
            self.callbackSelect()
        end
    end)
end

--- @param parent UnityEngine_Transform
function GuildWarDefenseWorldBase:Init(parent)
    self.config.transform:SetParent(parent)

    self.config.tagSlot.gameObject:SetActive(false)
    self.config.medal:SetActive(false)

    self.config.transform.localPosition = U_Vector3.zero
    self:SetActive(true)

    self.config.worldCanvas.overrideSorting = true
end

function GuildWarDefenseWorldBase:SetActive(isActive)
    self.gameObject:SetActive(isActive)
end

--- @param slotIndex number
--- @param elo number
function GuildWarDefenseWorldBase:SetBaseData(isAlly, slotIndex, elo)
    self.config.textSlotIndex.text = tostring(slotIndex)
    self.config.textMedal.text = tostring(elo)

    self.config.tagSlot.anchoredPosition3D = U_Vector3(0, 153, 0)
    self.config.tagSlot.gameObject:SetActive(true)
    self.config.medal:SetActive(true)

    self.config.barPercent.gameObject:SetActive(false)
    self.config.towerAnchor:SetActive(false)
    self.config.base:SetActive(true)

    self:SetRotationBySide(isAlly)
end

function GuildWarDefenseWorldBase:SetRotationBySide(isAlly)
    local color = isAlly and UIUtils.ALLY_COLOR or UIUtils.OPPONENT_COLOR
    local colorBar = isAlly and UIUtils.RECORD_WIN or UIUtils.RECORD_LOSE
    local rotate = U_Vector3.zero
    if isAlly == true then
        rotate.y = 180
    end
    self.config.playerName.color = color
    self.config.bgBossHp.color = colorBar
    self.config.allyFrag:SetActive(isAlly)
    self.config.opponentFrag:SetActive(not isAlly)
    self.config.towerSprite.transform.localEulerAngles = rotate
end

--- @param slotIndex number
--- @param guildWarPlayerInBound GuildWarPlayerInBound
function GuildWarDefenseWorldBase:SetMemberBaseData(slotIndex, guildWarPlayerInBound, point)
    self.config.playerName.text = guildWarPlayerInBound.compactPlayerInfo.playerName
    self.pointBar:SetText(tostring(point))
    self.config.textSlotIndex.text = tostring(slotIndex)

    self.config.tagSlot.anchoredPosition3D = U_Vector3(60, 120, 0)
    self.config.tagSlot.gameObject:SetActive(true)
    self.config.medal:SetActive(false)
end

--- @param isEnable boolean
function GuildWarDefenseWorldBase:EnableHighlightArrow(isEnable)
    self.config.arrowHighlight:SetActive(isEnable)
    if isEnable then
        self:SetLayerId(ClientConfigUtils.FRONT_BATTLE_LAYER_ID)
    else
        self:SetLayerId(ClientConfigUtils.BACKGROUND_LAYER_ID)
    end
end

--- @param layerId number
function GuildWarDefenseWorldBase:SetLayerId(layerId)
    self.config.worldCanvas.sortingLayerID = layerId
    self.config.towerSprite.sortingLayerID = layerId
end

--- @param sprite UnityEngine_Sprite
function GuildWarDefenseWorldBase:SetTowerImage(sprite)
    self.config.towerSprite.sprite = sprite
    self.config.towerAnchor:SetActive(true)

    self.config.base:SetActive(false)
end

function GuildWarDefenseWorldBase:SetTowerState(isLeftSide, position, healthPercent)
    local sprite = ClientConfigUtils.GetGuildWarTowerSprite(isLeftSide, position, healthPercent)
    self.pointBar:SetPercent(healthPercent)
    self.config.barPercent.gameObject:SetActive(true)
    self:SetTowerImage(sprite)

    local listChildren = self.config.towerSprite.transform.childCount
    for i = 1, listChildren do
        self.config.towerSprite.transform:GetChild(i - 1).gameObject:SetActive(false)
    end
    if healthPercent > 0 and healthPercent < 1 then
        local towerType = ClientConfigUtils.GetGuildWarTowerTypeByPosition(position)
        self.config.towerSprite.transform:GetChild(towerType - 1).gameObject:SetActive(true)
    end
end

function GuildWarDefenseWorldBase:OnPointerDown()
    self.isSelectable = true
end

function GuildWarDefenseWorldBase:OnPointerUp()

end

function GuildWarDefenseWorldBase:OnBeginDrag()
    self.isSelectable = false
    self:OnPointerUp()
end

return GuildWarDefenseWorldBase