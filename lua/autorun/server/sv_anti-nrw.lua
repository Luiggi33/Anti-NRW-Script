ANTI_NRW = ANTI_NRW or {}
ANTI_NRW.ToPunishPlayers = ANTI_NRW.ToPunishPlayers or {}
ANTI_NRW.Cache = ANTI_NRW.Cache or {}

local function getMinuteDifference(timestamp1, timestamp2)
    local minuteDifference = math.floor(math.abs(timestamp2 - timestamp1) / 60)
    return minuteDifference
end

function ANTI_NRW:CheckCache()
    if table.IsEmpty(self.Cache) then return end
    local checkedCache = {}
    local curTime = os.time()
    for cacheIP, cacheTime in pairs(self.Cache) do
        if getMinuteDifference(curTime, cacheTime) < ANTI_NRW.Cache_Duration then
            checkedCache[cacheIP] = cacheTime
        end
    end
    self.Cache = checkedCache
end

hook.Add("Initialize", "NRW_Verboten_Loader", function()
    if file.Exists("anti_nrw_cache.json", "DATA") then
        ANTI_NRW.Cache = util.JSONToTable(file.Read("anti_nrw_cache.json", "DATA") or "") or {}
        ANTI_NRW:CheckCache()
    end
    timer.Create("NRW_Verboten_Checker", 60 * 30, 0, function()
        ANTI_NRW:CheckCache()
        file.Write("anti_nrw_cache.json", util.TableToJSON(ANTI_NRW.Cache))
    end)
end)

hook.Add("ShutDown", "NRW_Verboten_SaveCache", function()
    ANTI_NRW:CheckCache()
    file.Write("anti_nrw_cache.json", util.TableToJSON(ANTI_NRW.Cache))
end)

hook.Add("PlayerConnect", "NRW_Verboten_Handler", function(_, ip)
    if ANTI_NRW.Cache[ip] then
        if getMinuteDifference(os.time(), ANTI_NRW.Cache[ip]) < ANTI_NRW.Cache_Duration then
            ANTI_NRW.ToPunishPlayers[ip] = true
            return
        else
            ANTI_NRW.Cache[ip] = nil
        end
    end
    http.Fetch("http://ip-api.com/json/" .. ip, function(body)
        local data = util.JSONToTable(body)
        if data.status == "success" and data.country == "Germany" and data.region == "NW" then
            ANTI_NRW.Cache[ip] = os.time()
            ANTI_NRW.ToPunishPlayers[ip] = true
        end
    end, function(err)
        print(err)
    end)
end)

gameevent.Listen("player_connect")
hook.Add("player_connect", "NRW_Verboten_Punisher", function(data)
	if ANTI_NRW.ToPunishPlayers[data.address] then
		game.KickID(data.userid, ANTI_NRW.Nachricht)
		ANTI_NRW.ToPunishPlayers[data.address] = nil
	end
end)
