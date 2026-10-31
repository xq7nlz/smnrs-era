require "lua.client.core.network.playerData.heroFood.HeroFood"

--- @class PlayerHeroFoodInBound
PlayerHeroFoodInBound = Class(PlayerHeroFoodInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function PlayerHeroFoodInBound:ReadBuffer(buffer)
    ---@type List
    self.listHeroFood = NetworkUtils.GetListDataInBound(buffer, HeroFood.CreateByBuffer)
end

--- @return void
---@param heroFoodType HeroFoodType
---@param star number
---@param number number
function PlayerHeroFoodInBound:AddHeroFood(heroFoodType, star, number)
    ---@type HeroFood
    local food
    ------@param v HeroFood
    for _, v in pairs(self.listHeroFood:GetItems()) do
        if v.heroFoodType == heroFoodType and v.star == star then
            food = v
            break
        end
    end
    if food == nil then
        food = HeroFood(heroFoodType, star, number)
        self.listHeroFood:Add(food)
    else
        food.number = food.number + number
    end
end

--- @return void
---@param heroFoodType HeroFoodType
---@param star number
---@param number number
function PlayerHeroFoodInBound:SubHeroFood(heroFoodType, star, number)
    ------@param v HeroFood
    for _, v in pairs(self.listHeroFood:GetItems()) do
        if v.heroFoodType == heroFoodType and v.star == star then
            if v.number == number then
                self.listHeroFood:RemoveByReference(v)
            else
                v.number = v.number - number
            end
            break
        end
    end
end

--- @return void
---@param id number
---@param number number
function PlayerHeroFoodInBound:AddIdAndNumber(id, number, star)
    self:AddHeroFood(ClientConfigUtils.GetHeroFoodTypeById(id), star or ClientConfigUtils.GetHeroFoodStarById(id), number)
end

--- @return void
---@param id number
---@param number number
function PlayerHeroFoodInBound:SubIdAndNumber(id, number)
    self:SubHeroFood(ClientConfigUtils.GetHeroFoodTypeById(id), ClientConfigUtils.GetHeroFoodStarById(id), number)
end