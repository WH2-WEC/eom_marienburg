SAM_MARIENBURG_MONOPOLY_TECH = "SAM_ADD" --:string
SAM_MONOPOLY_BUNDLE_PREFIX = "SAM_ADD"




--v function(counter: number)
local function apply_monopoly_bundles(counter)
    marien:log("applying monopoly bundles for trade domiance over ["..counter.."] factions ")
    if counter >= 2 then
        if cm:get_faction("wh_main_emp_marienburg"):has_effect_bundle(SAM_MONOPOLY_BUNDLE_PREFIX.."_"..math.ceil(counter/2)) then
            marien:log("bundle unchanged!")
            return
        end
    end

    for i = 1, 5 do
        if cm:get_faction("wh_main_emp_marienburg"):has_effect_bundle(SAM_MONOPOLY_BUNDLE_PREFIX.."_"..i) then
            cm:remove_effect_bundle(SAM_MONOPOLY_BUNDLE_PREFIX.."_"..i, "wh_main_emp_marienburg")
        end
    end
    if counter < 2 then
        marien:log("Less than two factions, granting no bonus")
        return
    end
    if counter > 10 then counter = 10 end
    local level = math.ceil(counter/2)
    marien:log("bundle level is ["..level.."]")
    cm:apply_effect_bundle(SAM_MONOPOLY_BUNDLE_PREFIX.."_"..level, "wh_main_emp_marienburg", 0)
    
end








--v function()
local function calculate_marienburg_monopoly()
    local marienburg = cm:get_faction("wh_main_emp_marienburg")
    if  marienburg:has_technology(SAM_MARIENBURG_MONOPOLY_TECH) or MARIENBURG_TESTING_VAR == true then
        local trading_nations = marienburg:factions_trading_with()
        local monopoly_counter = 0 --:number
        for i = 0, trading_nations:num_items() - 1 do
            if marienburg:trade_value() > trading_nations:item_at(i):trade_value() then
                monopoly_counter = monopoly_counter + 1
            end
        end
        apply_monopoly_bundles(monopoly_counter)
    end
end















core:add_listener(
    "MarienburgMonopolyMechanic",
    "FactionTurnStart",
    function(context)
        return context:faction():name() == "wh_main_emp_marienburg"
    end,
    function(context)

    end,
    true
)