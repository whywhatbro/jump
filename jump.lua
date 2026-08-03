-- Khởi tạo dịch vụ
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Biến quản lý trạng thái
local jumpEnabled = false
local jumpPowerValue = 150 -- Sức nhảy khi bật
local normalJumpValue = 50  -- Sức nhảy mặc định

-- TẠO SCREEN GUI
local ScreenGui = Instance.new("ScreenGui")
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = PlayerGui end
ScreenGui.Name = "MobileJumpMenu"
ScreenGui.ResetOnSpawn = false

-- ==========================================
-- 1. NÚT TRÒN ĐỂ ẨN/HIỆN MENU (Dành cho Mobile)
-- ==========================================
local ToggleMenuButton = Instance.new("TextButton")
ToggleMenuButton.Size = UDim2.new(0, 50, 0, 50)
ToggleMenuButton.Position = UDim2.new(0.05, 0, 0.15, 0) -- Nằm góc trên bên trái màn hình
ToggleMenuButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleMenuButton.Text = "Menu"
ToggleMenuButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleMenuButton.Font = Enum.Font.SourceSansBold
ToggleMenuButton.TextSize = 14
ToggleMenuButton.Parent = ScreenGui

-- Bo tròn nút Mở Menu
local UICornerBtn = Instance.new("UICorner")
UICornerBtn.CornerRadius = UDim.new(0, 25) -- Tạo hình tròn
UICornerBtn.Parent = ToggleMenuButton

-- ==========================================
-- 2. KHUNG MENU CHÍNH (Đã phóng to để dễ chạm)
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 180) -- Kích thước vừa vặn cho màn hình điện thoại
MainFrame.Position = UDim2.new(0.5, -130, 0.4, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

-- Bo tròn các góc của Menu
local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 12)
UICornerMain.Parent = MainFrame

-- Tiêu đề Menu
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Text = "MOBILE JUMP MENU"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.Parent = MainFrame

local UICornerTitle = Instance.new("UICorner")
UICornerTitle.CornerRadius = UDim.new(0, 12)
UICornerTitle.Parent = Title

-- NÚT BẬT/TẮT NHẢY CAO (Nút to, dễ bấm trúng)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0.85, 0, 0, 50)
ToggleButton.Position = UDim2.new(0.075, 0, 0.45, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60) -- Màu đỏ ban đầu
ToggleButton.Text = "Nhảy Cao: TẮT"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 18
ToggleButton.Parent = MainFrame

local UICornerToggle = Instance.new("UICorner")
UICornerToggle.CornerRadius = UDim.new(0, 8)
UICornerToggle.Parent = ToggleButton

-- ==========================================
-- 3. LOGIC XỬ LÝ CHỨC NĂNG & DI ĐỘNG
-- ==========================================

-- Hàm cập nhật sức nhảy
local function updateJump()
    if Player.Character then
        local Humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            Humanoid.UseJumpPower = true
            Humanoid.JumpPower = jumpEnabled and jumpPowerValue or normalJumpValue
        end
    end
end

-- Tự động giữ trạng thái khi nhân vật hồi sinh
Player.CharacterAdded:Connect(function(Character)
    local Humanoid = Character:WaitForChild("Humanoid")
    task.wait(0.5)
    updateJump()
end)

-- Click bật/tắt Nhảy cao
ToggleButton.MouseButton1Click:Connect(function()
    jumpEnabled = not jumpEnabled
    if jumpEnabled then
        ToggleButton.Text = "Nhảy Cao: BẬT"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 220, 60) -- Xanh lá
    else
        ToggleButton.Text = "Nhảy Cao: TẮT"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60) -- Đỏ
    end
    updateJump()
end)

-- Click nút tròn để Ẩn/Hiện Menu chính
ToggleMenuButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- HỆ THỐNG KÉO THẢ MENU BẰNG CẢM ỨNG (Touch Drag)
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
          end
