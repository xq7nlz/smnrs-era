require "lua.client.core.network.playerData.summoner.SummonerSkillInBound"

--- @class PlayerSummonerInBound
PlayerSummonerInBound = Class(PlayerSummonerInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function PlayerSummonerInBound:ReadBuffer(buffer)
    ---@type number
    self.exp = buffer:GetLong()
    ---@type number
    self.star = buffer:GetByte()
    ---@type number
    self.summonerId = buffer:GetByte()
    ---@type number
    local size = buffer:GetByte()
    ---@type Dictionary  --<SummonerId, SummonerSkillInBound>
    self.summonerSkills = Dictionary()
    for i = 1, size do
        self.summonerSkills:Add(buffer:GetByte(), SummonerSkillInBound(buffer))
    end
    zg.playerData:GetFormationInBound():ReadBuffer(buffer)

    self:SetSummonerId()
end

---@return List
function PlayerSummonerInBound:GetTierBySkillId(summonerId, skillId)
    local tier = 1
    ---@type SummonerSkillInBound
    local summonerSkill = self.summonerSkills:Get(summonerId)
    if summonerSkill ~= nil then
        tier = summonerSkill.skillTiers:Get(skillId)
    end
    return tier
end

---@return List
function PlayerSummonerInBound:GetListSkillBySummonerId(_summonerId)
    local summonerId = _summonerId or self.summonerId
    local list = List()
    if self.star == 3 then
        list:Add(3)
    else
        ---@type SummonerSkillInBound
        local summonerSkill = self.summonerSkills:Get(summonerId)
        for i = 1, 4 do
            local skill = nil
            if summonerSkill ~= nil and summonerSkill.skillTiers ~= nil then
                skill = summonerSkill.skillTiers:Get(i)
            end
            list:Add(ClientConfigUtils.GetStarByTier(skill, self.star))
        end
    end
    return list
end

---@return List
function PlayerSummonerInBound:SetSkillSummoner(summonerId, skillId, tier, callbackSuccess)
    local onReceived = function(result)
        local onSuccess = function()
            ---@type SummonerSkillInBound
            local summonerSkill = self.summonerSkills:Get(summonerId)
            if summonerSkill == nil then
                summonerSkill = SummonerSkillInBound()
                self.summonerSkills:Add(summonerId, summonerSkill)
            end
            summonerSkill.skillTiers:Add(skillId, tier)
            if callbackSuccess ~= nil then
                callbackSuccess()
            end
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, SmartPoolUtils.LogicCodeNotification)
    end
    NetworkUtils.Request(OpCode.SUMMONER_SKILL_TIER_SELECT, UnknownOutBound.CreateInstance(PutMethod.Byte, summonerId, PutMethod.Byte, skillId, PutMethod.Byte, tier), onReceived)
end

function PlayerSummonerInBound:SetSummonerId()
    local currentExp = InventoryUtils.Get(ResourceType.SummonerExp, 0)
    if currentExp ~= self.exp then
        InventoryUtils.Add(ResourceType.SummonerExp, 0, self.exp - currentExp)
    end
    if self.star > 3 and self.summonerId < 1 then
        self.summonerId = 1
    end
end

function PlayerSummonerInBound:IsNotiEvolve()
    return ResourceMgr.GetMainCharacterConfig():IsCanEvolve(self.star)
end

function PlayerSummonerInBound:IsCanEvolve()
    ---@type HeroEvolveConfig
    local heroEvolveConfig = ResourceMgr.GetHeroMenuConfig():GetHeroEvolveConfig()
    return self.star < heroEvolveConfig.summonerMaxStar
end

--- @return void
function PlayerSummonerInBound:ToString()
    return LogUtils.ToDetail(self)
end