--- @class EventType45TagName
EventType45TagName = Class(EventType45TagName)

function EventType45TagName:Ctor(transform)
    --- @type UnityEngine_Transform
    self.transform = transform
    self:InitConfig(transform)
end

--- @param transform UnityEngine_Transform
function EventType45TagName:InitConfig(transform)
    --- @type UnityEngine_UI_Text
    self.textName = transform:Find("text_name"):GetComponent(ComponentName.UnityEngine_UI_Text)
    --- @type UnityEngine_UI_Text
    self.textGuild = transform:Find("text_guild"):GetComponent(ComponentName.UnityEngine_UI_Text)
    --- @type UnityEngine_UI_Button
    self.button = transform:Find("Button"):GetComponent(ComponentName.UnityEngine_UI_Button)
end

function EventType45TagName:SetName(textName, textGuild)
    self.textName.text = textName
    self.textGuild.text = textGuild
end

function EventType45TagName:SetActive(isActive)
    self.transform.gameObject:SetActive(isActive)
end