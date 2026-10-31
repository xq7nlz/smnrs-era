--- @class UISelect
UISelect = Class(UISelect)

--- @return void
--- @param onSelect function (index : number, isSelect : bool, indexTab : number)
--- @param onChangeSelect function (index : number, lastIndex : number)
function UISelect:Ctor(uiTransform, config, onSelect, onChangeSelect, onClickSelect, conditionClick, onClickFailed)
    --- @type UnityEngine_RectTransform
    self.uiTransform = uiTransform
    --- @type config
    self.config = config
    --- @type List <UnityEngine_UI_Button>
    self.configList = List()
    --- @type function
    self.onSelect = onSelect
    --- @type function
    self.onChangeSelect = onChangeSelect
    --- @type function
    self.onClickSelect = onClickSelect
    --- @type function
    self.conditionClick = conditionClick
    --- @type function
    self.onClickFailed = onClickFailed
    --- @type number
    self.indexTab = nil
    --- @type UnityEngine_GameObject
    self._prefabNodePage = nil

    self:_GetNodePrefab()
    self:_Init()
end

function UISelect:_GetNodePrefab()
    self._prefabNodePage = self.uiTransform:GetChild(0)
    assert(self._prefabNodePage)

    --local buttonNode = self._prefabNodePage:GetComponent(ComponentName.UnityEngine_UI_Button)
    --buttonNode.onClick:AddListener(function ()
    --    self:Select(0)
    --end)
    --self.configList:Add(buttonNode)
end

--- @param pageCount number
function UISelect:SetPagesCount(pageCount)
    local deltaPage = pageCount - self.configList:Count()
    if deltaPage < 0 then
        for i = 1, pageCount do
            self.configList:Get(i).gameObject:SetActive(true)
        end
        for i = pageCount + 1, self.configList:Count() do
            self.configList:Get(i).gameObject:SetActive(false)
        end
    else
        for i = 1, self.configList:Count() do
            self.configList:Get(i).gameObject:SetActive(true)
        end
        for i = self.configList:Count() + 1, pageCount do
            local newNode = self:_GetMoreNodePage()
            newNode.gameObject:SetActive(true)
        end
    end
    for i = 1, pageCount do
        self.onSelect(self.configList:Get(i), false, nil)
    end
end

function UISelect:_GetMoreNodePage()
    --- @type UnityEngine_Transform
    local newNode = U_GameObject.Instantiate(self._prefabNodePage).transform
    UIUtils.SetParent(newNode, self.uiTransform)
    newNode:SetAsLastSibling()

    local inst
    local button
    if self.config ~= nil then
        inst = self.config(newNode)
        button = inst.button
    else
        inst = newNode:GetComponent(ComponentName.UnityEngine_UI_Button)
        button = inst
    end
    self.configList:Add(inst)

    local nodeIndex = self.uiTransform.childCount - 1
    if button then
        button.onClick:AddListener(function()
            if self.conditionClick == nil or self.conditionClick(nodeIndex) == true then
                if self.indexTab == nodeIndex then
                    self:Select(nil)
                else
                    self:Select(nodeIndex)
                end
                if self.onClickSelect ~= nil then
                    self.onClickSelect(nodeIndex)
                end
                zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
            elseif self.onClickFailed ~= nil then
                self.onClickFailed(nodeIndex)
            end
        end)
    end
    return newNode
end

--- @return void
function UISelect:_Init()
    local childTab = self.uiTransform.childCount
    for i = 1, childTab do
        local inst
        ---@type UnityEngine_UI_Button
        local button
        if self.config ~= nil then
            inst = self.config(self.uiTransform:GetChild(i - 1))
            button = inst.button
        else
            inst = self.uiTransform:GetChild(i - 1):GetComponent(ComponentName.UnityEngine_UI_Button)
            button = inst
        end
        self.configList:Add(inst)
        local index = i
        if button then
            button.onClick:AddListener(function()
                if self.conditionClick == nil or self.conditionClick(index) == true then
                    if self.indexTab == index then
                        self:Select(nil)
                    else
                        self:Select(index)
                    end
                    if self.onClickSelect ~= nil then
                        self.onClickSelect(index)
                    end
                    zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
                elseif self.onClickFailed ~= nil then
                    self.onClickFailed(index)
                end
            end)
        end
        if self.onSelect ~= nil then
            self.onSelect(inst, false, index)
        end
    end
end

--- @return void
--- @param index number
function UISelect:Select(index)
    --if self.indexTab == index then
    --    return
    --end
    ---@type number
    local lastIndex = self.indexTab
    self.indexTab = index

    if (self.onChangeSelect) then
        self.onChangeSelect(self.indexTab, lastIndex)
    end
    if (self.onSelect) then
        if lastIndex ~= nil and self.indexTab ~= lastIndex then
            self.onSelect(self.configList:Get(lastIndex), false, lastIndex)
        end
        if self.indexTab ~= nil then
            self.onSelect(self.configList:Get(self.indexTab), true, self.indexTab)
        end
    end
end

--- @return UnityEngine_UI_Button
--- @param index number
function UISelect:HighlightTabByIndex(index)
    if self.indexTab ~= nil then
        local lastButton = self:GetButtonTabByIndex(self.indexTab)
        self:SetHighlightButton(lastButton, false)
    end
    local button = self:GetButtonTabByIndex(index)
    self:SetHighlightButton(button, true)
end

--- @param obj UITabPopupConfig
function UISelect:SetHighlightButton(obj, isHighlight)
    if obj ~= nil then
        obj.button.interactable = not isHighlight
        if obj.imageOn ~= nil then
            obj.imageOn.gameObject:SetActive(isHighlight)
        end
        if obj.bgOn ~= nil then
            obj.bgOn:SetActive(isHighlight)
        end
    end
end

--- @return UITabPopupConfig
function UISelect:GetButtonTabByIndex(index)
    return self.configList:Get(index)
end
