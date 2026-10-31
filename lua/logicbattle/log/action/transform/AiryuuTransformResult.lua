--- @class AiryuuTransformResult : TransformResult
AiryuuTransformResult = Class(AiryuuTransformResult, TransformResult)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param isDragonForm boolean
function AiryuuTransformResult:Ctor(initiator, target, isDragonForm)
    TransformResult.Ctor(self, initiator, target)

    --- @type boolean
    self.isDragonForm = isDragonForm
end

--- @return AiryuuTransformResult
function AiryuuTransformResult:GetData()
    local data = BaseActionResult.GetData(self)

    data.isDragonForm = self.isDragonForm

    return data
end

--- @return string
function AiryuuTransformResult:ToString()
    local transform = "TRANSFORM "
    if self.isDragonForm == true then
        transform = transform .. "DRAGON"
    else
        transform = transform .. "HUMAN"
    end

    local result = string.format("%s", BaseActionResult.GetPrefix(self, transform))
    return result
end