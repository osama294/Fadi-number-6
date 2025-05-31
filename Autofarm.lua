-- سكربت Auto Farm محسن لـ Blox Fruits (العالم الثاني والثالث)
-- يدعم السلاح/الأسلوب المُستخدم، ويفعل الهاكي، ويتفادى الزعماء الخطرين
-- يتضمن Anti-AFK ويصحح أسماء البوتات والمستويات المطلوبة بدقة

-- انتظر تحميل اللعبة بالكامل
repeat wait() until game:IsLoaded()

-- منع الإقصاء بسبب عدم النشاط (Anti-AFK)
local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- إعدادات عامة
local Settings = {
    AutoFarm       = false,
    SafeDistance   = 20,
    EnableHaki     = true,
    UseRaceSkills  = true,       -- تفعيل مهارات العرق V3/V4 إن وجدت
    SmoothMovement = true,
    CombatType     = "Equipped"  -- "Equipped", "Melee", "Sword", "Blox Fruit"
}

-- إنشاء واجهة GUI دائرية
local Gui = Instance.new("ScreenGui", game.CoreGui)
Gui.Name = "AutoFarmGui"

-- الإيقونة الدائرية (بحجم 130×130)
local Frame = Instance.new("ImageLabel", Gui)
Frame.Size               = UDim2.new(0, 130, 0, 130)
Frame.Position           = UDim2.new(0.85, 0, 0.3, 0)
Frame.BackgroundTransparency = 1
Frame.Image              = "rbxassetid://17204591132"  -- صورة الأيقونة المرفوعة
Frame.Draggable          = true
Frame.Active             = true

-- زر تشغيل/إيقاف AutoFarm صغير أسفل الإيقونة
local ToggleButton = Instance.new("TextButton", Frame)
ToggleButton.Size            = UDim2.new(0, 60, 0, 25)
ToggleButton.Position        = UDim2.new(0.5, -30, 1, -30)
ToggleButton.BackgroundColor3= Color3.fromRGB(50, 200, 50)
ToggleButton.TextColor3      = Color3.new(1, 1, 1)
ToggleButton.Text            = "AutoFarm"
ToggleButton.Font            = Enum.Font.SourceSansBold
ToggleButton.TextSize        = 14
ToggleButton.BorderSizePixel = 0
ToggleButton.AutoButtonColor = true

ToggleButton.MouseButton1Click:Connect(function()
    Settings.AutoFarm = not Settings.AutoFarm
    ToggleButton.BackgroundColor3 = Settings.AutoFarm 
        and Color3.fromRGB(200, 50, 50) 
        or Color3.fromRGB(50, 200, 50)
end)

-- قائمة منسدلة لاختيار نوع القتال
local ModeDropdown = Instance.new("TextButton", Frame)
ModeDropdown.Size            = UDim2.new(0, 110, 0, 25)
ModeDropdown.Position        = UDim2.new(0.5, -55, 1, -60)
ModeDropdown.BackgroundColor3= Color3.fromRGB(30, 30, 30)
ModeDropdown.TextColor3      = Color3.new(1, 1, 1)
ModeDropdown.Text            = "نوع القتال: Equipped"
ModeDropdown.Font            = Enum.Font.SourceSans
ModeDropdown.TextSize        = 13

local combatModes = { "Equipped", "Melee", "Sword", "Blox Fruit" }
local currentMode   = 1

ModeDropdown.MouseButton1Click:Connect(function()
    currentMode = currentMode % #combatModes + 1
    Settings.CombatType = combatModes[currentMode]
    ModeDropdown.Text = "نوع القتال: " .. combatModes[currentMode]
end)

-- دالة لتفعيل هاكي التصلب والتنبؤ (Buso & Ken)
local function enableHaki()
    pcall(function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Ken")
    end)
end

-- دالة لاختيار السلاح/الأسلوب حسب النوع المحدد
local function getWeaponByType()
    local bp = game.Players.LocalPlayer.Backpack
    for _, tool in pairs(bp:GetChildren()) do
        if tool:IsA("Tool") then
            if Settings.CombatType == "Equipped" then
                return nil  -- لا يغير أي شيء، يبقي على السلاح المجهز فعليًا
            elseif Settings.CombatType == "Melee" and tool.ToolTip:find("Fighting Style") then
                return tool.Name
            elseif Settings.CombatType == "Sword" and tool.ToolTip:find("Sword") then
                return tool.Name
            elseif Settings.CombatType == "Blox Fruit" and tool.ToolTip:find("Blox Fruit") then
                return tool.Name
            end
        end
    end
    return nil
end

