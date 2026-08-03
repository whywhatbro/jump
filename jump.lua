-- PART 1: SYSTEM, DATA CONFIG & ANTI-AFK
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local PlayerGui = Player:WaitForChild("PlayerGui")

local CONFIG_FILE = "MM2_DaiTayTruong_Config.json"
local HttpService = game:GetService("HttpService")

local config = {
    farmCoin = false,
    aimMurder = false,
    aimSheriff = false,
    shootMurderEnabled = false,
    killAllEnabled = false,
    espPlayers = false,
    menuTextureId = "rbxassetid://0"
}

local function saveConfig()
    pcall(function() if writefile then writefile(CONFIG_FILE, HttpService:JSONEncode(config)) end end)
end

local function loadConfig()
    pcall(function()
        if isfile and readfile and isfile(CONFIG_FILE) then
            local saved = HttpService:JSONDecode(readfile(CONFIG_FILE))
            for k, v in pairs(saved) do config[k] = v end
        end
    end)
end
loadConfig()

pcall(function()
    local VirtualUser = game:GetService("VirtualUser")
    Player.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0,0))
    end)
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DaiTayTruongMM2Menu"
ScreenGui.ResetOnSpawn = false
if gethui then ScreenGui.Parent = gethui() else ScreenGui.Parent = PlayerGui end

-- NÚT MENU ĐÃ SỬA LỖI ĐÓNG MỞ (FIXED TOGGLE)
local ToggleMenuButton = Instance.new("TextButton")
ToggleMenuButton.Size = UDim2.new(0, 50, 0, 50)
ToggleMenuButton.Position = UDim2.new(0.02, 0, 0.15, 0)
ToggleMenuButton.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
ToggleMenuButton.Text = "Menu"
ToggleMenuButton.TextColor3 = Color3.fromRGB(255, 215, 0)
ToggleMenuButton.Font = Enum.Font.SourceSansBold
ToggleMenuButton.TextSize = 14
ToggleMenuButton.ZIndex = 10
ToggleMenuButton.Parent = ScreenGui

local UICornerBtn = Instance.new("UICorner")
UICornerBtn.CornerRadius = UDim.new(0, 25)
UICornerBtn.Parent = ToggleMenuButton

local MainFrame = Instance.new("ImageLabel")
MainFrame.Size = UDim2.new(0, 540, 0, 240)
MainFrame.Position = UDim2.new(0.5, -270, 0.4, -120)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 15)
MainFrame.Active = true
MainFrame.ScaleType = Enum.ScaleType.Slice
MainFrame.Parent = ScreenGui

if config.menuTextureId ~= "rbxassetid://0" then MainFrame.Image = config.menuTextureId end

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 10)
UICornerMain.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
Title.BackgroundTransparency = 0.1
Title.Text = "FREE HACK BY ĐẠI TÀY TRƯỞNG"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 15
Title.Parent = MainFrame

local UICornerTitle = Instance.new("UICorner")
UICornerTitle.CornerRadius = UDim.new(0, 10)
UICornerTitle.Parent = Title

local LeftColumn = Instance.new("Frame")
LeftColumn.Size = UDim2.new(0.46, 0, 0.8, 0)
LeftColumn.Position = UDim2.new(0.02, 0, 0.16, 0)
LeftColumn.BackgroundTransparency = 1
LeftColumn.Parent = MainFrame

local RightColumn = Instance.new("Frame")
RightColumn.Size = UDim2.new(0.46, 0, 0.8, 0)
RightColumn.Position = UDim2.new(0.52, 0, 0.16, 0)
RightColumn.BackgroundTransparency = 1
RightColumn.Parent = MainFrame
-- PART 2: FIXED UI LAYOUT & BUTTON PRESET
local function createMenuButton(text, parent, posY, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.Position = UDim2.new(0, 0, 0, posY)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 13
    btn.Parent = parent
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = btn
    return btn
end

local function createMenuTextBox(placeholder, parent, posY)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.45, 0, 0, 32)
    box.Position = UDim2.new(0, 0, 0, posY)
    box.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    box.PlaceholderText = placeholder
    box.Text = ""
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.PlaceholderColor3 = Color3.fromRGB(140, 140, 140)
    box.Font = Enum.Font.SourceSans
    box.TextSize = 13
    box.Parent = parent
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = box
    return box
end

local FarmCoinBtn = createMenuButton("Auto Farm Coin: TẮT", LeftColumn, 5, Color3.fromRGB(200, 50, 50))
local AimMurderBtn = createMenuButton("Aimbot Khoá Murder: TẮT", LeftColumn, 42, Color3.fromRGB(200, 50, 50))
local AimSheriffBtn = createMenuButton("Aimbot Khoá Sheriff: TẮT", LeftColumn, 79, Color3.fromRGB(200, 50, 50))
local EspBtn = createMenuButton("ESP Nhìn Xuyên (M, S, I): TẮT", LeftColumn, 116, Color3.fromRGB(200, 50, 50))

