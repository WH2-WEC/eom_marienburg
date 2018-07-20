local marienburg_interest = {} --:{rate: number, cap: number}
marienburg_interest.cap = 5000
marienburg_interest.rate = (5/100)
marienburg_interest.bundle_prefix = "sam_marienburg_interest_rate_"

--v function(marienburg: CA_FACTION)
local function marienburg_evaluate_interest(marienburg)
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
local old_bundle = cm:get_saved_value("sam_marienburg_interest")
if old_bundle == nil then
    cm:set_saved_value("sam_marienburg_interest", interest_bundle)
    cm:apply_effect_bundle(interest_bundle, marienburg:name(), 0)
    return
end

if not old_bundle == interest_bundle then
    cm:remove_effect_bundle(old_bundle, marienburg:name())
    cm:apply_effect_bundle(interest_bundle, marienburg:name(), 0)
    cm:set_saved_value("sam_marienburg_interest", interest_bundle)
end
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