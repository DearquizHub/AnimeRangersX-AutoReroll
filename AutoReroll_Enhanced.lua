
-- Enhanced Auto Reroll Script v2: Full Features + Anti-Detection + Optimizations

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Player
local LocalPlayer = Players.LocalPlayer

-- Logging utility
local function log(msg)
    print("[AutoReroll]: " .. msg)
end

-- Anti-detection dummy function (basic)
local function disableConnections(instance)
    for _, conn in pairs(getconnections(instance.Changed)) do
        pcall(function() conn:Disable() end)
    end
end

-- Anti-detection: Monitor for suspicious UI or property changes
local function enableAntiDetection()
    for _, v in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
        if v:IsA("TextLabel") or v:IsA("TextButton") then
            disableConnections(v)
        end
    end
    log("Anti-detection enabled.")
end

-- GUI Setup
local screenGui = Instance.new("ScreenGui", CoreGui)
screenGui.Name = "AutoRerollUI"
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 384, 0, 336)
frame.Position = UDim2.new(0.5, -192, 0.5, -168)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.ZIndex = 999

local UICorner = Instance.new("UICorner", frame)
UICorner.CornerRadius = UDim.new(0, 10)

local UIStroke = Instance.new("UIStroke", frame)
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(100, 200, 255)

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 36)
title.Text = "Anime Rangers X | Auto Reroll v2"
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
Instance.new("UICorner", title)

-- Utility UI Creation
local function createInput(posY, placeholder, default)
    local box = Instance.new("TextBox", frame)
    box.Size = UDim2.new(1, -20, 0, 36)
    box.Position = UDim2.new(0, 10, 0, posY)
    box.PlaceholderText = placeholder
    box.Text = default
    box.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    box.TextColor3 = Color3.new(1, 1, 1)
    box.Font = Enum.Font.Gotham
    box.TextSize = 18
    Instance.new("UICorner", box)
    return box
end

local unitInput = createInput(50, "ชื่อยูนิต", "Madara")
local modeInput = createInput(96, "Main / Sub", "Main")
local traitInput = createInput(142, "Trait ที่ต้องการ", "Sovereign")

-- Buttons
local rerollButton = Instance.new("TextButton", frame)
rerollButton.Size = UDim2.new(0.5, -10, 0, 36)
rerollButton.Position = UDim2.new(0, 10, 0, 188)
rerollButton.Text = "เริ่มสุ่ม"
rerollButton.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
rerollButton.TextColor3 = Color3.new(1,1,1)
rerollButton.Font = Enum.Font.GothamBold
rerollButton.TextSize = 18
Instance.new("UICorner", rerollButton)

local stopButton = Instance.new("TextButton", frame)
stopButton.Size = UDim2.new(0.5, -10, 0, 36)
stopButton.Position = UDim2.new(0.5, 0, 0, 188)
stopButton.Text = "หยุด"
stopButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
stopButton.TextColor3 = Color3.new(1,1,1)
stopButton.Font = Enum.Font.GothamBold
stopButton.TextSize = 18
Instance.new("UICorner", stopButton)

-- Labels
local status = Instance.new("TextLabel", frame)
status.Position = UDim2.new(0, 0, 0, 234)
status.Size = UDim2.new(1, 0, 0, 30)
status.Text = "สถานะ: -"
status.TextColor3 = Color3.new(1,1,1)
status.BackgroundTransparency = 1
status.Font = Enum.Font.GothamSemibold
status.TextSize = 18

local count = Instance.new("TextLabel", frame)
count.Position = UDim2.new(0, 0, 0, 264)
count.Size = UDim2.new(1, 0, 0, 30)
count.Text = "จำนวนสุ่ม: 0"
count.TextColor3 = Color3.new(1,1,1)
count.BackgroundTransparency = 1
count.Font = Enum.Font.GothamSemibold
count.TextSize = 18

-- Sound
local sound = Instance.new("Sound", frame)
sound.SoundId = "rbxassetid://9118823106"
sound.Volume = 2

-- Trait Finder
local function getTraitText()
    for _, v in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
        if v:IsA("TextLabel") and v.Text and string.find(v.Text, "%u") then
            if string.find(v.Text, traitInput.Text) then
                return v.Text
            end
        end
    end
    return ""
end

-- Reroll System
local rerolling = false
local rerollCount = 0
local rerollRemote = ReplicatedStorage.Remote.Server.Gambling.RerollTrait

local function rerollLoop()
    rerolling = true
    rerollCount = 0
    enableAntiDetection()

    while rerolling do
        rerollCount += 1
        count.Text = "จำนวนสุ่ม: " .. rerollCount
        status.Text = "สถานะ: สุ่ม..."
        log("สุ่มรอบ: " .. rerollCount)

        rerollRemote:FireServer(unitInput.Text, "Reroll", modeInput.Text, "Shards")
        task.wait(0.5)

        local currentTrait = getTraitText()
        if string.find(currentTrait, traitInput.Text) then
            sound:Play()
            status.Text = "เจอ Trait ที่ต้องการแล้ว!"
            log("พบ Trait: " .. currentTrait)
            rerolling = false
            break
        end
        status.Text = "ได้ Trait: " .. currentTrait
    end
end

-- Bindings
rerollButton.MouseButton1Click:Connect(function()
    if not rerolling then rerollLoop() end
end)

stopButton.MouseButton1Click:Connect(function()
    rerolling = false
    status.Text = "หยุดแล้ว"
    log("ผู้ใช้หยุดการสุ่ม")
end)
