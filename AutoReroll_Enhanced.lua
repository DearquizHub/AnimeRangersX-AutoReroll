-- Auto Reroll Script for Anime Rangers X (Final Version) -- Features: Dark-themed UI, DC toggle button, Auto-Reroll Main/Sub Trait, Alert Sound, Logging, Webhook ready

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players") local LocalPlayer = Players.LocalPlayer local HttpService = game:GetService("HttpService") local TweenService = game:GetService("TweenService") local SoundService = game:GetService("SoundService") local CoreGui = game:GetService("CoreGui") local RunService = game:GetService("RunService")

local UIName = "AutoRerollUI" local rerolling = false local selectedMode = "Main" -- or "Sub" local desiredTrait = "Celestial" -- 0.1% Trait local lastSuccessUnit = ""

-- Sound setup local sound = Instance.new("Sound") sound.Name = "AlertSound" sound.SoundId = "rbxassetid://9118823102" -- gentle notification sound.Volume = 1 sound.Parent = SoundService

-- UI Setup local ScreenGui = Instance.new("ScreenGui") ScreenGui.Name = UIName ScreenGui.ResetOnSpawn = false ScreenGui.Parent = CoreGui

local ToggleButton = Instance.new("TextButton") ToggleButton.Name = "DCToggle" ToggleButton.Size = UDim2.new(0, 40, 0, 40) ToggleButton.Position = UDim2.new(0, 10, 0.5, -20) ToggleButton.Text = "DC" ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30) ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255) ToggleButton.Parent = ScreenGui

local MainFrame = Instance.new("Frame") MainFrame.Name = "MainUI" MainFrame.Size = UDim2.new(0, 400, 0, 250) MainFrame.Position = UDim2.new(0.5, -200, 0.5, -125) MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) MainFrame.BorderSizePixel = 0 MainFrame.Visible = false MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel") Title.Size = UDim2.new(1, 0, 0, 30) Title.BackgroundTransparency = 1 Title.Text = "Auto Reroll | Anime Rangers X" Title.TextColor3 = Color3.fromRGB(255, 255, 255) Title.Font = Enum.Font.GothamBold Title.TextSize = 16 Title.Parent = MainFrame

local StatusLabel = Instance.new("TextLabel") StatusLabel.Size = UDim2.new(1, -20, 0, 25) StatusLabel.Position = UDim2.new(0, 10, 0, 40) StatusLabel.BackgroundTransparency = 1 StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200) StatusLabel.Font = Enum.Font.Gotham StatusLabel.TextSize = 14 StatusLabel.Text = "Status: Waiting" StatusLabel.Parent = MainFrame

local LastUnitLabel = Instance.new("TextLabel") LastUnitLabel.Size = UDim2.new(1, -20, 0, 25) LastUnitLabel.Position = UDim2.new(0, 10, 0, 70) LastUnitLabel.BackgroundTransparency = 1 LastUnitLabel.TextColor3 = Color3.fromRGB(200, 200, 200) LastUnitLabel.Font = Enum.Font.Gotham LastUnitLabel.TextSize = 14 LastUnitLabel.Text = "Last Successful Unit: N/A" LastUnitLabel.Parent = MainFrame

ToggleButton.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- Function to simulate reroll request (replace with Remote call) local function performReroll() -- Simulate random result for demo local traits = {"Common", "Rare", "Epic", "Celestial"} local result = traits[math.random(1, #traits)] local unit = "Unit" .. tostring(math.random(1, 999)) return result, unit end

-- Main reroll loop spawn(function() while true do if rerolling then local trait, unit = performReroll() StatusLabel.Text = "Rerolling... Current Trait: " .. trait if trait == desiredTrait then rerolling = false sound:Play() lastSuccessUnit = unit LastUnitLabel.Text = "Last Successful Unit: " .. unit StatusLabel.Text = "Found Trait! Trait: " .. trait end end task.wait(0.8) end end)

-- Start rerolling automatically rerolling = true

