local prior_afk_time = CreateConVar( "afk_time", "300", 0, "Set the time required to be punished for being inactive.")
 
local prior_warn_time = CreateConVar( "afk_time", "150", 0, "Set the time when people recieve a warning regarding their inactivity.")

hook.Add("PlayerInitialSpawn", "MakeAFKVar", function(ply)
    ply.NextAFK = CurTime() + prior_afk_time
end)
 
hook.Add("Think", "HandleAFKPlayers", function()
	local playercount = player.GetCount()
	local tPlayers = player.GetAll()
	for i = 1, playercount do
		local ply = tPlayers[i]
	  	 if ( ply:IsConnected() and ply:IsFullyAuthenticated() ) then
            if (!ply.NextAFK) then
                ply.NextAFK = CurTime() + prior_afk_time
            end
     		local afktime = ply.NextAFK
            if (CurTime() >= afktime - prior_warn_time) and (!ply.Warning) and playercount > game.MaxPlayers() - 10 then
                ply:ChatPrint("[Prior-AFK]: You will be kicked from the server soon if you continue to be inactive.")
                ply.Warning = true
            elseif playercount < game.MaxPlayers() - 12 then 
                ply:ChatPrint("[Prior-AFK]: You will be switched to Spectators soon if you continue to be inactive.")
                ply.Warning = true
            elseif (CurTime() >= afktime) and (ply.Warning) and playercount < game.MaxPlayers() - 10 then
                ply.Warning = nil
                ply.NextAFK = nil
                ply:SetTeam( TEAM_SPEC )
            elseif (CurTime() >= afktime) and (ply.Warning) and playercount > game.MaxPlayers() - 10 then
            	ply.Warning = nil
                ply.NextAFK = nil
                ply:Kick("[Prior-AFK]: You were kicked for being AFK on the server.")
            end
        end
	end
end)
 
hook.Add("KeyPress", "PlayerMoved", function(ply, key)
    ply.NextAFK = CurTime() + prior_afk_time
    ply.Warning = false
end)