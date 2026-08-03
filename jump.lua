-- PART 1: SYSTEM INITIALIZATION, AUTO-SAVE DATA & HORIZONTAL GUI CONTAINER
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local PlayerGui = Player:WaitForChild("PlayerGui")

-- File cấu hình lưu trên thiết bị
local CONFIG_FILE = "V9_Menu_Config.json"
local HttpService = game:GetService("HttpService")

-- Giá trị mặc định của hệ thống
local config = {
    speedEnabled = false,
    jumpEnabled = false,
    flyEnabled = false,
    noclipEnabled = false,
    espEnabled = false,
    aimbotEnabled = false,
    flingEnabled = false,
    shiftLockEnabled = false,
    speedValue = 80,
    jumpHeightValue = 150,
    flySpeedValue = 50,
    menuTextureId = "rbxassetid://0", -- Mặc định không có ảnh nền
    shiftLockUIVisible = false
}

-- HÀM TỰ ĐỘNG LƯU VÀ TẢI CẤU HÌNH (Yêu cầu executor hỗ trợ readfile/writefile)
local function saveConfig()
    pcall(function()
        if writefile then
            writefile(CONFIG_FILE, HttpService:JSONEncode(config))
        end
    end)
end

local function loadConfig()
    pcall(function()
        if isfile and readfile and isfile(CONFIG_FILE) then
            local saved = HttpService:JSONDecode(readfile(CONFIG_FILE))
            for k, v in pairs(saved) do
                config[k] = v
            end
        end
    end)
end
loadConfig() -- Tải dữ liệu đã lưu ngay khi chạy script

-- KHỞI TẠO SCREEN GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HorizontalUltimateMenuV9"
ScreenGui.ResetOnSpawn = false
if gethui then ScreenGui.Parent = gethui() else ScreenGui.Parent = PlayerGui end

-- NÚT TRÒN MENU GHIM GÓC MÀN HÌNH
local ToggleMenuButton = Instance.new("TextButton")
ToggleMenuButton.Size = UDim2.new(0, 50, 0, 50)
ToggleMenuButton.Position = UDim2.new(0.02, 0, 0.15, 0)
ToggleMenuButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ToggleMenuButton.Text = "Menu"
ToggleMenuButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleMenuButton.Font = Enum.Font.SourceSansBold
ToggleMenuButton.TextSize = 15
ToggleMenuButton.ZIndex = 10
ToggleMenuButton.Parent = ScreenGui

local UICornerBtn = Instance.new("UICorner")
UICornerBtn.CornerRadius = UDim.new(0, 25)
UICornerBtn.Parent = ToggleMenuButton

-- KHUNG MENU HÌNH CHỮ NHẬT NẰM NGANG (Không lo tràn màn hình đứng)
local MainFrame = Instance.new("ImageLabel")
MainFrame.Size = UDim2.new(0, 540, 0, 260) -- Thiết kế ngang chuẩn cho Mobile
MainFrame.Position = UDim2.new(0.5, -270, 0.4, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Active = true
MainFrame.ScaleType = Enum.ScaleType.Slice
MainFrame.Parent = ScreenGui

-- Cập nhật ảnh nền Menu từ cấu hình đã lưu
if config.menuTextureId ~= "rbxassetid://0" then
    MainFrame.Image = config.menuTextureId
end

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 10)
UICornerMain.Parent = MainFrame

-- Tiêu đề Menu ở chính giữa trên cùng
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.BackgroundTransparency = 0.2
Title.Text = "HORIZONTAL MULTI-HACK MENU V9"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 14
Title.Parent = MainFrame

local UICornerTitle = Instance.new("UICorner")
UICornerTitle.CornerRadius = UDim.new(0, 10)
UICornerTitle.Parent = Title

-- Chia khung thành 2 bên cột Trái và cột Phải
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
-- PART 2: CREATE HORIZONTAL LAYOUT BUTTONS & VALUE INPUTS (LEFT & RIGHT COLUMNS)
local function createMenuButton(text, parent, sizeY, posY, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.65, 0, 0, sizeY)
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

local function createMenuTextBox(placeholder, parent, sizeY, posY)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.3, 0, 0, sizeY)
    box.Position = UDim2.new(0.7, 0, 0, posY)
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

