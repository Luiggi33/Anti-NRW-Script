hook.Add("PlayerConnect", "NRW_Verboten", function(_, ip)
    http.Fetch("http://ip-api.com/json/" .. ip, function(body)
        local data = util.JSONToTable(body)
        if data.region == "NW" then
            ply:Ban(0, "Du kommst aus NRW, du darfst hier nicht spielen!")
        end
    end, function(err)
        print(err)
    end)
end)
