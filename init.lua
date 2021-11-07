function getBones(pos, username)
    local pos1       = vector.subtract(pos, { x = 50, y = 50, z = 50 })
    local pos2       = vector.add(pos, { x = 50, y = 50, z = 50 })
    local pos_list   = minetest.find_nodes_in_area(pos1, pos2, {"bones:bones"})
    local user_pos_list = {}
    for _, pos_in_list in ipairs(pos_list) do
        local meta = minetest.get_meta(pos_in_list)
        if meta:get_string("owner") == username then
            user_pos_list[#user_pos_list+1] = pos_in_list
        end
    end
    return user_pos_list
end
