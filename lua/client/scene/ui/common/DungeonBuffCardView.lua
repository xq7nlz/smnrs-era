---COMMENT_CONFIG_COMMON    require "lua.client.scene.ui.common.DungeonBuffCardConfig"

local ColorRarity = { "FFFFFF", "00D0FF", "FFB500", "FB2525" }

local GetTitleColorByRarity = function(rarity)
    return ColorRarity[rarity]
end

--- @class DungeonBuffCardView : IconView
DungeonBuffCardView = Class(DungeonBuffCardView, IconView)

--- @return void
function DungeonBuffCardView:Ctor()
    self.buffData = nil
    --- @type List
    self.iconBuffList = List()
    --- @type boolean
    self.choose = false
    --- @type boolean
    self.canScale = false
    --- @type boolean
    self.canSetNumber = true

    IconView.Ctor(self)
end

--- @return void
function DungeonBuffCardView:SetPrefabName()
    self.prefabName = 'dungeon_buff_card'
    self.uiPoolType = UIPoolType.DungeonBuffCardView
end

--- @return void
--- @param transform UnityEngine_Transform
function DungeonBuffCardView:SetConfig(transform)
    if transform then
        ---@type DungeonBuffCardConfig
        self.config = UIBaseConfig(transform)
    else
        XDebug.Error("transform is nil")
    end
end

--- @return void
--- @param reward RewardInBound
function DungeonBuffCardView:SetIconData(reward)
    --- @type RewardInBound
    self.iconData = reward
    self:SetBuffData()
    self:UpdateView()
end

--- @return boolean
function DungeonBuffCardView:IsActiveBuff()
    return self.iconData.type == ResourceType.DungeonItemActiveBuff
end

function DungeonBuffCardView:UpdateView()
    self:SetButton()
    self:SetRarity()
    self:SetSupportIcon()
    self:SetBuffIcon()
    self:SetContent()
    self:SetQuantity()
    self:SetButtonText()
end

---@param option BaseItemOption
function DungeonBuffCardView:GetRequirement(option)
    local listFaction = List()
    local listClass = List()
    ---@param param string
    ---@param list List
    local addToList = function(param, list)
        if not StringUtils.IsNilOrEmpty(param) then
            local split = param:Split(";")
            for _, v in ipairs(split) do
                list:Add(tostring(v))
            end
        end
    end
    if option.type == ItemOptionType.STAT_CHANGE then
        addToList(option.params:Get(4), listClass)
        addToList(option.params:Get(5), listFaction)
    elseif option.type == ItemOptionType.DAMAGE_AGAINST then
        addToList(option.params:Get(2), listFaction)
    end
    return listFaction, listClass
end

function DungeonBuffCardView:SetContent()
    if self:IsActiveBuff() then
        self.config.requirement:GetChild(0).gameObject:SetActive(true)
        self.config.textCardName.text = UIUtils.SetColorString(GetTitleColorByRarity(self.buffData.rarity), LanguageUtils.LocalizeDungeonActiveBuffName(self.iconData.id))
        self.config.textDungeonCardInfo.text = LanguageUtils.LocalizeDungeonActiveBuff(ResourceMgr.GetServiceConfig():GetDungeon():GetActiveBuff(self.iconData.id))
    else
        ---@type PassiveBuffDataEntry
        local passiveBuffDataEntry = ResourceMgr.GetServiceConfig():GetDungeon():GetPassiveBuff(self.iconData.id)
        ---@type List
        local listFaction, listClass = DungeonBuffCardView:GetRequirement(passiveBuffDataEntry.optionList:Get(1))
        if listFaction:Count() == 0 and listClass:Count() == 0 then
            self.config.requirement:GetChild(0).gameObject:SetActive(true)
        else
            local index = 1
            for _, v in ipairs(listFaction:GetItems()) do
                ---@type UnityEngine_UI_Image
                local image = self.config.requirement:GetChild(index).gameObject:GetComponent(ComponentName.UnityEngine_UI_Image)
                image.sprite = ResourceLoadUtils.LoadFactionIcon(v)
                image.gameObject:SetActive(true)
                index = index + 1
            end
            for _, v in ipairs(listClass:GetItems()) do
                ---@type UnityEngine_UI_Image
                local image = self.config.requirement:GetChild(index).gameObject:GetComponent(ComponentName.UnityEngine_UI_Image)
                image.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconClassHeroes, v)
                image.gameObject:SetActive(true)
                index = index + 1
            end
        end
        self.config.textCardName.text = UIUtils.SetColorString(GetTitleColorByRarity(self.buffData.rarity), LanguageUtils.LocalizeDungeonPassiveBuffName(self.iconData.id))
        self.config.textDungeonCardInfo.text = LanguageUtils.LocalizeDungeonPassiveBuff(passiveBuffDataEntry)
    end
end

function DungeonBuffCardView:SetButtonText()
    self.config.textCollect.text = LanguageUtils.LocalizeCommon(self.canScale and "choose" or "use")
end

