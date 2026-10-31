--- @class GuildDungeonWorldView : BgWorldView
GuildDungeonWorldView = Class(GuildDungeonWorldView, BgWorldView)

GuildDungeonWorldView.STAGE_PASS = 0
GuildDungeonWorldView.STAGE_BATTLE = 1
GuildDungeonWorldView.STAGE_LOCK = 2

--- @param transform UnityEngine_Transform
--- @param view UIGuildDungeonView
function GuildDungeonWorldView:Ctor(transform, view)
    BgWorldView.Ctor(self, transform)
    --- @type UIGuildDungeonView
    self.view = view
    --- @type Dictionary
    self.standDict = Dictionary()
end

--- @param transform UnityEngine_Transform
function GuildDungeonWorldView:InitConfig(transform)
    --- @type GuildDungeonWorldConfig
    self.config = UIBaseConfig(transform)
end

function GuildDungeonWorldView:SetActive(isActive)
    self.config.gameObject:SetActive(isActive)
end

function GuildDungeonWorldView:Hide()
    self:SetActive(false)
    self:HideAllStands()
end

function GuildDungeonWorldView:HideAllStands()
    --- @param v GuildDungeonBossStand
    for _, v in pairs(self.standDict:GetItems()) do
        v:ReturnPool()
    end
    self.standDict = Dictionary()
end

function GuildDungeonWorldView:Show()
    self.standDict = Dictionary()
    self:SetActive(true)
end

--- @return GuildDungeonBossStand
--- @param posIndex number
--- @param stage number
--- @param heroResource HeroResource
--- @param status boolean
function GuildDungeonWorldView:SetStageHeroAtPos(posIndex, stage, heroResource, status)
    --- @type GuildDungeonBossStand
    local stand = self.standDict:Get(stage)
    if stand == nil then
        stand = self:GetMoreStandByStage(stage)
    end
    stand:SetStageStatus(stage, status)
    stand:ShowHero(heroResource)
    stand:SetPosition(self:GetIndexPosition(posIndex))
    stand:SetActive(true)
    return stand
end

--- @param stage number
--- @param heroResource HeroResource
--- @param stageStatus number
function GuildDungeonWorldView:SetStandView(stage, heroResource, stageStatus)
    --- @type GuildDungeonBossStand
    local stand = self.standDict:Get(stage)
    if stand ~= nil then
        stand:SetStageStatus(stage, stageStatus)
        if stand.heroResource == nil then
            stand:ShowHero(heroResource)
        end
    end
end

--- @return GuildDungeonBossStand
--- @param stage number
function GuildDungeonWorldView:GetMoreStandByStage(stage)
    --- @type GuildDungeonBossStand
    local stand = SmartPool.Instance:SpawnLuaGameObject(AssetType.UIPool, UIPoolType.GuildDungeonBossStand)
    self.standDict:Add(stage, stand)
    stand:SetActive(true)
    return stand
end

--- @param stage number
function GuildDungeonWorldView:RemoveStand(stage)
    --- @type GuildDungeonBossStand
    local stand = self.standDict:Get(stage)
    if stand ~= nil then
        stand:ReturnPool()
        self.standDict:RemoveByKey(stage)
    end
end

--- @param fromIndex number
--- @param toIndex number
--- @param onStartMove function
--- @param onEndMove function
function GuildDungeonWorldView:MoveStandPos(stage, fromIndex, toIndex, onStartMove, onEndMove)
    --- @type GuildDungeonBossStand
    local stand = self.standDict:Get(stage)
    if stand == nil and toIndex ~= fromIndex and stage > 0 then
        stand = self:GetMoreStandByStage(stage)
    end
    if stand == nil then
        onStartMove(nil)
        onEndMove(nil)
        return
    end
    local startPos = self:GetIndexPosition(fromIndex)
    local endPos = self:GetIndexPosition(toIndex)
    stand:SetPosition(startPos)
    stand:SetActive(true)
    onStartMove(stand)

    Coroutine.start(function()
        coroutine.yield(nil)
        local onComplete = function()
            onEndMove(stand)
        end
        stand:DoMove(startPos, endPos, 0.15, onComplete)
    end)
end

--- @param index number
function GuildDungeonWorldView:GetIndexPosition(index)
    --- @type UnityEngine_Vector3
    local pos = U_Vector3.zero
    if math.abs(index) >= 2 then
        pos.x = index * 6
    else
        pos.x = index * 4.5
    end
    if index == 0 then
        pos.y = -0.2
    end
    return pos
end