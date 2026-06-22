-- Создаём GUI
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Создаём ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ColorChangerGui"
screenGui.Parent = playerGui

-- Создаём рамку
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.Parent = screenGui

-- Создаём кнопку
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 160, 0, 50)
button.Position = UDim2.new(0.5, -80, 0.5, -25)
button.BackgroundColor3 = Color3.fromRGB(0, 170, 255) -- Синий цвет
button.Text = "Сделать не синим"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 16
button.Parent = frame

-- Округляем углы (опционально)
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = button

-- Функция при нажатии
button.MouseButton1Click:Connect(function()
    -- Меняем цвет кнопки на зелёный (не синий)
    button.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
    button.Text = "Готово! Не синий"
end)
