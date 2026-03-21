local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local WEBHOOK_URL = _G.WebhookURL

if not WEBHOOK_URL or WEBHOOK_URL == "" then
    warn("⚠️ [LỖI] Chưa nhập link Webhook vào biến _G.WebhookURL")
    return
end

-- Chờ leaderstats và Bounty nạp xong (phải khác 0 mới chạy tiếp)
local bounty_stat = player:WaitForChild("leaderstats"):WaitForChild("Bounty/Honor")
while bounty_stat.Value <= 0 do 
    task.wait(0.5) 
end

-- Bây giờ Bounty đã có số thực, lưu mốc này lại
local last_bounty = bounty_stat.Value

function send_notif(title, display_gained, color)
    local current_bounty = bounty_stat.Value
    
    local data = {
        ["embeds"] = {{
            ["title"] = "📈 " .. title,
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
                    ["name"] = "⚔️ Bounty Gained",
                    ["value"] = "```" .. display_gained .. "```",
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
                ["text"] = "Bounty VIP Tracker • " .. os.date("%X"),
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

-- GỬI TIN NHẮN CHÀO SÂN (Chỉ gửi 1 lần khi đã có số Bounty thật)
send_notif("INITIALIZED ⚔️", "+0", 16777215)

-- Vòng lặp theo dõi biến động
task.spawn(function()
    while task.wait(1) do 
        local current_bounty = bounty_stat.Value
        
        if current_bounty ~= last_bounty then
            local diff = current_bounty - last_bounty
            local prefix = (diff > 0) and "+" or ""
            
            -- Gửi Update khi đi săn có kết quả
            send_notif("BOUNTY UPDATE ✅", prefix .. tostring(diff), (diff > 0 and 65280 or 16711680))
            
            last_bounty = current_bounty 
        end
    end
end)
