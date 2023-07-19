ANTI_NRW = ANTI_NRW or {}

hook.Add("PlayerConnect", "NRW_Verboten", function(_, ip)
    http.Fetch("http://ip-api.com/json/" .. ip, function(body)
        local data = util.JSONToTable(body)
        if data.region == "NW" then
            if ANTI_NRW.Ban then
				ply:Ban(ANTI_NRW.BanDauer, ANTI_NRW.Nachricht)
            else
                ply:Kick(ANTI_NRW.Nachricht)
            end
        end
    end, function(err)
        print(err)
    end)
end)
