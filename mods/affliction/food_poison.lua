


-- Food Poisoning
local perishable_items = {}
local perishable_groups = {
    "food_meat_raw" = 0.45,
    "food_milk" = 0.35,
}

function afflictions.register_perishable_group(group_name)
    table.insert(perishable_groups, group_name)
end


for name, itemdef in pairs(minetest.registered_items) do
    local groups = itemdef.groups
    for perishable_group, chance in ipairs(perishable_groups) do
        if groups[perishable_group] then
            local definition = itemdef
            table.insert(perishable_items, name)
            definition.stack_max = 1 -- Just to make life harder
            minetest.override_item(name, definition)
        end
    end
end

local function is_perished(item_name)
    local perished_value = math.random()
    if perished_value <  then
        return true
    end
    return false
end

minetest.register_on_item_eat(function(hp_change, replace_with_item, itemstack, user, pointed_thing)
    local item_name = itemstack:get_name()
    print(item_name)
    for _, perishable_item in ipairs(perishable_items) do
        print(perishable_item)
        if item_name == perishable_item then
            
            if is_perished() then
                print("tainted")
                itemstack:take_item(1)
                stamina.poison(user, hp_change, stamina.settings.poison_tick)
                --return itemstack
            end
        end
    end
end)

