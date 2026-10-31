--- @class HeroSlotWorldFormation
HeroSlotWorldFormation = Class(HeroSlotWorldFormation)

local LOCK_COLOR = U_Color(0.5, 0.5, 0.5, 1)
local COLOR = U_Color(1, 1, 1, 1)

function HeroSlotWorldFormation:Ctor()
    --- @type HeroResource
    self.heroResource = nil
    --- @type PreviewHero
    self.previewHero = nil

    --- @type {isFrontLine, positionId}
    self.positionTable = nil
    --- @func {isFrontLine, positionId}
    self.btnCallbackSelect = nil
    --- @func {isFrontLine, positionId}
    self.btnCallbackRemove = nil
    --- @func {isFrontLine, positionId}
    self.btnCallbackSwap = nil
    --- @func {isFrontLine, positionId}
    self.btnChangeCallback = nil

    --- @func {isFrontLine, positionId}
    self.triggerPointerDown = nil
    --- @func {position}
    self.triggerPointerUp = nil
    --- @func {position}
    self.triggerPointerDrag = nil

    self:InitConfig()
end

function HeroSlotWorldFormation:InitConfig()
    self:SetPrefabName()
    self.gameObject = SmartPool.Instance:CreateGameObject(AssetType.UIPool, self.prefabName)
    self:SetConfig(self.gameObject.transform)
end

function HeroSlotWorldFormation:SetPrefabName()
    self.prefabName = 'hero_slot_world_formation'
    self.uiPoolType = UIPoolType.HeroSlotWorldFormation
end

function HeroSlotWorldFormation:InitLocalization()
    self.config.localizeChange.text = LanguageUtils.LocalizeCommon("change")
end

--- @param transform UnityEngine_Transform
function HeroSlotWorldFormation:SetConfig(transform)
    --- @type HeroSlotWorldFormationConfig
    self.config = UIBaseConfig(transform)
    --- @type PreviewHero
    self.previewHero = PreviewHero(self.config.heroAnchor)
    --- @type Dictionary
    self.imgCharDict = Dictionary()
end

--- @param parent UnityEngine_Transform
--- @param isAttacker boolean
function HeroSlotWorldFormation:Init(parent, isAttacker)
    self.config.transform:SetParent(parent)
    self.isAttacker = isAttacker
    if isAttacker == true then
        self:InitButtonListener()
    end
    self:SetActive(true)
end

function HeroSlotWorldFormation:SetActive(isActive)
    self.gameObject:SetActive(isActive)
end

function HeroSlotWorldFormation:InitButtonListener()
    self.config.buttonRemove.onClick:RemoveAllListeners()
    self.config.buttonRemove.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if self.btnCallbackRemove ~= nil then
            self.btnCallbackRemove(self.positionTable)
        end
        self:OnRemoveSlot()
    end)

    self.config.buttonSwap.onClick:RemoveAllListeners()
    self.config.buttonSwap.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if self.btnCallbackSwap ~= nil then
            self.btnCallbackSwap(self.positionTable)
        end
    end)

    self.config.buttonChange.onClick:RemoveAllListeners()
    self.config.buttonChange.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if self.btnChangeCallback ~= nil then
            self.btnChangeCallback()
        end
    end)

    self.config.buttonSelect.onClick:RemoveAllListeners()
    self.config.buttonSelect.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if self.previewHero:IsHasHero() == true then
            if self.btnCallbackSelect ~= nil then
                self.btnCallbackSelect(self.positionTable)
            end
        end
    end)

    self.config.eventTrigger.triggers:Clear()
    local entryPointerDown = U_EventSystems.EventTrigger.Entry()
    entryPointerDown.eventID = U_EventSystems.EventTriggerType.PointerDown
    entryPointerDown.callback:AddListener(function(data)
        if self.previewHero:IsHasHero() == true then
            if self.triggerPointerDown ~= nil then
                self.triggerPointerDown(self.positionTable)
            end
        end
    end)
    self.config.eventTrigger.triggers:Add(entryPointerDown)

    local entryPointerUp = U_EventSystems.EventTrigger.Entry()
    entryPointerUp.eventID = U_EventSystems.EventTriggerType.PointerUp
    entryPointerUp.callback:AddListener(function(data)
        if self.triggerPointerUp ~= nil then
            self.triggerPointerUp(data.position)
        end
    end)
    self.config.eventTrigger.triggers:Add(entryPointerUp)

    --- calculate and drag slot hero
    --- @type UnityEngine_EventSystems_EventTrigger_Entry
    local entryDrag = U_EventSystems.EventTrigger.Entry()
    entryDrag.eventID = U_EventSystems.EventTriggerType.Drag
    entryDrag.callback:AddListener(function(data)
        if self.triggerPointerDrag ~= nil then
            self.triggerPointerDrag(data.position)
        end
    end)
    self.config.eventTrigger.triggers:Add(entryDrag)
end

