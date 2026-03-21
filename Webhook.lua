local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- LẤY URL TỪ BIẾN _G KHI CHẠY SCRIPT
local WEBHOOK_URL = _G.WebhookURL 

-- Kiểm tra nếu chưa nhập URL
if not WEBHOOK_URL or WEBHOOK_URL == "" or WEBHOOK_URL == "URL_WEBHOOK_CỦA_BẠN" then
    warn("⚠️ [LỖI] Bạn chưa nhập link Webhook vào biến _G.WebhookURL")
    return
end

local last_bounty = player.leaderstats.Bounty.Value

function send_notif(status, diff, color)
    local prefix = (diff > 0) and "+" or "" 
    
    local data = {
        ["embeds"] = {{
            ["title"] = "🎯 BOUNTY NOTIFICATION - " .. status,
            ["color"] = color,
            ["fields"] = {
                {
                    ["name"] = "👤 Người chơi",
                    ["value"] = "```" .. player.Name .. "```",
                    ["inline"] = true
                },
                {
                    ["name"] = "⚔️ Biến động",
                    ["value"] = "```" .. prefix .. tostring(diff) .. "```",
                    ["inline"] = true
                },
                {
                    ["name"] = "💰 Bounty Hiện Tại",
                    ["value"] = "```" .. tostring(player.leaderstats.Bounty.Value) .. "```",
                    ["inline"] = false
                }
            },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }

    local payload = HttpService:JSONEncode(data)
    
    -- Gửi dữ liệu đến Discord (Sử dụng request để tương thích tốt nhất với Executor)
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

-- Thông báo khi script bắt đầu chạy thành công
send_notif("STARTED 🚀", 0, 16776960) -- Màu vàng

-- Vòng lặp kiểm tra
task.spawn(function()
    while task.wait(2) do
        local current_bounty = player.leaderstats.Bounty.Value
        
        if current_bounty ~= last_bounty then
            local diff = current_bounty - last_bounty
            
            if diff > 0 then
                send_notif("WIN ✅", diff, 65280) -- Màu xanh lá
            elseif diff < 0 then
                send_notif("LOSS ❌", diff, 16711680) -- Màu đỏ
            end
            
            last_bounty = current_bounty 
        end
    end
end)
