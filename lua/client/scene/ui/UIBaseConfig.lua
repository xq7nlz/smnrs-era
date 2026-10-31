--- @class UIBaseConfig
UIBaseConfig = Class(UIBaseConfig)

--- @return void
--- @param object UnityEngine_RectTransform
function UIBaseConfig:Ctor(object, class, nameClass)
    if object == nil then
        XDebug.Log("miss transform")
    end
    ---@type CS_GenConfigUI
    local genConfigUI = object:GetComponent(typeof(CS.GenConfigUI))
    --- @type UnityEngine_GameObject
    self.gameObject = object.gameObject
    --- @type UnityEngine_Transform
    self.transform = object.transform
    if genConfigUI ~= nil then
        local listPropertyDatas = genConfigUI.propertyDatas
        for i = 1, listPropertyDatas.Count do
            ---@type CS_GenConfigUI_PropertyData
            local propertyData = listPropertyDatas[i - 1]
            if Main.IsNull(propertyData.component) then
                self[propertyData.propertyName] = propertyData.gameObject
            else
                self[propertyData.propertyName] = propertyData.component
            end
        end
    else
        if class ~= nil then
            for k, v in pairs(class(object)) do
                self[k] = v
                --XDebug.Log(k)
                --XDebug.Log(LogUtils.ToDetail(v))
            end
        end
        local object = object.transform
        local path = object.gameObject.name
        while Main.IsNull(object.transform.parent) == false do
            object = object.transform.parent
            path = object.gameObject.name .. "/" .. path
        end
        if nameClass ~= nil then
            XDebug.Error(nameClass .. "   " .. path)
        else
            XDebug.Error("NIL UIBaseConfig " .. path)
        end
    end
end