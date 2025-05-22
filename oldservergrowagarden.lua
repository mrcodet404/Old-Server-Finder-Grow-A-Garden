local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local PlaceId = game.PlaceId
local JobId = game.JobId


local placeVersion = "Unknown"
pcall(function()
    for _, v in pairs(CoreGui:GetDescendants()) do
        if v:IsA("TextLabel") and v.Text:find("Place Version:") then
            placeVersion = tonumber(v.Text:match("Place Version:%s*(%d+)")) or "Unknown"
            break
        end
    end
end)

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "SimpleServerHopUI"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.35, 0, 0.25, 0)
MainFrame.Size = UDim2.new(0, 450, 0, 320)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", MainFrame)
Title.Text = "🌀 Old Server Finder by @xxfrd666 ZEN0END"
Title.Font = Enum.Font.SourceSansBold
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, -50, 0, 40)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.TextXAlignment = Enum.TextXAlignment.Left


local VersionLabel = Instance.new("TextLabel", MainFrame)
VersionLabel.Font = Enum.Font.SourceSans
VersionLabel.TextSize = 14
VersionLabel.Position = UDim2.new(0, 15, 0, 50)
VersionLabel.Size = UDim2.new(1, -30, 0, 25)
VersionLabel.BackgroundTransparency = 1
VersionLabel.TextXAlignment = Enum.TextXAlignment.Center


if type(placeVersion) == "number" then
    if placeVersion <= 1231 then
        VersionLabel.Text = "✅ Old Server (v" .. placeVersion .. ")"
        VersionLabel.TextColor3 = Color3.fromRGB(0, 255, 0) -- hijau
    else
        VersionLabel.Text = "This Is New Server (v" .. placeVersion .. ")"
        VersionLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- merah
    end
else
    VersionLabel.Text = "Place Version: Unknown"
    VersionLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
end

local ServerHopBtn = Instance.new("TextButton", MainFrame)
ServerHopBtn.Text = "🔄 Find Old Server"
ServerHopBtn.Font = Enum.Font.SourceSansBold
ServerHopBtn.TextSize = 16
ServerHopBtn.TextColor3 = Color3.new(1, 1, 1)
ServerHopBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
ServerHopBtn.Position = UDim2.new(0.1, 0, 0, 100)
ServerHopBtn.Size = UDim2.new(0.8, 0, 0, 40)
Instance.new("UICorner", ServerHopBtn).CornerRadius = UDim.new(0, 4)

local JobIdBox = Instance.new("TextBox", MainFrame)
JobIdBox.PlaceholderText = "Enter JobId here"
JobIdBox.Font = Enum.Font.SourceSans
JobIdBox.TextSize = 14
JobIdBox.Text = ""
JobIdBox.TextColor3 = Color3.new(1, 1, 1)
JobIdBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
JobIdBox.Position = UDim2.new(0.1, 0, 0, 160)
JobIdBox.Size = UDim2.new(0.8, 0, 0, 35)
Instance.new("UICorner", JobIdBox).CornerRadius = UDim.new(0, 4)

local TeleportJobBtn = Instance.new("TextButton", MainFrame)
TeleportJobBtn.Text = "🔀 Teleport JobId"
TeleportJobBtn.Font = Enum.Font.SourceSansBold
TeleportJobBtn.TextSize = 16
TeleportJobBtn.TextColor3 = Color3.new(1, 1, 1)
TeleportJobBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 100)
TeleportJobBtn.Position = UDim2.new(0.1, 0, 0, 210)
TeleportJobBtn.Size = UDim2.new(0.8, 0, 0, 40)
Instance.new("UICorner", TeleportJobBtn).CornerRadius = UDim.new(0, 4)

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Text = "X"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 16

local MinimizeBtn = Instance.new("TextButton", MainFrame)
MinimizeBtn.Text = "➖"
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -70, 0, 5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
MinimizeBtn.TextColor3 = Color3.new(1,1,1)
MinimizeBtn.Font = Enum.Font.SourceSansBold
MinimizeBtn.TextSize = 16

local ReopenBtn = Instance.new("TextButton", ScreenGui)
ReopenBtn.Text = "🌀 Reopen"
ReopenBtn.Position = UDim2.new(0.01, 0, 0.9, 0)
ReopenBtn.Size = UDim2.new(0, 100, 0, 30)
ReopenBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
ReopenBtn.TextColor3 = Color3.new(1, 1, 1)
ReopenBtn.Visible = false
ReopenBtn.Font = Enum.Font.SourceSansBold
ReopenBtn.TextSize = 16
Instance.new("UICorner", ReopenBtn).CornerRadius = UDim.new(0, 4)


local function ServerHop()
    local reqfunc = httprequest or request or syn and syn.request or http_request or fluxus and fluxus.request
    if reqfunc then
        local servers = {}
        local req = reqfunc({
            Url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true", PlaceId)
        })

        local body = HttpService:JSONDecode(req.Body)
        if body and body.data then
            for _, v in pairs(body.data) do
                if v.playing < v.maxPlayers and v.id ~= JobId then
                    table.insert(servers, v.id)
                end
            end
        end

        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(PlaceId, servers[math.random(1, #servers)], Players.LocalPlayer)
        else
            ServerHopBtn.Text = "❌ No Servers!"
            wait(2)
            ServerHopBtn.Text = "🔄 Server Hop"
        end
    else
        ServerHopBtn.Text = "❌ Exploit Not Supported"
        wait(2)
        ServerHopBtn.Text = "🔄 Server Hop"
    end
end


TeleportJobBtn.MouseButton1Click:Connect(function()
    local inputId = JobIdBox.Text
    if inputId ~= "" then
        TeleportService:TeleportToPlaceInstance(PlaceId, inputId, Players.LocalPlayer)
    else
        TeleportJobBtn.Text = "❌ No JobId!"
        wait(2)
        TeleportJobBtn.Text = "🔀 Teleport JobId"
    end
end)



ServerHopBtn.MouseButton1Click:Connect(ServerHop)
MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ReopenBtn.Visible = true
end)
ReopenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    ReopenBtn.Visible = false
end)
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
