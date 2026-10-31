
--- @class TalentSelectItemView : IconView
TalentSelectItemView = Class(TalentSelectItemView, IconView)

--- @return void
function TalentSelectItemView:Ctor()
    IconView.Ctor(self)
end

--- @return void
function TalentSelectItemView:SetPrefabName()
    self.prefabName = 'talent_item_select'
    self.uiPoolType = UIPoolType.TalentSelectItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function TalentSelectItemView:SetConfig(transform)
    if transform then
        ---@type TalentSelectItemConfig
        self.config = UIBaseConfig(transform)
        self.config.buttonChoose.onClick:AddListener(function ()
            self:OnClickSelect()
        end)
    else
        XDebug.Error("transform is nil")
    end
end

function TalentSelectItemView:InitLocalization()
    self.config.textCollect.text = LanguageUtils.LocalizeCommon("select")
end

--- @return void
--- @param id number
function TalentSelectItemView:SetIconData(id, callbackSelect)
    --- @type number
    self.id = id
    self.callbackSelect = callbackSelect

    self.config.textCardName.text = LanguageUtils.LocalizeTalent(id)

    local localizeTalentBuff
    if self.id / ClientItemConstants.TALENT_2_DEFINE >= 1 then
        localizeTalentBuff = LanguageUtils.LocalizePassiveTalentBuff(ResourceMgr.GetServiceConfig():GetItemData(ResourceType.Talent, self.id))
    else
        localizeTalentBuff = LanguageUtils.LocalizeTalentBuff(ResourceMgr.GetServiceConfig():GetItemData(ResourceType.Talent, self.id))
    end

    self.config.textDungeonCardInfo.text = localizeTalentBuff

    self.config.iconItem.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconTalent, id)
    self.config.iconItem:SetNativeSize()

    --- @type UnityEngine_RectTransform
    self.borderTalent = SmartPool.Instance:SpawnTransform(AssetType.UIPool, UIPoolType.BorderTalent)
    UIUtils.SetUIParent(self.borderTalent, self.config.iconItemAnchor)
    self.borderTalent.gameObject:SetActive(true)
end

function TalentSelectItemView:ReturnPool()
    IconView.ReturnPool(self)

    if self.borderTalent ~= nil then
        IconView.DespawnUIPool(UIPoolType.BorderTalent, self.borderTalent)
    end
end

--- @return void
function TalentSelectItemView:OnClickSelect()
    if self.callbackSelect ~= nil then
        self.callbackSelect(self.id)
    end
end

return TalentSelectItemView