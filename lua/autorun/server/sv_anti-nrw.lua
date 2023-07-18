hook.Add("PlayerInitialSpawn", "NRW_Verboten", function(ply)
    http.Fetch("http://ip-api.com/json/" .. ply:IPAddress(), function(body)
        local data = util.JSONToTable(body)
        if data.region == "NW" then
            ply:Ban(0, "Du kommst aus NRW, du darfst hier nicht spielen!")
        end
    end, function(err)
        print(err)
    end)
end)