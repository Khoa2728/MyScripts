local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local WEBHOOK_URL = _G.WebhookURL

if not WEBHOOK_URL or WEBHOOK_URL == "" then
    warn("⚠️ [LỖI] Chưa nhập link Webhook vào biến _G.WebhookURL")
    return
end

-- Lấy mốc Bounty/Honor ngay khi chạy script
local last_bounty = player.leaderstats["Bounty/Honor"].Value

function send_notif(status, diff, color)
    local prefix = (diff > 0) and "+" or "" 
    local current_bounty = player.leaderstats["Bounty/Honor"].Value
    
    local data = {
        ["embeds"] = {{
            ["title"] = "📈 BOUNTY UPDATE ⚔️",
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
                    ["value"] = "```" .. prefix .. tostring(diff) .. "```",
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
        -- Tối ưu hóa request để tương thích với nhiều Executor
        local req = (syn and syn.request or http_request or request or HttpPost)
        if req then
            req({
                Url = WEBHOOK_URL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = payload
            })
        else
            -- Nếu Executor quá cũ không có hàm request
            HttpService:PostAsync(WEBHOOK_URL, payload)
        end
    end)
end

-- Vòng lặp kiểm tra Bounty mỗi giây
task.spawn(function()
    while task.wait(1) do 
        local success, current_bounty = pcall(function() 
            return player.leaderstats["Bounty/Honor"].Value 
        end)
        
        if success and current_bounty ~= last_bounty then
            local diff = current_bounty - last_bounty
            
            if diff > 0 then
                send_notif("WINNER ✅", diff, 65280) 
            elseif diff < 0 then
                send_notif("LOSER ❌", diff, 16711680) 
            end
            
            last_bounty = current_bounty 
        end
    end
end)
