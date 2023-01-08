local Einstellungen = require(script.Parent.Einstellungen)
local EventSenden = game:GetService("ReplicatedStorage"):WaitForChild("Ticket Events").Senden
local EventEmpfangen = game:GetService("ReplicatedStorage"):WaitForChild("Ticket Events").Empfangen
local EventTeleport = game:GetService("ReplicatedStorage"):WaitForChild("Ticket Events").Teleport

local Datenbank = game:GetService("DataStoreService")

local DatenbankTicket = Datenbank:GetDataStore("Tickets")

local https = game:GetService("HttpService")


game:GetService("Players").PlayerAdded:Connect(function(player)
	
	print(DatenbankTicket)
	
end)


local function createMessage(url, message : string)
	local data = {
		["content"] = message
	}
	local finalData = https:JSONEncode(data)
	local finalUrl = string.gsub(url, "discord.com", "webhook.lewistehminerz.dev")
	local finalBackupUrl = string.gsub(url, "discord.com", "webhook.newstargeted.com")
	local good, bad = pcall(function()
		https:PostAsync(finalUrl, finalData)
	end)
	if good then
		print("Webhook Gesendet!")
	else
		print("Webhook senden Fehlgeschlagen " .. bad)
		https:PostAsync(finalBackupUrl, finalData)
		print("Webhook Down.")
	end
end


local function createEmbed(url, title : string, message :string , fields, image)
	local data = {
		['content'] = "",
		['embeds'] = {{
			["image"] = {["url"] = image},
			['title'] = "**"..title.."**",
			['description'] = message,
			['type'] = "rich",
			["color"] = tonumber(Einstellungen.EmbedFarbe),
			['fields'] = fields

		},
		},
	}
	local finalData = https:JSONEncode(data)
	local finalUrl = string.gsub(url, "discord.com", "webhook.lewistehminerz.dev")
	local finalBackupUrl = string.gsub(url, "discord.com", "webhook.newstargeted.com")

	local good, bad = pcall(function()
		https:PostAsync(finalUrl, finalData)
	end)
	if good then
		print("Webhook Gesendet!")
	else
		print("Webhook senden Fehlgeschlagen " .. bad)
		https:PostAsync(finalBackupUrl, finalData)
		print("Webhook Down.")

	end
end


local function createAuthorEmbed(url, authorName : string, iconurl, description : string, fields)
	local data = {
		["embeds"] = {{
			["author"] = {
				["name"] = authorName,
				["icon_url"] = iconurl,
			},
			["description"] = description,
			["color"] = tonumber(0xFFFAFA),
			["fields"] = fields


		}},
	}

	local finalData = https:JSONEncode(data)
	local finalUrl = string.gsub(url, "discord.com", "webhook.lewistehminerz.dev")
	local finalBackupUrl = string.gsub(url, "discord.com", "webhook.newstargeted.com")

	local good, bad = pcall(function()
		https:PostAsync(finalUrl, finalData)
	end)
	if good then
		print("Webhook Gesendet!")
	else
		print("Webhook senden Fehlgeschlagen " .. bad)
		https:PostAsync(finalBackupUrl, finalData)
		print("Webhook Down.")

	end
end

EventSenden.OnServerEvent:Connect(function(player, Art, Spieler, Grund)
	
	if Art == "SENDEN" then

		createEmbed(Einstellungen.WebhookURL, "TICKET", "**[SPIELER]** :  "..player.Name.."\n**[GEMELDET]** :  "..Spieler.."\n**[GRUND]** :  "..Grund)
		
		EventEmpfangen:FireAllClients("EMPFANGEN", Spieler, Grund)
		
		
		-- DATENBANK
		
		--DatenbankTicket:SetAsync(game:GetService("Players"):FindFirstChild(Spieler).UserId, Grund)
		--print("Gespeichert")
	end

end)

EventTeleport.OnServerEvent:Connect(function(player, Art, Spieler)
	
	if Art == "TELEPORT" then
		
		player.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(game.Workspace:WaitForChild(Spieler).HumanoidRootPart.Position)

		EventTeleport:FireClient(player, "TELEPORTNOTIFY", Spieler)
		
	end
	
	
	
	
end)
