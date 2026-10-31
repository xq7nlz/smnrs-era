--- @class NotificationFragment
NotificationFragment = Class(NotificationFragment)

NotificationFragment.KEY_FRAGMENT_NOTI = "fragment_noti"

---@type {heroFragment, artifactFragment}
NotificationFragment.data = nil

--- @return void
---@param uiNoti UnityEngine_GameObject
function NotificationFragment.CheckNotificationFragment(uiNoti)
    local check = function()
        local noti = false
        ---@type List
        local listArtifactFragment = InventoryUtils.GetListResource(ResourceType.ItemFragment)
        if noti == false then
            for i, v in pairs(listArtifactFragment:GetItems()) do
                if NotificationFragment.CheckNotificationFragmentType(ResourceType.ItemFragment, v) == true then
                    noti = true
                    break
                end
            end
        end

        if noti == false then
            ---@type List
            local listHeroFragment = InventoryUtils.GetListResource(ResourceType.HeroFragment)
            for i, v in pairs(listHeroFragment:GetItems()) do
                if NotificationFragment.CheckNotificationFragmentType(ResourceType.HeroFragment, v) == true then
                    noti = true
                    break
                end
            end
        end

        if uiNoti ~= nil then
            uiNoti:SetActive(noti)
        end
    end

    if NotificationFragment.data ~= nil then
        check()
    else
        NotificationFragment.LoadFromServer(check, function ()
            if uiNoti ~= nil then
                uiNoti:SetActive(false)
            end
        end)
    end
end

function NotificationFragment.IsCanShowSoftTutFragment()
    return (UIBaseView.IsActiveTutorial() == false) and (zg.playerData.remoteConfig.softTutFragment == nil) and (NotificationFragment.GetNotiHeroFragment() ~= nil)
end

function NotificationFragment.GetNotiHeroFragment()
    ---@type List
    local listHeroFragment = InventoryUtils.GetListResource(ResourceType.HeroFragment)
    for i, v in pairs(listHeroFragment:GetItems()) do
        local countCurrent = NotificationFragment.GetNumberCanSummon(ResourceType.HeroFragment, v)
        if  countCurrent > 0 then
            return v
        end
    end
    return nil
end

--- @return void
function NotificationFragment.LoadFromServer(callbackSuccess, callbackFailed)
    NotificationFragment.data = zg.playerData.remoteConfig.fragment
    if NotificationFragment.data == nil then
        NotificationFragment.data = {}
    end
    if callbackSuccess ~= nil then
        callbackSuccess()
    end
    --RemoteConfigSetOutBound.GetValueByKey(NotificationFragment.KEY_FRAGMENT_NOTI, function (data)
    --    NotificationFragment.data = json.decode(data)
    --    if callbackSuccess ~= nil then
    --        callbackSuccess()
    --    end
    --end, function ()
    --    NotificationFragment.data = {}
    --    if callbackSuccess ~= nil then
    --        callbackSuccess()
    --    end
    --end)
end

--- @return void
function NotificationFragment.SaveToServer()
    NotificationFragment.data = {}
    ---@type List
    local listArtifactFragment = InventoryUtils.GetListResource(ResourceType.ItemFragment)
    NotificationFragment.data.artifactFragment = {}
    for i, v in pairs(listArtifactFragment:GetItems()) do
        NotificationFragment.data.artifactFragment[tostring(v)] = NotificationFragment.GetNumberCanSummon(ResourceType.ItemFragment, v)
    end

    ---@type List
    local listHeroFragment = InventoryUtils.GetListResource(ResourceType.HeroFragment)
    NotificationFragment.data.heroFragment = {}
    for i, v in pairs(listHeroFragment:GetItems()) do
        NotificationFragment.data.heroFragment[tostring(v)] = NotificationFragment.GetNumberCanSummon(ResourceType.HeroFragment, v)
    end

    zg.playerData.remoteConfig.fragment = NotificationFragment.data
    zg.playerData:SaveRemoteConfig()
    --local remoteConfigSetOutBound = RemoteConfigSetOutBound()
    --remoteConfigSetOutBound:AddItem(RemoteConfigItemOutBound(NotificationFragment.KEY_FRAGMENT_NOTI,
    --        RemoteConfigValueType.STRING, json.encode(NotificationFragment.data)))
    --RemoteConfigSetOutBound.SetValue(remoteConfigSetOutBound)
end

--- @return void
---@param resourceType ResourceType
---@param resourceId number
function NotificationFragment.GetNumberCanSummon(resourceType, resourceId)
    local countSummonFragment = 1
    if resourceType == ResourceType.HeroFragment then
        local star = ClientConfigUtils.GetHeroFragmentStar(resourceId)
        ---@type HeroFragmentNumberConfig
        local heroFragmentNumberConfig = ResourceMgr.GetFragmentConfig().heroFragmentNumberDictionary:Get(star)
        if heroFragmentNumberConfig ~= nil then
            countSummonFragment = heroFragmentNumberConfig.number
        end
    elseif resourceType == ResourceType.ItemFragment then
        ---@type ArtifactFragmentConfig
        local artifactConfig = ResourceMgr.GetFragmentConfig().artifactFragmentDictionary:Get(resourceId)
        countSummonFragment = artifactConfig.price
    end
    return math.floor(InventoryUtils.Get(resourceType, resourceId) / countSummonFragment)
end

--- @return void
---@param resourceType ResourceType
---@param resourceId number
function NotificationFragment.CheckNotificationFragmentType(resourceType, resourceId)
    local noti = false
    local data = nil
    if NotificationFragment.data ~= nil then
        if resourceType == ResourceType.HeroFragment then
            data = NotificationFragment.data.heroFragment or {}
        elseif resourceType == ResourceType.ItemFragment then
            data = NotificationFragment.data.artifactFragment or {}
        end
    end
    if data ~= nil then
        local countCurrent = NotificationFragment.GetNumberCanSummon(resourceType, resourceId)
        local countBefore = data[tostring(resourceId)]
        if countBefore == nil then
            countBefore = 0
        end
        if countCurrent > countBefore then
            noti = true
        end
    end
    return noti
end