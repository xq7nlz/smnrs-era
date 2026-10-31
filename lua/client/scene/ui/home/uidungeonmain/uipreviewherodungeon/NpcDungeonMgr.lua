require "lua.client.scene.ui.home.uiDungeonMain.uiPreviewHeroDungeon.NpcDungeonSeller"

--- @class NpcDungeonMgr
NpcDungeonMgr = Class(NpcDungeonMgr)

--- @param parent UnityEngine_Transform
function NpcDungeonMgr:Ctor(parent)
    self.parent = parent
    --- @type NpcDungeonSeller
    self.npc = nil
    --- @type number
    self.shopType = nil
    --- @type boolean
    self.isShowing = false
    ---@type table
    self.npcDict = {}
end

function NpcDungeonMgr:GetNpc(callback)
    --- @type NpcDungeonSeller
    local npc = self.npcDict[self.shopType]
    if npc == nil then
        npc = NpcDungeonSeller(self.shopType)
        self.npcDict[self.shopType] = npc
        npc:SetConfig(self.parent, function()
            callback(npc)
        end)
    else
        callback(npc)
    end
end

function NpcDungeonMgr:ShowNpc()
    --- @param npc NpcDungeonSeller
    local onNpcLoaded = function(npc)
        self.npc = npc
        self.npc:Show()
        self.npc:PlayAnim()
        self.isShowing = true
    end
    self:GetNpc(onNpcLoaded)
end

function NpcDungeonMgr:HideNpc()
    if self.npc == nil then
        return
    end
    self.npc:Hide()
    self.npc = nil
    self.isShowing = false
end

--- @return void
--- @param shopType number
function NpcDungeonMgr:OnShow(shopType)
    if self.shopType ~= shopType then
        self:HideNpc()
    end
    if self.isShowing == false then
        self.shopType = shopType
        self:ShowNpc()
    end
end

function NpcDungeonMgr:OnHide()
    self:HideNpc()
end