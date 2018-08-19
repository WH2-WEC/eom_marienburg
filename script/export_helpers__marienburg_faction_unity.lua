SAM_MARIENBURG_EMP_POINT_THRESHOLD = 40
SAM_MARIENBURG_BRET_POINT_THRESHOLD = 30

SAM_MARIENBURG_BRETONIA_UNITY_BUNDLE = "marien_bretonnia_unity"
SAM_MARIENBURG_EMPIRE_UNITY_BUNDLE = "marien_empire_unity"

SAM_MARIENBURG_UNITY_REDUCTION_TECH_KEY = "tech_Marien_Diplomacy_3a"
SAM_MARIENBURG_POST_TECH_UNITY_SUCCESS_CHANCE = 35

SAM_MARIENBURG_BATTLE_VALUE = 1
SAM_MARIENBURG_SETTLEMENT_EMPIRE_VALUES = {
        ["wh_main_ostland_castle_von_rauken"] = 1,
        ["wh_main_ostland_norden"] = 1,
        ["wh_main_ostland_wolfenburg"] = 1,
        ["wh_main_reikland_altdorf"] = 20,
        ["wh_main_reikland_eilhart"] = 1,
        ["wh_main_reikland_grunburg"] = 1,
        ["wh_main_reikland_helmgart"] = 1,
        ["wh_main_stirland_the_moot"] = 1,
        ["wh_main_stirland_wurtbad"] = 1,
        ["wh_main_talabecland_kemperbad"] = 1,
        ["wh_main_wissenland_nuln"] = 1,
        ["wh_main_wissenland_pfeildorf"] = 1,
        ["wh_main_wissenland_wissenburg"] = 1,
        ["wh_main_hochland_brass_keep"] = 1,
        ["wh_main_hochland_hergig"] = 1,
        ["wh_main_middenland_carroburg"] = 1,
        ["wh_main_middenland_middenheim"] = 15,
        ["wh_main_middenland_weismund"] = 1,
        ["wh_main_nordland_dietershafen"] = 1,
        ["wh_main_nordland_salzenmund"] = 1,
        ["wh_main_talabecland_talabheim"] = 1,
        ["wh_main_averland_averheim"] = 1,
        ["wh_main_averland_grenzstadt"] = 1,
        ["wh_main_ostermark_bechafen"] = 1,
        ["wh_main_ostermark_essen"] = 1
    }--:map<string, number>
SAM_MARIENBURG_SETTLEMENT_BRET_VALUES = {
        ["wh_main_bastonne_et_montfort_castle_bastonne"] = 1,
        ["wh_main_bastonne_et_montfort_montfort"] = 1,
        ["wh_main_bordeleaux_et_aquitaine_aquitaine"] = 1,
        ["wh_main_bordeleaux_et_aquitaine_bordeleaux"] = 1,
        ["wh_main_carcassone_et_brionne_brionne"] = 1,
        ["wh_main_carcassone_et_brionne_castle_carcassonne"] = 1,
        ["wh_main_couronne_et_languille_couronne"] = 20,
        ["wh_main_couronne_et_languille_languille"] = 1,
        ["wh_main_forest_of_arden_castle_artois"] = 1,
        ["wh_main_forest_of_arden_gisoreux"] = 1,
        ["wh_main_lyonesse_lyonesse"] = 1,
        ["wh_main_parravon_et_quenelles_parravon"] = 1,
        ["wh_main_parravon_et_quenelles_quenelles"] = 1
    }--:map<string, number>
if cm:get_saved_value("SAM_MARIENBURG_UNITY_BRET") == nil or cm:get_saved_value("SAM_MARIENBURG_UNITY_EMP") == nil then
    cm:set_saved_value("SAM_MARIENBURG_UNITY_BRET", 0)
    cm:set_saved_value("SAM_MARIENBURG_UNITY_EMP", 0)
end

--v function(region_name: string)
local function marienburg_took_settlement(region_name)
    if not not SAM_MARIENBURG_SETTLEMENT_EMPIRE_VALUES[region_name] then
        local old_unity = cm:get_saved_value("SAM_MARIENBURG_UNITY_EMP")
        local new_unity = old_unity + SAM_MARIENBURG_SETTLEMENT_EMPIRE_VALUES[region_name]
        cm:set_saved_value("SAM_MARIENBURG_UNITY_EMP", new_unity)
        marien:log("Marienburg took the settlement ["..region_name.."] and unity is now ["..new_unity.."] ")
    end
    if not not SAM_MARIENBURG_SETTLEMENT_BRET_VALUES[region_name] then
        local old_unity = cm:get_saved_value("SAM_MARIENBURG_UNITY_BRET")
        local new_unity = old_unity + SAM_MARIENBURG_SETTLEMENT_BRET_VALUES[region_name]
        cm:set_saved_value("SAM_MARIENBURG_UNITY_BRET", new_unity)
        marien:log("Marienburg took the settlement ["..region_name.."] and unity is now ["..new_unity.."] ")
    end
end

--v function()
local function marienburg_defeats_empire()
    local old_unity = cm:get_saved_value("SAM_MARIENBURG_UNITY_EMP")
    local new_unity = old_unity + 1
    cm:set_saved_value("SAM_MARIENBURG_UNITY_EMP", new_unity)
    marien:log("Marienburg defeated the empire and unity is now ["..new_unity.."] ")
end

