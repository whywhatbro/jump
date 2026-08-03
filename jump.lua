-- Khởi tạo dịch vụ hệ thống
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Biến quản lý trạng thái các tính năng
local jumpEnabled = false
local speedEnabled = false
local noclipEnabled = false

local jumpPowerValue = 150 -- Độ cao nhảy khi bật
local speedValue = 100     -- Tốc độ chạy khi bật (Mặc định là 16)

-- TẠO GIAO DIỆN CHÍNH (GUI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateMobileMenu"
ScreenGui.ResetOnSpawn = false

if gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = PlayerGui
end

-- ==========================================
-- 1. NÚT TRÒN ẨN/HIỆN MENU
-- ==========================================
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

-- ==========================================
-- 2. KHUNG MENU CHÍNH (Phóng to để chứa 3 nút)
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 270)
MainFrame.Position = UDim2.new(0.5, -130, 0.4, -135)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 12)
UICornerMain.Parent = MainFrame

-- Tiêu đề Menu
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Text = "ULTIMATE MENU MOBILE"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.Parent = MainFrame

local UICornerTitle = Instance.new("UICorner")
UICornerTitle.CornerRadius = UDim.new(0, 12)
UICornerTitle.Parent = Title

-- Hàm mẫu tạo nút bấm nhanh để tránh trùng lặp code
local function createButton(text, positionY, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.85, 0, 0, 45)
    btn.Position = UDim2.new(0.075, 0, 0, positionY)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.Parent = MainFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    return btn
end

-- Tạo 3 nút chức năng
local JumpBtn = createButton("Nhảy Cao: TẮT", 60, Color3.fromRGB(200, 50, 50))
local SpeedBtn = createButton("Chạy Nhanh: TẮT", 125, Color3.fromRGB(200, 50, 50))
local NoclipBtn = createButton("Xuyên Tường: TẮT", 190, Color3.fromRGB(200, 50, 50))

-- ==========================================
-- 3. LOGIC XỬ LÝ CHỨC NĂNG VÀ VÒNG LẶP
-- ==========================================

-- Hàm cập nhật Nhảy cao & Chạy nhanh
local function updateStatus()
    if Player.Character then
        local Humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            -- Xử lý Nhảy
            Humanoid.UseJumpPower = true
            Humanoid.JumpPower = jumpEnabled and jumpPowerValue or 50
            -- Xử lý Chạy
            Humanoid.WalkSpeed = speedEnabled and speedValue or 16
        end
    end
end

-- Vòng lặp liên tục để xử lý Xuyên Tường (Noclip)
RunService.Stepped:Connect(function()
    if noclipEnabled and Player.Character then
        for _, part in pairs(Player.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide == true then
                part.CanCollide = false
            end
        end
    end
end)

-- Tự động áp dụng lại khi nhân vật hồi sinh
Player.CharacterAdded:Connect(function(Character)
    Character:WaitForChild("Humanoid")
    task.wait(0.5)
    updateStatus()
end)

-- Sự kiện Click nút Nhảy cao
JumpBtn.MouseButton1Click:Connect(function()
    jumpEnabled = not jumpEnabled
    if jumpEnabled then
        JumpBtn.Text = "Nhảy Cao: BẬT"
        JumpBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
    else
        JumpBtn.Text = "Nhảy Cao: TẮT"
        JumpBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
    updateStatus()
end)

-- Sự kiện Click nút Chạy nhanh
SpeedBtn.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    if speedEnabled then
        SpeedBtn.Text = "Chạy Nhanh: BẬT"
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
    else
        SpeedBtn.Text = "Chạy Nhanh: TẮT"
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
    updateStatus()
end)

-- Sự kiện Click nút Xuyên tường
NoclipBtn.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        NoclipBtn.Text = "Xuyên Tường: BẬT"
        NoclipBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
    else
        NoclipBtn.Text = "Xuyên Tường: TẮT"
        NoclipBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        -- Trả lại trạng thái va chạm bình thường khi tắt
        if Player.Character then
            for _, part in pairs(Player.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
    end
end)

-- Click nút tròn để Ẩn/Hiện menu chính
ToggleMenuButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Hệ thống kéo thả menu bằng cảm ứng di động
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

print("Menu Ultimate V3 đã tải thành công!")