-- جدول المهمات/Bot لكل مستوى (العالم الثاني والثالث حتى لفل 2650)
local function getQuestForLevel(level)
    local quests = {
        -- ======== العالم الثاني (Second Sea: Lv. 700–1450) =========
        { lvl = 700,  name = "Raider Quest",           enemy = "Raider",             boss = false },
        { lvl = 725,  name = "Mercenary Quest",         enemy = "Mercenary",         boss = false },
        { lvl = 775,  name = "Diamond Quest",           enemy = "Diamond",           boss = true  },
        { lvl = 775,  name = "Swan Pirate Quest",       enemy = "Swan Pirate",       boss = false },
        { lvl = 850,  name = "Factory Staff Quest",     enemy = "Factory Staff",     boss = false },
        { lvl = 875,  name = "Jeremy Quest",            enemy = "Jeremy",            boss = true  },
        { lvl = 875,  name = "Marine Lieutenant Quest", enemy = "Marine Lieutenant", boss = false },
        { lvl = 900,  name = "Marine Captain Quest",    enemy = "Marine Captain",    boss = false },
        { lvl = 1000, name = "Snow Trooper Quest",      enemy = "Snow Trooper",      boss = false },
        { lvl = 1050, name = "Winter Warrior Quest",    enemy = "Winter Warrior",    boss = false },
        { lvl = 1100, name = "Lab Subordinate Quest",   enemy = "Lab Subordinate",   boss = false },
        { lvl = 1150, name = "Horned Warrior Quest",    enemy = "Horned Warrior",    boss = false },
        { lvl = 1250, name = "Ship Deckhand Quest",     enemy = "Ship Deckhand",     boss = false },
        { lvl = 1275, name = "Ship Engineer Quest",     enemy = "Ship Engineer",     boss = false },
        { lvl = 1350, name = "Arctic Warrior Quest",    enemy = "Arctic Warrior",    boss = false },
        { lvl = 1400, name = "Snow Lurker Quest",       enemy = "Snow Lurker",       boss = false },
        { lvl = 1425, name = "Sea Soldier Quest",       enemy = "Sea Soldier",       boss = false },
        { lvl = 1450, name = "Water Fighter Quest",     enemy = "Water Fighter",     boss = false },

        -- ======== العالم الثالث (Third Sea: Lv. 1500–2525) =========
        { lvl = 1500, name = "Pirate Millionaire Quest",  enemy = "Pirate Millionaire",  boss = false },
        { lvl = 1525, name = "Pistol Billionaire Quest",  enemy = "Pistol Billionaire",  boss = false },
        { lvl = 1550, name = "Stone Quest",               enemy = "Stone",               boss = true  },
        { lvl = 1575, name = "Dragon Crew Warrior Quest", enemy = "Dragon Crew Warrior", boss = false },
        { lvl = 1600, name = "Dragon Crew Archer Quest",  enemy = "Dragon Crew Archer",  boss = false },
        { lvl = 1625, name = "Hydra Enforcer Quest",      enemy = "Hydra Enforcer",      boss = false },
        { lvl = 1650, name = "Venomous Assailant Quest",  enemy = "Venomous Assailant",  boss = false },
        { lvl = 1675, name = "Hydra Leader Quest",        enemy = "Hydra Leader",        boss = true  },
        { lvl = 1700, name = "Marine Commodore Quest",    enemy = "Marine Commodore",    boss = false },
        { lvl = 1725, name = "Marine Rear Admiral Quest", enemy = "Marine Rear Admiral", boss = false },
        { lvl = 1750, name = "Fishman Raider Quest",      enemy = "Fishman Raider",      boss = false },
        { lvl = 1775, name = "Fishman Captain Quest",     enemy = "Fishman Captain",     boss = false },
        { lvl = 1800, name = "Forest Pirate Quest",       enemy = "Forest Pirate",       boss = false },
        { lvl = 1825, name = "Mythological Pirate Quest", enemy = "Mythological Pirate", boss = false },
        { lvl = 1850, name = "Jungle Pirate Quest",       enemy = "Jungle Pirate",       boss = false },
        { lvl = 1900, name = "Musketeer Pirate Quest",    enemy = "Musketeer Pirate",    boss = false },
        { lvl = 1925, name = "Reborn Skeleton Quest",     enemy = "Reborn Skeleton",     boss = false },
        { lvl = 1950, name = "Living Zombie Quest",       enemy = "Living Zombie",       boss = false },
        { lvl = 1975, name = "Demonic Soul Quest",        enemy = "Demonic Soul",        boss = false },
        { lvl = 2000, name = "Possessed Mummy Quest",     enemy = "Possessed Mummy",     boss = false },
        { lvl = 2025, name = "Peanut Scout Quest",        enemy = "Peanut Scout",        boss = false },
        { lvl = 2050, name = "Peanut President Quest",    enemy = "Peanut President",    boss = false },
        { lvl = 2100, name = "Ice Cream Chef Quest",      enemy = "Ice Cream Chef",      boss = false },
        { lvl = 2125, name = "Ice Cream Commander Quest", enemy = "Ice Cream Commander", boss = false },
        { lvl = 2150, name = "Cake Guard Quest",          enemy = "Cake Guard",          boss = false },
        { lvl = 2175, name = "Baking Staff Quest",        enemy = "Baking Staff",        boss = false },
        { lvl = 2200, name = "Head Baker Quest",          enemy = "Head Baker",          boss = false },
        { lvl = 2225, name = "Cocoa Warrior Quest",       enemy = "Cocoa Warrior",       boss = false },
        { lvl = 2250, name = "Chocolate Bar Battler Quest", enemy = "Chocolate Bar Battler", boss = false },
        { lvl = 2275, name = "Sweet Thief Quest",         enemy = "Sweet Thief",         boss = false },
        { lvl = 2300, name = "Candy Rebel Quest",         enemy = "Candy Rebel",         boss = false },
        { lvl = 2325, name = "Candy Pirate Quest",        enemy = "Candy Pirate",        boss = false },
        { lvl = 2350, name = "Snow Demon Quest",          enemy = "Snow Demon",          boss = false },
        { lvl = 2400, name = "Isle Outlaw Quest",         enemy = "Isle Outlaw",         boss = false },
        { lvl = 2425, name = "Island Boy Quest",          enemy = "Island Boy",          boss = false },
        { lvl = 2450, name = "Sun-kissed Warrior Quest",  enemy = "Sun-kissed Warrior",  boss = false },
        { lvl = 2475, name = "Isle Champion Quest",       enemy = "Isle Champion",       boss = false },
        { lvl = 2500, name = "Serpent Hunter Quest",      enemy = "Serpent Hunter",      boss = false },
        { lvl = 2525, name = "Skull Slayer Quest",        enemy = "Skull Slayer",        boss = false }
    }

    for i = #quests, 1, -1 do
        if level >= quests[i].lvl then
            -- إذا كانت مهمة بوس ولم يبلغ اللاعب لفل بوس +50، ننتقل للمهمة السابقة
            if quests[i].boss and level < quests[i].lvl + 50 then
                return quests[i - 1]
            else
                return quests[i]
            end
        end
    end

    return nil
