require "lua.client.core.network.playerData.formation.HeroFormationInBound"

--- @class TeamFormationInBound
TeamFormationInBound = Class(TeamFormationInBound)

--- @return void
function TeamFormationInBound:Ctor()
    --- @type number
    self.summonerId = nil
    --- @type number
    self.formationId = nil
    --- @type List --<HeroFormationInBound>
    self.frontLine = List()
    --- @type List --<HeroFormationInBound>
    self.backLine = List()
    --- @type List
    self.listSlotLock = List()
    ---@type DefenseFormationConfig
    self.defenseFormation = nil
end

--- @return Dictionary
---@param list List
function TeamFormationInBound:GetHeroPositionDict(list)
    local dict = Dictionary()
    ---@param v HeroFormationInBound
    for _, v in ipairs(list:GetItems()) do
        dict:Add(v.positionId, v.heroInventoryId)
    end
    return dict
end

--- @return Dictionary
function TeamFormationInBound:GetFrontLineDict()
    return self:GetHeroPositionDict(self.frontLine)
end

--- @return Dictionary
function TeamFormationInBound:GetBackLineDict()
    return self:GetHeroPositionDict(self.backLine)
end

--- @return boolean
--- @param team TeamFormationInBound
function TeamFormationInBound:Equal(team)
    local equal = false
    local dictFrontLine = self:GetFrontLineDict()
    local dictBackLine = self:GetBackLineDict()
    if team == nil then
        if dictFrontLine:Count() == 0 and dictBackLine:Count() == 0 then
            equal = true
        end
    else
        if self.summonerId == team.summonerId then
            local dictFrontLineTeam = team:GetFrontLineDict()
            local dictBackLineTeam = team:GetBackLineDict()
            if self.summonerId == team.summonerId and dictFrontLine:Count() == dictFrontLineTeam:Count() and dictBackLine:Count() == dictBackLineTeam:Count() then
                local equalFrontLine = true
                for i, v in pairs(dictFrontLine:GetItems()) do
                    if dictFrontLineTeam:Get(i) ~= v then
                        equalFrontLine = false
                        break
                    end
                end
                if equalFrontLine == true then
                    equal = true
                    for i, v in pairs(dictBackLine:GetItems()) do
                        if dictBackLineTeam:Get(i) ~= v then
                            equal = false
                            break
                        end
                    end
                end
            end
        end
    end
    return equal
end

--- @return void
function TeamFormationInBound:SetDefaultTeam()
    ---@type PlayerSummonerInBound
    local summoner = zg.playerData:GetMethod(PlayerDataMethod.SUMMONER)
    self.summonerId = summoner.summonerId
    self.formationId = 4
end

--- @return void
function TeamFormationInBound:ValidateSummonerId()
    ---@type PlayerSummonerInBound
    local summoner = zg.playerData:GetMethod(PlayerDataMethod.SUMMONER)
    if summoner.star <= 3 then
        if self.summonerId > 0 then
            self.summonerId = 0
        end
    else
        if self.summonerId == 0 then
            if summoner.summonerId > 0 then
                self.summonerId = summoner.summonerId
            else
                self.summonerId = 1
            end
        end
    end
end

--- @return void
function TeamFormationInBound:IsContainHeroInFormation()
    return self.backLine:Count() > 0 or self.frontLine:Count() > 0 or (self.defenseFormation ~= nil and self.defenseFormation:IsContainHero() == true)
end

--- @return TeamFormationInBound
---@param team TeamFormationInBound
function TeamFormationInBound.Clone(team)
    ---@type TeamFormationInBound
    local teamFormation = TeamFormationInBound()

    if team ~= nil then
        teamFormation.summonerId = team.summonerId
        teamFormation.formationId = team.formationId
        for _, v in pairs(team.frontLine:GetItems()) do
            teamFormation.frontLine:Add(v)
        end
        for _, v in pairs(team.backLine:GetItems()) do
            teamFormation.backLine:Add(v)
        end
    else
        teamFormation:SetDefaultTeam()
    end
    return teamFormation
end

--- @return boolean
function TeamFormationInBound:CheckHeroId(listHeroResource)
    ---@param v HeroFormationInBound
    for _, v in pairs(self.frontLine:GetItems()) do
        if InventoryUtils.GetHeroResourceByInventoryId(v.heroInventoryId, listHeroResource) == nil then
            self:RemoveHeroInventoryId(v.heroInventoryId)
        end
    end
    ---@param v HeroFormationInBound
    for _, v in pairs(self.backLine:GetItems()) do
        if InventoryUtils.GetHeroResourceByInventoryId(v.heroInventoryId, listHeroResource) == nil then
            self:RemoveHeroInventoryId(v.heroInventoryId)
        end
    end
