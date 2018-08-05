    
    
--v function(faction: CA_FACTION) --> boolean
local function find_is_faction_met(faction)
	local met_list = cm:get_faction("wh_main_emp_marienburg"):factions_met();
	for i = 0, met_list:num_items() - 1 do
		if met_list:item_at(i) == faction then
			return true;
		end;
	end;
	return false;
end
--v function(region: CA_REGION) --> boolean
local function is_major_port(region)
	return region:is_province_capital() and not region:is_abandoned() and region:settlement():is_port();
end;


local function marienburg_see_major_ports()
    local region_list = cm:model():world():region_manager():region_list()
    for i = 0, region_list:num_items() - 1 do
        local current_region = region_list:item_at(i);
        
        if is_major_port(current_region) then
            local faction_name = current_region:owning_faction():name();
            if not cm:get_saved_value("marienburg_met_"..faction_name) == true then
                if find_is_faction_met(current_region:owning_faction()) then
                    cm:set_saved_value("marienburg_met"..faction_name, true)
                else
                    cm:set_saved_value("marienburg_met"..faction_name, true)
                    cm:make_diplomacy_available("wh_main_emp_marienburg", faction_name)
                end
            end
        end
    end
end

core:add_listener(
    "MarienburgPorts",
    "FactionTurnStart",
    function(context)
        return context:faction():name() == "wh_main_emp_marienburg"
    end,
    function(context)
        if cm:get_faction("wh_main_emp_marienburg"):has_technology("SAM_ENTER_KEY_HERE") or MARIENBURG_TESTING_VAR == true then
            marienburg_see_major_ports()
        end
    end,
    true)
