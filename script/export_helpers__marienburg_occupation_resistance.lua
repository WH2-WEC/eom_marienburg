local OCCUPATION_BUNDLE_PREFIX = "marien_occupation_penalty"
local OCCUPATION_RESISTANCE_TECH_1 = "tech_Marien_Occupation_1"
local OCCUPATION_RESISTANCE_BUILDING = "Marien_Occupation"



--v function () --> string
local function get_occupation_resistance_level()
    local marienburg = cm:get_faction("wh_main_emp_marienburg")
    if marienburg:has_technology(OCCUPATION_RESISTANCE_TECH_1) then
        return "_1"
    else
        return "_2"
    end
end

--v function(region: string) --> boolean
local function should_province_resist(region)
    local restricted_regions = {
        ["wh_main_ostland_castle_von_rauken"] = 1,
        ["wh_main_ostland_norden"] = 1,
        ["wh_main_ostland_wolfenburg"] = 2,
        ["wh_main_reikland_altdorf"] = 2,
        ["wh_main_reikland_eilhart"] = 1,
        ["wh_main_reikland_grunburg"] = 1,
        ["wh_main_reikland_helmgart"] = 1,
        ["wh_main_stirland_the_moot"] = 1,
        ["wh_main_stirland_wurtbad"] = 2,
        ["wh_main_talabecland_kemperbad"] = 1,
        ["wh_main_wissenland_nuln"] = 2,
        ["wh_main_wissenland_pfeildorf"] = 1,
        ["wh_main_wissenland_wissenburg"] = 1,
        ["wh_main_hochland_brass_keep"] = 1,
        ["wh_main_hochland_hergig"] = 2,
        ["wh_main_middenland_carroburg"] = 1,
        ["wh_main_middenland_middenheim"] = 2,
        ["wh_main_middenland_weismund"] = 1,
        ["wh_main_nordland_dietershafen"] = 2,
        ["wh_main_nordland_salzenmund"] = 1,
        ["wh_main_talabecland_talabheim"] = 2,
        ["wh_main_averland_averheim"] = 2,
        ["wh_main_averland_grenzstadt"] = 1,
        ["wh_main_ostermark_bechafen"] = 2,
        ["wh_main_ostermark_essen"] = 1,
        ["wh_main_bastonne_et_montfort_castle_bastonne"] = 1,
        ["wh_main_bastonne_et_montfort_montfort"] = 1,
        ["wh_main_bordeleaux_et_aquitaine_aquitaine"] = 1,
        ["wh_main_bordeleaux_et_aquitaine_bordeleaux"] = 1,
        ["wh_main_carcassone_et_brionne_brionne"] = 1,
        ["wh_main_carcassone_et_brionne_castle_carcassonne"] = 1,
        ["wh_main_couronne_et_languille_couronne"] = 1,
        ["wh_main_couronne_et_languille_languille"] = 1,
        ["wh_main_forest_of_arden_castle_artois"] = 1,
        ["wh_main_forest_of_arden_gisoreux"] = 1,
        ["wh_main_lyonesse_lyonesse"] = 1,
        ["wh_main_parravon_et_quenelles_parravon"] = 1,
        ["wh_main_parravon_et_quenelles_quenelles"] = 1
    }--:map<string, number>
    if restricted_regions[region] == nil then
        return false
    else
        return true
    end
end





--v function ()
local function apply_occupation_reistance()

    local province_index = {} --:map<string, string>
    local province_locks = {} --:map<string, boolean>
    local provinces_with_building = {} --:map<string, boolean>
    local marienburg = cm:get_faction("wh_main_emp_marienburg")
    local region_list = marienburg:region_list()
    for i = 0, region_list:num_items() - 1 do
        cm:remove_effect_bundle_from_region(OCCUPATION_BUNDLE_PREFIX.."_1", region_list:item_at(i):name())
        cm:remove_effect_bundle_from_region(OCCUPATION_BUNDLE_PREFIX.."_2", region_list:item_at(i):name())
        if province_locks[region_list:item_at(i):province_name()] == nil then
            province_index[region_list:item_at(i):province_name()] = region_list:item_at(i):name()
        end
        if region_list:item_at(i):is_province_capital() then
            province_locks[region_list:item_at(i):province_name()] = true
        end
        if region_list:item_at(i):building_exists(OCCUPATION_RESISTANCE_BUILDING) then
            provinces_with_building[region_list:item_at(i):province_name()] = true
        end
    end
    local bundle = OCCUPATION_BUNDLE_PREFIX..get_occupation_resistance_level()
    for province, region in pairs(province_index) do
        if not provinces_with_building[province] == true then
            if should_province_resist(region) then
                cm:apply_effect_bundle_to_region(bundle, region, 0)
            end
        end
    end
end


core:add_listener(
    "MarienburgOccupationResistance",
    "FactionTurnStart",
    function(context)
       return context:faction():name() == "wh_main_emp_marienburg"
    end,
    function(context)
        apply_occupation_reistance()
    end,
    true)














