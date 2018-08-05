SAM_BRET_PROTECTION_BUNDLE = "marien_emp_positive_relations" 
SAM_EMP_PROTECTION_BUNDLE = "marien_bret_positive_relations"
SAM_PROTECTION_TECH = "tech_Marien_Diplomacy_1"

--v function(subculture: string) --> boolean
local function marienburg_at_war_with(subculture)
    local list = cm:get_faction("wh_main_emp_marienburg"):factions_at_war_with()
    for i = 0, list:num_items() - 1 do
        if list:item_at(i):subculture() == subculture then
            return true
        end
    end
    return false
end




core:add_listener(
    "MarienburgWarDeclaredProtection",
    "NegativeDiplomaticEvent",
    function(context)
        return context:recipient():name() == "wh_main_emp_marienburg"
    end,
    function(context)
        if cm:get_faction("wh_main_emp_marienburg"):has_technology(SAM_PROTECTION_TECH) or MARIENBURG_TESTING_VAR == true then
            if context:proposer():subculture() == "wh_main_sc_emp_empire" then
                cm:apply_effect_bundle(SAM_EMP_PROTECTION_BUNDLE, "wh_main_emp_marienburg", 0)
                marien:log("War declared on marienburg by ["..context:proposer():name().."] applying the empire war bundle!")
            elseif context:proposer():subculture() == "wh_main_sc_brt_bretonnia" then
                cm:apply_effect_bundle(SAM_BRET_PROTECTION_BUNDLE, "wh_main_emp_marienburg", 0)
                marien:log("War declared on marienburg by ["..context:proposer():name().."] applying the bret war bundle!")
            end
        end
    end,
    true
)

core:add_listener(
    "MarienburgTurnEndProtection",
    "FactionTurnStart",
    true,
    function(context)
        if cm:model():turn_number() == 2 and MARIENBURG_TESTING_VAR == true then
            cm:force_declare_war("wh_main_emp_empire", "wh_main_emp_marienburg", false, false)
        end
        local marienburg = cm:get_faction("wh_main_emp_marienburg")
        if not marienburg_at_war_with("wh_main_sc_emp_empire") then
            if marienburg:has_effect_bundle(SAM_EMP_PROTECTION_BUNDLE) then
                marien:log("Not at war with Empire anymore, removing the protection bundle!")
                cm:remove_effect_bundle(SAM_EMP_PROTECTION_BUNDLE, marienburg:name())
            end
        end
        if not marienburg_at_war_with("wh_main_sc_brt_bretonnia") then
            if marienburg:has_effect_bundle(SAM_BRET_PROTECTION_BUNDLE) then
                marien:log("Not at war with bretonnia anymore, removing the protection bundle!")
                cm:remove_effect_bundle(SAM_BRET_PROTECTION_BUNDLE, marienburg:name())
            end
        end
    end,
    true)

