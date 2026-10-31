--- @class UIBattleTextLog
UIBattleTextLog = Class(UIBattleTextLog)

--- @return void
function UIBattleTextLog:Ctor()
    --- @type boolean
    self.isInited = false
    --- @type table
    self.config = {}
    --- @type UnityEngine_GameObject
    self.gameObject = nil

    self:SetPrefabName()
    self:SetGameObject()

    --- @type UnityEngine_Coroutine
    self.autoCoroutine = nil
end

--- @return void
function UIBattleTextLog:SetPrefabName()
    self.prefabName = 'battle_text_log'
    self.uiPoolType = GeneralEffectPoolType.BattleTextLog
end

--- @return UnityEngine_Transform
function UIBattleTextLog:SetGameObject()
    self.gameObject = SmartPool.Instance:CreateGameObject(AssetType.GeneralBattleEffect, self.prefabName)
    self.config.gameObject = self.gameObject
    self.config.transform = self.config.gameObject.transform

    self.config.textLog = self.config.transform:Find("log"):GetComponent(ComponentName.TMPro_TextMeshPro)
    self.config.anim = self.config.gameObject:GetComponent(ComponentName.UnityEngine_Animator)
end

function UIBattleTextLog:ReturnPool()
    self.config.gameObject:SetActive(false)
    SmartPool.Instance:DespawnLuaGameObject(AssetType.GeneralBattleEffect, GeneralEffectPoolType.BattleTextLog, self)
    zg.battleEffectMgr:ReleaseBattleTextLog(self)
    ClientConfigUtils.KillCoroutine(self.autoCoroutine)
end

--- @param isActive boolean
function UIBattleTextLog:SetActive(isActive)
    self.config.gameObject:SetActive(isActive)
    if isActive == true then
        self:AutoDisable()
    end
end

function UIBattleTextLog:AutoDisable()
    ClientConfigUtils.KillCoroutine(self.autoCoroutine)
    self.autoCoroutine = Coroutine.start(function()
        coroutine.waitforseconds(BattleTextLogUtil.LOG_TIME)
        self:ReturnPool()
    end)
end

--- @param clientHero ClientHero
--- @param isCrit boolean
--- @param value number
function UIBattleTextLog:LogDamage(clientHero, isCrit, value)
    self.config.textLog.fontSize = BattleTextLogUtil.NORMAL_FONT_SIZE
    self.config.textLog.text = string.format(BattleTextLogUtil.DAMAGE_FORMAT, math.floor(value))
    self.config.transform.position = clientHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
    self:SetActive(true)
    if isCrit == true then
        self.config.textLog.font = BattleTextLogUtil.CRIT_DAMAGE_FONT_ASSET
        self.config.anim:SetTrigger(BattleTextLogUtil.CRIT_HASH)
    else
        self.config.textLog.font = BattleTextLogUtil.DAMAGE_FONT_ASSET
        self.config.anim:SetTrigger(BattleTextLogUtil.DAMAGE_HASH)

        local signX = self.config.transform.position.x
        if signX >= 0 then signX = 1
        else signX = -1 end

        self.config.transform:DOMoveX(self.config.transform.position.x + signX, 1)
    end
    self.config.textLog:UpdateFontAsset()
end

--- @param clientHero ClientHero
--- @param offsetY number
--- @param value number
function UIBattleTextLog:LogDamageFollow(clientHero, value, offsetY)
    offsetY = offsetY or 0
    self.config.textLog.fontSize = BattleTextLogUtil.FOLLOW_FONT_SIZE
    self.config.textLog.text = string.format(BattleTextLogUtil.DAMAGE_FORMAT, math.floor(value))
    self.config.textLog.font = BattleTextLogUtil.DAMAGE_FONT_ASSET
    self.config.textLog:UpdateFontAsset()

    local position = clientHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
    position.y = position.y + offsetY
    self.config.transform.position = position
    self:SetActive(true)
    self.config.anim:SetTrigger(BattleTextLogUtil.DAMAGE_HASH)

    local signX = self.config.transform.position.x
    if signX >= 0 then signX = 1
    else signX = -1 end

    self.config.transform:DOMoveX(self.config.transform.position.x + signX, 1)
end

--- @param clientHero ClientHero
function UIBattleTextLog:LogMiss(clientHero)
    self.config.textLog.fontSize = BattleTextLogUtil.STATUS_FONT_SIZE
    self.config.textLog.text = BattleTextLogUtil.MISS_FORMAT
    self.config.textLog.font = BattleTextLogUtil.OTHER_FONT_ASSET
    self.config.textLog:UpdateFontAsset()

    self.config.transform.position = clientHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
    self:SetActive(true)
    self.config.anim:SetTrigger(BattleTextLogUtil.MISS_HASH)
end

