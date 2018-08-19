SAM_MARIENBURG_MUDVARD_TECH = "SAM_ADD"
SAM_MARIENBURG_MUDVARD_SUBTYPE = "SAM_ADD"
SAM_MARIENBURG_MUDVARD_FORENAME = "SAM_ADD"
SAM_MARIENBURG_MUDVARD_SURNAME = "SAM_ADD"










if not cm:get_saved_value("sam_marienburg_mudvard_unlocked") then
    core:add_listener(
        "MudvarkUnlock",
        "FactionTurnStart",
        function(context)
            return context:faction():name() == "wh_main_emp_marienburg" and context:faction():has_technology(SAM_MARIENBURG_MUDVARD_TECH)
        end,
        function(context)
            cm:spawn_character_to_pool("wh_main_emp_marienburg", SAM_MARIENBURG_MUDVARD_FORENAME, SAM_MARIENBURG_MUDVARD_SURNAME, "", "", 18, true, "general", SAM_MARIENBURG_MUDVARD_SUBTYPE, true, "");
            cm:set_saved_value("sam_marienburg_mudvard_unlocked", true)
        end,
        false
    )
end