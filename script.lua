
-- Auto Reroll Script for Anime Rangers X (Perfect Version)
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Settings
local targetTrait = "Mythical Trait" -- เปลี่ยนชื่อนี้ตาม Trait เป้าหมาย
local isSubTrait = false -- true = Sub Trait, false = Main Trait

-- Notification sound
local function playNotification()
    local SoundService = game:GetService("SoundService")
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://9118823105" -- เสียงคล้ายข้อความเข้า
    sound.Volume = 1
    sound.Parent = SoundService
    sound:Play()
end

-- ตัวอย่าง UI ปุ่ม "DC" สำหรับเปิด/ปิด
local CoreGui = game:GetService("CoreGui")
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "AutoRerollUI"
local toggleButton = Instance.new("TextButton", ScreenGui)
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.Text = "DC"
toggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleButton.TextColor3 = Color3.new(1,1,1)
toggleButton.BorderSizePixel = 0
toggleButton.Active = true
toggleButton.Draggable = true

local uiVisible = true
toggleButton.MouseButton1Click:Connect(function()
    uiVisible = not uiVisible
    for _, child in ipairs(ScreenGui:GetChildren()) do
        if child ~= toggleButton then
            child.Visible = uiVisible
        end
    end
end)

-- ระบบหลัก (ตัวอย่างจำลอง)
local function rerollLoop()
    local attempts = 0
    while true do
        task.wait(1)
        attempts += 1
        print("กำลังสุ่ม Trait... ครั้งที่", attempts)

        local currentTrait = "Random" -- ใส่ logic จริงจากเกมตรงนี้

        if currentTrait == targetTrait then
            print("พบ Trait ที่ต้องการแล้ว:", currentTrait)
            playNotification()
            break
        end
    end
end

task.delay(2, rerollLoop)