function DungeonBuffCardView:SetQuantity()
    if self.canSetNumber then
        self.config.textQuantity.text = self.iconData.number
    else
        self.config.textQuantity.text = ""
    end
end

function DungeonBuffCardView:SetBuffData()
    if self:IsActiveBuff() then
        self.buffData = ResourceMgr.GetServiceConfig():GetDungeon():GetActiveBuff(self.iconData.id)
    else
        self.buffData = ResourceMgr.GetServiceConfig():GetDungeon():GetPassiveBuff(self.iconData.id)
    end
    if self.buffData == nil then
        XDebug.Log(self.iconData:ToString())
    end
end

function DungeonBuffCardView:SetBuffIcon()
    local sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconDungeon, tostring(self.iconData.id))
    if sprite == nil then
        sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconDungeon, "1001")
    end
    self.config.iconItemDungeonBuff.sprite = sprite
end

function DungeonBuffCardView:SetSupportIcon()
    --- @param v UnityEngine_UI_Image
    for _, v in ipairs(self.iconBuffList:GetItems()) do
        v.enabled = false
    end
    if self:IsActiveBuff() then
        self:SetActiveBuffIcon()
    else
        self:SetPassiveBuffIcon()
    end
end

function DungeonBuffCardView:SetActiveBuffIcon()
    for _ = 1, 2 - self.iconBuffList:Count() do
        local object = U_GameObject.Instantiate(self.config.iconBuff, self.config.rootBuff)
        self.iconBuffList:Add(object:GetComponent(ComponentName.UnityEngine_UI_Image))
    end
    --- @type UnityEngine_UI_Image
    local buff1 = self.iconBuffList:Get(1)
    buff1.gameObject:SetActive(true)
    buff1.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconDungeon, "icon_potion_buff")
    --- @type UnityEngine_UI_Image
    local buff2 = self.iconBuffList:Get(2)
    buff2.gameObject:SetActive(true)
    buff2.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconDungeon, "icon_all")
end

function DungeonBuffCardView:SetPassiveBuffIcon()
    local listClass = List()
    local listFaction = List()
    --- @param v BaseItemOption
    for _, v in ipairs(self.buffData.optionList:GetItems()) do
        for _, class in ipairs(v.affectedHeroClass:GetItems()) do
            if listClass:IsContainValue(class) then
                listClass:Add(class)
            end
        end

        for _, faction in ipairs(v.affectedHeroFaction:GetItems()) do
            if listFaction:IsContainValue(faction) then
                listFaction:Add(faction)
            end
        end
    end
end

function DungeonBuffCardView:SetRarity()
    -- local name = string.format("icon_%d_buff", self.buffData.rarity - 1)
    -- self.config.iconRareBuff.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconDungeon, name)
    local sprite = ResourceLoadUtils.LoadSkinRarity(self.buffData.rarity)
    if sprite ~= nil then
        self.config.iconRarity.sprite = sprite
        self.config.iconRarity:SetNativeSize()
    end
end

--- @return void
---@param cardFunc function
---@param chooseFunc function
function DungeonBuffCardView:AddListener(cardFunc, chooseFunc)
    self.config.buttonCard.interactable = cardFunc ~= nil
    self.config.buttonCard.onClick:AddListener(function ()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if cardFunc then
            cardFunc()
        end
    end)

    self.config.buttonChoose.interactable = chooseFunc ~= nil
    self.config.buttonChoose.onClick:AddListener(function ()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if chooseFunc then
            chooseFunc()
        end
    end)
end

function DungeonBuffCardView:RemoveAllListeners()
    self.config.buttonCard.onClick:RemoveAllListeners()
    self.config.buttonChoose.onClick:RemoveAllListeners()
end

function DungeonBuffCardView:SetButton()
    self.config.buttonChoose.gameObject:SetActive(self.choose)
end

--- @param scale number
function DungeonBuffCardView:SetScale(scale)
    self.config.visual.localScale = U_Vector3.one * scale
end
function DungeonBuffCardView:SetSizeDelta(sizeDelta)
    self.config.iconRareBuff.sizeDelta = sizeDelta
end
function DungeonBuffCardView:ChooseCard(choose)
    self.choose = choose
    self:SetButton()
    if self.canScale then
        self:SetSizeDelta(choose and U_Vector2(1150,240) or U_Vector2(950,234))
        self:SetScale(choose and 1.23 or 1)
    end
end

function DungeonBuffCardView:AddBuff()
    --- @type DungeonInBound
    local server = zg.playerData:GetMethod(PlayerDataMethod.DUNGEON)
    server:AddBuff(self.iconData)
    server:RemoveFirstBuffSelectionStage()
end

function DungeonBuffCardView:DisableRequirement()
    for i = 1, self.config.requirement.childCount do
        self.config.requirement:GetChild(i - 1).gameObject:SetActive(false)
    end
end

function DungeonBuffCardView:ReturnPool()
    IconView.ReturnPool(self)
    self:ChooseCard(false)
    self:DisableRequirement()
    self.canScale = false
    self.canSetNumber = true
end

--- @return void
function DungeonBuffCardView:RegisterShowInfo()

end

return DungeonBuffCardView