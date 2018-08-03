events = get_events(); cm = get_cm(); marien = _G.marien
local marienburg_interest = {
    cap = 5000,
    rate = (5/100),
    bundle_prefix = "sam_marienburg_interest_rate_"
} --:{rate: number, cap: number, bundle_prefix: string}


--v function(marienburg: CA_FACTION)
local function marienburg_evaluate_interest(marienburg)
    marien:log("Checking interest this turn for ["..marienburg:name().."] ")
    if marienburg:has_technology("tech_Marien_Banking_1") then
        marienburg_interest.rate = (8/100)
    end
    if marienburg:has_technology("tech_Marien_Banking_2") then
        marienburg_interest.cap = 10000
    end
    if marienburg:has_technology("tech_Marien_Banking_3a") then
        marienburg_interest.cap = 20000
    end

    local treasury = marienburg:treasury()
    local interest = treasury * marienburg_interest.rate
    local rounded_interest = math.floor((interest/100) + 0.5) * 100
    local interest_bundle = marienburg_interest.bundle_prefix..rounded_interest
    marien:log("new Interest bundle should be ["..interest_bundle.."] ")
    local old_bundle = cm:get_saved_value("sam_marienburg_interest")
    if old_bundle == nil then
        marien:log("setting the bundle for the first time!")
        cm:set_saved_value("sam_marienburg_interest", interest_bundle)
        cm:apply_effect_bundle(interest_bundle, marienburg:name(), 0)
        return
    end
    marien:log("old_bundle was ["..old_bundle.."] ")
        cm:remove_effect_bundle(old_bundle, marienburg:name())
        cm:apply_effect_bundle(interest_bundle, marienburg:name(), 0)
        cm:set_saved_value("sam_marienburg_interest", interest_bundle)
        marien:log("applied new interest bundle!")
end


core:add_listener(
    "MarienburgInterest",
    "FactionTurnStart",
    function(context)
        return context:faction():name() == "wh_main_emp_marienburg"
    end,
    function(context)
        marienburg_evaluate_interest(context:faction())
    end,
    true)
