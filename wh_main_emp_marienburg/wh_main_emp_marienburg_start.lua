cm:set_saved_value("Sam_Marienburg", true);



function mb_replace_with_ll()
    cm:disable_event_feed_events(true, "", "wh_event_subcategory_character_deaths", "");
	startmarienburgarmy = "Ersatzsolder_SwSh,Ersatzsolder_SwSh,Ersatzsolder_Sp,Ersatzsolder_Sp,Raubritter,Bergjaeger,wh_main_emp_art_mortar"

                cm:create_force_with_general(
		-- faction_key, unit_list, region_key, x, y, agent_type, agent_subtype, forename, clan_name, family_name, other_name, make_faction_leader, success_callback
		"wh_main_emp_marienburg",
		startmarienburgarmy,
		"wh_main_the_wasteland_marienburg",
		406,
		480,
		"general",
		"Marien_Mundvard",
		"names_name_7531593",
		"",		
		"names_name_7531594",
		"",
        true,
        function(cqi)
            cm:set_character_immortality(cm:char_lookup_str(cqi), true)
        end
    );
    cm:show_message_event(
        "wh_main_emp_marienburg",
        "event_feed_strings_text_marienburg_how_to_play_title",
        "event_feed_strings_text_marienburg_how_to_play_sub",
        "event_feed_strings_text_marienburg_how_to_play_desc",
        true,
        591)
                cm:set_character_immortality("faction:wh_main_emp_marienburg,forename:2147344088", false)
                cm.game_interface:kill_character_and_commanded_unit("faction:wh_main_emp_marienburg,forename:2147344088", true, true)
                cm:set_character_immortality("faction:wh_main_emp_marienburg,forename:991028", false)
                cm.game_interface:kill_character_and_commanded_unit("faction:wh_main_emp_marienburg,forename:991028", true, true)
    if cm:get_faction("wh_main_emp_marienburg"):is_human() then
        cm:force_make_peace("wh_main_emp_marienburg", "wh_main_brt_bretonnia")
        cm:force_declare_war("wh_main_emp_nordland", "wh_main_emp_marienburg", false, false)
        cm:force_declare_war("wh_main_brt_artois", "wh_main_emp_marienburg", false, false)
    end
    cm:callback(function() cm:disable_event_feed_events(false, "", "wh_event_subcategory_character_deaths", "") end, 1);
end;

local agent_subtype_key = "emp_marienburg"; -- character subtype_key here

function sam_marien_ancillary_listener()
    core:add_listener(
        "sam_marien_ancillary_listener",
        "CharacterCreated",
        function(context)
            return context:character():character_subtype(agent_subtype_key)
        end,
        function(context)
            local character = context:character();
            cm:force_add_ancillary(cm:char_lookup_str(character), "wh_anc_edward_van_der_kraal_sea_bride_standard"); -- Adding ???? ancillary to ????
        end,
        false
    );
end;


if cm:is_new_game() then 
	mb_replace_with_ll()
end
sam_marien_ancillary_listener()