--- @param isFlip boolean
function HeroSlotWorldFormation:FlipLeft(isFlip)
    self.isAttacker = not isFlip
    local signFlip = 1
    if isFlip == true then
        signFlip = -1
        self.config.heroAnchor.localEulerAngles = U_Vector3(0, 180, 0)
    else
        self.config.heroAnchor.localEulerAngles = U_Vector3.zero
    end
    self.config.spriteSlotIndex.transform.localPosition = U_Vector3(signFlip * 1.23, 0.381, 0)
    self.config.buffIcon.transform.localEulerAngles = self.config.heroAnchor.localEulerAngles
end

--- @param heroResource HeroResource
function HeroSlotWorldFormation:SetHeroSlot(heroResource, onFinish, allowScale)
    if allowScale == nil then
        allowScale = true
    end
    self.heroResource = heroResource
    if heroResource ~= nil then
        if onFinish ~= nil then
            local onSpawned = function()
                self.previewHero:UpdateLayerByAxisY()
                onFinish()
            end
            self.previewHero:PreviewHeroAsync(heroResource, HeroModelType.Dummy, onSpawned)
        else
            self.previewHero:PreviewHero(heroResource, HeroModelType.Dummy)
            self.previewHero:UpdateLayerByAxisY()
        end
        self.config.txtLevel.text = tostring(heroResource.heroLevel)
        self:EnableTextLevel(true)
        self:ResetButtonSlot()

        --- @type UnityEngine_RectTransform
        local rectFactionBorder = self.config.txtLevel:GetComponent(ComponentName.UnityEngine_RectTransform)
        if heroResource.isBoss == true and allowScale == true then
            self.config.heroAnchor.localScale = U_Vector3.one * 1.5
            rectFactionBorder.anchoredPosition3D = U_Vector3.up * 395
            self.config.txtLevel.transform.position = self.previewHero.clientHero.components.headAnchor.position
        else
            self.config.heroAnchor.localScale = U_Vector3.one * 0.8
            rectFactionBorder.anchoredPosition3D = U_Vector3.up * 270
        end

        local factionId = ClientConfigUtils.GetFactionIdByHeroId(heroResource.heroId)
        self.config.factionBorder.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.formationNumber, factionId)
    else
        self.previewHero:DespawnHero()
        self:EnableTextLevel(false)
    end
    self:EnableBtnSelect(true)

    if self:IsModifiable() or self.isAttacker == false then
        self:EnableLockSlot(false)
    else
        self:EnableLockSlot(true)
    end
end


--- @param heroResource HeroResource
function HeroSlotWorldFormation:SetSummonerSlot(heroResource)
    self:SetHeroSlot(heroResource)
    self:EnableBtnSelect(false)

    local buffIcon = ResourceLoadUtils.LoadTexture(ResourceLoadUtils.iconBattleEffect, "icon_main_characater_base", ComponentName.UnityEngine_Sprite)
    if buffIcon ~= nil then
        self:SetIconBase(buffIcon)
        self:EnableLockSlot(false)
        self:EnableBuffIcon(true)
    else
        self:EnableBuffIcon(false)
    end
    self:EnableTextLevel(false)
end

function HeroSlotWorldFormation:OnRemoveSlot()
    self:EnableTextLevel(false)
    self:EnableBtnRemove(false)
    self:EnableBtnSwap(false)
    self:EnableBtnSelect(true)
    self.previewHero:DespawnHero()
end

function HeroSlotWorldFormation:OnSelectSlot()
    if self.btnCallbackSelect ~= nil then
        self.btnCallbackSelect(self.positionTable)
    end
end

--- @param isEnable boolean
function HeroSlotWorldFormation:SetEnable(isEnable)
    self.config.gameObject:SetActive(isEnable)
end

--- @param isEnable boolean
function HeroSlotWorldFormation:EnableTextLevel(isEnable)
    self.config.txtLevel.gameObject:SetActive(isEnable)
end

--- @param isEnable boolean
--- @param slotIndex number
function HeroSlotWorldFormation:EnableTextSlot(isEnable, slotIndex)
    self.config.spriteSlotIndex.enabled = isEnable
    if isEnable == true then
        local spriteSlotName
        if self.positionTable.isFrontLine then
            spriteSlotName = string.format("f_%d", slotIndex)
        else
            spriteSlotName = string.format("b_%d", slotIndex)
        end
        self.config.spriteSlotIndex.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.formationNumber, spriteSlotName)
    end
end

--- @param isEnable boolean
--- @param value number
function HeroSlotWorldFormation:EnableBuffStat(isEnable, value)
    self.config.iconBuff.gameObject:SetActive(isEnable)
    if isEnable then
        local iconBuffName = "b_buff"
        if self.positionTable.isFrontLine then
            iconBuffName = "f_buff"
        end
        self.config.iconBuff.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.formationNumber, iconBuffName)

        local strValue = tostring(value) .. "%"
        local stringLen = string.len(strValue)
        for i = 1, stringLen do
            local char = string.sub(strValue, i, i)
            self:SetImgCharacter(i, char)
        end
    end
end

