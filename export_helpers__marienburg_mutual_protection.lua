

core:add_listener(
    "MarienburgWarDeclared",
    "NegativeDiplomaticEvent",
    function(context)
        return true
    end,
    function(context)

    end,
    true
)