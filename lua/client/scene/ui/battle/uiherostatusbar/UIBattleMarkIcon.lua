
--- @class UIBattleMarkIcon
UIBattleMarkIcon = Class(UIBattleMarkIcon)

--- @return void
function UIBattleMarkIcon:Ctor()
    --- @type EffectIconElements
    self.config = nil
    self._overStackFormat = "+%d"
    --- @type UnityEngine_GameObject
    self.gameObject = nil
    self:InitConfig()
end

function UIBattleMarkIcon:InitConfig()
    self:SetPrefabName()
    self.gameObject = SmartPool.Instance:CreateGameObject(AssetType.GeneralBattleEffect, self.prefabName)
    self.config = EffectIconElements(self.gameObject)
end

--- @return void
function UIBattleMarkIcon:SetPrefabName()
    self.prefabName = 'battle_mark_icon'
    self.detailPoolType = GeneralEffectPoolType.BattleMarkIcon
end

--- @param overStackValue number
function UIBattleMarkIcon:SetStack(overStackValue)
    self:ShowStack(overStackValue)
end

--- @param effectLogType EffectLogType
function UIBattleMarkIcon:SetIconByType(effectLogType)
    local iconName = string.format("mark_icon_%d", effectLogType)
    self.config.iconImage.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconBuffDebuffs, iconName)
    self.config.iconImage:SetNativeSize()
end

--- @param stackValue number
function UIBattleMarkIcon:ShowOverStack(stackValue)
    self.config.stackText.text = string.format(self._overStackFormat, stackValue)
end

--- @param stackValue number
function UIBattleMarkIcon:ShowStack(stackValue)
    if stackValue > 0 then
        self.config.stackText.text = tostring(stackValue)
    else
        self.config.stackText.text = ""
    end
end

--- @param pos UnityEngine_Vector3
function UIBattleMarkIcon:FixedTextMarkPosition(pos)
    self.config.transStack.anchoredPosition3D = pos
end

--- @param size number
function UIBattleMarkIcon:FixedTextSize(size)
    self.config.stackText.text = size
end

function UIBattleMarkIcon:Release()
    self:ReturnPool()
end

function UIBattleMarkIcon:ReturnPool()
    self:SetActive(false)
    SmartPool.Instance:DespawnLuaGameObject(AssetType.GeneralBattleEffect, self.detailPoolType, self)
    zg.battleEffectMgr:ReleaseUIBattleMarkIcon(self)
end

--- @param parent UnityEngine_Transform
function UIBattleMarkIcon:SetParent(parent)
    self.config.transform:SetParent(parent)
    self.config.transform.localScale = U_Vector3.one
    self:SetActive(true)
end

function UIBattleMarkIcon:SetAsLastSibling()
    self.config.transform:SetAsLastSibling()
end

function UIBattleMarkIcon:SetAsFirstSibling()
    self.config.transform:SetAsFirstSibling()
end

--- @param isActive boolean
function UIBattleMarkIcon:SetActive(isActive)
    self.config.gameObject:SetActive(isActive)
end

return UIBattleMarkIcon