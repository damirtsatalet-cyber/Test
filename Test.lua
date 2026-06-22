local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

-- Создаём главный GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ESPGui"
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

-- Создаём перетаскиваемую панель
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 260, 0, 240)
mainFrame.Position = UDim2.new(0, 20, 0, 100)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Заголовок
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -40, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "ESP Панель"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.Font = Enum.Font.SourceSansBold
titleText.TextSize = 16
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- Кнопка закрытия
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 2)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 14
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 15)
closeCorner.Parent = closeButton

-- Кнопка скрытия
local hideButton = Instance.new("TextButton")
hideButton.Size = UDim2.new(0, 30, 0, 30)
hideButton.Position = UDim2.new(1, -70, 0, 2)
hideButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
hideButton.Text = "_"
hideButton.TextColor3 = Color3.fromRGB(255, 255, 255)
hideButton.Font = Enum.Font.SourceSansBold
hideButton.TextSize = 14
hideButton.Parent = titleBar

local hideCorner = Instance.new("UICorner")
hideCorner.CornerRadius = UDim.new(0, 15)
hideCorner.Parent = hideButton

-- Содержимое панели
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 1, -45)
contentFrame.Position = UDim2.new(0, 10, 0, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Функция для создания переключателей
local function createToggle(name, yPos)
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(1, 0, 0, 32)
    toggle.Position = UDim2.new(0, 0, 0, yPos)
    toggle.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
    toggle.Text = name .. ": ВКЛ"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.Font = Enum.Font.SourceSansBold
    toggle.TextSize = 13
    toggle.Parent = contentFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggle
    
    return toggle
end

-- Создаём переключатели
local espToggle = createToggle("ESP", 0)
local playerToggle = createToggle("Игроки", 40)
local npcToggle = createToggle("NPC", 80)
local nameToggle = createToggle("Имена", 120)
local healthToggle = createToggle("Здоровье", 160)
local highlightToggle = createToggle("Подсветка", 200)

-- Логика перетаскивания
local dragging = false
local dragStart = nil
local startPos = nil

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

titleBar.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Состояния
local espEnabled = true
local playerESPEnabled = true
local npcESPEnabled = true
local nameEnabled = true
local healthEnabled = true
local highlightEnabled = true

local espObjects = {}
local npcConnections = {}

-- Закрытие панели
closeButton.MouseButton1Click:Connect(function()
    -- Очищаем NPC коннекции
    for _, conn in pairs(npcConnections) do
        conn:Disconnect()
    end
    screenGui:Destroy()
end)

-- Скрытие/показ
local panelHidden = false
hideButton.MouseButton1Click:Connect(function()
    panelHidden = not panelHidden
    contentFrame.Visible = not panelHidden
    hideButton.Text = panelHidden and "□" or "_"
    mainFrame.Size = panelHidden and UDim2.new(0, 260, 0, 40) or UDim2.new(0, 260, 0, 240)
end)

-- Функция обновления переключателя
local function updateToggle(toggle, enabled, name)
    toggle.Text = name .. ": " .. (enabled and "ВКЛ" or "ВЫКЛ")
    toggle.BackgroundColor3 = enabled and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(170, 0, 0)
end

-- Функция обновления видимости ESP
local function updateAllESP()
    for _, data in pairs(espObjects) do
        local isPlayer = data.isPlayer
        local shouldShow = espEnabled and ((isPlayer and playerESPEnabled) or (not isPlayer and npcESPEnabled))
        
        if data.billboard then
            data.billboard.Enabled = shouldShow
        end
        if data.highlight then
            data.highlight.Enabled = shouldShow and highlightEnabled
        end
        if data.nameLabel then
            data.nameLabel.Visible = nameEnabled
        end
        if data.healthLabel then
            data.healthLabel.Visible = healthEnabled
        end
    end
end

-- Переключатели
espToggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    updateToggle(espToggle, espEnabled, "ESP")
    updateAllESP()
end)

playerToggle.MouseButton1Click:Connect(function()
    playerESPEnabled = not playerESPEnabled
    updateToggle(playerToggle, playerESPEnabled, "Игроки")
    updateAllESP()
end)

