--- @class DomainMemberWorldSlot
DomainMemberWorldSlot = Class(DomainMemberWorldSlot)

function DomainMemberWorldSlot:Ctor(transform)
    --- @type DomainMemberWorldSlotConfig
    self.config = UIBaseConfig(transform)

    --- @type VipIconView
    self.vipIconView = nil

    self:InitLocalization()
end

function DomainMemberWorldSlot:InitLocalization()
    self.config.textReady.text = LanguageUtils.LocalizeCommon("ready")
end

function DomainMemberWorldSlot:SetReady(isReady)
    self.config.ready:SetActive(isReady == true)
    self.config.unready:SetActive(isReady == false)
    self.config.glowReady:SetActive(isReady == true)

    if isReady == nil then
        self:ReturnPoolVipIcon()

        self.config.selectSelf:SetActive(false)

        self.config.playerName.text = ""
    end
end

function DomainMemberWorldSlot:SetAvatar(avatar, level, playerId, playerName)
    if self.vipIconView == nil then
        self.vipIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.VipIconView, self.config.avatarAnchor)
    end
    self.vipIconView:SetData2(avatar, level)
    self.config.selectSelf:SetActive(playerId == PlayerSettingData.playerId)
    self.config.playerName.text = playerName
end

function DomainMemberWorldSlot:ReturnPoolVipIcon()
    if self.vipIconView ~= nil then
        self.vipIconView:ReturnPool()
        self.vipIconView = nil
    end
end

function DomainMemberWorldSlot:OnHide()
    self:ReturnPoolVipIcon()
end