end

--- @return boolean
--- @param heroInventoryId number
function TeamFormationInBound:IsContainHeroInventoryId(heroInventoryId)
    ---@param v HeroFormationInBound
    for _, v in pairs(self.frontLine:GetItems()) do
        if v.heroInventoryId == heroInventoryId then
            return true, v.positionId
        end
    end
    ---@param v HeroFormationInBound
    for _, v in pairs(self.backLine:GetItems()) do
        if v.heroInventoryId == heroInventoryId then
            --- @type FormationData
            local formationData = ResourceMgr.GetServiceConfig():GetHeroes():GetFormationData(self.formationId)
            return true, v.positionId + formationData.frontLine
        end
    end
    return false, nil
end

--- @param defenseFormationConfig DefenseFormationConfig
function TeamFormationInBound:SetDefenseFormationConfig(defenseFormationConfig)
    self.defenseFormation = defenseFormationConfig
    if self.defenseFormation ~= nil then
        --- @type FormationData
        local formationData = ResourceMgr.GetServiceConfig():GetHeroes():GetFormationData(self.formationId)
        for i = self.frontLine:Count(), 1, -1 do
            ---@type HeroFormationInBound
            local heroFormationInBound = self.frontLine:Get(i)
            if self.defenseFormation.dictHeroSlot:Get(heroFormationInBound.positionId) > 0 then
                self.frontLine:RemoveByIndex(i)
            end
        end
        for i = self.backLine:Count(), 1, -1 do
            ---@type HeroFormationInBound
            local heroFormationInBound = self.backLine:Get(i)
            if self.defenseFormation.dictHeroSlot:Get(heroFormationInBound.positionId + formationData.frontLine) > 0 then
                self.backLine:RemoveByIndex(i)
            end
        end
    end
end

--- @return List
function TeamFormationInBound:GetListHeroId()
    ---@type List
    local list = List()
    ---@param v HeroFormationInBound
    for _, v in pairs(self.frontLine:GetItems()) do
        if v.heroInventoryId > 0 then
            local heroResource = InventoryUtils.GetHeroResourceByInventoryId(v.heroInventoryId)
            if heroResource ~= nil and list:IsContainValue(heroResource.heroId) == false then
                list:Add(heroResource.heroId)
            end
        end
    end
    ---@param v HeroFormationInBound
    for _, v in pairs(self.backLine:GetItems()) do
        if v.heroInventoryId > 0 then
            local heroResource = InventoryUtils.GetHeroResourceByInventoryId(v.heroInventoryId)
            if heroResource ~= nil and list:IsContainValue(heroResource.heroId) == false then
                list:Add(heroResource.heroId)
            end
        end
    end
    return list
end

--- @return List
function TeamFormationInBound:GetListHero()
    ---@type List
    local list = List()
    ---@param v HeroFormationInBound
    for _, v in pairs(self.frontLine:GetItems()) do
        if v.heroInventoryId > 0 then
            local heroResource = InventoryUtils.GetHeroResourceByInventoryId(v.heroInventoryId)
            if heroResource ~= nil and list:IsContainValue(heroResource.heroId) == false then
                list:Add(heroResource)
            end
        end
    end
    ---@param v HeroFormationInBound
    for _, v in pairs(self.backLine:GetItems()) do
        if v.heroInventoryId > 0 then
            local heroResource = InventoryUtils.GetHeroResourceByInventoryId(v.heroInventoryId)
            if heroResource ~= nil and list:IsContainValue(heroResource.heroId) == false then
                list:Add(heroResource)
            end
        end
    end
    return list
end

--- @return boolean, number
--- @param heroInventoryId number
function TeamFormationInBound:RemoveHeroInventoryId(heroInventoryId)
    ---@param v HeroFormationInBound
    for i, v in ipairs(self.frontLine:GetItems()) do
        if v.heroInventoryId == heroInventoryId then
            self.frontLine:RemoveByIndex(i)
            return true, v.positionId
        end
    end
    ---@param v HeroFormationInBound
    for i, v in ipairs(self.backLine:GetItems()) do
        if v.heroInventoryId == heroInventoryId then
            self.backLine:RemoveByIndex(i)
            return false, v.positionId
        end
    end
end

