local WebhookURL = "DÁN_LINK_WEBHOOK_DISCORD_CỦA_BẠN_VÀO_ĐÂY"

local function SendWebhook(msg)
    local data = {
        ["embeds"] = {{
            ["title"] = "🚀 BOUNTY UPDATE 🚀",
            ["description"] = msg,
            ["color"] = 65280, -- Màu xanh lá
            ["footer"] = {["text"] = "User: " .. game.Players.LocalPlayer.Name}
        }}
    }
    local response = (syn and syn.request or http_request or request or HttpPost)({
        Url = WebhookURL,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = game:GetService("HttpService"):JSONEncode(data)
    })
end

SendWebhook("Script đã được kích hoạt thành công cho người chơi: " .. game.Players.LocalPlayer.DisplayName)

-- Tự động gửi tin nhắn khi Bounty thay đổi
game.Players.LocalPlayer.leaderstats["Bounty/Honor"].Changed:Connect(function(newVal)
    SendWebhook("Bounty hiện tại: **" .. tostring(newVal) .. "**")
end)
