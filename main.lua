# my-roblox-script.
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GreenDino0/Ui-Libraries/refs/heads/main/Venyx"))()
local win = library.new("FOAB GUI", "Green")

local page = win:addPage("Main", 5012544693)
local section1 = page:addSection("Player")
local section2 = page:addSection("Kill Aura")
local section3 = page:addSection("Weapon")

section1:addSlider("WalkSpeed", 16, 16, 500, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)

section1:addSlider("JumpPower", 50, 50, 500, function(value)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
end)

local killAuraEnabled = false
local killAuraConnection

section2:addToggle("Kill Aura (Loop)", false, function(value)
    killAuraEnabled = value
    if killAuraEnabled then
        killAuraConnection = game:GetService("RunService").RenderStepped:Connect(function()
            if not killAuraEnabled then return end
            local localPlayer = game.Players.LocalPlayer
            local character = localPlayer.Character
            if not character then return end
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if not rootPart then return end

            local currentWeapon = nil
            for _, item in ipairs(character:GetChildren()) do
                if item:IsA("Tool") and item:FindFirstChild("Handle") then
                    currentWeapon = item
                    break
                end
            end

            if not currentWeapon then return end

            for _, player in ipairs(game.Players:GetPlayers()) do
                if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
                    local targetRoot = player.Character.HumanoidRootPart
                    local targetHumanoid = player.Character.Humanoid
                    
                    if targetHumanoid.Health > 0 then
                        local distance = (rootPart.Position - targetRoot.Position).Magnitude
                        if distance <= 20 then
                            firetouchinterest(currentWeapon.Handle, targetRoot, 0)
                            firetouchinterest(currentWeapon.Handle, targetRoot, 1)
                        end
                    end
                end
            end
        end)
    else
        if killAuraConnection then
            killAuraConnection:Disconnect()
            killAuraConnection = nil
        end
    end
end)

section3:addButton("Get All Weapons", function()
    for _, item in ipairs(game:GetService("Lighting"):GetChildren()) do
        if item:IsA("Tool") then
            local clone = item:Clone()
            clone.Parent = game.Players.LocalPlayer.Backpack
        end
    end
end)
