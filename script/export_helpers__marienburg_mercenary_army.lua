SAM_MARIENBURG_NORSCA_ARMY_TECH = "tech_Marien_Diplomacy_3b"
SAM_MARIENBURG_NORSCA_ARMY_COOLDOWN = 40
--button image paths.
SAM_MARIENBURG_BUTTON_ACTIVE = "ui/skins/default/icon_marien_norscan_diplomacy.png" --:string
SAM_MARIENBURG_BUTTON_DISABLED = "ui/skins/default/icon_marien_norscan_diplomacy_2.png" --:string
SAM_MARIENBURG_BUTTON_TOOLTIP_ACTIVE = "ui/skins/default/icon_marien_norscan_diplomacy.png" --:string
SAM_MARIENBURG_BUTTON_TOOLTIP_DISABLED = "ui/skins/default/icon_marien_norscan_diplomacy_2.png" --:string


--spawn information
SAM_MARIENBURG_SPAWNED_FORCE = "wh_dlc08_nor_inf_marauder_champions_0,wh_dlc08_nor_inf_marauder_champions_0,wh_dlc08_nor_inf_marauder_spearman_0,wh_dlc08_nor_inf_marauder_spearman_0,wh_dlc08_nor_mon_skinwolves_0,wh_main_nor_cav_marauder_horsemen_0,wh_main_nor_cav_marauder_horsemen_0,wh_dlc08_nor_inf_marauder_hunters_0,wh_dlc08_nor_inf_marauder_hunters_0,wh_dlc08_nor_mon_norscan_ice_trolls_0,wh_dlc08_nor_mon_norscan_ice_trolls_0,wh_main_nor_mon_chaos_warhounds_1,wh_main_nor_mon_chaos_warhounds_1" --:string
SAM_MARIENBURG_SPAWNED_GENERAL_SUBTYPE = "nor_marauder_chieftain"--:string
--add as many as you like, it will select the name randomly
SAM_MARIENBURG_SPAWNED_GENERAL_FORENAME = {"names_name_1002972665", "names_name_1007456194"} --:vector<string>
SAM_MARIENBURG_SPAWNED_GENERAL_SURNAME = {"names_name_2147356358", "names_name_2147356366"}--:vector<string>

if cm:get_saved_value("MARIENBURG_NORSCANS_CD") == nil then
    cm:set_saved_value("MARIENBURG_NORSCANS_CD", 0)
end



local function spawn_mercs()
    local marienburg = cm:get_faction("wh_main_emp_marienburg")
    cm:create_force_with_general(
        "wh_main_emp_marienburg",
        SAM_MARIENBURG_SPAWNED_FORCE,
        marienburg:home_region():name(),
        marienburg:home_region():settlement():logical_position_x() - 1,
        marienburg:home_region():settlement():logical_position_y() - 1,
        "general",
        SAM_MARIENBURG_SPAWNED_GENERAL_SUBTYPE,
        SAM_MARIENBURG_SPAWNED_GENERAL_FORENAME[cm:random_number(#SAM_MARIENBURG_SPAWNED_GENERAL_FORENAME)],
        "",
        SAM_MARIENBURG_SPAWNED_GENERAL_SURNAME[cm:random_number(#SAM_MARIENBURG_SPAWNED_GENERAL_SURNAME)],
        "",
        false,
        function(cqi)

        end)

end

--mp safe
core:add_listener(
    "MarienburgNorscaUIEvent",
    "UITriggerScriptEvent",
    function(context)
        return context:trigger() == "SAM_MARIENBURG_SPAWN_NORSCANS"
    end,
    function(context)
        marien:log("Recieved the UI event to spawn norscans!")
        spawn_mercs()
    end,
    true)



--v function() --> BUTTON
local function get_merc_button()
    local existingButton = Util.getComponentWithName("SamMarienburgNorscaButton")
    if not not existingButton then
        --# assume existingButton: BUTTON
        marien:log("Found an existing button: returning it")
        return existingButton
    else
        local component = find_uicomponent(core:get_ui_root(), "button_group_management")
        if not not component then
            local NorscaButton = Button.new("SamMarienburgNorscaButton", component, "CIRCULAR", SAM_MARIENBURG_BUTTON_ACTIVE)
            NorscaButton:Resize(69, 69)
            NorscaButton:SetVisible(true)
            marien:log("Created a new Norsca Button!")
            return NorscaButton  
        else
            marien:log("ERROR: button generation failed, could not find the parent!")
            return nil
        end
    end
end

--v function()
local function trigger_UI_spawn_norsca()
    marien:log("Sending the UI event to spawn norscans!")
    local marienburg = cm:get_faction("wh_main_emp_marienburg")
    CampaignUI.TriggerCampaignScriptEvent(marienburg:command_queue_index(), "SAM_MARIENBURG_SPAWN_NORSCANS")

end



--v function(active: boolean, button: BUTTON)
local function set_merc_button_tooltip(active, button)
        if active == true then
            marien:log("Setting up the Norscan button as active!")
            button:RegisterForClick(function() trigger_UI_spawn_norsca()  end)
        else 
            marien:log("Setting up the Norscan button as inactive!")
            button:RegisterForClick(function() end)
        end
end




core:add_listener(
    "MarienburgNorscaButtonTurnStart",
    "FactionTurnStart",
    function(context)
        return context:faction():is_human() 
    end,
    function(context)
        local marienburg = cm:get_faction("wh_main_emp_marienburg")
        if marienburg:has_technology(SAM_MARIENBURG_NORSCA_ARMY_TECH) or MARIENBURG_TESTING_VAR == true then
            if context:faction():name() == marienburg:name() then
                local button = get_merc_button()

                local cooldown = cm:get_saved_value("MARIENBURG_NORSCANS_CD") 

                if cooldown > 1 then
                    set_merc_button_tooltip(false, button)
                    cm:set_saved_value("MARIENBURG_NORSCANS_CD", cooldown - 1)
                elseif cooldown <= 1 then
                    cm:set_saved_value("MARIENBURG_NORSCANS_CD", 0)
                    set_merc_button_tooltip(true, button)
                end
            else
                marien:log("Deleting the button, it isn't marienburg's turn!")
                get_merc_button():Delete()
            end
        else
            marien:log("Not creating the Norsca Button! Marienburg does not have the tech yet!")
        end
    end,
    true
)



marien:log("Norscan button script is active!")