-- === CÁC NÚT BÊN CỘT TRÁI (LEFT COLUMN) ===
local SpeedBtn = createMenuButton("Chạy Nhanh: TẮT", LeftColumn, 32, 5, Color3.fromRGB(200, 50, 50))
local SpeedBox = createMenuTextBox("Số: 80", LeftColumn, 32, 5)

local JumpBtn = createMenuButton("Nhảy Cao: TẮT", LeftColumn, 32, 45, Color3.fromRGB(200, 50, 50))
local JumpBox = createMenuTextBox("Số: 150", LeftColumn, 32, 45)

local FlyBtn = createMenuButton("Bay Lượn: TẮT", LeftColumn, 32, 85, Color3.fromRGB(200, 50, 50))
local FlyBox = createMenuTextBox("Tốc độ: 50", LeftColumn, 32, 85)

local NoclipBtn = createMenuButton("Xuyên Tường: TẮT", LeftColumn, 32, 125, Color3.fromRGB(200, 50, 50))
NoclipBtn.Size = UDim2.new(1, 0, 0, 32)

local FlingBtn = createMenuButton("Fling (Đẩy người): TẮT", LeftColumn, 32, 165, Color3.fromRGB(200, 50, 50))
FlingBtn.Size = UDim2.new(1, 0, 0, 32)

-- === CÁC NÚT BÊN CỘT PHẢI (RIGHT COLUMN) ===
local EspBtn = createMenuButton("ESP (Nhìn xuyên): TẮT", RightColumn, 32, 5, Color3.fromRGB(200, 50, 50))
EspBtn.Size = UDim2.new(1, 0, 0, 32)

local AimBtn = createMenuButton("Aimbot (Tự ngắm): TẮT", RightColumn, 32, 45, Color3.fromRGB(200, 50, 50))
AimBtn.Size = UDim2.new(1, 0, 0, 32)

-- Khu vực Dịch chuyển (Teleport)
local TpBox = createMenuTextBox("Nhập tên...", RightColumn, 32, 85)
TpBox.Size = UDim2.new(0.5, 0, 0, 32)
TpBox.Position = UDim2.new(0, 0, 0, 85)

local TpBtn = createMenuButton("Dịch Chuyển", RightColumn, 32, 85, Color3.fromRGB(0, 120, 200))
TpBtn.Size = UDim2.new(0.45, 0, 0, 32)
TpBtn.Position = UDim2.new(0.55, 0, 0, 85)

-- Nút hiển thị Shift Lock rời
local ToggleShiftLockUIVisibleBtn = createMenuButton("Nút Shift Lock: TẮT", RightColumn, 32, 125, Color3.fromRGB(200, 50, 50))
ToggleShiftLockUIVisibleBtn.Size = UDim2.new(1, 0, 0, 32)

-- Khu vực Đổi Ảnh Nền (Texture Image UID)
local TextureBox = createMenuTextBox("Nhập ID ảnh...", RightColumn, 32, 165)
TextureBox.Size = UDim2.new(0.5, 0, 0, 32)
TextureBox.Position = UDim2.new(0, 0, 0, 165)

local TextureBtn = createMenuButton("Đổi Nền", RightColumn, 32, 165, Color3.fromRGB(140, 20, 180))
TextureBtn.Size = UDim2.new(0.45, 0, 0, 32)
TextureBtn.Position = UDim2.new(0.55, 0, 0, 165)

-- NÚT SHIFTLOCK RỜI TRÊN MÀN HÌNH (Ghim gần nút nhảy của game)
local MobileShiftLockBtn = Instance.new("TextButton")
MobileShiftLockBtn.Size = UDim2.new(0, 50, 0, 50)
MobileShiftLockBtn.Position = UDim2.new(0.75, 0, 0.62, 0) 
MobileShiftLockBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MobileShiftLockBtn.Text = "🔒"
MobileShiftLockBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MobileShiftLockBtn.Font = Enum.Font.SourceSansBold
MobileShiftLockBtn.TextSize = 22
MobileShiftLockBtn.Visible = config.shiftLockUIVisible
MobileShiftLockBtn.Parent = ScreenGui