--- @param char string
function HeroSlotWorldFormation:SetImgCharacter(index, char)
    if index > self.config.buffStatAnchor.childCount then
        assert(false)
    end
    --- @type UnityEngine_SpriteRenderer
    local imgChar = self.imgCharDict:Get(index)
    if imgChar == nil then
        imgChar = self.config.buffStatAnchor:GetChild(index - 1):GetComponent(ComponentName.UnityEngine_SpriteRenderer)
        self.imgCharDict:Add(index, imgChar)
    end
    local charName
    if self.positionTable.isFrontLine then
        charName = string.format("f_%s", char)
    else
        charName = string.format("b_%s", char)
    end
    imgChar.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.formationNumber, charName)
end

--- @param position UnityEngine_Vector3
--- @param isFrontLine boolean
--- @param position number
function HeroSlotWorldFormation:SetPosition(position, isFrontLine, positionId)
    self.config.transform.position = position

    if isFrontLine == nil or positionId == nil then
        self:EnableBuffIcon(false)
        return
    end

    self.positionTable = {}
    self.positionTable.isFrontLine = isFrontLine
    self.positionTable.positionId = positionId

    --- @type UnityEngine_Sprite
    local buffIcon = ResourceLoadUtils.LoadTexture(ResourceLoadUtils.iconBattleEffect,
            isFrontLine == true and "icon_hp_team_up" or "icon_attack_team_up",
            ComponentName.UnityEngine_Sprite)
    self:SetIconBase(buffIcon)
    self.config.highlight.enabled = false
end

--- @param spriteBg UnityEngine_Sprite
function HeroSlotWorldFormation:FixedBgSlot(spriteBg)
    self:SetIconBase(spriteBg)
    self:EnableBuffIcon(true)
end

--- @param isEnable boolean
function HeroSlotWorldFormation:EnableBtnSelect(isEnable)
    self.config.buttonSelect.gameObject:SetActive(isEnable and self:IsModifiable())
end

--- @param isEnable boolean
function HeroSlotWorldFormation:EnableBtnRemove(isEnable)
    self.config.buttonRemove.gameObject:SetActive(isEnable and self:IsModifiable())
end


--- @param isEnable boolean
function HeroSlotWorldFormation:EnableBtnSwap(isEnable)
    self.config.buttonSwap.gameObject:SetActive(isEnable and self:IsModifiable())
end

--- @param isEnable boolean
function HeroSlotWorldFormation:EnableBtnChange(isEnable)
    self.config.buttonChange.gameObject:SetActive(isEnable)
    if isEnable then
        LanguageUtils.CheckInitLocalize(self, HeroSlotWorldFormation.InitLocalization)
    end
end

--- @param isEnable boolean
function HeroSlotWorldFormation:EnableBuffIcon(isEnable)
    self.config.buffIcon.gameObject:SetActive(isEnable)
end

--- @param iconBase UnityEngine_Sprite
function HeroSlotWorldFormation:SetIconBase(iconBase)
    if iconBase ~= nil then
        self.config.buffIcon.sprite = iconBase
    end
end

function HeroSlotWorldFormation:ResetButtonSlot()
    self:EnableBtnSelect(true)
    self:EnableBtnRemove(false)
    self:EnableBtnSwap(false)
    self:EnableLinking(false)
    self:EnableBtnChange(false)
end

--- @param heightY number
--- @param offsetLayer number
function HeroSlotWorldFormation:UpdateLayer(heightY, offsetLayer)
    self.previewHero:UpdateLayerByAxisY(heightY, offsetLayer)
end

--- @return UnityEngine_Vector3
function HeroSlotWorldFormation:GetPosition()
    return self.config.transform.position
end

--- @param mainCam UnityEngine_Camera
function HeroSlotWorldFormation:SetMainCamera(mainCam)
    self.config.worldCanvas.worldCamera = mainCam
end

function HeroSlotWorldFormation:ReturnPool()
    self:SetActive(false)
    SmartPool.Instance:DespawnLuaGameObject(AssetType.UIPool, UIPoolType.HeroSlotWorldFormation, self)
    self.previewHero:OnHide()
    self:ResetButtonSlot()

    self:EnableLockSlot(false)
end

--- @param isEnable boolean
function HeroSlotWorldFormation:EnableLinking(isEnable)
    self.config.highlight.enabled = isEnable
end

--- @param isEnable boolean
function HeroSlotWorldFormation:EnableModification(isEnable)
    self.config.rayCaster.enabled = isEnable
end

--- @return boolean
function HeroSlotWorldFormation:IsModifiable()
    return self.heroResource == nil or self.heroResource.inventoryId ~= nil
end

function HeroSlotWorldFormation:EnableLockSlot(isLock)
    self.config.buffIcon.enabled = not isLock
    self.config.lock.enabled = isLock
end

--- @param isEnable boolean
function HeroSlotWorldFormation:DisableRemoveButton()
    self.config.buttonRemove.gameObject:SetActive(false)
end


return HeroSlotWorldFormation