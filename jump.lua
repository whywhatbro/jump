-- PART 1: MM2 SYSTEM, AUTO-SAVE CONFIG & ANTI-AFK
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local PlayerGui = Player:WaitForChild("PlayerGui")

local CONFIG_FILE = "MM2_Menu_Config.json"
local HttpService = game:GetService("HttpService")

local config = {
    farmCoin = false,
    aimMurder = false,
    aimSheriff = false,
    killMurder = false,
    menuTextureId = "rbxassetid://0"
}

local function saveConfig()
    pcall(function()
        if writefile then writefile(CONFIG_FILE, HttpService:JSONEncode(config)) end
    end)
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

-- ANTI-AFK CHẠY NGẦM TREO GAME MM2
pcall(function()
    local VirtualUser = game:GetService("VirtualUser")
    Player.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0,0))
    end)
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2HorizontalMenuV10"
ScreenGui.ResetOnSpawn = false
if gethui then ScreenGui.Parent = gethui() else ScreenGui.Parent = PlayerGui end

local ToggleMenuButton = Instance.new("TextButton")
ToggleMenuButton.Size = UDim2.new(0, 50, 0, 50)
ToggleMenuButton.Position = UDim2.new(0.02, 0, 0.15, 0)
ToggleMenuButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ToggleMenuButton.Text = "MM2"
ToggleMenuButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleMenuButton.Font = Enum.Font.SourceSansBold
ToggleMenuButton.TextSize = 15
ToggleMenuButton.ZIndex = 10
ToggleMenuButton.Parent = ScreenGui

local UICornerBtn = Instance.new("UICorner")
UICornerBtn.CornerRadius = UDim.new(0, 25)
UICornerBtn.Parent = ToggleMenuButton

local MainFrame = Instance.new("ImageLabel")
MainFrame.Size = UDim2.new(0, 540, 0, 240)
MainFrame.Position = UDim2.new(0.5, -270, 0.4, -120)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 20, 20)
MainFrame.Active = true
MainFrame.ScaleType = Enum.ScaleType.Slice
MainFrame.Parent = ScreenGui

if config.menuTextureId ~= "rbxassetid://0" then MainFrame.Image = config.menuTextureId end

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 10)
UICornerMain.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(50, 30, 30)
Title.BackgroundTransparency = 0.2
Title.Text = "MURDER MYSTERY 2 ULTIMATE V10"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 14
Title.Parent = MainFrame

local UICornerTitle = Instance.new("UICorner")
UICornerTitle.CornerRadius = UDim.new(0, 10)
UICornerTitle.Parent = Title

local LeftColumn = Instance.new("Frame")
LeftColumn.Size = UDim2.new(0.46, 0, 0.8, 0)
LeftColumn.Position = UDim2.new(0.02, 0, 0.18, 0)
LeftColumn.BackgroundTransparency = 1
LeftColumn.Parent = MainFrame

local RightColumn = Instance.new("Frame")
RightColumn.Size = UDim2.new(0.46, 0, 0.8, 0)
RightColumn.Position = UDim2.new(0.52, 0, 0.18, 0)
RightColumn.BackgroundTransparency = 1
RightColumn.Parent = MainFrame
-- PART 2: UI BUTTON CREATION FOR MM2 FEATURES
local function createMenuButton(text, parent, posY, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
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
    box.Size = UDim2.new(0.45, 0, 0, 36)
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

-- NÚT CỘT TRÁI (LEFT)
local FarmCoinBtn = createMenuButton("Auto Farm Coin: TẮT", LeftColumn, 5, Color3.fromRGB(200, 50, 50))
local AimMurderBtn = createMenuButton("Aimbot Khoá Murder: TẮT", LeftColumn, 50, Color3.fromRGB(200, 50, 50))
local AimSheriffBtn = createMenuButton("Aimbot Khoá Sheriff: TẮT", LeftColumn, 95, Color3.fromRGB(200, 50, 50))

-- NÚT CỘT PHẢI (RIGHT)
local KillMurderBtn = createMenuButton("⚡ BẮN CHẾT MURDER ⚡", RightColumn, 5, Color3.fromRGB(180, 20, 20))

local TextureBox = createMenuTextBox("Nhập ID ảnh...", RightColumn, 55)
local TextureBtn = createMenuButton("Đổi Nền", RightColumn, 55, Color3.fromRGB(140, 20, 180))
TextureBtn.Size = UDim2.new(0.5, 0, 0, 36)
TextureBtn.Position = UDim2.new(0.5, 0, 0, 55)
-- PART 3: MM2 ROLE DETECTOR & TELEPORT/AIMBOT LOGIC
local function getMM2Roles()
    local murder, sheriff = nil, nil
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character then
            -- Quét dựa trên vật phẩm đang cầm hoặc để trong túi của người chơi
            if p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife") then
                murder = p
            elseif p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun") then
                sheriff = p
            end
        end
    end
    return murder, sheriff
end

-- Logic Auto Farm Coin (Dịch chuyển gom xu nhặt)
task.spawn(function()
    while task.wait(0.3) do
        if config.farmCoin and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local container = Workspace:FindFirstChild("Normal") or Workspace:FindFirstChild("InGame")
            if container then
                for _, obj in pairs(container:GetDescendants()) do
                    if config.farmCoin and (obj.Name == "Coin_Giver" or obj.Name == "Coin") and obj:IsA("BasePart") then
                        Player.Character.HumanoidRootPart.CFrame = obj.CFrame
                        task.wait(0.2) -- Độ trễ an toàn để game nhận xu
                    end
                end
            end
        end
    end
end)
-- PART 4: KILL MURDER, AIM LOCK, CUSTOM TEXTURE & AUTO-RESTORE VISUALS
RunService.RenderStepped:Connect(function()
    local murder, sheriff = getMM2Roles()
    
    -- Khóa góc nhìn vào Murder
    if config.aimMurder and murder and murder.Character and murder.Character:FindFirstChild("Head") then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, murder.Character.Head.Position)
    end
    
    -- Khóa góc nhìn vào Sheriff
    if config.aimSheriff and sheriff and sheriff.Character and sheriff.Character:FindFirstChild("Head") then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, sheriff.Character.Head.Position)
    end
