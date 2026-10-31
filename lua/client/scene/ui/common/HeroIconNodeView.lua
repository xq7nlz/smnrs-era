--- @class HeroIconNodeView : UIPrefabView
HeroIconNodeView = Class(HeroIconNodeView , UIPrefabView)

function HeroIconNodeView:Ctor(transform)
    UIPrefabView.Ctor(self, transform)
    ---@type HeroIconNodeConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
function HeroIconNodeView:SetPrefabName()
    self.prefabName = 'hero_icon_node'
    self.uiPoolType = UIPoolType.HeroIconNodeView
end

--- @return void
function HeroIconNodeView:AddListener(callback)
    self.config.buttonHeroIcon.onClick:AddListener(function()
        callback()
    end)
end

--- @return void
function HeroIconNodeView:EnableNodeHighlight()
    self.config.frameActive:SetActive(true)
    self.config.lineActive:SetActive(true)

    self.config.frameChoosenNext:SetActive(false)
    self.config.frameDisable:SetActive(false)
    self.config.blackCover:SetActive(false)
end

--- @return void
function HeroIconNodeView:EnableNextNodeHighlight()
    self.config.frameActive:SetActive(false)
    self.config.lineActive:SetActive(true)

    self.config.frameChoosenNext:SetActive(true)
    self.config.frameDisable:SetActive(true)
    self.config.blackCover:SetActive(true)
end


--- @return void
function HeroIconNodeView:DisableNodeHighlight()
    self.config.frameActive:SetActive(false)
    self.config.lineActive:SetActive(false)

    self.config.frameChoosenNext:SetActive(false)
    self.config.frameDisable:SetActive(true)
    self.config.blackCover:SetActive(true)
end

--- @return void
--- @param transform UnityEngine_Transform
function HeroIconNodeView:SetConfig(transform)
    assert(transform)
end

return HeroIconNodeView