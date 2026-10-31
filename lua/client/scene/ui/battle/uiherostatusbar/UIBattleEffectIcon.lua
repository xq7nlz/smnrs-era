require "lua.client.scene.ui.battle.uiHeroStatusBar.EffectIconElements"

--- @class UIBattleEffectIcon
UIBattleEffectIcon = Class(UIBattleEffectIcon)

--- @return void
function UIBattleEffectIcon:Ctor(anchor)
    --- @type EffectIconElements
    self.config = nil
    --- @type number
    self.stack = 0
    --- @type boolean
    self.isInited = false

    self._overStackFormat = "+%d"
    self._effectIconName = "effect_icon_%d_isBuff_%s"
    --- @type UnityEngine_GameObject
    self.gameObject = nil

    if anchor == nil then
        self:InitConfig()
    else
        self.config = EffectIconElements(anchor.gameObject)
    end
end

function UIBattleEffectIcon:InitConfig()
    self:SetPrefabName()
    self.gameObject = SmartPool.Instance:CreateGameObject(AssetType.GeneralBattleEffect, self.prefabName)
    self.config = EffectIconElements(self.gameObject)
end

--- @return void
function UIBattleEffectIcon:SetPrefabName()
    self.prefabName = 'battle_effect_icon'
    self.detailPoolType = GeneralEffectPoolType.BattleEffectIcon
end

--- @return number
function UIBattleEffectIcon:GetStack()
    return self.stack
end

--- @param overStackValue number
function UIBattleEffectIcon:SetStack(overStackValue)
    self.stack = overStackValue
    self:ShowStack(overStackValue)
    self:SetAsFirstSibling()
end

--- @param stackValue number
function UIBattleEffectIcon:ShowOverStack(stackValue)
    self.config.stackText.text = string.format(self._overStackFormat, stackValue)
end

--- @param stackValue number
function UIBattleEffectIcon:ShowStack(stackValue)
    if stackValue > 1 then
        self.config.stackText.text = tostring(stackValue)
    else
        self.config.stackText.text = ""
    end
end

--- @param effectLogType EffectLogType
--- @param isBuff boolean
function UIBattleEffectIcon:ShowIcon(effectLogType, isBuff)
    local iconName = ""
    if effectLogType then
        iconName = string.format(self._effectIconName, effectLogType, isBuff == true and "True" or "False")
    else
        iconName = "+5"
    end
    self.config.gameObject.name = iconName
    self.config.iconImage.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconBuffDebuffs, iconName)
    self.config.iconImage:SetNativeSize()
    self:SetStack(1)
end

function UIBattleEffectIcon:Release()
    self:ReturnPool()
end

function UIBattleEffectIcon:ReturnPool()
    self:SetActive(false)
    --SmartPool.Instance:DespawnLuaGameObject(AssetType.GeneralBattleEffect, self.detailPoolType, self)
    --zg.battleEffectMgr:ReleaseUIBattleEffectIcon(self)
end

--- @param parent UnityEngine_Transform
function UIBattleEffectIcon:SetParent(parent)
    self.config.transform:SetParent(parent)
    self.config.transform.localScale = U_Vector3.one
    self:SetActive(true)
end

function UIBattleEffectIcon:SetAsLastSibling()
    self.config.transform:SetAsLastSibling()
end

function UIBattleEffectIcon:SetAsFirstSibling()
    self.config.transform:SetAsFirstSibling()
end

--- @param isActive boolean
function UIBattleEffectIcon:SetActive(isActive)
    self.config.gameObject:SetActive(isActive)
end

return UIBattleEffectIcon