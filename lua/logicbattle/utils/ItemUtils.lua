--- @class ItemUtils
ItemUtils = {}

--- @return BaseItemOption
--- @param data table
--- @param heroDataService HeroDataService
--- @param itemDataService ItemDataService
function ItemUtils.CreateItemOption(data, heroDataService, itemDataService)
    --- @type BaseItemOption
    local option
    if data.option_type ~= nil then
        local optionType = tonumber(data.option_type)

        --print(LogUtils.ToDetail(data))

        if optionType == ItemOptionType.STAT_CHANGE then
            option = StatChangerItemOption(optionType, data, heroDataService)
        elseif optionType == ItemOptionType.DAMAGE_AGAINST then
            option = DamageAgainstItemOption(optionType, data, heroDataService)
        elseif optionType == ItemOptionType.REDUCE_DAMAGE_AGAINST then
            option = ReduceDamageAgainstItemOption(optionType, data, heroDataService)
        elseif optionType == ItemOptionType.DAMAGE_TAKEN then
            option = DamageTakenItemOption(optionType, data, heroDataService)
        elseif optionType == ItemOptionType.REDUCE_DAMAGE_TAKEN then
            option = ReduceDamageTakenItemOption(optionType, data, heroDataService)
        elseif optionType == ItemOptionType.ITEM_PASSIVE then
            option = PassiveItemOption(optionType, data, heroDataService, itemDataService)
        end
    else
        assert(false)
    end

    --print(option:ToString())
    option:Validate()
    return option
end

return ItemUtils