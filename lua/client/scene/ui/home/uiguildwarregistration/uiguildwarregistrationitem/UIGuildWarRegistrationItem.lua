require "lua.client.scene.ui.common.BattleTeamView"

--- @class UIGuildWarRegistrationItem : IconView
UIGuildWarRegistrationItem = Class(UIGuildWarRegistrationItem, IconView)

function UIGuildWarRegistrationItem:Ctor()
    --- @type BattleTeamView
    self.battleTeamView = nil
    IconView.Ctor(self)
end

function UIGuildWarRegistrationItem:SetPrefabName()
    self.prefabName = 'guild_war_registration_item'
    self.uiPoolType = UIPoolType.GuildWarRegistrationItem
end

function UIGuildWarRegistrationItem:InitLocalization()

end

function UIGuildWarRegistrationItem:_InitButtonListener()

end

--- @param transform UnityEngine_Transform
function UIGuildWarRegistrationItem:SetConfig(transform)
    --- @type UIGuildWarRegistrationItemConfig
    self.config = UIBaseConfig(transform)

    self:_InitButtonListener()
end

--- @param guildWarPlayerInBound GuildWarPlayerInBound
--- @param guildRole GuildRole
function UIGuildWarRegistrationItem:SetData(guildWarPlayerInBound, guildRole)
    self.config.iconLeader:SetActive(guildRole == GuildRole.LEADER)
    self.config.iconViceLeader:SetActive(guildRole == GuildRole.SUB_LEADER)
    self.config.memberName.text = guildWarPlayerInBound.compactPlayerInfo.playerName

    self:ShowTeamInfo(guildWarPlayerInBound.compactPlayerInfo)
    self:DisableButtons()
    self:SetBattleTeamViewPosition(true)

    self.config.textCp.text = tostring(guildWarPlayerInBound:GetPower())
end

--- @param isEnable boolean
function UIGuildWarRegistrationItem:EnableIconTick(isEnable)
    self.config.iconTick:SetActive(isEnable)
    if isEnable == true then
        self.config.medalInfo:SetActive(false)
        self:SetBattleTeamViewPosition(false)
    end
end

--- @param isEnable boolean
function UIGuildWarRegistrationItem:EnableMedalInfo(isEnable)
    self.config.medalInfo:SetActive(isEnable)
    if isEnable == true then
        self.config.iconTick:SetActive(false)
        self:SetBattleTeamViewPosition(false)
    end
end

--- @param positionIndex number
--- @param medalCount number
function UIGuildWarRegistrationItem:SetMedalData(positionIndex, medalCount)
    self.config.textSlot.text = tostring(positionIndex)
    self.config.textMedal.text = tostring(medalCount)
    self:EnableMedalInfo(true)
end

--- @param compactPlayerInfo OtherPlayerInfoInBound
function UIGuildWarRegistrationItem:ShowTeamInfo(compactPlayerInfo)
    --- @type SummonerBattleInfo
    local summonerBattleInfo = compactPlayerInfo.summonerBattleInfoInBound.summonerBattleInfo
    --- @type BattleTeamInfo
    local battleTeamInfo = compactPlayerInfo:CreateBattleTeamInfo(compactPlayerInfo.playerLevel)

    self.battleTeamView = BattleTeamView(self.config.defenderTeamAnchor)
    self.battleTeamView:Show()

    self.battleTeamView:SetDataDefender(UIPoolType.HeroIconView, battleTeamInfo)
    self.battleTeamView.uiTeamView:SetSummonerInfo(summonerBattleInfo)
    self.battleTeamView.uiTeamView:ActiveBuff(false)
    self.battleTeamView.uiTeamView:ActiveLinking(false)

    self.battleTeamView:SetSummonerTransform(U_Vector3(-525, 82, 0), U_Vector3.one * 1.1)
end

--- @param isCenterPos boolean
function UIGuildWarRegistrationItem:SetBattleTeamViewPosition(isCenterPos)
    if isCenterPos == true then
        self.config.formationShow.anchoredPosition3D = U_Vector3.zero
    else
        self.config.formationShow.anchoredPosition3D = U_Vector3(40, 0, 0)
    end
end

function UIGuildWarRegistrationItem:ReturnPool()
    IconView.ReturnPool(self)
    if self.battleTeamView ~= nil then
        self.battleTeamView:Hide()
        self.battleTeamView = nil
    end
end

--- @param listener function
function UIGuildWarRegistrationItem:AddOnClickSetUpListener(listener)
    self.config.buttonSetUp.gameObject:SetActive(true)
    self.config.buttonSetUp.onClick:RemoveAllListeners()
    self.config.buttonSetUp.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        listener()
    end)
end

--- @param listener function
function UIGuildWarRegistrationItem:AddOnClickSwapListener(listener)
    self.config.buttonSwap.gameObject:SetActive(true)
    self.config.buttonSwap.onClick:RemoveAllListeners()
    self.config.buttonSwap.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        listener()
    end)
end

function UIGuildWarRegistrationItem:DisableButtons()
    self.config.buttonSwap.gameObject:SetActive(false)
    self.config.buttonSetUp.gameObject:SetActive(false)
end

return UIGuildWarRegistrationItem