npcToggle.MouseButton1Click:Connect(function()
    npcESPEnabled = not npcESPEnabled
    updateToggle(npcToggle, npcESPEnabled, "NPC")
    updateAllESP()
end)

nameToggle.MouseButton1Click:Connect(function()
    nameEnabled = not nameEnabled
    updateToggle(nameToggle, nameEnabled, "Имена")
    updateAllESP()
end)

healthToggle.MouseButton1Click:Connect(function()
    healthEnabled = not healthEnabled
    updateToggle(healthToggle, healthEnabled, "Здоровье")
    updateAllESP()
end)

highlightToggle.MouseButton1Click:Connect(function()
    highlightEnabled = not highlightEnabled
    updateToggle(highlightToggle, highlightEnabled, "Подсветка")
    updateAllESP()
end)

-- Функция создания ESP для персонажа (игрок или NPC)
local function createESP(character, isPlayer, customName)
    if not character or not character.Parent then return end
    
    local head = character:FindFirstChild("Head")
    if not head then
        -- Ждём появления головы
        local connection
        connection = character.ChildAdded:Connect(function(child)
            if child.Name == "Head" then
                connection:Disconnect()
                createESP(character, isPlayer, customName)
            end
        end)
        return
    end
    
    -- Проверяем, нет ли уже ESP на этом персонаже
    local existingBillboard = head:FindFirstChild("PlayerESP")
    if existingBillboard then
        existingBillboard:Destroy()
    end
    
    local espData = {
        isPlayer = isPlayer,
        character = character
    }
    
    -- Уникальный ID для NPC
    local id = isPlayer and character.Name or (customName .. "_" .. #espObjects)
    espObjects[id] = espData
    
    -- Создаём BillboardGui
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "PlayerESP"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Enabled = espEnabled and ((isPlayer and playerESPEnabled) or (not isPlayer and npcESPEnabled))
    billboard.Parent = head
    espData.billboard = billboard
    
    -- Фон
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = isPlayer and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(50, 30, 0)
    frame.BackgroundTransparency = 0.5
    frame.Parent = billboard
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    -- Имя
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -10, 0.5, 0)
    nameLabel.Position = UDim2.new(0, 5, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = isPlayer and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 200, 100)
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextSize = 14
    nameLabel.Text = customName or character.Name
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Visible = nameEnabled
    nameLabel.Parent = frame
    espData.nameLabel = nameLabel
    
    -- Здоровье
    local healthLabel = Instance.new("TextLabel")
    healthLabel.Size = UDim2.new(1, -10, 0.5, 0)
    healthLabel.Position = UDim2.new(0, 5, 0.5, 0)
    healthLabel.BackgroundTransparency = 1
    healthLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
    healthLabel.Font = Enum.Font.SourceSans
    healthLabel.TextSize = 12
    healthLabel.Text = "HP: ???"
    healthLabel.TextXAlignment = Enum.TextXAlignment.Left
    healthLabel.Visible = healthEnabled
    healthLabel.Parent = frame
    espData.healthLabel = healthLabel
    
    -- Подсветка
    local highlight = Instance.new("Highlight")
    highlight.Name = "PlayerHighlight"
    highlight.FillColor = isPlayer and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 150, 50)
    highlight.FillTransparency = 0.8
    highlight.OutlineColor = isPlayer and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 150, 50)
    highlight.OutlineTransparency = 0
    highlight.Enabled = highlightEnabled and espEnabled and ((isPlayer and playerESPEnabled) or (not isPlayer and npcESPEnabled))
    highlight.Parent = character
    espData.highlight = highlight
    
    -- Обновление здоровья (если есть Humanoid)
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        local function updateHealth()
            local health = math.floor(humanoid.Health)
            healthLabel.Text = "HP: " .. health
            
            if health > 75 then
                healthLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
            elseif health > 40 then
                healthLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
            else
                healthLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            end
        end
        
        humanoid.HealthChanged:Connect(updateHealth)
        updateHealth()
        
        -- Смерть
        humanoid.Died:Connect(function()
            if billboard then
                billboard:Destroy()
            end
            if highlight then
                highlight:Destroy()
            end
            espObjects[id] = nil
        end)
    else
        healthLabel.Text = isPlayer and "HP: ???" or "[NPC]"
    end
    
    -- Удаление при исчезновении персонажа
    character.AncestryChanged:Connect(function(_, parent)
        if not parent then
            if billboard then billboard:Destroy() end
            if highlight then highlight:Destroy() end
            espObjects[id] = nil
        end
    end)
    
    return espData