--- @return boolean, number
--- @param heroInventoryId number
function TeamFormationInBound:CheckHeroInventoryId(heroInventoryId)
    ---@param v HeroFormationInBound
    for i, v in ipairs(self.frontLine:GetItems()) do
        if v.heroInventoryId == heroInventoryId then
            return true
        end
    end
    ---@param v HeroFormationInBound
    for i, v in ipairs(self.backLine:GetItems()) do
        if v.heroInventoryId == heroInventoryId then
            return true
        end
    end
    return false
end

--- @param hero {isFrontLine, positionId}
function TeamFormationInBound:RemoveHeroPosition(hero)
    if hero.isFrontLine == true then
        ---@param v HeroFormationInBound
        for i, v in ipairs(self.frontLine:GetItems()) do
            if v.positionId == hero.positionId then
                self.frontLine:RemoveByIndex(i)
                return true
            end
        end
    else
        ---@param v HeroFormationInBound
        for i, v in ipairs(self.backLine:GetItems()) do
            if v.positionId == hero.positionId then
                self.backLine:RemoveByIndex(i)
                return true
            end
        end
    end
end

--- @param hero {isFrontLine, positionId}
function TeamFormationInBound:GetHeroPosition(hero)
    if hero.isFrontLine == true then
        ---@param v HeroFormationInBound
        for i, v in ipairs(self.frontLine:GetItems()) do
            if v.positionId == hero.positionId then
                return self.frontLine:Get(i)
            end
        end
    else
        ---@param v HeroFormationInBound
        for i, v in ipairs(self.backLine:GetItems()) do
            if v.positionId == hero.positionId then
                return self.backLine:Get(i)
            end
        end
    end
end

--- @return void
--- @param hero1 {isFrontLine, positionId}
--- @param hero2 {isFrontLine, positionId}
function TeamFormationInBound:SwapHero(hero1, hero2)
    ---@type Dictionary
    local dictHeroFormation = self:GetDictHeroFormationInBound()
    --- @type FormationData
    local formationData = ResourceMgr.GetServiceConfig():GetHeroes():GetFormationData(self.formationId)
    local getHeroId = function(heroFormation)
        local heroId
        if heroFormation.isFrontLine then
            heroId = dictHeroFormation:Get(heroFormation.positionId)
        else
            heroId = dictHeroFormation:Get(heroFormation.positionId + formationData.frontLine)
        end
        return heroId
    end
    local getPosInDict = function(heroFormation)
        local position
        if heroFormation.isFrontLine then
            position = heroFormation.positionId
        else
            position = heroFormation.positionId + formationData.frontLine
        end
        return position
    end
    local heroId1 = getHeroId(hero1)
    local heroId2 = getHeroId(hero2)
    local position1 = getPosInDict(hero1)
    local position2 = getPosInDict(hero2)
    if heroId1 ~= nil then
        dictHeroFormation:Add(position2, heroId1)
    elseif dictHeroFormation:IsContainKey(position2) then
        dictHeroFormation:RemoveByKey(position2)
    end
    if heroId2 ~= nil then
        dictHeroFormation:Add(position1, heroId2)
    elseif dictHeroFormation:IsContainKey(position1) then
        dictHeroFormation:RemoveByKey(position1)
    end
    self.frontLine, self.backLine = self:Get2ListHeroFormationInBound(dictHeroFormation)
end

--- @return Dictionary
function TeamFormationInBound:GetDictHeroFormationInBound()
    ---@type List
    local dict = Dictionary()
    --- @type FormationData
    local formationData = ResourceMgr.GetServiceConfig():GetHeroes():GetFormationData(self.formationId)
    ---@param v HeroFormationInBound
    for _, v in ipairs(self.frontLine:GetItems()) do
        dict:Add(v.positionId, v.heroInventoryId)
    end
    ---@param v HeroFormationInBound
    for _, v in ipairs(self.backLine:GetItems()) do
        dict:Add(v.positionId + formationData.frontLine, v.heroInventoryId)
    end
    --XDebug.Log(LogUtils.ToDetail(dict:GetItems()))
    return dict
end

--- @return List
--- @param dict Dictionary
function TeamFormationInBound:Get2ListHeroFormationInBound(dict)
    ---@type List
    local list1 = List()
    ---@type List
    local list2 = List()
    --- @type FormationData
    local formationData = ResourceMgr.GetServiceConfig():GetHeroes():GetFormationData(self.formationId)
    ---@param v number
    for i, v in pairs(dict:GetItems()) do
        if i > formationData.frontLine then
            list2:Add(HeroFormationInBound.CreateInstance(i - formationData.frontLine, v))
        else
            list1:Add(HeroFormationInBound.CreateInstance(i, v))
        end
    end
    return list1, list2
end

