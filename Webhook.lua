local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- LẤY URL TỪ BIẾN _G
local WEBHOOK_URL = _G.WebhookURL 

if not WEBHOOK_URL or WEBHOOK_URL == "" then
    warn("⚠️ [LỖI] Chưa nhập link Webhook vào biến _G.WebhookURL")
    return
end

-- Lấy mốc Bounty ngay tại thời điểm chạy Script
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
                    ["name"] = "🏷️  Username",
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
                    ["value"] = "```" .. prefix .. tostring(diff) .. "```", -- Đây là số bounty vừa ăn được
                    ["inline"] = true
                },
                {
                    ["name"] = "✅ Status",
                    ["value"] = "```" .. 🟢 Online .. "```",
                    ["inline"] = false
                }
            },
            ["image"] = {
                ["url"] = "https://i.pinimg.com/originals/75/dd/c0/75ddc05c78d9168fa4296a75569b8fe1.gif" 
            },
            ["footer"] = {
                ["text"] = "Script by tuitenphaa • " .. os.date("%X"),
            },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }

    local payload = HttpService:JSONEncode(data)
    
    pcall(function()
        local request = (syn and syn.request or http_request or request or HttpPost)
        request({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = payload
        })
    end)
end

-- Vòng lặp kiểm tra thay đổi Bounty
task.spawn(function()
    while task.wait(1) do -- Kiểm tra mỗi giây cho nhạy
        local current_bounty = player.leaderstats["Bounty/Honor"].Value
        
        -- Nếu Bounty hiện tại khác với Bounty trước đó
        if current_bounty ~= last_bounty then
            local diff = current_bounty - last_bounty
            
            if diff > 0 then
                -- Ăn mạng (Win) -> Hiện số dương (Ví dụ: +12408)
                send_notif("WINNER ✅", diff, 65280) 
            elseif diff < 0 then
                -- Bị giết (Loss) -> Hiện số âm (Ví dụ: -15000)
                send_notif("LOSER ❌", diff, 16711680) 
            end
            
            -- Cập nhật lại mốc Bounty mới để tính cho lần tiếp theo
            last_bounty = current_bounty 
        end
    end
end)