--- @param clientHero ClientHero
--- @param offsetHeight Number
function UIBattleTextLog:LogBlock(clientHero, offsetHeight)
    offsetHeight = offsetHeight or 0
    self.config.textLog.fontSize = BattleTextLogUtil.STATUS_FONT_SIZE
    self.config.textLog.text = BattleTextLogUtil.BLOCK_FORMAT
    self.config.textLog.font = BattleTextLogUtil.OTHER_FONT_ASSET
    self.config.textLog:UpdateFontAsset()

    self.config.transform.position = clientHero.components:GetAnchorPosition(ClientConfigUtils.HEAD_ANCHOR)
                                + U_Vector3.up * offsetHeight
    self:SetActive(true)
    self.config.anim:SetTrigger(BattleTextLogUtil.MISS_HASH)
end

--- @param clientHero ClientHero
function UIBattleTextLog:LogExecute(clientHero)
    self.config.textLog.fontSize = BattleTextLogUtil.STATUS_FONT_SIZE
    self.config.textLog.text = BattleTextLogUtil.EXECUTE_FORMAT
    self.config.textLog.font = BattleTextLogUtil.EXECUTE_FONT_ASSET
    self.config.textLog:UpdateFontAsset()

    self.config.transform.position = clientHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
    self:SetActive(true)
    self.config.anim:SetTrigger(BattleTextLogUtil.CRIT_HASH)
end

--- @param clientHero ClientHero
function UIBattleTextLog:LogResist(clientHero)
    self.config.textLog.fontSize = BattleTextLogUtil.STATUS_FONT_SIZE
    self.config.textLog.text = BattleTextLogUtil.RESIST_FORMAT
    self.config.textLog.font = BattleTextLogUtil.OTHER_FONT_ASSET
    self.config.textLog:UpdateFontAsset()

    self.config.transform.position = clientHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
    self:SetActive(true)
    self.config.anim:SetTrigger(BattleTextLogUtil.MISS_HASH)
end

--- @param clientHero ClientHero
function UIBattleTextLog:LogResistInstantKill(clientHero)
    self.config.textLog.fontSize = BattleTextLogUtil.STATUS_FONT_SIZE
    self.config.textLog.text = BattleTextLogUtil.RESIST_EXECUTE_FORMAT
    self.config.textLog.font = BattleTextLogUtil.OTHER_FONT_ASSET
    self.config.textLog:UpdateFontAsset()

    self.config.transform.position = clientHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
    self:SetActive(true)
    self.config.anim:SetTrigger(BattleTextLogUtil.MISS_HASH)
end

--- @param clientHero ClientHero
function UIBattleTextLog:LogReflect(clientHero)
    self.config.textLog.fontSize = BattleTextLogUtil.STATUS_FONT_SIZE
    self.config.textLog.text = BattleTextLogUtil.REFLECT_FORMAT
    self.config.textLog.font = BattleTextLogUtil.OTHER_FONT_ASSET

    self.config.textLog:UpdateFontAsset()

    self.config.transform.position = clientHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
    self:SetActive(true)
    self.config.anim:SetTrigger(BattleTextLogUtil.MISS_HASH)
end

--- @param clientHero ClientHero
function UIBattleTextLog:LogGlancing(clientHero)
    self.config.textLog.fontSize = BattleTextLogUtil.STATUS_FONT_SIZE
    self.config.textLog.text = BattleTextLogUtil.GLANCING_FORMAT
    self.config.textLog.font = BattleTextLogUtil.OTHER_FONT_ASSET
    self.config.textLog:UpdateFontAsset()

    self.config.transform.position = clientHero.components:GetAnchorPosition(ClientConfigUtils.HEAD_ANCHOR)
    self:SetActive(true)
    self.config.anim:SetTrigger(BattleTextLogUtil.MISS_HASH)
end

--- @param position UnityEngine_Vector3
--- @param value number
function UIBattleTextLog:LogDamageAtPosition(position, value)
    self.config.textLog.fontSize = BattleTextLogUtil.NORMAL_FONT_SIZE
    self.config.textLog.text = string.format(BattleTextLogUtil.DAMAGE_FORMAT, math.floor(value))
    self.config.textLog.font = BattleTextLogUtil.DAMAGE_FONT_ASSET
    self.config.textLog:UpdateFontAsset()

    self.config.transform.position = position
    self:SetActive(true)
    self.config.anim:SetTrigger(BattleTextLogUtil.DAMAGE_HASH)
end

--- @param clientHero ClientHero
--- @param value number
function UIBattleTextLog:LogHealing(clientHero, value)
    self.config.textLog.fontSize = BattleTextLogUtil.NORMAL_FONT_SIZE
    self.config.textLog.text = string.format(BattleTextLogUtil.HEAL_FORMAT, math.floor(value))
    self.config.textLog.font = BattleTextLogUtil.HEAL_FONT_ASSET
    self.config.textLog:UpdateFontAsset()

    self.config.transform.position = clientHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
    self:SetActive(true)
    self.config.anim:SetTrigger(BattleTextLogUtil.HEAL_HASH)
end

function UIBattleTextLog:Show()

end

return UIBattleTextLog