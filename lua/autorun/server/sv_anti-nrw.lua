ANTI_NRW = ANTI_NRW or {}
ANTI_NRW.ToPunishPlayers = ANTI_NRW.ToPunishPlayers or {}

hook.Add("PlayerConnect", "NRW_Verboten_Handler", function(_, ip)
    http.Fetch("http://ip-api.com/json/" .. ip, function(body)
        local data = util.JSONToTable(body)
        if data.status == "success" and data.country == "Germany" and data.region == "NW" then
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