local ShootToggleBtn = createMenuButton("Nút Bắn Murder Rời: TẮT", RightColumn, 5, Color3.fromRGB(200, 50, 50))
local KillAllBtn = createMenuButton("💀 KILL ALL PLAYER (MURDER) 💀", RightColumn, 42, Color3.fromRGB(150, 0, 0))

local TextureBox = createMenuTextBox("Nhập ID ảnh...", RightColumn, 85)
local TextureBtn = createMenuButton("Đổi Nền UI", RightColumn, 85, Color3.fromRGB(140, 20, 180))
TextureBtn.Size = UDim2.new(0.5, 0, 0, 32)
TextureBtn.Position = UDim2.new(0.5, 0, 0, 85)

local RoundShootBtn = Instance.new("TextButton")
RoundShootBtn.Name = "MobileCustomShootButton"
RoundShootBtn.Size = UDim2.new(0, 55, 0, 55)
RoundShootBtn.Position = UDim2.new(0.68, -65, 0.65, -65)
RoundShootBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
RoundShootBtn.Text = "SHOOT"
RoundShootBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RoundShootBtn.Font = Enum.Font.SourceSansBold
RoundShootBtn.TextSize = 14
RoundShootBtn.ZIndex = 5
RoundShootBtn.Visible = config.shootMurderEnabled
RoundShootBtn.Parent = ScreenGui

local UICornerShoot = Instance.new("UICorner")
UICornerShoot.CornerRadius = UDim.new(0, 28)
UICornerShoot.Parent = RoundShootBtn
-- PART 3: ROLE DETECTION, COIN TWEEN LOOP & MURDER KILL ALL LOGIC
local function getMM2Roles()
    local murder, sheriff = nil, nil
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character then
            if p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife") then
                murder = p
            elseif p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun") then
                sheriff = p
            end
        end
    end
    return murder, sheriff
end

local function getClosestCoin()
    local closest = nil
    local shortestDistance = math.huge
    local container = Workspace:FindFirstChild("Normal") or Workspace:FindFirstChild("InGame")
    if container and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        for _, obj in pairs(container:GetDescendants()) do
            if (obj.Name == "Coin_Giver" or obj.Name == "Coin") and obj:IsA("BasePart") then
                local distance = (obj.Position - Player.Character.HumanoidRootPart.Position).Magnitude
                if distance < shortestDistance then closest = obj shortestDistance = distance end
            end
        end
    end
    return closest
end

task.spawn(function()
    while task.wait(0.5) do
        if config.farmCoin and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
            local coinContainer = Player.Character:FindFirstChild("CoinContainer") or Player:FindFirstChild("CoinContainer")
            local isFull = false
            if coinContainer and coinContainer:FindFirstChild("Coin") and coinContainer.Coin.Value >= 40 then
                isFull = true
            end
            if humanoid and humanoid.Health > 0 and not isFull then
                local targetCoin = getClosestCoin()
                if targetCoin and Player.Character:FindFirstChild("HumanoidRootPart") then
                    local root = Player.Character.HumanoidRootPart
                    local distance = (targetCoin.Position - root.Position).Magnitude
                    local tweenInfo = TweenInfo.new(distance / 25, Enum.EasingStyle.Linear)
                    local tween = TweenService:Create(root, tweenInfo, {CFrame = targetCoin.CFrame})
                    for _, part in pairs(Player.Character:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                    tween:Play()
                    tween.Completed:Wait()
                    task.wait(0.1)
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.2) do
        if config.killAllEnabled and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local knife = Player.Character:FindFirstChild("Knife") or Player.Backpack:FindFirstChild("Knife")
            if knife then
                knife.Parent = Player.Character
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid") and p.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                        if config.killAllEnabled then
                            Player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame + p.Character.HumanoidRootPart.CFrame.LookVector * -1
                            knife:Activate()
                            task.wait(0.05)
                        end
                    end
                end
            end
        end
    end
end)
-- PART 4: ADVANCED CORNER-HIGHLIGHT ESP & SMOOTH TOGGLE CLICK
local function applyAdvancedESP()
    local murder, sheriff = getMM2Roles()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Player and p.Character and p.Character:FindFirstChildOfClass("Humanoid") and p.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            if config.espPlayers then
                local highlight = p.Character:FindFirstChild("MM2Highlight")
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "MM2Highlight"
                    highlight.FillTransparency = 0.4
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.Parent = p.Character
                end
                if p == murder then
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                elseif p == sheriff then
                    highlight.FillColor = Color3.fromRGB(0, 0, 255)
                else
                    highlight.FillColor = Color3.fromRGB(0, 255, 0)
                end
            else
                local hl = p.Character:FindFirstChild("MM2Highlight") if hl then hl:Destroy() end
            end
        end
    end
