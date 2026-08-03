local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

_G.HeadSize = 999
local rainbowHue = 0

-- Store original sizes/properties to restore them correctly
local originalProperties = {}

-- Create GUI Button on the Right Side
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HitboxToggleGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ToggleButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleButton.BorderSizePixel = 2
ToggleButton.Position = UDim2.new(1, -160, 0.5, -25) -- Right side of screen
ToggleButton.Size = UDim2.new(0, 150, 0, 50)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "Trigger Hitbox (R)"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 18

-- Core function to trigger the enlarged hitbox for 0.1 seconds
local isRunning = false
local function triggerHitbox()
    if isRunning then return end
    isRunning = true
    
    -- Save original properties and apply enlarged hitbox to alive players only
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            
            -- Check if the player is alive
            if humanoid and humanoid.Health > 0 then
                local hrp = player.Character.HumanoidRootPart
                
                -- Store original values
                originalProperties[player] = {
                    Size = hrp.Size,
                    Transparency = hrp.Transparency,
                    Color = hrp.Color,
                    Material = hrp.Material,
                    CanCollide = hrp.CanCollide,
                    Shape = hrp.Shape
                }
                
                -- Apply modified properties
                pcall(function()
                    hrp.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
                    hrp.Transparency = 0.95
                    hrp.Color = Color3.fromHSV(rainbowHue, 1, 1)
                    hrp.Material = Enum.Material.Neon
                    hrp.CanCollide = false
                    hrp.Shape = Enum.PartType.Ball
                end)
            end
        end
    end
    
    -- Wait 0.1 seconds
    task.wait(0.1)
    
    -- Restore hitboxes back to normal
    for player, props in pairs(originalProperties) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                local hrp = player.Character.HumanoidRootPart
                hrp.Size = props.Size
                hrp.Transparency = props.Transparency
                hrp.Color = props.Color
                hrp.Material = props.Material
                hrp.CanCollide = props.CanCollide
                hrp.Shape = props.Shape
            end)
        end
    end
    
    table.clear(originalProperties)
    isRunning = false
end

-- Update rainbow hue continuously
game:GetService("RunService").RenderStepped:Connect(function()
    rainbowHue = (rainbowHue + 0.005) % 1
end)

-- Button Click Listener
ToggleButton.MouseButton1Click:Connect(triggerHitbox)

-- 'R' Key Press Listener
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end -- Ignore if typing in chat
    if input.KeyCode == Enum.KeyCode.R then
        triggerHitbox()
    end
end)