--- @return void
--- @param _formationId number
function TeamFormationInBound:ChangeFormationId(_formationId)
    ---@type Dictionary
    local dictHeroFormation = self:GetDictHeroFormationInBound()
    self.formationId = _formationId
    self.frontLine, self.backLine = self:Get2ListHeroFormationInBound(dictHeroFormation)
end

--- @return boolean, number
--- @param heroInventoryId number
function TeamFormationInBound:AddHeroInventoryId(heroInventoryId)
    local isFrontLine
    local position
    ---@type Dictionary
    local dictHeroFormation = self:GetDictHeroFormationInBound()
    --- @type FormationData
    local formationData = ResourceMgr.GetServiceConfig():GetHeroes():GetFormationData(self.formationId)
    for i = 1, formationData.backLine + formationData.frontLine do
        if dictHeroFormation:IsContainKey(i) == false and (self.defenseFormation == nil
                or self.defenseFormation.dictHeroSlot:IsContainKey(i) == false or self.defenseFormation.dictHeroSlot:Get(i) <= 0) then
            dictHeroFormation:Add(i, heroInventoryId)
            if i > formationData.frontLine then
                isFrontLine = false
                position = i - formationData.frontLine
            else
                isFrontLine = true
                position = i
            end
            break
        end
    end
    self.frontLine, self.backLine = self:Get2ListHeroFormationInBound(dictHeroFormation)
    return isFrontLine, position
end

--- @return boolean
function TeamFormationInBound:IsFull()
    --- @type FormationData
    local formationData = ResourceMgr.GetServiceConfig():GetHeroes():GetFormationData(self.formationId)
    local countLock = 0
    if self.defenseFormation ~= nil then
        for i, v in pairs(self.defenseFormation.dictHeroSlot:GetItems()) do
            if v > 0 then
                countLock = countLock + 1
            end
        end
    end
    return self.frontLine:Count() + self.backLine:Count() >= formationData.frontLine + formationData.backLine - countLock
end

--- @return number
function TeamFormationInBound:HeroCount()
    return self.frontLine:Count() + self.backLine:Count()
end

--- @return number
function TeamFormationInBound:MaxFormationHeroCount()
    --- @type FormationData
    local formationData = ResourceMgr.GetServiceConfig():GetHeroes():GetFormationData(self.formationId)
    local countLock = 0
    if self.defenseFormation ~= nil then
        for _, v in pairs(self.defenseFormation.dictHeroSlot:GetItems()) do
            if v > 0 then
                countLock = countLock + 1
            end
        end
    end
    return formationData.frontLine + formationData.backLine - countLock
end

--- @return string
function TeamFormationInBound:ToString()
    local front = ""
    for i, v in ipairs(self.frontLine:GetItems()) do
        front = front .. v:ToString()
    end

    local back = ""
    for i, v in ipairs(self.backLine:GetItems()) do
        back = back .. v:ToString()
    end
    return string.format("forId: %d, front: %s, back: %s", self.formationId, front, back)
end

--- @return TeamFormationInBound
--- @param buffer UnifiedNetwork_ByteBuf
function TeamFormationInBound.CreateByBuffer(buffer)
    local data = TeamFormationInBound()

    data.summonerId = buffer:GetByte()
    data.formationId = buffer:GetByte()

    local sizeOfFrontLine = buffer:GetByte()
    data.frontLine = List()
    for i = 1, sizeOfFrontLine do
        ---@type HeroFormationInBound
        local heroFormationInBound = HeroFormationInBound.CreateByBuffer(buffer)
        ---@type HeroResource
        local heroResource = InventoryUtils.GetHeroResourceByInventoryId(heroFormationInBound.heroInventoryId)
        if heroResource ~= nil then
            data.frontLine:Add(heroFormationInBound)
        end
    end

    local sizeOfBackLine = buffer:GetByte()
    data.backLine = List()
    for i = 1, sizeOfBackLine do
        ---@type HeroFormationInBound
        local heroFormationInBound = HeroFormationInBound.CreateByBuffer(buffer)
        ---@type HeroResource
        local heroResource = InventoryUtils.GetHeroResourceByInventoryId(heroFormationInBound.heroInventoryId)
        if heroResource ~= nil then
            data.backLine:Add(heroFormationInBound)
        end
    end
    data:ValidateSummonerId()

    --XDebug.Log(data:ToString())
    return data
end

