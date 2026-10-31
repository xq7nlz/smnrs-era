--- @class HeroAllUnlockInBound
HeroAllUnlockInBound = Class(HeroAllUnlockInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function HeroAllUnlockInBound:Ctor(buffer, listHeroInventoryId)
    --- @type List
    self.listHeroInventoryId = listHeroInventoryId
    --- @type List
    self.listFailed = List()
    --- @type Dictionary
    self.tabDic = Dictionary()
    local size = buffer:GetByte()
    for i = 1, size do
        local key = buffer:GetByte()
        local value = buffer:GetShort()
        self.tabDic:Add(key, value)
    end
    self:UnlockFeatures()
end

--- @return void
function HeroAllUnlockInBound:UnlockFeatures()
    self.listFailed:Clear()
    if self.listHeroInventoryId == nil or self.listHeroInventoryId:Count() == 0 then
        return
    end

    --- @param k FeatureType
    --- @param v LogicCode
    for k, v in pairs(self.tabDic:GetItems()) do
        if v == LogicCode.SUCCESS then
            if k == FeatureType.CAMPAIGN then
                for _, inventoryId in pairs(self.listHeroInventoryId:GetItems()) do
                    zg.playerData:GetCampaignData().trainingSlotExp:RemoveByReference(inventoryId)
                    break
                end
            elseif k == FeatureType.ARENA then
                ---@type TeamFormationInBound
                local teamFormationInBound = zg.playerData:GetFormationInBound():GetTeamFormationInBound(GameMode.ARENA)
                if teamFormationInBound ~= nil then
                    for _, inventoryId in pairs(self.listHeroInventoryId:GetItems()) do
                        teamFormationInBound:RemoveHeroInventoryId(inventoryId)
                        break
                    end
                end
            elseif k == FeatureType.ARENA_TEAM then
                for _, inventoryId in pairs(self.listHeroInventoryId:GetItems()) do
                    ---@param teamFormationInBound TeamFormationInBound
                    for i, teamFormationInBound in pairs(zg.playerData:GetFormationInBound().arenaTeamDict:GetItems()) do
                        teamFormationInBound:RemoveHeroInventoryId(inventoryId)
                        break
                    end
                end
            elseif k == FeatureType.GUILD_WAR then
                ---@type TeamFormationInBound
                local teamFormationInBound = zg.playerData:GetFormationInBound().teamDict:Get(GameMode.GUILD_WAR)
                if teamFormationInBound then
                    for _, inventoryId in pairs(self.listHeroInventoryId:GetItems()) do
                        teamFormationInBound:RemoveHeroInventoryId(inventoryId)
                        break
                    end
                end
            elseif k == FeatureType.INVENTORY then
                for _, inventoryId in pairs(self.listHeroInventoryId:GetItems()) do
                    --- @type HeroResource
                    local hero = InventoryUtils.GetHeroResourceByInventoryId(inventoryId)
                    if hero.isLock ~= false then
                        hero.isLock = false
                        break
                    end
                end
            elseif k == FeatureType.HERO_LINKING then
                --- @type HeroLinkingInBound
                local linkingInBound = zg.playerData:GetMethod(PlayerDataMethod.HERO_LINKING)
                if linkingInBound then
                    for _, inventoryId in pairs(self.listHeroInventoryId:GetItems()) do
                        linkingInBound:RemoveHeroFromLinking(inventoryId)
                        break
                    end
                end
            elseif k == FeatureType.HERO_LINKING_SUPPORT then
                ---@type PlayerFriendInBound
                local inbound = zg.playerData:GetMethod(PlayerDataMethod.FRIEND)
                if inbound then
                    for _, inventoryId in pairs(self.listHeroInventoryId:GetItems()) do
                        inbound:RemoveSupportHero(inventoryId)
                        break
                    end
                end
            elseif k == FeatureType.DOMAINS then
                ---@type DomainInBound
                local inbound = zg.playerData:GetMethod(PlayerDataMethod.DOMAIN)
                if inbound and inbound.domainCrewInBound then
                    for _, inventoryId in pairs(self.listHeroInventoryId:GetItems()) do
                        if inbound.domainContributeHeroListInBound.listHeroContribute:Count() > 1 then
                            inbound.domainContributeHeroListInBound.listHeroContribute:RemoveByReference(inventoryId)
                            ---@param member DomainsCrewMember
                            for _, member in pairs(inbound.domainCrewInBound.listMember:GetItems()) do
                                if member.playerId == PlayerSettingData.playerId then
                                    ---@param heroResource HeroResource
                                    for i, heroResource in pairs(member.listHero:GetItems()) do
                                        if heroResource.inventoryId == inventoryId then
                                            member.listHero:RemoveByReference(heroResource)
                                            break
                                        end
                                    end
                                end
                            end
                        end
                    end
                elseif inbound then
                    for _, inventoryId in pairs(self.listHeroInventoryId:GetItems()) do
                        if inbound.domainContributeHeroListInBound.listHeroContribute:Count() > 1 then
                            inbound.domainContributeHeroListInBound.listHeroContribute:RemoveByReference(inventoryId)
                            break
                        end
                    end
                end
            elseif k == FeatureType.RAISE_LEVEL then
                ---@type PlayerRaiseLevelInbound
                local inbound = zg.playerData:GetRaiseLevelHero()
                if inbound then
                    for _, inventoryId in pairs(self.listHeroInventoryId:GetItems()) do
                        local slotId = inbound:GetRaisedSlotIdByHeroInventoryId(inventoryId)
                        if slotId ~= nil then
                            ---@type
                            local slotData = inbound:GetRaisedSlot(slotId)
                            local hero = InventoryUtils.GetHeroResourceByInventoryId(inventoryId)
                            hero.heroLevel = slotData.originLevel
                            inbound:RemoveRaisedSlot(slotId, inventoryId)
                            break
                        end
                    end
                end
            end
        else
            self.listFailed:Add(k)
        end
    end
end