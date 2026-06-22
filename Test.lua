local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Создаём главный GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ESPGui"
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

-- Создаём перетаскиваемую панель
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 420)
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
titleText.Text = "ESP + AIM Панель"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.Font = Enum.Font.SourceSansBold
titleText.TextSize = 15
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

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

-- Содержимое
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 1, -45)
contentFrame.Position = UDim2.new(0, 10, 0, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Функция создания переключателя
local function createToggle(name, yPos)
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(1, 0, 0, 30)
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

-- Функция создания слайдера
local function createSlider(name, min, max, default, yPos)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 55)
    sliderFrame.Position = UDim2.new(0, 0, 0, yPos)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = contentFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. default
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderFrame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, 0, 0, 8)
    sliderBg.Position = UDim2.new(0, 0, 0, 25)
    sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    sliderBg.Parent = sliderFrame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 4)
    sliderCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    sliderFill.Parent = sliderBg
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 4)
    fillCorner.Parent = sliderFill
    
    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Size = UDim2.new(0, 16, 0, 16)
    sliderBtn.Position = UDim2.new((default - min) / (max - min), -8, 0, 21)
    sliderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderBtn.Text = ""
    sliderBtn.Parent = sliderFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = sliderBtn
    
    local value = default
    
    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        value = math.floor(min + (max - min) * pos)
        sliderFill.Size = UDim2.new(pos, 0, 1, 0)
        sliderBtn.Position = UDim2.new(pos, -8, 0, 21)
        label.Text = name .. ": " .. value
    end
    
    sliderBtn.MouseButton1Down:Connect(function()
        local connection
        connection = UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider(input)
            end
        end)
        
        local endConnection
        endConnection = UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                connection:Disconnect()
                endConnection:Disconnect()
            end
        end)
    end)
    
    return {
        Frame = sliderFrame,
        GetValue = function() return value end,
        SetValue = function(v) 
            value = v
            local pos = (v - min) / (max - min)
            sliderFill.Size = UDim2.new(pos, 0, 1, 0)
            sliderBtn.Position = UDim2.new(pos, -8, 0, 21)
            label.Text = name .. ": " .. v
        end
    }
end

-- Создаём переключатели и слайдеры
local espToggle = createToggle("ESP", 0)
local playerToggle = createToggle("Игроки", 35)
local npcToggle = createToggle("NPC", 70)
local nameToggle = createToggle("Имена", 105)
local healthToggle = createToggle("Здоровье", 140)
local highlightToggle = createToggle("Подсветка", 175)

-- Разделитель
local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, 0, 0, 2)
divider.Position = UDim2.new(0, 0, 0, 210)
divider.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
divider.Parent = contentFrame

-- Aim Bot
local aimToggle = createToggle("AIM BOT", 220)
local aimRadiusSlider = createSlider("Радиус", 50, 500, 200, 255)
local aimSmoothSlider = createSlider("Плавность", 1, 20, 5, 315)
local aimPartToggle = createToggle("Цель: Голова", 370) -- true = голова, false = туловище

-- Прицел
local crosshairToggle = createToggle("Прицел", 405)

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
local aimEnabled = false
local aimPart = "Head" -- Head или HumanoidRootPart
local crosshairEnabled = false

local espObjects = {}
local npcConnections = {}

-- Закрытие
closeButton.MouseButton1Click:Connect(function()
    for _, conn in pairs(npcConnections) do
        conn:Disconnect()
    end
    if aimConnection then aimConnection:Disconnect() end
    if crosshairGui then crosshairGui:Destroy() end
    screenGui:Destroy()
end)

-- Скрытие
local panelHidden = false
hideButton.MouseButton1Click:Connect(function()
    panelHidden = not panelHidden
    contentFrame.Visible = not panelHidden
    hideButton.Text = panelHidden and "□" or "_"
    mainFrame.Size = panelHidden and UDim2.new(0, 280, 0, 40) or UDim2.new(0, 280, 0, 420)
end)

-- Обновление переключателя
local function updateToggleUI(toggle, enabled, name)
    toggle.Text = name .. ": " .. (enabled and "ВКЛ" or "ВЫКЛ")
    toggle.BackgroundColor3 = enabled and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(170, 0, 0)
end

-- Обновление ESP
local function updateAllESP()
    for _, data in pairs(espObjects) do
        local isPlayer = data.isPlayer
        local shouldShow = espEnabled and ((isPlayer and playerESPEnabled) or (not isPlayer and npcESPEnabled))
        
        if data.billboard then data.billboard.Enabled = shouldShow end
        if data.highlight then data.highlight.Enabled = shouldShow and highlightEnabled end
        if data.nameLabel then data.nameLabel.Visible = nameEnabled end
        if data.healthLabel then data.healthLabel.Visible = healthEnabled end
    end
end

-- Переключатели ESP
espToggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    updateToggleUI(espToggle, espEnabled, "ESP")
    updateAllESP()
end)

playerToggle.MouseButton1Click:Connect(function()
    playerESPEnabled = not playerESPEnabled
    updateToggleUI(playerToggle, playerESPEnabled, "Игроки")
    updateAllESP()
end)

npcToggle.MouseButton1Click:Connect(function()
    npcESPEnabled = not npcESPEnabled
    updateToggleUI(npcToggle, npcESPEnabled, "NPC")
    updateAllESP()
end)