end

-- دالة لإيجاد أقرب بوت مترابط بالاسم المعطى
local function getNearestMob(name)
    local closest, dist = nil, math.huge
    for _, mob in pairs(workspace.Enemies:GetChildren()) do
        if mob.Name == name 
           and mob:FindFirstChild("HumanoidRootPart") 
           and mob:FindFirstChild("Humanoid") 
           and mob.Humanoid.Health > 0 then
            local distance = (mob.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if distance < dist then
                closest, dist = mob, distance
            end
        end
    end
    return closest
end

-- دالة الحركة السلس (Lerp) أو MoveTo
local function moveToPosition(targetPos)
    if Settings.SmoothMovement then
        local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(hrp.Position:Lerp(targetPos, 0.15))
        end
    else
        game.Players.LocalPlayer.Character:MoveTo(targetPos)
    end
end

-- اللوب الرئيسي لفارم المهام
spawn(function()
    while true do
        if Settings.AutoFarm then
            local player    = game.Players.LocalPlayer
            local level     = player.Data.Level.Value
            local questData = getQuestForLevel(level)

            if questData then
                -- تفعيل الهاكي تلقائيًا
                if Settings.EnableHaki then
                    enableHaki()
                end

                -- تفعيل مهارات العرق إن وُجدت (V3/V4)
                if Settings.UseRaceSkills then
                    pcall(function()
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ActivateRaceV4")
                    end)
                end

                -- البدء في المهمة إن لم تكن مفعّلة
                if not player.PlayerGui:FindFirstChild("Main").Quest.Visible then
                    pcall(function()
                        game:GetService("ReplicatedStorage").Remotes.Comm:InvokeServer("StartQuest", questData.name, 1)
                    end)
                end

                -- اختيار السلاح/الأسلوب المناسب إن تم تغييره من القائمة
                local chosenWeapon = getWeaponByType()
                if chosenWeapon then
                    local tool = player.Backpack:FindFirstChild(chosenWeapon)
                    if tool then
                        player.Character.Humanoid:EquipTool(tool)
                    end
                end

                -- إيجاد أقرب بوت من نوع المهمة
                local mob = getNearestMob(questData.enemy)
                if mob then
                    -- الانتقال إلى مكان البوت مع الاحتفاظ بارتفاع آمن (20 وحدة)
                    local targetCFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, Settings.SafeDistance, 0)
                    moveToPosition(targetCFrame.Position)

                    -- تنفيذ الهجوم بالزر "Z" (السلاح أو الأسلوب المجهّز)
                    pcall(function()
                        game:GetService("VirtualInputManager"):SendKeyEvent(true,  "Z", false, game)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, "Z", false, game)
                    end)
                end
            end
        end
        wait(0.8)  -- انتظر قليلًا قبل التحقق مجددًا لتقليل الضغط على السيرفر
    end
end)
