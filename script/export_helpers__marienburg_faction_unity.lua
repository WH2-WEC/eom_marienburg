SAM_MARIENBURG_EMP_POINT_THRESHOLD = 40
SAM_MARIENBURG_BRET_POINT_THRESHOLD = 30

SAM_MARIENBURG_BRETONIA_UNITY_BUNDLE = "SAM_ADD"
SAM_MARIENBURG_EMPIRE_UNITY_BUNDLE = "SAM_ADD"

SAM_MARIENBURG_UNITY_REDUCTION_TECH_KEY = "SAM_ADD"
SAM_MARIENBURG_POST_TECH_UNITY_SUCCESS_CHANCE = 35

SAM_MARIENBURG_BATTLE_VALUE = 1
SAM_MARIENBURG_SETTLEMENT_EMPIRE_VALUES = {

    }--:map<string, number>
SAM_MARIENBURG_SETTLEMENT_BRET_VALUES = {

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
    end
    if not not SAM_MARIENBURG_SETTLEMENT_BRET_VALUES[region_name] then
        local old_unity = cm:get_saved_value("SAM_MARIENBURG_UNITY_BRET")
        local new_unity = old_unity + SAM_MARIENBURG_SETTLEMENT_BRET_VALUES[region_name]
        cm:set_saved_value("SAM_MARIENBURG_UNITY_BRET", new_unity)
    end
end

--v function()
local function marienburg_defeats_empire()
    local old_unity = cm:get_saved_value("SAM_MARIENBURG_UNITY_EMP")
    local new_unity = old_unity + 1
    cm:set_saved_value("SAM_MARIENBURG_UNITY_EMP", new_unity)
end

--v function()
local function marienburg_defeats_bret()
    local old_unity = cm:get_saved_value("SAM_MARIENBURG_UNITY_BRET")
    local new_unity = old_unity + 1
    cm:set_saved_value("SAM_MARIENBURG_UNITY_BRET", new_unity)
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
            if cm:get_saved_value("SAM_MARIENBURG_UNITY_BRET") >= SAM_MARIENBURG_BRET_POINT_THRESHOLD then
                local leader = cm:get_faction("wh_main_brt_bretonnia")
                local others = leader:factions_of_same_subculture()
                cm:apply_effect_bundle(SAM_MARIENBURG_BRETONIA_UNITY_BUNDLE, leader:name(), 20)
                cm:set_saved_value("SAM_MARIENBURG_BRET_UNITY_OCCURED", true)
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
            if cm:get_saved_value("SAM_MARIENBURG_UNITY_EMP") >= SAM_MARIENBURG_EMP_POINT_THRESHOLD then
                local leader = cm:get_faction("wh_main_emp_empire")
                local others = leader:factions_of_same_subculture()
                cm:apply_effect_bundle(SAM_MARIENBURG_EMPIRE_UNITY_BUNDLE, leader:name(), 20)
                cm:set_saved_value("SAM_MARIENBURG_EMP_UNITY_OCCURED", true)
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




