local UICornerSL = Instance.new("UICorner")
UICornerSL.CornerRadius = UDim.new(0, 25)
UICornerSL.Parent = MobileShiftLockBtn
-- PART 3: FEATURE LOGIC & PHYSICAL BYPASS
local function updateBypassPhysics()
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character:FindFirstChildOfClass("Humanoid") then
        local root = Player.Character.HumanoidRootPart
        local hum = Player.Character:FindFirstChildOfClass("Humanoid")
        if config.speedEnabled and hum.MoveDirection.Magnitude > 0 then
            root.CFrame = root.CFrame + (hum.MoveDirection * (config.speedValue / 100))
        end
    end
end
RunService.RenderStepped:Connect(updateBypassPhysics)

UserInputService.JumpRequest:Connect(function()
    if config.jumpEnabled and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local root = Player.Character.HumanoidRootPart
        root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, config.jumpHeightValue, root.AssemblyLinearVelocity.Z)
    end
end)

SpeedBox.FocusLost:Connect(function() local num = tonumber(SpeedBox.Text) if num then config.speedValue = num saveConfig() end end)
JumpBox.FocusLost:Connect(function() local num = tonumber(JumpBox.Text) if num then config.jumpHeightValue = num saveConfig() end end)
FlyBox.FocusLost:Connect(function() local num = tonumber(FlyBox.Text) if num then config.flySpeedValue = num saveConfig() end end)

