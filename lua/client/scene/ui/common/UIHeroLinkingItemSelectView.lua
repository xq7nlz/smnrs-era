--- @class UIHeroLinkingItemSelectView : MotionIconView
UIHeroLinkingItemSelectView = Class(UIHeroLinkingItemSelectView, MotionIconView)

--- @return void
function UIHeroLinkingItemSelectView:Ctor()
    ---@type number
    self.slot = nil
    ---@type number
    self.groupLinking = nil
    ---@type HeroIconView
    self.heroIcon = nil
    ---@type LinkingHeroDataInBound
    self.linkingHeroDataInBound = nil
    MotionIconView.Ctor(self)
end

--- @return void
function UIHeroLinkingItemSelectView:SetPrefabName()
    self.prefabName = 'hero_item_linking'
    self.uiPoolType = UIPoolType.UIHeroLinkingItemSelectView
end

--- @return void
--- @param transform UnityEngine_Transform
function UIHeroLinkingItemSelectView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type UIHeroItemLinkingConfig
    self.config = UIBaseConfig(transform)
    self.config.button.onClick:AddListener(function ()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickSelect()
    end)

end

--- @return void
--- @param heroId number
--- @param isNoti boolean
function UIHeroLinkingItemSelectView:SetData(heroId, slot, groupLinking, isNoti)
    ---@type HeroLinkingInBound
    local heroLinkingInBound = zg.playerData:GetMethod(PlayerDataMethod.HERO_LINKING)
    self.heroId = heroId
    self.slot = slot
    self.groupLinking = groupLinking
    self.linkingHeroDataInBound = heroLinkingInBound:GetLinkingHeroDataByIdAndSlot(groupLinking, slot)
    self.heroIcon = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.HeroIconView, self.config.iconHero)
    self.heroIconData = HeroIconData.CreateInstance(ResourceType.Hero, heroId, nil, nil, ClientConfigUtils.GetFactionIdByHeroId(heroId))
    if self.linkingHeroDataInBound ~= nil then
        self.config.textUserName.gameObject:SetActive(true)
        if self.linkingHeroDataInBound.isOwnHero == true then
            ---@type HeroResource
            local heroResource = InventoryUtils.GetHeroResourceByInventoryId(self.linkingHeroDataInBound.inventoryId)
            self.heroIconData.star = heroResource.heroStar
            self.heroIconData.level = heroResource.heroLevel
            self.heroIconData.skinId = heroResource.heroItem:Get(HeroItemSlot.SKIN)
            self.config.textUserName.text = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).name
        else
            ---@type SupportHeroData
            local supportHeroData = heroLinkingInBound:GetSupportHeroDataByFriendIdAndInventoryId(self.linkingHeroDataInBound.friendId, self.linkingHeroDataInBound.inventoryId)
            self.heroIconData.star = supportHeroData.star
            ---@type PlayerFriendInBound
            local friendInBound = zg.playerData:GetMethod(PlayerDataMethod.FRIEND)
            ---@type FriendData
            local friendData = friendInBound:GetFriendDataByFriendId(self.linkingHeroDataInBound.friendId)
            if friendData ~= nil then
                self.config.textUserName.text = friendData.friendName
            else
                self.config.textUserName.text = ""
            end
        end
        self.heroIcon:SetIconData(self.heroIconData)
        self.heroIcon:SetActiveColor(true)
        self.config.add:SetActive(false)
        self.config.bgHeroLinkingActiveEffect:SetActive(true)
    else
        self.config.textUserName.gameObject:SetActive(false)
        self.heroIcon:SetIconData(self.heroIconData)
        self.heroIcon:SetActiveColor(false)
        self.config.add:SetActive(true)
        self.config.bgHeroLinkingActiveEffect:SetActive(false)
    end
    self.config.noti:SetActive(isNoti)
end

--- @return void
function UIHeroLinkingItemSelectView:UpdateUI()

end

--- @return void
function UIHeroLinkingItemSelectView:ReturnPool()
    if self.heroIcon ~= nil then
        self.heroIcon:ReturnPool()
        self.heroIcon = nil
    end
    MotionIconView.ReturnPool(self)
end

--- @return void
function UIHeroLinkingItemSelectView:OnClickSelect()
    local data = {}
    data.groupId = self.groupLinking
    data.slot = self.slot
    data.callback = self.callbackSelect
    PopupMgr.ShowPopup(UIPopupName.UISelectHeroForLinking, data)
end

return UIHeroLinkingItemSelectView