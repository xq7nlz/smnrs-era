require "lua.client.scene.ui.home.uiDomainTeam.DomainMemberWorldSlot"

--- @class DomainTeamWorld
DomainTeamWorld = Class(DomainTeamWorld)

--- @param transform UnityEngine_Transform
function DomainTeamWorld:Ctor(transform)
    --- @type DomainTeamWorldConfig
    self.config = UIBaseConfig(transform)

    --- @type BattleView
    self.battleView = nil

    --- @type List -- HeroSlotWorldFormation[]
    self.listHeroWorldSlot = List()

    UIUtils.SetParent(transform, zgUnity.transform)

    self:InitSlots()
end

function DomainTeamWorld:InitLocalization()
    if self.listHeroWorldSlot then
        --- @param v DomainMemberWorldSlot
        for k, v in pairs(self.listHeroWorldSlot:GetItems()) do
            v:InitLocalization()
        end
    end
end

function DomainTeamWorld:InitSlots()
    self.listHeroWorldSlot = List()
    local root = self.config.worldCanvas.transform
    for i = 1, root.childCount do
        local domainMemberSlot = DomainMemberWorldSlot(root:GetChild(i - 1))
        self.listHeroWorldSlot:Add(domainMemberSlot)
    end
end

function DomainTeamWorld:OnShow()
    self:InitBattleView()
    self:SetActive(true)
end

function DomainTeamWorld:InitBattleView()
    if self.battleView == nil then
        self.battleView = zg.battleMgr:GetBattleView()
        self.battleView:UpdateView()
    end
    self.battleView:ShowBg(true)
    self.battleView:EnableMainCamera(true)
    self.battleView:SetActive(true)
end

function DomainTeamWorld:OnHide()
    self:SetActive(false)
    if self.battleView ~= nil then
        self.battleView:OnHide()
        self.battleView = nil
    end

    for i = 1, self.listHeroWorldSlot:Count() do
        --- @type DomainMemberWorldSlot
        local slot = self.listHeroWorldSlot:Get(i)
        slot:OnHide()
    end
end

function DomainTeamWorld:SetActive(isActive)
    self.config.gameObject:SetActive(isActive)
end

--- @param listMember List
function DomainTeamWorld:ShowListMember(listMember)
    for i = 1, listMember:Count() do
        --- @type DomainsCrewMember
        local member = listMember:Get(i)
        --- @type DomainMemberWorldSlot
        local slot = self.listHeroWorldSlot:Get(i)
        slot:SetReady(member.isReady)
        slot:SetAvatar(member.playerAvatar, member.playerLevel, member.playerId, member.playerName)
    end
    for i = listMember:Count() + 1, self.listHeroWorldSlot:Count() do
        --- @type DomainMemberWorldSlot
        local slot = self.listHeroWorldSlot:Get(i)
        slot:SetReady()
    end
end