--v function()
local function marienburg_defeats_bret()
    local old_unity = cm:get_saved_value("SAM_MARIENBURG_UNITY_BRET")
    local new_unity = old_unity + 1
    cm:set_saved_value("SAM_MARIENBURG_UNITY_BRET", new_unity)
    marien:log("Marienburg defeated the bret and unity is now ["..new_unity.."] ")
end







core:add_listener(
    "SamMarienburgUnitySettlementTaken",
    "GarrisonOccupiedEvent",
    function(context)
        return context:character():faction():name() == "wh_main_emp_marienburg" and context:character():faction():is_human()
    end,
    function(context)
        local gar_res = context:garrison_residence() --:CA_GARRISON_RESIDENCE
        local region_name = gar_res:region():name() 
        if cm:get_saved_value("SAM_MARIENBURG_ALREADY_TAKEN_"..region_name) == true then
            return
        end
        cm:set_saved_value("SAM_MARIENBURG_ALREADY_TAKEN_"..region_name, true)
        marienburg_took_settlement(region_name)
    end,
    true)

core:add_listener(
    "SamMarienburgUnityBattleCompleted",
    "CharacterCompletedBattle",
    function(context)
        return context:character():faction():name() == "wh_main_emp_marienburg" and context:character():faction():is_human() and context:character():won_battle()
    end,
    function(context)
        local character = context:character() --:CA_CHAR
        local enemies = cm:pending_battle_cache_get_enemies_of_char(character)
        for i = 1, #enemies do
            local enemy = enemies[i]
            local enemy_sub = enemy:faction():subculture()
            if enemy_sub == "wh_main_sc_brt_bretonnia" then
                marienburg_defeats_bret()
            elseif enemy_sub == "wh_main_sc_emp_empire" then
                marienburg_defeats_empire()
            end
        end
    end,
    true)




core:add_listener(
    "SamMarienburgUnityTurnStart",
    "FactionTurnStart",
    function(context)
        return context:faction():name() == "wh_main_emp_marienburg" and context:faction():is_human()
    end,
    function(context)
        if not cm:get_saved_value("SAM_MARIENBURG_BRET_UNITY_OCCURED") then
            marien:log("unity has not occured yet for bret!")
            if cm:get_saved_value("SAM_MARIENBURG_UNITY_BRET") >= SAM_MARIENBURG_BRET_POINT_THRESHOLD then
                local leader = cm:get_faction("wh_main_brt_bretonnia")
                local others = leader:factions_of_same_subculture()
                cm:apply_effect_bundle(SAM_MARIENBURG_BRETONIA_UNITY_BUNDLE, leader:name(), 20)
                cm:set_saved_value("SAM_MARIENBURG_BRET_UNITY_OCCURED", true)
                cm:show_message_event(
                    "wh_main_emp_marienburg",
                    "event_feed_strings_text_marienburg_unity_bret_title",
                    "event_feed_strings_text_marienburg_unity_bret_sub",
                    "event_feed_strings_text_marienburg_unity_bret_desc",
                    true,
                    591)
                for i = 0, others:num_items() - 1 do
                    local current = others:item_at(i)
                    if cm:get_faction("wh_main_emp_marienburg"):has_technology(SAM_MARIENBURG_UNITY_REDUCTION_TECH_KEY) then
                        if cm:random_number(100) < SAM_MARIENBURG_POST_TECH_UNITY_SUCCESS_CHANCE then
                            cm:apply_effect_bundle(SAM_MARIENBURG_BRETONIA_UNITY_BUNDLE, current:name(), 20)
                        end
                    else
                        cm:apply_effect_bundle(SAM_MARIENBURG_BRETONIA_UNITY_BUNDLE, current:name(), 20)
                    end
                end

            end
        end
        if not cm:get_saved_value("SAM_MARIENBURG_EMP_UNITY_OCCURED") then
            marien:log("unity has not occured yet for empire!")
            if cm:get_saved_value("SAM_MARIENBURG_UNITY_EMP") >= SAM_MARIENBURG_EMP_POINT_THRESHOLD then
                local leader = cm:get_faction("wh_main_emp_empire")
                local others = leader:factions_of_same_subculture()
                cm:apply_effect_bundle(SAM_MARIENBURG_EMPIRE_UNITY_BUNDLE, leader:name(), 20)
                cm:set_saved_value("SAM_MARIENBURG_EMP_UNITY_OCCURED", true)
                cm:show_message_event(
                    "wh_main_emp_marienburg",
                    "event_feed_strings_text_marienburg_unity_emp_title",
                    "event_feed_strings_text_marienburg_unity_emp_sub",
                    "event_feed_strings_text_marienburg_unity_emp_desc",
                    true,
                    591)
                for i = 0, others:num_items() - 1 do
                    local current = others:item_at(i)
                    if cm:get_faction("wh_main_emp_marienburg"):has_technology(SAM_MARIENBURG_UNITY_REDUCTION_TECH_KEY) then
                        if cm:random_number(100) < SAM_MARIENBURG_POST_TECH_UNITY_SUCCESS_CHANCE then
                            cm:apply_effect_bundle(SAM_MARIENBURG_EMPIRE_UNITY_BUNDLE, current:name(), 20)
                        end
                    else
                        cm:apply_effect_bundle(SAM_MARIENBURG_EMPIRE_UNITY_BUNDLE, current:name(), 20)
                    end
                end
            end
        end
    end,
    true)




























