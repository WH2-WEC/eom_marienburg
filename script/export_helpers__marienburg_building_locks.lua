SAM_MARIENBURG_TRADE_BUILDING_KEY = "SAM_ADD"
SAM_MARIENBURG_TRADE_BUILDING_TECH = "SAM_ADD"
SAM_MARIENBURG_OCCUPATION_RESISTANCE_BUILDING_KEY = "SAM_ADD"
SAM_MARIENBURG_OCCUPATION_RESISTANCE_BUILDING_TECH = "SAM_ADD"



core:add_listener(
    "MarienburgBuildingUnlocksTurnStart",
    "FactionTurnStart",
    function(context)
        return context:faction():name() == "wh_main_emp_marienburg"
    end,
    function(context)
        local marienburg = cm:get_faction("wh_main_emp_marienburg")
        if marienburg:has_technology(SAM_MARIENBURG_TRADE_BUILDING_TECH) then
            cm:remove_restricted_building_level_record_for_faction("wh_main_emp_marienburg", SAM_MARIENBURG_TRADE_BUILDING_TECH)
        else
            cm:add_restricted_building_level_record_for_faction("wh_main_emp_marienburg", SAM_MARIENBURG_TRADE_BUILDING_TECH)
        end
        if marienburg:has_technology(SAM_MARIENBURG_OCCUPATION_RESISTANCE_BUILDING_TECH) then
            cm:remove_restricted_building_level_record_for_faction("wh_main_emp_marienburg", SAM_MARIENBURG_OCCUPATION_RESISTANCE_BUILDING_KEY)
        else
            cm:add_restricted_building_level_record_for_faction("wh_main_emp_marienburg", SAM_MARIENBURG_OCCUPATION_RESISTANCE_BUILDING_KEY)
        end
    end,
    true
)