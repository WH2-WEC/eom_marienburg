SAM_MARIENBURG_REBELLION_TECH = "SAM_ADD"
SAM_MARIENBURG_REBELLION_BUNDLE = "SAM_ADD"
SAM_MARIENBURG_REBELLION_CHANCE = 5

core:add_listener(
    "MarienburgRebellionTurnStart",
    "FactionTurnStart",
    function(context)
        return context:faction():name() == "wh_main_emp_marienburg" and context:faction():has_technology(SAM_MARIENBURG_REBELLION_TECH)
    end,
    function(context)
        for i = 0, context:faction():region_list():num_items() - 1 do
            local borders = context:faction():region_list():item_at(i):adjacent_region_list()
            for j = 0, borders:num_items() - 1 do
                local region = borders:item_at(j) --:CA_REGION
                if region:owning_faction():subculture() == "wh_main_sc_brt_brettonia" then
                    if cm:random_number(100) < SAM_MARIENBURG_REBELLION_CHANCE then
                        if not cm:get_saved_value("sam_marienburg_rebel_"..region:name()) then
                            cm:apply_effect_bundle_to_region(SAM_MARIENBURG_REBELLION_BUNDLE, region:name(), 3)
                            cm:set_saved_value("sam_marienburg_rebel_"..region:name(), true)
                        end
                    end
                end
            end
        end
    end,
    true
)