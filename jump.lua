-- PART 1: KHỞI TẠO HỆ THỐNG VÀ GIAO DIỆN
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local PlayerGui = Player:WaitForChild("PlayerGui")

local jumpEnabled = false
local speedEnabled = false
local flyEnabled = false
local noclipEnabled = false
local espEnabled = false
local aimbotEnabled = false

local jumpHeightValue = 150 
local speedValue = 80     
local flySpeedValue = 50   

local flyBodyVelocity, flyBodyGyro, flyConnection

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MobileMenuV7_Fixed"
ScreenGui.ResetOnSpawn = false
if gethui then ScreenGui.Parent = gethui() else ScreenGui.Parent = PlayerGui end

local ToggleMenuButton = Instance.new("TextButton")
ToggleMenuButton.Size = UDim2.new(0, 55, 0, 55)
ToggleMenuButton.Position = UDim2.new(0.02, 0, 0.2, 0)
ToggleMenuButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ToggleMenuButton.Text = "Menu"
ToggleMenuButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleMenuButton.Font = Enum.Font.SourceSansBold
ToggleMenuButton.TextSize = 16
ToggleMenuButton.ZIndex = 10
ToggleMenuButton.Parent = ScreenGui

local UICornerBtn = Instance.new("UICorner")
UICornerBtn.CornerRadius = UDim.new(0, 28)
UICornerBtn.Parent = ToggleMenuButton

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 270, 0, 440)
MainFrame.Position = UDim2.new(0.5, -135, 0.4, -220)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 12)
UICornerMain.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Text = "MENU V7 (FIX NATURAL DISASTER)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 14
Title.Parent = MainFrame

local UICornerTitle = Instance.new("UICorner")
UICornerTitle.CornerRadius = UDim.new(0, 12)
UICornerTitle.Parent = Title

local function createButton(text, positionY, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.55, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, positionY)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.Parent = MainFrame
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    return btn
end

local function createTextBox(placeholder, positionY)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.3, 0, 0, 40)
    box.Position = UDim2.new(0.65, 0, 0, positionY)
    box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    box.PlaceholderText = placeholder
    box.Text = ""
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    box.Font = Enum.Font.SourceSans
    box.TextSize = 14
    box.Parent = MainFrame
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = box
    return box
end

local SpeedBtn = createButton("Chạy Nhanh: TẮT", 60, Color3.fromRGB(200, 50, 50))
local SpeedBox = createTextBox("Số: 80", 60)
local JumpBtn = createButton("Nhảy Cao: TẮT", 120, Color3.fromRGB(200, 50, 50))
local JumpBox = createTextBox("Số: 150", 120)
local FlyBtn = createButton("Bay Lượn: TẮT", 180, Color3.fromRGB(200, 50, 50))
local FlyBox = createTextBox("Tốc độ: 50", 180)
local NoclipBtn = createButton("Xuyên Tường: TẮT", 240, Color3.fromRGB(200, 50, 50))
local EspBtn = createButton("ESP (Nhìn xuyên): TẮT", 300, Color3.fromRGB(200, 50, 50))
EspBtn.Size = UDim2.new(0.9, 0, 0, 40)
local AimBtn = createButton("Aimbot (Tự ngắm): TẮT", 360, Color3.fromRGB(200, 50, 50))
AimBtn.Size = UDim2.new(0.9, 0, 0, 40)
-- PART 2: LOGIC XỬ LÝ CÁC CHỨC NĂNG VÀ VÁ LỖI
RunService.RenderStepped:Connect(function()
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character:FindFirstChildOfClass("Humanoid") then
        local root = Player.Character.HumanoidRootPart
        local hum = Player.Character:FindFirstChildOfClass("Humanoid")
        if speedEnabled and hum.MoveDirection.Magnitude > 0 then
            root.CFrame = root.CFrame + (hum.MoveDirection * (speedValue / 100))
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if jumpEnabled and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local root = Player.Character.HumanoidRootPart
        root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, jumpHeightValue, root.AssemblyLinearVelocity.Z)
    end
end)

SpeedBox.FocusLost:Connect(function() local num = tonumber(SpeedBox.Text) if num then speedValue = num end end)
JumpBox.FocusLost:Connect(function() local num = tonumber(JumpBox.Text) if num then jumpHeightValue = num end end)
FlyBox.FocusLost:Connect(function() local num = tonumber(FlyBox.Text) if num then flySpeedValue = num end end)

RunService.Stepped:Connect(function()
    if noclipEnabled and Player.Character then
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
                    flyBodyVelocity.Velocity = camera.CFrame:VectorToWorldSpace(Vector3.new(moveDirection.X, 0, -moveDirection.Z).Unit * flySpeedValue)
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

local function applyESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Player and p.Character then
            if espEnabled then
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
    if aimbotEnabled then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end
    if espEnabled then applyESP() end
end)

Player.CharacterAdded:Connect(function(Character) Character:WaitForChild("Humanoid") task.wait(0.5) if flyEnabled then setFlying(true) end end)

SpeedBtn.MouseButton1Click:Connect(function() speedEnabled = not speedEnabled SpeedBtn.Text = speedEnabled and "Chạy Nhanh: BẬT" or "Chạy Nhanh: TẮT" SpeedBtn.BackgroundColor3 = speedEnabled and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(200, 50, 50) end)
JumpBtn.MouseButton1Click:Connect(function() jumpEnabled = not jumpEnabled JumpBtn.Text = jumpEnabled and "Nhảy Cao: BẬT" or "Nhảy Cao: TẮT" JumpBtn.BackgroundColor3 = jumpEnabled and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(200, 50, 50) end)
FlyBtn.MouseButton1Click:Connect(function() flyEnabled = not flyEnabled FlyBtn.Text = flyEnabled and "Bay Lượn: BẬT" or "Bay Lượn: TẮT" FlyBtn.BackgroundColor3 = flyEnabled and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(200, 50, 50) setFlying(flyEnabled) end)
NoclipBtn.MouseButton1Click:Connect(function() noclipEnabled = not noclipEnabled NoclipBtn.Text = noclipEnabled and "Xuyên Tường: BẬT" or "Xuyên Tường: TẮT" NoclipBtn.BackgroundColor3 = noclipEnabled and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(200, 50, 50) if not noclipEnabled and Player.Character then for _, part in pairs(Player.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = true end end end end)
EspBtn.MouseButton1Click:Connect(function() espEnabled = not espEnabled EspBtn.Text = espEnabled and "ESP (Nhìn xuyên): BẬT" or "ESP (Nhìn xuyên): TẮT" EspBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(200, 50, 50) if not espEnabled then applyESP() end end)
AimBtn.MouseButton1Click:Connect(function() aimbotEnabled = not aimbotEnabled AimBtn.Text = aimbotEnabled and "Aimbot (Tự ngắm): BẬT" or "Aimbot (Tự ngắm): TẮT" AimBtn.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(200, 50, 50) end)

ToggleMenuButton.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true dragStart = input.Position startPos = MainFrame.Position input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end)
MainFrame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then local delta = input.Position - dragStart MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)

print("Menu V7 Mobile Full Loaded!")
