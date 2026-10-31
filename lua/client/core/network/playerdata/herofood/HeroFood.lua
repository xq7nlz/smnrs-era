--- @class HeroFood
HeroFood = Class(HeroFood)

--- @return void
---@param heroFoodType HeroFoodType
---@param star number
---@param number number
---@param id number
function HeroFood:Ctor(heroFoodType, star, number, id)
    --- @type HeroFoodType
    self.heroFoodType = heroFoodType
    --- @type string
    self.star = star
    --- @type number
    self.number = number
    --- @type number
    self.id = id
end

--- @return HeroFood
--- @param buffer UnifiedNetwork_ByteBuf
function HeroFood.CreateByBuffer(buffer)
    local data = HeroFood()
    data.heroFoodType = buffer:GetByte()
    data.star = buffer:GetByte()
    data.number = buffer:GetInt()
    if data.number == 0 then
        data = nil
    end
    --XDebug.Log("HeroFood" .. LogUtils.ToDetail(data))
    return data
end