RunService.Stepped:Connect(function()
    if config.noclipEnabled and Player.Character then
        for _, part in pairs(Player.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide == true then part.CanCollide = false end
        end
    end
end)

local function setFlying(state)
    if state then
        if flyConnection then flyConnection:Disconnect() end
        local rootPart = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
        local humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
        if not rootPart or not humanoid then return end
        flyBodyVelocity = Instance.new("BodyVelocity")
        flyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        flyBodyVelocity.Parent = rootPart
        flyBodyGyro = Instance.new("BodyGyro")
        flyBodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        flyBodyGyro.CFrame = rootPart.CFrame
        flyBodyGyro.Parent = rootPart
        humanoid.PlatformStand = true
        flyConnection = RunService.RenderStepped:Connect(function()
            if Player.Character and rootPart and Workspace.CurrentCamera then
                local camera = Workspace.CurrentCamera
                local moveDirection = humanoid.MoveDirection
                if moveDirection.Magnitude > 0 then
                    flyBodyVelocity.Velocity = camera.CFrame:VectorToWorldSpace(Vector3.new(moveDirection.X, 0, moveDirection.Z).Unit * config.flySpeedValue)
                else
                    flyBodyVelocity.Velocity = Vector3.new(0, 0.1, 0)
                end
                flyBodyGyro.CFrame = camera.CFrame
            end
        end)
    else
        if flyConnection then flyConnection:Disconnect() flyConnection = nil end
        if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
        if flyBodyGyro then flyBodyGyro:Destroy() flyBodyGyro = nil end
        if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then Player.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false end
    end
end
-- PART 4: AIMBOT, ESP, CUSTOM TEXTURE AND CONFIGURATION AUTO-LOAD
RunService.Heartbeat:Connect(function()
    if config.flingEnabled and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local root = Player.Character.HumanoidRootPart
        root.AssemblyAngularVelocity = Vector3.new(0, 99999, 0)
        root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    end
end)

local function applyESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Player and p.Character then
            if config.espEnabled then
                if not p.Character:FindFirstChild("ESPHighlight") then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "ESPHighlight"
                    highlight.FillColor = Color3.fromRGB(0, 255, 255)
                    highlight.FillTransparency = 0.4
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.Parent = p.Character
                end
            else
                local hl = p.Character:FindFirstChild("ESPHighlight")
                if hl then hl:Destroy() end
            end
        end
    end
end

local function getClosestPlayer()
    local closest = nil
    local shortestDistance = math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Player and p.Character and p.Character:FindFirstChild("Head") and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (p.Character.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance then closest = p shortestDistance = distance end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if config.aimbotEnabled then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end
    if config.espEnabled then applyESP() end
    if config.shiftLockEnabled and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        local root = Player.Character.HumanoidRootPart
        local lookVector = Camera.CFrame.LookVector
        root.CFrame = CFrame.new(root.Position, Vector3.new(root.Position.X + lookVector.X, root.Position.Y, root.Position.Z + lookVector.Z))
    end
end)

TpBtn.MouseButton1Click:Connect(function()
    local targetText = string.lower(TpBox.Text)
    if targetText == "" then return end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if string.sub(string.lower(p.Name), 1, #targetText) == targetText or string.sub(string.lower(p.DisplayName), 1, #targetText) == targetText then
                if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                    Player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                    break
                end
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

MobileShiftLockBtn.MouseButton1Click:Connect(function()
    config.shiftLockEnabled = not config.shiftLockEnabled
    MobileShiftLockBtn.BackgroundColor3 = config.shiftLockEnabled and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(50, 50, 50)
    MobileShiftLockBtn.Text = config.shiftLockEnabled and "🔓" or "🔒"
end)

local function refreshVisuals()
    SpeedBtn.Text = config.speedEnabled and "Chạy Nhanh: BẬT" or "Chạy Nhanh: TẮT"
    SpeedBtn.BackgroundColor3 = config.speedEnabled and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(200, 50, 50)
    JumpBtn.Text = config.jumpEnabled and "Nhảy Cao: BẬT" or "Nhảy Cao: TẮT"
    JumpBtn.BackgroundColor3 = config.jumpEnabled and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(200, 50, 50)
    FlyBtn.Text = config.flyEnabled and "Bay Lượn: BẬT" or "Bay Lượn: TẮT"
    FlyBtn.BackgroundColor3 = config.flyEnabled and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(200, 50, 50)
    NoclipBtn.Text = config.noclipEnabled and "Xuyên Tường: BẬT" or "Xuyên Tường: TẮT"
    NoclipBtn.BackgroundColor3 = config.noclipEnabled and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(200, 50, 50)
    FlingBtn.Text = config.flingEnabled and "Fling (Đẩy người): BẬT" or "Fling (Đẩy người): TẮT"
    FlingBtn.BackgroundColor3 = config.flingEnabled and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(200, 50, 50)
    EspBtn.Text = config.espEnabled and "ESP (Nhìn xuyên): BẬT" or "ESP (Nhìn xuyên): TẮT"
    EspBtn.BackgroundColor3 = config.espEnabled and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(200, 50, 50)
    AimBtn.Text = config.aimbotEnabled and "Aimbot (Tự ngắm): BẬT" or "Aimbot (Tự ngắm): TẮT"
    AimBtn.BackgroundColor3 = config.aimbotEnabled and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(200, 50, 50)
    ToggleShiftLockUIVisibleBtn.Text = config.shiftLockUIVisible and "Nút Shift Lock: BẬT" or "Nút Shift Lock: TẮT"
    ToggleShiftLockUIVisibleBtn.BackgroundColor3 = config.shiftLockUIVisible and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(200, 50, 50)
    MobileShiftLockBtn.Visible = config.shiftLockUIVisible
    setFlying(config.flyEnabled)
end

SpeedBtn.MouseButton1Click:Connect(function() config.speedEnabled = not config.speedEnabled saveConfig() refreshVisuals() end)
JumpBtn.MouseButton1Click:Connect(function() config.jumpEnabled = not config.jumpEnabled saveConfig() refreshVisuals() end)
FlyBtn.MouseButton1Click:Connect(function() config.flyEnabled = not config.flyEnabled saveConfig() refreshVisuals() end)
NoclipBtn.MouseButton1Click:Connect(function() config.noclipEnabled = not config.noclipEnabled saveConfig() refreshVisuals() if not config.noclipEnabled and Player.Character then for _, part in pairs(Player.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = true end end end end)
FlingBtn.MouseButton1Click:Connect(function() config.flingEnabled = not config.flingEnabled saveConfig() refreshVisuals() if not config.flingEnabled and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then Player.Character.HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0) end end)
EspBtn.MouseButton1Click:Connect(function() config.espEnabled = not config.espEnabled saveConfig() refreshVisuals() if not config.espEnabled then applyESP() end end)
AimBtn.MouseButton1Click:Connect(function() config.aimbotEnabled = not config.aimbotEnabled saveConfig() refreshVisuals() end)
ToggleShiftLockUIVisibleBtn.MouseButton1Click:Connect(function() config.shiftLockUIVisible = not config.shiftLockUIVisible saveConfig() refreshVisuals() end)

Player.CharacterAdded:Connect(function(Character) Character:WaitForChild("Humanoid") task.wait(0.5) if config.flyEnabled then setFlying(true) end end)
ToggleMenuButton.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true dragStart = input.Position startPos = MainFrame.Position input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end)
MainFrame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then local delta = input.Position - dragStart MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)

refreshVisuals()
print("Menu V9 Horizontal Completed!")
