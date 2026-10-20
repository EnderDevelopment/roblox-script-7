-- WeaponScript.server.lua

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local weapon = script.Parent
local fireRate = 0.1 -- Time between shots in seconds
local lastShotTime = 0

local function onActivated(player, inputObject, inputKey)
    if inputKey == Enum.UserInputType.MouseButton1 and os.time() - lastShotTime >= fireRate then
        lastShotTime = os.time()
        
        -- Fire the weapon
        local bullet = Instance.new("Part")
        bullet.Size = Vector3.new(0.2, 0.2, 1)
        bullet.Position = weapon.Handle.Position + weapon.Handle.CFrame.LookVector * 2
        bullet.CFrame = weapon.Handle.CFrame
        bullet.Anchored = false
        bullet.CanCollide = true
        bullet.Material = Enum.Material.Metal
        bullet.Color = Color3.new(1, 0, 0) -- Red color for the bullet
        bullet.Parent = workspace
        
        -- Apply a force to the bullet
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = weapon.Handle.CFrame.LookVector * 100
        bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
        bodyVelocity.Parent = bullet
        
        -- Remove the bullet after a delay
        game:GetService("Debris"):AddItem(bullet, 5)
        
        -- Play a sound effect
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://123456789" -- Replace with your sound ID
        sound.Parent = bullet
        sound:Play()
        
        -- Create a cool VFX effect
        local particleEmitter = Instance.new("ParticleEmitter")
        particleEmitter.Texture = "rbxassetid://123456789" -- Replace with your particle texture ID
        particleEmitter.LightEmission = 1
        particleEmitter.Color = ColorSequence.new(Color3.new(1, 0, 0))
        particleEmitter.Size = NumberSequence.new(0.5)
        particleEmitter.Transparency = NumberSequence.new(0, 1)
        particleEmitter.Lifetime = NumberRange.new(0.5)
        particleEmitter.Rate = 100
        particleEmitter.Parent = bullet
        
        -- Connect the bullet to a hit detection function
        bullet.Touched:Connect(function(hit)
            if hit.Parent:FindFirstChild("Humanoid") then
                -- Apply damage to the humanoid
                hit.Parent.Humanoid:TakeDamage(10)
            
                -- Create an explosion effect
                local explosion = Instance.new("Explosion")
                explosion.Position = hit.Position
                explosion.BlastRadius = 5
                explosion.BlastPressure = 0
                explosion.Parent = workspace
                
                -- Remove the bullet
                bullet:Destroy()
            end
        end)
    end
end

-- Connect the weapon to the player's input
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
        local input = character:WaitForChild("HumanoidRootPart"):WaitForChild("Input")
        
        input.InputBegan:Connect(function(inputObject, gameProcessed)
            if not gameProcessed then
                onActivated(player, inputObject, inputObject.UserInputType)
            end
        end)
    end)
end)