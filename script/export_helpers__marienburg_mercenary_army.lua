SAM_MARIENBURG_NORSCA_ARMY_TECH = "SAM_ADD"
SAM_MARIENBURG_NORSCA_ARMY_COOLDOWN = 40
--button image paths.
SAM_MARIENBURG_BUTTON_ACTIVE = "SAM_ADD.png" --:string
SAM_MARIENBURG_BUTTON_DISABLED = "SAM_ADD.png" --:string
SAM_MARIENBURG_BUTTON_TOOLTIP_ACTIVE = "SAM_ADD" --:string
SAM_MARIENBURG_BUTTON_TOOLTIP_DISABLED = "SAM_ADD" --:string


--spawn information
SAM_MARIENBURG_SPAWNED_FORCE = "units,seperated,by,commas,no,spaces,SAM,ADD" --:string
SAM_MARIENBURG_SPAWNED_GENERAL_SUBTYPE = "SAM_ADD"--:string
--add as many as you like, it will select the name randomly
SAM_MARIENBURG_SPAWNED_GENERAL_FORENAME = {"SAM_ADD", "SAM_ADD"} --:vector<string>
SAM_MARIENBURG_SPAWNED_GENERAL_SURNAME = {"SAM_ADD", "SAM_ADD"}--:vector<string>

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
        spawn_mercs()
    end,
    true)



--v function() --> BUTTON
local function get_merc_button()
    local existingButton = Util.getComponentWithName("SamMarienburgNorscaButton")
    if not not existingButton then
        --# assume existingButton: BUTTON
        return existingButton
    else
        local component = find_uicomponent(core:get_ui_root(), "button_group_management")
        if not not component then
            local NorscaButton = Button.new("SamMarienburgNorscaButton", component, "CIRCULAR", "SAM_MARIENBURG_BUTTON_ACTIVE")
            NorscaButton:Resize(69, 69)
            return NorscaButton  
        else
            marien:log("ERROR: button generation failed, could not find the parent!")
        end
    end
    return nil
end

--v function()
local function trigger_UI_spawn_norsca()
    local marienburg = cm:get_faction("wh_main_emp_marienburg")
    CampaignUI.TriggerCampaignScriptEvent(marienburg:command_queue_index(), "SAM_MARIENBURG_SPAWN_NORSCANS")

end



--v function(active: boolean, button: BUTTON)
local function set_merc_button_tooltip(active, button)
    local uic = button:GetContentComponent()
    if not not uic then
        if active == true then
            uic:SetTooltipText(SAM_MARIENBURG_BUTTON_TOOLTIP_ACTIVE)
            button:RegisterForClick(function() trigger_UI_spawn_norsca()  end)
        else 
            uic:SetTooltipText(SAM_MARIENBURG_BUTTON_TOOLTIP_DISABLED)
            button:RegisterForClick(function() end)
        end
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
                get_merc_button():Delete()
            end
        end
    end,
    true
)











