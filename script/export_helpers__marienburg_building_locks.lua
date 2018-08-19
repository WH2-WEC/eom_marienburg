SAM_MARIENBURG_TRADE_BUILDING_KEY = "Marien_Costal"
SAM_MARIENBURG_TRADE_BUILDING_TECH = "tech_Marien_Merchant_3a"
SAM_MARIENBURG_OCCUPATION_RESISTANCE_BUILDING_KEY = "Marien_Occupation"
SAM_MARIENBURG_OCCUPATION_RESISTANCE_BUILDING_TECH = "tech_Marien_Occupation_2"



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