end

RunService.RenderStepped:Connect(function()
    local murder, sheriff = getMM2Roles()
    if config.aimMurder and murder and murder.Character and murder.Character:FindFirstChild("Head") then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, murder.Character.Head.Position)
    end
    if config.aimSheriff and sheriff and sheriff.Character and sheriff.Character:FindFirstChild("Head") then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, sheriff.Character.Head.Position)
    end
    if config.espPlayers then applyAdvancedESP() end
end)

RoundShootBtn.MouseButton1Click:Connect(function()
    local murder, _ = getMM2Roles()
    if murder and murder.Character and murder.Character:FindFirstChild("HumanoidRootPart") then
        local gun = Player.Character:FindFirstChild("Gun") or Player.Backpack:FindFirstChild("Gun")
        if gun then
            gun.Parent = Player.Character
            task.wait(0.02)
            if gun:FindFirstChild("KnifeServer") and gun.KnifeServer:FindFirstChild("ShootGun") then
                gun.KnifeServer.ShootGun:InvokeServer(murder.Character.HumanoidRootPart.Position)
            else
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, murder.Character.HumanoidRootPart.Position)
                local VirtualUser = game:GetService("VirtualUser")
                VirtualUser:CaptureController() VirtualUser:ClickButton1(Vector2.new(0,0))
            end
        end
    end
end)

TextureBtn.MouseButton1Click:Connect(function()
    local id = tonumber(TextureBox.Text)
    if id then
        local assetId = "rbxassetid://" .. id
        MainFrame.Image = assetId config.menuTextureId = assetId saveConfig()
    end
end)

local function refreshVisuals()
    FarmCoinBtn.Text = config.farmCoin and "Auto Farm Coin: BẬT" or "Auto Farm Coin: TẮT"
    FarmCoinBtn.BackgroundColor3 = config.farmCoin and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(200, 50, 50)
    AimMurderBtn.Text = config.aimMurder and "Aimbot Khoá Murder: BẬT" or "Aimbot Khoá Murder: TẮT"
    AimMurderBtn.BackgroundColor3 = config.aimMurder and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(200, 50, 50)
    AimSheriffBtn.Text = config.aimSheriff and "Aimbot Khoá Sheriff: BẬT" or "Aimbot Khoá Sheriff: TẮT"
    AimSheriffBtn.BackgroundColor3 = config.aimSheriff and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(200, 50, 50)
    EspBtn.Text = config.espPlayers and "ESP Nhìn Xuyên: BẬT" or "ESP Nhìn Xuyên: TẮT"
    EspBtn.BackgroundColor3 = config.espPlayers and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(200, 50, 50)
    ShootToggleBtn.Text = config.shootMurderEnabled and "Nút Bắn Murder Rời: BẬT" or "Nút Bắn Murder Rời: TẮT"
    ShootToggleBtn.BackgroundColor3 = config.shootMurderEnabled and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(200, 50, 50)
    KillAllBtn.Text = config.killAllEnabled and "💀 KILL ALL PLAYER: BẬT 💀" or "💀 KILL ALL PLAYER (MURDER) 💀"
    KillAllBtn.BackgroundColor3 = config.killAllEnabled and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(150, 0, 0)
    RoundShootBtn.Visible = config.shootMurderEnabled
end

FarmCoinBtn.MouseButton1Click:Connect(function() config.farmCoin = not config.farmCoin saveConfig() refreshVisuals() end)
AimMurderBtn.MouseButton1Click:Connect(function() config.aimMurder = not config.aimMurder saveConfig() refreshVisuals() if config.aimMurder then config.aimSheriff = false refreshVisuals() end end)
AimSheriffBtn.MouseButton1Click:Connect(function() config.aimSheriff = not config.aimSheriff saveConfig() refreshVisuals() if config.aimSheriff then config.aimMurder = false refreshVisuals() end end)
EspBtn.MouseButton1Click:Connect(function() config.espPlayers = not config.espPlayers saveConfig() refreshVisuals() if not config.espPlayers then applyAdvancedESP() end end)
ShootToggleBtn.MouseButton1Click:Connect(function() config.shootMurderEnabled = not config.shootMurderEnabled saveConfig() refreshVisuals() end)
KillAllBtn.MouseButton1Click:Connect(function() config.killAllEnabled = not config.killAllEnabled saveConfig() refreshVisuals() end)

-- SỬA LỖI ĐÓNG MỞ HOÀN TOÀN KHÔNG BỊ KẸT BIẾN ẨN
ToggleMenuButton.MouseButton1Click:Connect(function() 
    MainFrame.Visible = not MainFrame.Visible 
end)

local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true dragStart = input.Position startPos = MainFrame.Position input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end)
MainFrame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then local delta = input.Position - dragStart MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)

refreshVisuals()
print("free hack by dai tay truong fully fixed!")