end

-- Функция сканирования NPC
local function scanForNPCs()
    -- Очищаем старые коннекции
    for _, conn in pairs(npcConnections) do
        conn:Disconnect()
    end
    npcConnections = {}
    
    -- Ищем всех NPC в Workspace
    local function findNPCs(parent)
        for _, child in ipairs(parent:GetChildren()) do
            -- Пропускаем игроков и системные объекты
            if child:IsA("Model") and not Players:GetPlayerFromCharacter(child) then
                local humanoid = child:FindFirstChild("Humanoid")
                local head = child:FindFirstChild("Head")
                
                -- Это NPC если есть Humanoid и голова
                if humanoid and head and humanoid.Health > 0 then
                    local npcName = child.Name
                    
                    -- Если у NPC есть Humanoid с DisplayName
                    if humanoid.DisplayName and humanoid.DisplayName ~= "" then
                        npcName = humanoid.DisplayName
                    end
                    
                    createESP(child, false, npcName)
                end
            end
            
            -- Рекурсивно проверяем папки
            if child:IsA("Folder") or child:IsA("Model") then
                findNPCs(child)
            end
        end
    end
    
    findNPCs(workspace)
    
    -- Отслеживаем появление новых NPC
    local descendantAdded = workspace.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("Model") and not Players:GetPlayerFromCharacter(descendant) then
            local humanoid = descendant:FindFirstChild("Humanoid")
            local head = descendant:FindFirstChild("Head")
            
            if humanoid and head and humanoid.Health > 0 then
                local npcName = descendant.Name
                if humanoid.DisplayName and humanoid.DisplayName ~= "" then
                    npcName = humanoid.DisplayName
                end
                createESP(descendant, false, npcName)
            end
        end
    end)
    
    table.insert(npcConnections, descendantAdded)
    
    -- Отслеживаем добавление головы/Humanoid в существующие модели
    local childAdded = workspace.DescendantAdded:Connect(function(descendant)
        if (descendant.Name == "Head" or descendant.Name == "Humanoid") and 
           descendant.Parent and descendant.Parent:IsA("Model") and 
           not Players:GetPlayerFromCharacter(descendant.Parent) then
            
            local model = descendant.Parent
            local humanoid = model:FindFirstChild("Humanoid")
            local head = model:FindFirstChild("Head")
            
            if humanoid and head and humanoid.Health > 0 then
                local npcName = model.Name
                if humanoid.DisplayName and humanoid.DisplayName ~= "" then
                    npcName = humanoid.DisplayName
                end
                createESP(model, false, npcName)
            end
        end
    end)
    
    table.insert(npcConnections, childAdded)
end

-- Применяем ESP к игрокам
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= localPlayer then
        if player.Character then
            createESP(player.Character, true, player.Name)
        end
        
        player.CharacterAdded:Connect(function(character)
            createESP(character, true, player.Name)
        end)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= localPlayer then
        player.CharacterAdded:Connect(function(character)
            createESP(character, true, player.Name)
        end)
        
        if player.Character then
            createESP(player.Character, true, player.Name)
        end
    end
end)

-- Сканируем NPC
scanForNPCs()

-- Периодическое сканирование NPC (каждые 5 секунд)
local scanConnection = RunService.Heartbeat:Connect(function()
    -- Используем счётчик для периодической проверки
end)

spawn(function()
    while wait(5) do
        if screenGui and screenGui.Parent then
            scanForNPCs()
        else
            break
        end
    end
end)
