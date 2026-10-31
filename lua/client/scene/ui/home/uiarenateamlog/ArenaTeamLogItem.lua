--- @class ArenaTeamLogItem : IconView
ArenaTeamLogItem = Class(ArenaTeamLogItem, IconView)

--- @return void
function ArenaTeamLogItem:Ctor()
    --- @type VipIconView
    self.avatar1 = nil
    --- @type VipIconView
    self.avatar2 = nil
    IconView.Ctor(self)
end

--- @return void
function ArenaTeamLogItem:SetPrefabName()
    self.prefabName = 'arena_team_log_item'
    self.uiPoolType = UIPoolType.ArenaTeamLogItem
end

--- @param transform UnityEngine_Transform
function ArenaTeamLogItem:SetConfig(transform)
    --- @type ArenaTeamLogItemConfig
    self.config = UIBaseConfig(transform)

    self:InitButtons()
end

function ArenaTeamLogItem:InitButtons()
    self.config.buttonLog.onClick:RemoveAllListeners()
    self.config.buttonLog.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if self.onclick then
            self.onclick()
        end
    end)
end

--- @param data {match, isWin : boolean, attacker, defender, onClickDetail}
function ArenaTeamLogItem:SetIconData(data)
    self.config.textBattle.text = tostring(data.match)

    local color = UIUtils.green_dark
    local textResult = LanguageUtils.LocalizeCommon("victory")
    if data.isWin == false then
        color = UIUtils.red_dark
        textResult = LanguageUtils.LocalizeCommon("defeat")
    end
    self.config.textResult.text = UIUtils.SetColorString(color, textResult)

    self:GetAvatar()

    self.avatar1:SetData2(data.attacker.avatar, data.attacker.level)
    self.avatar2:SetData2(data.defender.avatar, data.defender.level)

    self.onclick = data.onClickDetail
end

function ArenaTeamLogItem:GetAvatar()
    if self.avatar1 == nil then
        self.avatar1 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.VipIconView, self.config.attackerAnchor)
    end
    if self.avatar2 == nil then
        self.avatar2 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.VipIconView, self.config.defenderAnchor)
    end
end

function ArenaTeamLogItem:ReturnPool()
    IconView.ReturnPool(self)
    self:ReturnPoolAvatar()
end

function ArenaTeamLogItem:ReturnPoolAvatar()
    if self.avatar1 ~= nil then
        self.avatar1:ReturnPool()
        self.avatar1 = nil
    end
    if self.avatar2 ~= nil then
        self.avatar2:ReturnPool()
        self.avatar2 = nil
    end
end

return ArenaTeamLogItem