--- @return TeamFormationInBound
--- @param buffer UnifiedNetwork_ByteBuf
function TeamFormationInBound.CreateByBufferWithHeroResourceList(buffer, heroResourceList)
    local data = TeamFormationInBound()

    data.summonerId = buffer:GetByte()
    data.formationId = buffer:GetByte()
    local sizeOfFrontLine = buffer:GetByte()
    data.frontLine = List()
    for i = 1, sizeOfFrontLine do
        ---@type HeroFormationInBound
        local heroFormationInBound = HeroFormationInBound.CreateByBuffer(buffer)
        ---@type HeroResource
        local heroResource = InventoryUtils.GetHeroResourceByInventoryId(heroFormationInBound.heroInventoryId, heroResourceList)
        if heroResource ~= nil then
            data.frontLine:Add(heroFormationInBound)
        end
    end

    local sizeOfBackLine = buffer:GetByte()
    data.backLine = List()
    for i = 1, sizeOfBackLine do
        ---@type HeroFormationInBound
        local heroFormationInBound = HeroFormationInBound.CreateByBuffer(buffer)
        ---@type HeroResource
        local heroResource, index = InventoryUtils.GetHeroResourceByInventoryId(heroFormationInBound.heroInventoryId, heroResourceList)
        if heroResource ~= nil then
            data.backLine:Add(heroFormationInBound)
        end
    end
    data:ValidateSummonerId()

    --XDebug.Log(data:ToString())
    return data
end

--- @return TeamFormationInBound
--- @param teamData UIFormationTeamData
function TeamFormationInBound.CreateByFormationTeamData(teamData)
    local data = TeamFormationInBound()

    data.summonerId = teamData.summonerId
    data.formationId = teamData.formationId

    data.frontLine = List()
    data.backLine = List()
    --- @param hero {heroResource:HeroResource, isFrontLine : boolean, position:number}
    for i, hero in ipairs(teamData.heroList:GetItems()) do
        if hero.isFrontLine then
            data.frontLine:Add(HeroFormationInBound.CreateInstance(hero.position, hero.heroResource.inventoryId))
        else
            data.backLine:Add(HeroFormationInBound.CreateInstance(hero.position, hero.heroResource.inventoryId))
        end
    end

    return data
end

function TeamFormationInBound:GetListHeroPrefabName()
    --- @type List
    local listPrefabName = List()
    --- @param lineDict Dictionary
    local checkLine = function(lineDict)
        --- @param v HeroFormationInBound
        for k, v in pairs(lineDict:GetItems()) do
            local heroResource = InventoryUtils.GetHeroResourceByInventoryId(v.heroInventoryId)
            if heroResource then
                local skinName = ClientConfigUtils.GetSkinNameByHeroResource(heroResource)
                local prefabName = string.format("hero_%d_%s", heroResource.heroId, skinName)
                if listPrefabName:IsContainValue(prefabName) == false then
                    listPrefabName:Add(prefabName)
                end
            end
        end
    end
    checkLine(self.frontLine)
    checkLine(self.backLine)
    return listPrefabName
end

--- @return number
function TeamFormationInBound:GetCountHero()
    ---@type number
    local count = 0
    ---@param v HeroFormationInBound
    for _, v in pairs(self.frontLine:GetItems()) do
        if v.heroInventoryId > 0 then
            local heroResource = InventoryUtils.GetHeroResourceByInventoryId(v.heroInventoryId)
            if heroResource ~= nil then
                count = count + 1
            end
        end
    end
    ---@param v HeroFormationInBound
    for _, v in pairs(self.backLine:GetItems()) do
        if v.heroInventoryId > 0 then
            local heroResource = InventoryUtils.GetHeroResourceByInventoryId(v.heroInventoryId)
            if heroResource ~= nil then
                count = count + 1
            end
        end
    end
    return count
end

--- @return boolean
--- @param listHeroInfo Dictionary {inventoryId, (hpPercent ,power) }
function TeamFormationInBound:KazetsuTrialCheckHeroDead(listHeroInfo)
    local heroInfo = {}
    ---@param v HeroFormationInBound
    for _, v in pairs(self.frontLine:GetItems()) do
        heroInfo = listHeroInfo:Get(v.heroInventoryId)
        if heroInfo ~= nil then
            if heroInfo.hpPercent <= 0 then
                self:RemoveHeroInventoryId(v.heroInventoryId)
            end
        end
    end
    ---@param v HeroFormationInBound
    for _, v in pairs(self.backLine:GetItems()) do
        heroInfo = listHeroInfo:Get(v.heroInventoryId)
        if heroInfo ~= nil then
            if heroInfo.hpPercent <= 0 then
                self:RemoveHeroInventoryId(v.heroInventoryId)
            end
        end
    end
end