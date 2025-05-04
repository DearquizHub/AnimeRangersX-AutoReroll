-- Auto Reroll Script for Anime Rangers X
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

-- Configurations (You can modify these)
local -- ดึงชื่อยูนิตอัตโนมัติจาก GUI
local player = game.Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")
local scrollingFrame = gui.UnitsIndex.Main.Base.Space.ScrollingFrame

local selectedName = "ไม่พบยูนิต"

for _, unitFrame in pairs(scrollingFrame:GetChildren()) do
    local info = unitFrame:FindFirstChild("Frame") and unitFrame.Frame:FindFirstChild("UnitFrame")
    if info and info:FindFirstChild("Info") and info.Info:FindFirstChild("Names") then
        local label = info.Info.Names
        if label:IsA("TextLabel") then
            selectedName = label.Text
            break
        end
    end
end

-- ใช้ selectedName ในคำสั่ง reroll แทนชื่อยูนิตที่กรอก
print("กำลังสุ่มยูนิต:", selectedName)
local targetTrait = "Sovereign" -- Trait ที่ต้องการให้หยุด
local rerollType = "Main" -- "Main" หรือ "Sub"
local rerollRemote = ReplicatedStorage.Remotes.RerollTrait
local stop = false
local rerollCount = 0

-- Create Draggable UI
local screenGui = Instance.new("ScreenGui", gui)
screenGui.Name = "RerollUI"
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 250, 0, 150)
frame.Position = UDim2.new(0.5, -125, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Text = "Auto Reroll"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22

local status = Instance.new("TextLabel", frame)
status.Text = "Trait: -\nRerolls: 0"
status.Size = UDim2.new(1, -20, 0, 50)
status.Position = UDim2.new(0, 10, 0, 35)
status.BackgroundTransparency = 1
status.TextColor3 = Color3.new(1, 1, 1)
status.Font = Enum.Font.SourceSans
status.TextWrapped = true
status.TextSize = 18

local startBtn = Instance.new("TextButton", frame)
startBtn.Text = "เริ่ม"
startBtn.Position = UDim2.new(0, 10, 1, -40)
startBtn.Size = UDim2.new(0.4, -15, 0, 30)
startBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
startBtn.TextColor3 = Color3.new(1, 1, 1)

local stopBtn = Instance.new("TextButton", frame)
stopBtn.Text = "หยุด"
stopBtn.Position = UDim2.new(0.6, 5, 1, -40)
stopBtn.Size = UDim2.new(0.4, -15, 0, 30)
stopBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
stopBtn.TextColor3 = Color3.new(1, 1, 1)

local function getTrait()
    for _, v in pairs(gui:GetDescendants()) do
        if v:IsA("TextLabel") and v.Text then
            if v.Text:match("%%") or v.Text:match("Trait") then
                return v.Text
            end
        end
    end
    return "-"
end

local function playSound()
    local sound = Instance.new("Sound", gui)
    sound.SoundId = "rbxassetid://9118823106"
    sound.Volume = 1
    sound:Play()
end

local function reroll()
    while not stop do
        rerollRemote:FireServer(unitName, "Reroll", rerollType, "Shards")
        rerollCount += 1
        wait(1)
        local trait = getTrait()
        status.Text = "Trait: " .. trait .. "\nRerolls: " .. rerollCount
        if trait:lower():find(targetTrait:lower()) then
            playSound()
            break
        end
    end
end

startBtn.MouseButton1Click:Connect(function()
    stop = false
    coroutine.wrap(reroll)()
end)

stopBtn.MouseButton1Click:Connect(function()
    stop = true
end)