nameToggle.MouseButton1Click:Connect(function()
    nameEnabled = not nameEnabled
    updateToggleUI(nameToggle, nameEnabled, "Имена")
    updateAllESP()
end)

healthToggle.MouseButton1Click:Connect(function()
    healthEnabled = not healthEnabled
    updateToggleUI(healthToggle, healthEnabled, "Здоровье")
    updateAllESP()
end)

highlightToggle.MouseButton1Click:Connect(function()
    highlightEnabled = not highlightEnabled
    updateToggleUI(highlightToggle, highlightEnabled, "Подсветка")
    updateAllESP()
end)

-- Aim Bot переключатель
aimToggle.MouseButton1Click:Connect(function()
    aimEnabled = not aimEnabled
    updateToggleUI(aimToggle, aimEnabled, "AIM BOT")
end)

-- Цель (голова/туловище)
aimPartToggle.MouseButton1Click:Connect(function()
    if aimPart == "Head" then
        aimPart = "HumanoidRootPart"
        aimPartToggle.Text = "Цель: Туловище"
    else
        aimPart = "Head"
        aimPartToggle.Text = "Цель: Голова"
    end
end)

-- Прицел
crosshairToggle.MouseButton1Click:Connect(function()
    crosshairEnabled = not crosshairEnabled
    updateToggleUI(crosshairToggle, crosshairEnabled, "Прицел")
    
    if crosshairEnabled then
        createCrosshair()
    else
        if crosshairGui then
            crosshairGui:Destroy()
            crosshairGui = nil
        end
    end
end)

-- ESP для персонажа
local function createESP(character, isPlayer, customName)
    if not character or not character.Parent then return end
    
    local head = character:FindFirstChild("Head")
    if not head then
        local connection
        connection = character.ChildAdded:Connect(function(child)
            if child.Name == "Head" then
                connection:Disconnect()
                createESP(character, isPlayer, customName)
            end
        end)
        return
    end
    
    local existingBillboard = head:FindFirstChild("PlayerESP")
    if existingBillboard then existingBillboard:Destroy() end
    
    local espData = {
        isPlayer = isPlayer,
        character = character,
        head = head
    }
    
    local id = isPlayer and character.Name or (customName .. "_" .. #espObjects)
    espObjects[id] = espData
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "PlayerESP"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Enabled = espEnabled and ((isPlayer and playerESPEnabled) or (not isPlayer and npcESPEnabled))
    billboard.Parent = head
    espData.billboard = billboard
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = isPlayer and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(50, 30, 0)
    frame.BackgroundTransparency = 0.5
    frame.Parent = billboard
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
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
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "PlayerHighlight"
    highlight.FillColor = isPlayer and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 150, 50)
    highlight.FillTransparency = 0.8
    highlight.OutlineColor = isPlayer and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 150, 50)
    highlight.OutlineTransparency = 0
    highlight.Enabled = highlightEnabled and espEnabled
    highlight.Parent = character
    espData.highlight = highlight
    
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
        
        humanoid.Died:Connect(function()
            if billboard then billboard:Destroy() end
            if highlight then highlight:Destroy() end
            espObjects[id] = nil
        end)
    else
        healthLabel.Text = isPlayer and "HP: ???" or "[NPC]"
    end
    
    character.AncestryChanged:Connect(function(_, parent)
        if not parent then
            if billboard then billboard:Destroy() end
            if highlight then highlight:Destroy() end
            espObjects[id] = nil
        end
    end)
    
    return espData
end

-- Сканирование NPC
local function scanForNPCs()
    for _, conn in pairs(npcConnections) do
        conn:Disconnect()
    end
    npcConnections = {}
    
    local function findNPCs(parent)
        for _, child in ipairs(parent:GetChildren()) do
            if child:IsA("Model") and not Players:GetPlayerFromCharacter(child) then
                local humanoid = child:FindFirstChild("Humanoid")
                local head = child:FindFirstChild("Head")
                
                if humanoid and head and humanoid.Health > 0 then
                    local npcName = child.Name
                    if humanoid.DisplayName and humanoid.DisplayName ~= "" then
                        npcName = humanoid.DisplayName
                    end
                    createESP(child, false, npcName)
                end
            end
            
            if child:IsA("Folder") or child:IsA("Model") then
                findNPCs(child)
            end
        end
    end
    
    findNPCs(workspace)
    
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

scanForNPCs()

spawn(function()
    while wait(5) do
        if screenGui and screenGui.Parent then
            scanForNPCs()
        else
            break
        end
    end
end)

-- =============== AIM BOT ===============

local aimConnection

-- Функция поиска ближайшей цели
local function getClosestTarget()
    local closestTarget = nil
    local closestDistance = aimRadiusSlider.GetValue()
    local mousePos = UserInputService:GetMouseLocation()
    
    for _, data in pairs(espObjects) do
        if data.character and data.character.Parent then
            -- Пропускаем если это игрок и игроки выключены
            if data.isPlayer and not playerESPEnabled then continue end
            -- Пропускаем если это NPC и NPC выключены
            if not data.isPlayer and not npcESPEnabled then continue end
            
            local targetPart = data.character:FindFirstChild(aimPart)
            if targetPart then
                local humanoid = data.character:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    local screenPos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
                    
                    if onScreen then
                   
