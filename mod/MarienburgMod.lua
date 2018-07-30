--Log script to text
--v function(text: string | number | boolean | CA_CQI)
local function MBLOG(text)
    local ftext = "GEOPOLITICS" 

    if not __write_output_to_logfile then
        return;
    end

    local logText = tostring(text)
    local logContext = tostring(ftext)
    local logTimeStamp = os.date("%d, %m %Y %X")
    local popLog = io.open("warhammer_expanded_log.txt","a")
    --# assume logTimeStamp: string
    popLog :write("MB:  [".. logTimeStamp .. "]:  "..logText .. "  \n")
    popLog :flush()
    popLog :close()
end

--v function()
local function MBSESSIONLOG()
    if not __write_output_to_logfile then
        return;
    end
    local logTimeStamp = os.date("%d, %m %Y %X")
    --# assume logTimeStamp: string

    local popLog = io.open("warhammer_expanded_log.txt","w+")
    popLog :write("NEW LOG ["..logTimeStamp.."] \n")
    popLog :flush()
    popLog :close() 
end
MBSESSIONLOG()
    



local marienburg_mod = {} --# assume marienburg_mod: MARIEN_MOD

--v function() 
function marienburg_mod.init()
    local self = {}
    setmetatable(self, {
        __index = marienburg_mod
    })--# assume self: marienburg_mod


    _G.marien = self
end


--v function(self: MARIEN_MOD, text: any)
function marienburg_mod.log(self, text)
    MBLOG(tostring(text))
end












marienburg_mod.init()