end)

-- LOGIC NÚT BẮN TỰ ĐỘNG CHẾT THẲNG VÀO MURDER (Yêu cầu bạn đang cầm súng Sheriff)
KillMurderBtn.MouseButton1Click:Connect(function()
    local murder, _ = getMM2Roles()
    if murder and murder.Character and murder.Character:FindFirstChild("HumanoidRootPart") then
        local gun = Player.Character:FindFirstChild("Gun") or Player.Backpack:FindFirstChild("Gun")
        if gun then
            -- Tự động trang bị súng lên tay
            gun.Parent = Player.Character
            task.wait(0.05)
            -- Kích hoạt tia đạn bắn nổ thẳng vào vị trí Murder
            if gun:FindFirstChild("KnifeServer") and gun.KnifeServer:FindFirstChild("ShootGun") then
                gun.KnifeServer.ShootGun:InvokeServer(murder.Character.HumanoidRootPart.Position)
                print("Đã kích hoạt đạn bắn gục Murder!")
            else
                -- Phương án dự phòng ép hướng súng ngắm thẳng mục tiêu
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, murder.Character.HumanoidRootPart.Position)
                local VirtualUser = game:GetService("VirtualUser")
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new(0,0))
            end
        end
    end
end)

TextureBtn.MouseButton1Click:Connect(function()
    local id = tonumber(TextureBox.Text)
    if id then
        local assetId = "rbxassetid://" .. id
        MainFrame.Image = assetId
        config.menuTextureId = assetId
        saveConfig()
    end
end)

local function refreshVisuals()
    FarmCoinBtn.Text = config.farmCoin and "Auto Farm Coin: BẬT" or "Auto Farm Coin: TẮT"
    FarmCoinBtn.BackgroundColor3 = config.farmCoin and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(200, 50, 50)
    
    AimMurderBtn.Text = config.aimMurder and "Aimbot Khoá Murder: BẬT" or "Aimbot Khoá Murder: TẮT"
    AimMurderBtn.BackgroundColor3 = config.aimMurder and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(200, 50, 50)
    
    AimSheriffBtn.Text = config.aimSheriff and "Aimbot Khoá Sheriff: BẬT" or "Aimbot Khoá Sheriff: TẮT"
    AimSheriffBtn.BackgroundColor3 = config.aimSheriff and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(200, 50, 50)
end

FarmCoinBtn.MouseButton1Click:Connect(function() config.farmCoin = not config.farmCoin saveConfig() refreshVisuals() end)
AimMurderBtn.MouseButton1Click:Connect(function() config.aimMurder = not config.aimMurder saveConfig() refreshVisuals() if config.aimMurder then config.aimSheriff = false refreshVisuals() end end)
AimSheriffBtn.MouseButton1Click:Connect(function() config.aimSheriff = not config.aimSheriff saveConfig() refreshVisuals() if config.aimSheriff then config.aimMurder = false refreshVisuals() end end)

ToggleMenuButton.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true dragStart = input.Position startPos = MainFrame.Position input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end)
MainFrame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then local delta = input.Position - dragStart MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)

refreshVisuals()
print("MM2 Multi-Hack V10 Horizontal Loaded!")
