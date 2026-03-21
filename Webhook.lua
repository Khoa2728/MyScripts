local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- LẤY URL TỪ BIẾN _G
local WEBHOOK_URL = _G.WebhookURL 

if not WEBHOOK_URL or WEBHOOK_URL == "" then
    warn("⚠️ [LỖI] Chưa nhập link Webhook vào biến _G.WebhookURL")
    return
end

-- Lấy mốc Bounty ban đầu của người chơi đó
local last_bounty = player.leaderstats["Bounty/Honor"].Value

function send_notif(status, diff, color)
    local prefix = (diff > 0) and "+" or "" 
    local current_bounty = player.leaderstats["Bounty/Honor"].Value
    
    -- Tự động lấy Display Name (Tên hiển thị) và Username (Tên đăng nhập)
    local displayName = player.DisplayName
    local userName = player.Name

    local data = {
        ["embeds"] = {{
            -- Tiêu đề tự đổi theo tên người chơi
            ["title"] = "📈 BOUNTY UPDATE: " .. displayName .. " ⚔️",
            ["description"] = "Báo cáo thời gian thực cho tài khoản: **@" .. userName .. "**",
            ["color"] = color,
            ["fields"] = {
                {
                    ["name"] = "🏷️ Tên hiển thị",
                    ["value"] = "```" .. displayName .. "```",
                    ["inline"] = true
                },
                {
                    ["name"] = "💰 Bounty Hiện Tại",
                    ["value"] = "```" .. tostring(current_bounty) .. "```",
                    ["inline"] = true
                },
                {
                    ["name"] = "⚔️ Biến động",
                    ["value"] = "```" .. prefix .. tostring(diff) .. "```",
                    ["inline"] = true
                },
                {
                    ["name"] = "✅ Trạng thái",
                    ["value"] = "🟢 Đang trong Server",
                    ["inline"] = false
                }
            },
            -- Ảnh lớn (GIF) phía dưới cùng
            ["image"] = {
                ["url"] = "https://media.tenor.com/ZNMWudRKW3YAAAAM/fujiwara-chika-dance.gif" 
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

-- Chạy vòng lặp kiểm tra thay đổi Bounty
task.spawn(function()
    while task.wait(2) do
        local current_bounty = player.leaderstats["Bounty/Honor"].Value
        if current_bounty ~= last_bounty then
            local diff = current_bounty - last_bounty
            if diff > 0 then
                send_notif("WINNER ✅", diff, 65280) -- Màu xanh
            elseif diff < 0 then
                send_notif("LOSER ❌", diff, 16711680) -- Màu đỏ
            end
            last_bounty = current_bounty 
        end
    end
end)
