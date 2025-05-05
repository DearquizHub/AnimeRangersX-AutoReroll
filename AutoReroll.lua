
--[[
    Anime Rangers X - Auto Reroll Script (AutoReroll.lua)
    Author: DearquizBot
    Features:
    - Draggable UI with Start/Stop
    - Auto-detect selected unit name from GUI
    - Select Main/Sub Trait reroll
    - Target trait lock (e.g., "Sovereign")
    - Trait reroll count display
    - Plays sound on success
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")
local HttpService = game:GetService("HttpService")

-- Configurable
local targetTrait = "Sovereign"
local traitType = "Main" -- Options: "Main", "Sub"

-- Detect selected unit name from GUI
local function getSelectedUnitName()
    local unitGui = gui:FindFirstChild("UnitsIndex", true)
    if not unitGui then return nil end

    local scrollingFrame = unitGui:FindFirstChild("ScrollingFrame", true)
    if not scrollingFrame then return nil end

    for _, child in pairs(scrollingFrame:GetDescendants()) do
        if child:IsA("TextLabel") and child.Name == "Names" and child.Text ~= "" then
            return child.Text
        end
    end
    return nil
end

-- Detect trait name from GUI
local function getCurrentTrait()
    for _, v in pairs(gui:GetDescendants()) do
        if v:IsA("TextLabel") and string.match(v.Text, "Sovereign") then
            return "Sovereign"
        end
    end
    return "Unknown"
end

-- Play sound
local function playSuccessSound()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://9118823103" -- Bell sound
    sound.Volume = 1
    sound.Parent = SoundService
    sound:Play()
    game.Debris:AddItem(sound, 5)
end

-- UI
local ScreenGui = Instance.new("ScreenGui", gui)
ScreenGui.Name = "AutoRerollUI"
local Frame = Instance.new("Frame", ScreenGui)
Frame.Position = UDim2.new(0.3, 0, 0.3, 0)
Frame.Size = UDim2.new(0, 200, 0, 130)
Frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 8)

local statusLabel = Instance.new("TextLabel", Frame)
statusLabel.Size = UDim2.new(1, 0, 0, 30)
statusLabel.Text = "สถานะ: หยุดอยู่"
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.new(1, 1, 1)

local toggleBtn = Instance.new("TextButton", Frame)
toggleBtn.Position = UDim2.new(0, 10, 0, 40)
toggleBtn.Size = UDim2.new(1, -20, 0, 30)
toggleBtn.Text = "เริ่ม Reroll"
toggleBtn.BackgroundColor3 = Color3.new(0.2, 0.6, 0.2)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)

local traitText = Instance.new("TextLabel", Frame)
traitText.Position = UDim2.new(0, 10, 0, 75)
traitText.Size = UDim2.new(1, -20, 0, 20)
traitText.Text = "Trait: ?"
traitText.BackgroundTransparency = 1
traitText.TextColor3 = Color3.new(1, 1, 1)

local countText = Instance.new("TextLabel", Frame)
countText.Position = UDim2.new(0, 10, 0, 100)
countText.Size = UDim2.new(1, -20, 0, 20)
countText.Text = "รอบ: 0"
countText.BackgroundTransparency = 1
countText.TextColor3 = Color3.new(1, 1, 1)

-- Loop control
local running = false
local rerollCount = 0

toggleBtn.MouseButton1Click:Connect(function()
    running = not running
    toggleBtn.Text = running and "หยุด Reroll" or "เริ่ม Reroll"
    toggleBtn.BackgroundColor3 = running and Color3.new(0.8, 0.2, 0.2) or Color3.new(0.2, 0.6, 0.2)
    statusLabel.Text = running and "สถานะ: กำลังสุ่ม..." or "สถานะ: หยุดอยู่"

    if running then
        task.spawn(function()
            local unitName = getSelectedUnitName()
            if not unitName then
                statusLabel.Text = "ไม่พบยูนิต"
                return
            end

            while running do
                local currentTrait = getCurrentTrait()
                traitText.Text = "Trait: " .. currentTrait
                countText.Text = "รอบ: " .. rerollCount

                if currentTrait == targetTrait then
                    statusLabel.Text = "ได้ Trait ที่ต้องการแล้ว!"
                    playSuccessSound()
                    running = false
                    toggleBtn.Text = "เริ่ม Reroll"
                    toggleBtn.BackgroundColor3 = Color3.new(0.2, 0.6, 0.2)
                    break
                end

                local remote = ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("RerollTrait")
                if remote then
                    remote:FireServer(unitName, "Reroll", traitType, "Shards")
                end

                rerollCount += 1
                task.wait(0.75)
            end
        end)
    end
end)
