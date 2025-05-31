-- ✅ Anti-AFK
local vu = game:service'VirtualUser'
game:service'Players'.LocalPlayer.Idled:connect(function()
   vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
   wait(1)
   vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

-- ✅ Variables
local plr = game.Players.LocalPlayer
local chr = plr.Character or plr.CharacterAdded:Wait()
local hrp = chr:WaitForChild("HumanoidRootPart")
local rs = game:GetService("ReplicatedStorage")
local wfc = game.WaitForChild
local enemies = workspace.Enemies

-- ✅ Enable Haki Always
spawn(function()
   while wait(1) do
       if not chr:FindFirstChild("HasBuso") then
           game:service'VirtualInputManager':SendKeyEvent(true, "J", false, game)
           wait(0.1)
           game:service'VirtualInputManager':SendKeyEvent(false, "J", false, game)
       end
   end
end)local questData = {
    -- World 2
    {1000, "Snow Mountain", "Snow Trooper", CFrame.new(607, 401, -5370), "SnowMountainQuest", 1},
    {1050, "Snow Mountain", "Winter Warrior", CFrame.new(607, 401, -5370), "SnowMountainQuest", 2},
    {1100, "Hot and Cold", "Lab Subordinate", CFrame.new(-5858, 15, -5006), "IceSideQuest", 1},
    {1150, "Hot and Cold", "Horned Warrior", CFrame.new(-5858, 15, -5006), "IceSideQuest", 2},
    {1200, "Hot and Cold", "Magma Ninja", CFrame.new(-5414, 78, -5959), "FlameSideQuest", 1},
    {1250, "Hot and Cold", "Lava Pirate", CFrame.new(-5414, 78, -5959), "FlameSideQuest", 2},
    {1300, "Cursed Ship", "Ship Deckhand", CFrame.new(921, 125, 32878), "ShipQuest1", 1},
    {1325, "Cursed Ship", "Ship Engineer", CFrame.new(921, 125, 32878), "ShipQuest1", 2},
    {1350, "Cursed Ship", "Ship Steward", CFrame.new(921, 125, 32878), "ShipQuest2", 1},
    {1375, "Cursed Ship", "Ship Officer", CFrame.new(921, 125, 32878), "ShipQuest2", 2},
    {1400, "Ice Castle", "Arctic Warrior", CFrame.new(5443, 28, -6250), "FrostQuest", 1},
    {1425, "Ice Castle", "Snow Lurker", CFrame.new(5443, 28, -6250), "FrostQuest", 2},
    {1450, "Forgotten Island", "Sea Soldier", CFrame.new(-3052, 237, -10148), "ForgottenQuest", 1},
    {1500, "Forgotten Island", "Water Fighter", CFrame.new(-3052, 237, -10148), "ForgottenQuest", 2},

    -- World 3
    {1500, "Port Town", "Pirate Millionaire", CFrame.new(-290, 44, 5567), "PiratePortQuest", 1},
    {1525, "Port Town", "Pistol Billionaire", CFrame.new(-290, 44, 5567), "PiratePortQuest", 2},
    {1575, "Hydra Island", "Dragon Crew Warrior", CFrame.new(5227, 604, -1471), "HydraQuest", 1},
    {1600, "Hydra Island", "Dragon Crew Archer", CFrame.new(5227, 604, -1471), "HydraQuest", 2},
    {1625, "Hydra Island", "Female Islander", CFrame.new(5443, 602, -2213), "HydraQuest2", 1},
    {1650, "Hydra Island", "Giant Islander", CFrame.new(5443, 602, -2213), "HydraQuest2", 2},
    {1700, "Great Tree", "Marine Commodore", CFrame.new(2363, 25, -6731), "TreeQuest", 1},
    {1725, "Great Tree", "Marine Rear Admiral", CFrame.new(2363, 25, -6731), "TreeQuest", 2},
    {1775, "Floating Turtle", "Jungle Pirate", CFrame.new(-10495, 332, -9296), "TurtleQuest", 1},
    {1800, "Floating Turtle", "Musketeer Pirate", CFrame.new(-10495, 332, -9296), "TurtleQuest", 2},
    {1825, "Floating Turtle", "Reborn Skeleton", CFrame.new(-11992, 331, -8797), "TurtleQuest2", 1},
    {1850, "Floating Turtle", "Living Zombie", CFrame.new(-11992, 331, -8797), "TurtleQuest2", 2},
    {1900, "Floating Turtle", "Posessed Mummy", CFrame.new(-9507, 172, -10753), "TurtleQuest3", 1},
    {1950, "Haunted Castle", "Reanimated Demon", CFrame.new(-9519, 141, 6078), "HauntedQuest1", 1},
    {1975, "Haunted Castle", "Living Demon", CFrame.new(-9519, 141, 6078), "HauntedQuest1", 2},
    {2000, "Haunted Castle", "Demonic Soul", CFrame.new(-9519, 141, 6078), "HauntedQuest2", 1},
    {2025, "Haunted Castle", "Posessed Vampire", CFrame.new(-9519, 141, 6078), "HauntedQuest2", 2},
    {2075, "Candy Island", "Sweet Thief", CFrame.new(-1141, 17, -14442), "CandyQuest1", 1},
    {2100, "Candy Island", "Candy Rebel", CFrame.new(-1141, 17, -14442), "CandyQuest1", 2},
    {2125, "Candy Island", "Cookie Crafter", CFrame.new(-1141, 17, -14442), "CandyQuest2", 1},
    {2150, "Candy Island", "Cake Guard", CFrame.new(-1141, 17, -14442), "CandyQuest2", 2},
    {2200, "Tiki Outpost", "Island Boy", CFrame.new(-16535, 85, -173), "TikiQuest1", 1},
    {2225, "Tiki Outpost", "Isle Outlaw", CFrame.new(-16535, 85, -173), "TikiQuest1", 2},
    {2250, "Tiki Outpost", "Sun-kissed Warrior", CFrame.new(-16535, 85, -173), "TikiQuest2", 1},
    {2300, "Tiki Outpost", "Sun-kissed Samurai", CFrame.new(-16535, 85, -173), "TikiQuest2", 2},
    {2350, "Tiki Outpost", "Savage", CFrame.new(-16535, 85, -173), "TikiQuest3", 1},
    {2400, "Tiki Outpost", "Mythical Pirate", CFrame.new(-16535, 85, -173), "TikiQuest3", 2},
    {2475, "Tiki Outpost", "Elite Pirate", CFrame.new(-16535, 85, -173), "TikiQuest4", 1},
    {2550, "Tiki Outpost", "Legendary Pirate", CFrame.new(-16535, 85, -173), "TikiQuest4", 2},
    {2625, "Tiki Outpost", "Ancient Pirate", CFrame.new(-16535, 85, -173), "TikiQuest5", 1}
}spawn(function()
    while task.wait(1) do
        local level = plr.Data.Level.Value
        local current = nil
        for i = #questData, 1, -1 do
            if level >= questData[i][1] then
                current = questData[i]
                break
            end
        end
        if current then
            hrp.CFrame = current[4]
            wait(1.5)
            rs.Remotes.CommF_:InvokeServer("StartQuest", current[5], current[6])
            wait(0.5)
            for _,enemy in pairs(enemies:GetChildren()) do
                if enemy.Name:find(current[3]) and enemy:FindFirstChild("HumanoidRootPart") and enemy.Humanoid.Health > 0 then
                    repeat
                        pcall(function()
                            hrp.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)
                            enemy.HumanoidRootPart.Size = Vector3.new(70,70,70)
                            enemy.HumanoidRootPart.Transparency = 0.5
                            chr:FindFirstChildOfClass("Humanoid"):ChangeState(11)
                            for _,tool in pairs(plr.Backpack:GetChildren()) do
                                if tool:IsA("Tool") then
                                    tool.Parent = chr
                                end
                            end
                            mouse1click()
                        end)
                        wait(0.2)
                    until enemy.Humanoid.Health <= 0 or not enemy:FindFirstChild("HumanoidRootPart")
                end
            end
        end
    end
end)
