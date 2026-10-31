require "lua.client.scene.ui.utils.uiSelect.UISelect"

--- @class UISelectCustomSprite :UISelect
UISelectCustomSprite = Class(UISelectCustomSprite, UISelect)

--- @param spriteFormat string
function UISelectCustomSprite:SetSprite(spriteFormat, startIndex)
    for i = startIndex, self.configList:Count() do
        --- @type UnityEngine_UI_Image
        local image = self.configList:Get(i):GetComponent(ComponentName.UnityEngine_UI_Image)
        image.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(spriteFormat, i - startIndex + 1)
    end
end

--- @class UISelectFactionFilter : UISelectCustomSprite
UISelectFactionFilter = Class(UISelectFactionFilter, UISelectCustomSprite)

function UISelectFactionFilter:SetSprite()
    UISelectCustomSprite.SetSprite(self, ResourceLoadUtils.iconFactions, 2)
end

--- @class UISelectRarityFilter : UISelectCustomSprite
UISelectRarityFilter = Class(UISelectRarityFilter, UISelectCustomSprite)

function UISelectRarityFilter:SetSprite(startIndex)
    UISelectCustomSprite.SetSprite(self, ResourceLoadUtils.iconRarity, startIndex or 1)
end