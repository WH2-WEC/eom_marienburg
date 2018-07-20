local tech_manager = {} --#assume tech_manager: TECH_MANAGER

function tech_manager.init()
    local self = {}
    setmetatable(self, {
        __index = tech_manager
    }) --# assume self: TECH_MANAGER
    _G.tm = self 
    self._techs = {} --:map<string, SCRIPTED_TECH>
end --# assume tm: TECH_MANAGER

local scripted_tech = {} --# assume scripted_tech: SCRIPTED_TECH
--v function(tech: string, manager: TECH_MANAGER)
function scripted_tech.new(tech, manager)
    local self = {}
    setmetatable(self, {
        __index = tech_manager,
        __tostring = function() return tech end
    })
    self._key = tech
    self._manager = manager

    self._unlockConditional = function(context) return false end --: (function(context: WHATEVER) --> boolean)
    self._unlockEvent = nil --:string
    self._unlockMessage = nil --:WEC_TYPE_MESSAGE

    self._researchedCallback = function(context) end --: function(context: WHATEVER) 
    self._hasTechCallback = function() end --:function()
    self._everyTurnWhenResearchedCallback = function(context) end --:function(context: WHATEVER)
end