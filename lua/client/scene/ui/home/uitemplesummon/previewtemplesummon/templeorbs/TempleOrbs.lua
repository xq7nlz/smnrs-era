require "lua.client.scene.ui.home.uiTempleSummon.previewTempleSummon.TempleOrbs.TempleOrbChild"

--- @class TempleOrbs
TempleOrbs = Class(TempleOrbs)

--- @param transform UnityEngine_Transform
--- @param model UITempleSummonModel
function TempleOrbs:Ctor(transform, model)
    --- @type UnityEngine_Transform
    self.transform = transform
    self.transform.localPosition = U_Vector3.zero

    --- @type UITempleSummonModel
    self.model = model

    --- @type List : <UnityEngine_Transform>
    self.orbList = List()
    --- @type Dictionary : <UnityEngine_Transform, TempleOrbChild>
    self.orbChildDict = Dictionary()

    self:_InitTempleOrbs()
end

function TempleOrbs:_InitTempleOrbs()
    local childCount = self.transform.childCount
    for i = 1, childCount do
        local transform = self.transform:GetChild(i - 1)
        self.orbList:Add(transform)
        local orbChild = TempleOrbChild(transform)
        self.orbChildDict:Add(transform, orbChild)

        transform.localPosition = self.model.positionList:Get(i)

        local scale = self.model.scaleList:Get(i)
        transform.localScale = U_Vector3.one * scale
        orbChild.meshRenderer.sortingOrder = transform.localPosition.z * self.model.deltaOrbLayer
        orbChild:UpdateFxOrbLayer()
    end
end

function TempleOrbs:MoveLeft()
    for i = 1, self.orbList:Count() do
        local currentTransform = self.orbList:Get(i)

        local nextIndex = i - 1
        if nextIndex < 1 then
            nextIndex = self.model.templeCount
        end
        local nextTransform = self.orbList:Get(nextIndex)
        self.orbChildDict:Get(currentTransform):DoMove(nextTransform, self.model.deltaOrbLayer, self.model.timeTempleRotate)
    end
end

function TempleOrbs:MoveRight()
    for i = 1, self.orbList:Count() do
        local currentTransform = self.orbList:Get(i)
        local nextIndex = i + 1
        if nextIndex > self.model.templeCount then
            nextIndex = 1
        end
        local nextTransform = self.orbList:Get(nextIndex)

        self.orbChildDict:Get(currentTransform):DoMove(nextTransform, self.model.deltaOrbLayer, self.model.timeTempleRotate)
    end
end

function TempleOrbs:DoFadeOrbs()
    self.transform.localPosition = U_Vector3.zero
    self.transform.gameObject:SetActive(true)
    for i = 1, self.orbList:Count() do
        self.orbChildDict:Get(self.orbList:Get(i)):DoFade()
    end
end

function TempleOrbs:OnHide()
    self.transform.gameObject:SetActive(false)
end