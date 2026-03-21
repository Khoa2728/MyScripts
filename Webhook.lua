repeat task.wait() until game:IsLoaded()

local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

local WEBHOOK_URL = _G.WebhookURL 
local last_bounty = LP.leaderstats["Bounty/Honor"].Value
local has_sent_initial = false 

local SafeGui = (gethui and gethui()) or game:GetService("CoreGui") or LP:WaitForChild("PlayerGui")
local LoadGui = Instance.new("ScreenGui", SafeGui)
local LoadFrame = Instance.new("Frame", LoadGui)
LoadFrame.Size = UDim2.new(0, 280, 0, 140)
LoadFrame.Position = UDim2.new(0.5, -140, 0.5, -70)
LoadFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Instance.new("UICorner", LoadFrame).CornerRadius = UDim.new(0, 10)
local ls = Instance.new("UIStroke", LoadFrame)
ls.Thickness = 1.5; ls.Color = Color3.fromRGB(85, 170, 255)

local WelcomeLabel = Instance.new("TextLabel", LoadFrame)
WelcomeLabel.Size = UDim2.new(1, 0, 0, 20); WelcomeLabel.Position = UDim2.new(0, 0, 0, 10)
WelcomeLabel.BackgroundTransparency = 1; WelcomeLabel.Text = "👋 Xin chào, " .. LP.DisplayName .. "!"
WelcomeLabel.TextColor3 = Color3.fromRGB(255, 220, 80); WelcomeLabel.Font = Enum.Font.GothamBold; WelcomeLabel.TextSize = 13

local ProgressBar = Instance.new("Frame", LoadFrame)
ProgressBar.Size = UDim2.new(0, 0, 0, 8); ProgressBar.Position = UDim2.new(0.09, 0, 0, 88)
ProgressBar.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
Instance.new("UICorner", ProgressBar).CornerRadius = UDim.new(0, 4)

local tween = TweenService:Create(ProgressBar, TweenInfo.new(2, Enum.EasingStyle.Quart), {Size = UDim2.new(0.82, 0, 0, 8)})
tween:Play(); tween.Completed:Wait()
LoadGui:Destroy()

local MainGui = Instance.new("ScreenGui", SafeGui)
local StatFrame = Instance.new("Frame", MainGui)
StatFrame.Size = UDim2.new(0, 180, 0, 90)
StatFrame.Position = UDim2.new(0, 10, 0.5, -45)
StatFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
StatFrame.BackgroundTransparency = 0.2
Instance.new("UICorner", StatFrame).CornerRadius = UDim.new(0, 8)
local st = Instance.new("UIStroke", StatFrame)
st.Color = Color3.fromRGB(85, 170, 255); st.Thickness = 2

local ToggleBtn = Instance.new("TextButton", MainGui)
ToggleBtn.Size = UDim2.new(0, 35, 0, 35)
ToggleBtn.Position = UDim2.new(0, 10, 0.5, 55)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
ToggleBtn.Text = "👁️"; ToggleBtn.TextColor3 = Color3.new(1,1,1); ToggleBtn.TextSize = 18
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
local ts = Instance.new("UIStroke", ToggleBtn)
ts.Color = Color3.fromRGB(85, 170, 255); ts.Thickness = 1.5

ToggleBtn.MouseButton1Click:Connect(function()
    StatFrame.Visible = not StatFrame.Visible
    ToggleBtn.Text = StatFrame.Visible and "👁️" or "❌"
end)

local function CreateStatText(name, pos, color)
    local l = Instance.new("TextLabel", StatFrame)
    l.Size = UDim2.new(1, -20, 0, 20); l.Position = pos
    l.BackgroundTransparency = 1; l.TextColor3 = color; l.Font = Enum.Font.GothamBold; l.TextSize = 11; l.TextXAlignment = Enum.TextXAlignment.Left
    return l
end

local BountyLabel = CreateStatText("Bounty", UDim2.new(0, 10, 0, 8), Color3.new(1,1,1))
local KillLabel = CreateStatText("Kills", UDim2.new(0, 10, 0, 33), Color3.fromRGB(255, 100, 100))
local TimeLabel = CreateStatText("Time", UDim2.new(0, 10, 0, 58), Color3.fromRGB(255, 200, 50))

function send_notif(title, diff, color, is_start)
    if not WEBHOOK_URL or WEBHOOK_URL == "" then return end
    
    local diff_text = is_start and "+0" or ((diff > 0 and "+" or "") .. tostring(diff))
    
    local data = {
        ["embeds"] = {{
            ["title"] = title,
            ["description"] = "Real-time report for: **@" .. LP.Name .. "**",
            ["color"] = color,
            ["fields"] = {
                {["name"] = "🏷️ Username", ["value"] = "```" .. LP.DisplayName .. "```", ["inline"] = true},
                {["name"] = "💰 Bounty (Current)", ["value"] = "```" .. tostring(LP.leaderstats["Bounty/Honor"].Value) .. "```", ["inline"] = true},
                {["name"] = "⚔️ Bounty Gained", ["value"] = "```" .. diff_text .. "```", ["inline"] = true},
                {["name"] = "✅ Status", ["value"] = "🟢 Online", ["inline"] = false}
            },
            ["image"] = {["url"] = "https://photo.znews.vn/Uploaded/mdf_drkydd/2016_12_18/12.gif"},
            ["footer"] = {["text"] = "Script by tuitenphaa • " .. os.date("%X")},
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

local StartTime = tick()
local TotalKills = 0
local IsWaitingSus = false

task.spawn(function()
    send_notif("📈 BOUNTY NOTIFICATION ⚔️", 0, 16777215, true)
    has_sent_initial = true
end)

task.spawn(function()
    while task.wait(0.5) do
        if IsWaitingSus and LP.Character and LP.Character:FindFirstChildOfClass("Tool") then
            LP.Character.Humanoid:UnequipTools()
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local current_bounty = LP.leaderstats["Bounty/Honor"].Value
            
            if has_sent_initial and current_bounty ~= last_bounty then
                local diff = current_bounty - last_bounty
                
                if diff > 0 then
                    TotalKills = TotalKills + 1
                    send_notif("📈 BOUNTY UPDATE ✅", diff, 65280, false)
                    IsWaitingSus = true
                    task.delay(2, function() IsWaitingSus = false end)
                elseif diff < 0 then
                    send_notif("📈 BOUNTY UPDATE ❌", diff, 16711680, false)
                end
                
                last_bounty = current_bounty 
            end
            
            BountyLabel.Text = "💰 BOUNTY: " .. tostring(current_bounty)
            KillLabel.Text = "⚔️ KILLS: " .. TotalKills
            local s = tick() - StartTime
            TimeLabel.Text = string.format("⏳ TIME: %02d:%02d:%02d", s/3600, (s%3600)/60, s%60)
        end)
    end
end)
