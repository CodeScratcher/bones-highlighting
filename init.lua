local function doesnt_have_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return false
        end
    end

    return true
end

local bones = {}
minetest.register_lbm({ name = "bone_finder:find_bones", nodenames = {"bones:bones"}, action = function(pos, node)
    print("hi")
    meta = minetest.get_meta(pos)
    if bones[meta:get_string("owner")] == nil then
        bones[meta:get_string("owner")] = {}
    end
    if doesnt_have_value(bones[meta:get_string("owner")], pos) then
        bones[meta:get_string("owner")][#bones[meta:get_string("owner")]+1] = pos
    end
end, run_at_every_load = true})

minetest.register_on_dieplayer(function(player)
	local player_name = player:get_player_name()
	if minetest.setting_getbool("creative_mode") then -- in creative, no chance of bones, bail
		return
	end

	local pos = player:get_pos()
	pos.x = math.floor(pos.x+0.5)
	pos.y = math.floor(pos.y+0.5)
	pos.z = math.floor(pos.z+0.5)


    if doesnt_have_value(bones[player_name], pos) then
        bones[player_name][#bones[player_name]+1] = pos
    end
end)


minetest.register_tool("bone_finder:bone_finder", {
    description = "Bone Finder",
    inventory_image = "bonefinder.png",
    on_use = function(toolstack, user, pointed_thing)
        if not user or not user:is_player() or user.is_fake_player then return end
        local poses = bones[user:get_player_name()]
        if poses == nil then
            minetest.chat_send_player(user:get_player_name(), "You have no bones in loaded chunks. If you're looking for someone else's bones, make sure they use it")
        else
            for _, pos_in_list in ipairs(poses) do
                minetest.chat_send_player(user:get_player_name(), "A bone was found at: (" .. pos_in_list.x .. ", " .. pos_in_list.y .. ", " .. pos_in_list.z .. ")")
            end
        end
        return toolstack
    end,
})

minetest.register_craft({
	output = "bone_finder:bone_finder",
	recipe = {
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
		{"default:steel_ingot", "default:mese_crystal", "default:steel_ingot"},
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
	}
})
