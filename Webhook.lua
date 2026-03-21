local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local WEBHOOK_URL = _G.WebhookURL

if not WEBHOOK_URL or WEBHOOK_URL == "" then
    warn("⚠️ [LỖI] Chưa nhập link Webhook vào biến _G.WebhookURL")
    return
end

local last_bounty = player.leaderstats["Bounty/Honor"].Value
local has_sent_initial = false 

function send_notif(title, diff, color, is_start)
    local current_bounty = player.leaderstats["Bounty/Honor"].Value
    local prefix = ""
    
    local diff_text = is_start and "+0" or ((diff > 0 and "+" or "") .. tostring(diff))
    
    local data = {
        ["embeds"] = {{
            ["title"] = title,
            ["description"] = "Real-time report for: **@" .. player.Name .. "**",
            ["color"] = color,
            ["fields"] = {
                {
                    ["name"] = "🏷️ Username",
                    ["value"] = "```" .. player.DisplayName .. "```",
                    ["inline"] = true
                },
                {
                    ["name"] = "💰 Bounty/Honor (Current)",
                    ["value"] = "```" .. tostring(current_bounty) .. "```",
                    ["inline"] = true
                },
                {
                    ["name"] = "⚔️ Bounty/Honor Gained",
                    ["value"] = "```" .. diff_text .. "```",
                    ["inline"] = true
                },
                {
                    ["name"] = "✅ Status",
                    ["value"] = "🟢 Online",
                    ["inline"] = false
                }
            },
            ["image"] = {
                ["url"] = "https://photo.znews.vn/Uploaded/mdf_drkydd/2016_12_18/12.gif" 
            },
            ["footer"] = {
                ["text"] = "Script by tuitenphaa • " .. os.date("%X"),
            },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }

    local payload = HttpService:JSONEncode(data)
    pcall(function()
        local req = (syn and syn.request or http_request or request or HttpPost)
        if req then
            req({Url = WEBHOOK_URL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = payload})
        else
            HttpService:PostAsync(WEBHOOK_URL, payload)
        end
    end)
end

task.spawn(function()
    send_notif("📈 BOUNTY NOTIFICATION ⚔️", 0, 16777215, true) 
    has_sent_initial = true
end)

task.spawn(function()
    while task.wait(1) do 
        local success, current_bounty = pcall(function() 
            return player.leaderstats["Bounty/Honor"].Value 
        end)
        
        if success and has_sent_initial then
            if current_bounty ~= last_bounty then
                local diff = current_bounty - last_bounty
                
                if diff > 0 then
                    send_notif("📈 BOUNTY UPDATE ✅", diff, 65280, false) 
                elseif diff < 0 then
                    send_notif("📈 BOUNTY UPDATE ❌", diff, 16711680, false) 
                end
                
                last_bounty = current_bounty 
            end
        end
    end
end)
