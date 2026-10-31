--- @class TowerResultItemView : IconView
TowerResultItemView = Class(TowerResultItemView, IconView)

--- @return void
function TowerResultItemView:Ctor()
    IconView.Ctor(self)
end

--- @return void
function TowerResultItemView:SetPrefabName()
    self.prefabName = 'tower_result'
    self.uiPoolType = UIPoolType.TowerResultItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function TowerResultItemView:SetConfig(transform)
    ---@type TowerResultItemConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
--- @param data {idTower, level, hpPercent}
function TowerResultItemView:SetData(index, data)
    if index ~= nil then
        self.config.textSystemName.text = string.format("%s%s(%s %s)",LanguageUtils.LocalizeCommon("tower") , index, LanguageUtils.LocalizeCommon("level"), data.level)
    end
    if data ~= nil then
        self.config.bgHpBar.fillAmount = data.hpPercent
        if data.hpPercent > 0 then
            self.config.iconReadyTickDefenseMode:SetActive(true)
            self.config.iconNotReady:SetActive(false)
            self.config.textPopupContent.text = LanguageUtils.LocalizeCommon("defense_success")
            self.config.bgHpBar.transform.parent.gameObject:SetActive(true)
        else
            self.config.textPopupContent.text = LanguageUtils.LocalizeCommon("defense_fail")
            self.config.iconReadyTickDefenseMode:SetActive(false)
            self.config.iconNotReady:SetActive(true)
            self.config.bgHpBar.transform.parent.gameObject:SetActive(false)
        end
    end
end

--- @return void
function TowerResultItemView:SetSpriteLand(id)
    self.config.iconTower.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.defenseModeTower, string.format("turret_%s", id))
    self.config.iconTower:SetNativeSize()
end

--- @return void
function TowerResultItemView:UpdateUI()

end

--- @return List
---@param tower List -- {idTower, level, hpPercent}>
---@param transform UnityEngine_Transform
function TowerResultItemView.CreateListTower(land, tower, transform)
    local list = List()
    if tower ~= nil and transform ~= nil then
        ---@param v {idTower, level, hpPercent}
        for i, v in ipairs(tower:GetItems()) do
            ---@type TowerResultItemView
            local towerResult = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.TowerResultItemView, transform)
            towerResult:SetData(i, v)
            towerResult:SetSpriteLand(land)
            list:Add(towerResult)
        end
    end
    return list
end

---@param list List
function TowerResultItemView.ReturnPoolListTowerResult(list)
    if list ~= nil then
        ---@param v TowerResultItemView
        for _, v in pairs(list:GetItems()) do
            v:ReturnPool()
        end
        list:Clear()
    end
end

return TowerResultItemView