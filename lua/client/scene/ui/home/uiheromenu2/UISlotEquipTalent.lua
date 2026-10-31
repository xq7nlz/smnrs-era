--- @class UISlotEquipTalent
UISlotEquipTalent = Class(UISlotEquipTalent)


--- @return void
--- @param transform UnityEngine_Transform
function UISlotEquipTalent:Ctor(transform, onNoti)
    ---@type UISlotEquipTalentConfig
    self.config = UIBaseConfig(transform)
    ---@type ItemIconView
    self.itemEquipView = nil
    ---@type boolean
    self.onNoti = onNoti
end

--- @return void
--- @param isActive boolean
function UISlotEquipTalent:ActiveAddImage(isActive)
    self.config.addImage.gameObject:SetActive(isActive)
end

function UISlotEquipTalent:EnableParticleLockTalent(isEnable)
    if isEnable == true then
        if self.particleLockTalent == nil then
            self.particleLockTalent = ResourceLoadUtils.LoadUIEffect("fx_ui_equip_iconlock", self.config.talentItemAnchor)
        end
        self.particleLockTalent.gameObject:SetActive(true)
    else
        if self.particleLockTalent ~= nil then
            self.particleLockTalent.gameObject:SetActive(false)
        end
    end
end

function UISlotEquipTalent:EnableParticleUnLockTalent(isEnable)
    if isEnable == true then
        if self.particleLockTalent == nil then
            self.particleLockTalent = ResourceLoadUtils.LoadUIEffect("fx_ui_equip_iconunlock", self.config.talentItemAnchor)
        end
        self.particleLockTalent.gameObject:SetActive(true)
    else
        if self.particleLockTalent ~= nil then
            self.particleLockTalent.gameObject:SetActive(false)
        end
    end
end


--- @return void
function UISlotEquipTalent:UpdateTalent(slotId,heroResource)
    --- @type FeatureConfigInBound
    local featureConfigInBound = zg.playerData:GetMethod(PlayerDataMethod.FEATURE_CONFIG)
    local evolveMaxStar = featureConfigInBound:GetFeatureConfigInBound(FeatureType.TALENT)
    self.config.gameObject:SetActive(evolveMaxStar:IsAvailableToShowButton())
    if evolveMaxStar:IsAvailableToShowButton() == false then
        return
    end
    self:EnableParticleLockTalent(false)
    self.config.iconLock.gameObject:SetActive(true)
    self.config.textUnlockTalent.gameObject:SetActive(heroResource.heroStar < (HeroConstants.MAX_STAR - 1))

    local idTalent = heroResource.heroItem:Get(slotId)
    if idTalent ~= nil and idTalent > 0 then
        if self.talent == nil then
            self.talent = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.ItemIconView, self.config.talentItemAnchor)
        end
        self.talent.config.gameObject:SetActive(true)
        self.talent:SetIconData(ItemIconData.CreateInstance(ResourceType.Talent, idTalent))
        self.talent:ActiveBorderTalent(true)
        self.config.iconNoti:SetActive(false)
    elseif heroResource.heroStar >= 13 then
        if slotId == SlotEquipmentType.Talent then
            self:EnableParticleUnLockTalent(true)
            self.config.iconLock.gameObject:SetActive(false)
            self.config.iconNoti:SetActive(true and self.onNoti)
        elseif slotId == SlotEquipmentType.Talent2 and heroResource.heroStar >= HeroConstants.MAX_STAR then
            self:EnableParticleUnLockTalent(true)
            self.config.iconLock.gameObject:SetActive(false)
            self.config.iconNoti:SetActive(true and self.onNoti)
        end
        if self.talent ~= nil then
            self.talent.config.gameObject:SetActive(false)
        end
    else
        self.config.iconNoti:SetActive(true and self.onNoti)
        if self.talent ~= nil then
            self.talent.config.gameObject:SetActive(false)
        end
    end
end