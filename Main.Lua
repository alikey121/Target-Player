-- Evitar duplicados
if game.CoreGui:FindFirstChild("JsLikeBeta_TargetSystem") then
    game.CoreGui.JsLikeBeta_TargetSystem:Destroy()
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local targetPlayer = nil
local loopTpConnection = nil
local isSpectating = false

-- Control estricto para detener el bucle del Tool Spy anterior
local currentSpySession = 0 

-- INTERFAZ PRINCIPAL
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "JsLikeBeta_TargetSystem"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- ==========================================
-- BOTÓN FLOTANTE (BOLITA JS)
-- ==========================================
local OpenCloseBtn = Instance.new("TextButton")
OpenCloseBtn.Size = UDim2.new(0, 45, 0, 45)
OpenCloseBtn.Position = UDim2.new(0.1, 0, 0.2, 0)
OpenCloseBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
OpenCloseBtn.Text = "Js"
OpenCloseBtn.TextColor3 = Color3.fromRGB(200, 0, 0)
OpenCloseBtn.TextSize = 20
OpenCloseBtn.Font = Enum.Font.SourceSansBold
OpenCloseBtn.Active = true
OpenCloseBtn.Draggable = true
OpenCloseBtn.Parent = ScreenGui

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(1, 0)
BtnCorner.Parent = OpenCloseBtn

local BtnStroke = Instance.new("UIStroke")
BtnStroke.Color = Color3.fromRGB(200, 0, 0)
BtnStroke.Thickness = 2
BtnStroke.Parent = OpenCloseBtn

-- ==========================================
-- MENÚ PRINCIPAL
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 310, 0, 350)
MainFrame.Position = UDim2.new(0.5, -155, 0.4, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.Visible = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(200, 0, 0)
UIStroke.Thickness = 2.5
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = MainFrame

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Sello de Identidad
local BrandLabel = Instance.new("TextLabel")
BrandLabel.Size = UDim2.new(0, 120, 0, 20)
BrandLabel.Position = UDim2.new(0, 12, 0, 8)
BrandLabel.Text = "Js Like Beta"
BrandLabel.TextColor3 = Color3.fromRGB(200, 0, 0)
BrandLabel.TextSize = 14
BrandLabel.Font = Enum.Font.SourceSansBold
BrandLabel.TextXAlignment = Enum.TextXAlignment.Left
BrandLabel.BackgroundTransparency = 1
BrandLabel.Parent = MainFrame

OpenCloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- ==========================================
-- AVATAR Y TEXTOS BRILLANTES
-- ==========================================
local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Size = UDim2.new(0, 85, 0, 85)
AvatarImage.Position = UDim2.new(0, 12, 0, 35)
AvatarImage.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
AvatarImage.Image = "rbxassetid://0"
AvatarImage.Visible = true
AvatarImage.Parent = MainFrame

local AvatarStroke = Instance.new("UIStroke")
AvatarStroke.Color = Color3.fromRGB(40, 40, 40)
AvatarStroke.Thickness = 1
AvatarStroke.Parent = AvatarImage

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(0, 6)
AvatarCorner.Parent = AvatarImage

local RightPanel = Instance.new("Frame")
RightPanel.Size = UDim2.new(0, 190, 0, 85)
RightPanel.Position = UDim2.new(0, 108, 0, 35)
RightPanel.BackgroundTransparency = 1
RightPanel.Parent = MainFrame

local NameLabel = Instance.new("TextLabel")
NameLabel.Size = UDim2.new(1, 0, 0, 38)
NameLabel.Position = UDim2.new(0, 0, 0, 2)
NameLabel.Text = "Esperando objetivo..."
NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
NameLabel.TextSize = 16
NameLabel.Font = Enum.Font.SourceSansBold
NameLabel.TextWrapped = true
NameLabel.TextXAlignment = Enum.TextXAlignment.Left
NameLabel.TextYAlignment = Enum.TextYAlignment.Top
NameLabel.BackgroundTransparency = 1
NameLabel.Parent = RightPanel

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(1, 0, 0, 35)
TextBox.Position = UDim2.new(0, 0, 1, -35)
TextBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TextBox.Text = ""
TextBox.PlaceholderText = "Escribir nombre..."
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
TextBox.TextSize = 15
TextBox.Font = Enum.Font.SourceSans
TextBox.Parent = RightPanel

local TBCorner = Instance.new("UICorner")
TBCorner.CornerRadius = UDim.new(0, 6)
TBCorner.Parent = TextBox

local TBStroke = Instance.new("UIStroke")
TBStroke.Color = Color3.fromRGB(50, 50, 50)
TBStroke.Thickness = 1
TBStroke.Parent = TextBox

-- ==========================================
-- CUADRÍCULA DE BOTONES ACCIÓN
-- ==========================================
local ButtonGrid = Instance.new("Frame")
ButtonGrid.Size = UDim2.new(0, 286, 0, 110)
ButtonGrid.Position = UDim2.new(0, 12, 0, 135)
ButtonGrid.BackgroundTransparency = 1
ButtonGrid.Parent = MainFrame

local UIGridLayout = Instance.new("UIGridLayout")
UIGridLayout.CellSize = UDim2.new(0, 138, 0, 48)
UIGridLayout.CellPadding = UDim2.new(0, 10, 0, 10)
UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIGridLayout.Parent = ButtonGrid

local function createGridButton(text, order)
    local btn = Instance.new("TextButton")
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 16
    btn.Font = Enum.Font.SourceSansBold
    btn.LayoutOrder = order
    btn.Parent = ButtonGrid

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(45, 45, 45)
    stroke.Thickness = 1.2
    stroke.Parent = btn

    return btn, stroke
end

local SpecButton, SpecStroke = createGridButton("Spectate", 1)
local LoopButton, LoopStroke = createGridButton("Loop Tp", 2)
local TPButton, TPStroke     = createGridButton("Tepear", 3)
local HighButton, HighStroke = createGridButton("Highlight", 4)

-- ==========================================
-- SECCIÓN DE ESPÍA DE INVENTARIO (TOOL SPY)
-- ==========================================
local SpyPanel = Instance.new("Frame")
SpyPanel.Size = UDim2.new(0, 286, 0, 85)
SpyPanel.Position = UDim2.new(0, 12, 0, 250)
SpyPanel.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
SpyPanel.Parent = MainFrame

local SpyCorner = Instance.new("UICorner")
SpyCorner.CornerRadius = UDim.new(0, 6)
SpyCorner.Parent = SpyPanel

local SpyStroke = Instance.new("UIStroke")
SpyStroke.Color = Color3.fromRGB(35, 35, 35)
SpyStroke.Thickness = 1
SpyStroke.Parent = SpyPanel

local SpyTitle = Instance.new("TextLabel")
SpyTitle.Size = UDim2.new(1, -10, 0, 18)
SpyTitle.Position = UDim2.new(0, 8, 0, 4)
SpyTitle.Text = "Inventario:"
SpyTitle.TextColor3 = Color3.fromRGB(200, 0, 0)
SpyTitle.TextSize = 13
SpyTitle.Font = Enum.Font.SourceSansBold
SpyTitle.TextXAlignment = Enum.TextXAlignment.Left
SpyTitle.BackgroundTransparency = 1
SpyTitle.Parent = SpyPanel

local InventoryLabel = Instance.new("TextLabel")
InventoryLabel.Size = UDim2.new(1, -16, 1, -26)
InventoryLabel.Position = UDim2.new(0, 8, 0, 22)
InventoryLabel.Text = "Ninguno"
InventoryLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
InventoryLabel.TextSize = 14
InventoryLabel.Font = Enum.Font.SourceSans
InventoryLabel.TextXAlignment = Enum.TextXAlignment.Left
InventoryLabel.TextYAlignment = Enum.TextYAlignment.Top
InventoryLabel.TextWrapped = true
InventoryLabel.BackgroundTransparency = 1
InventoryLabel.Parent = SpyPanel

-- ==========================================
-- LÓGICA DE ESCANEO REHECHA (SIN TRABAS)
-- ==========================================
local function updateInventorySpy(player)
    if not player then
        InventoryLabel.Text = "Ninguno"
        return
    end

    local toolNames = {}

    local backpack = player:FindFirstChildOfClass("Backpack")
    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                table.insert(toolNames, item.Name)
            end
        end
    end

    if player.Character then
        for _, item in ipairs(player.Character:GetChildren()) do
            if item:IsA("Tool") then
                table.insert(toolNames, item.Name .. " (Equipado)")
            end
        end
    end

    if #toolNames > 0 then
        InventoryLabel.Text = table.concat(toolNames, ", ")
    else
        InventoryLabel.Text = "Vacio"
    end
end

local function updateTargetUI(player)
    currentSpySession = currentSpySession + 1
    local mySession = currentSpySession

    if player then
        targetPlayer = player
        NameLabel.Text = player.DisplayName .. "\n(@" .. player.Name .. ")"

        task.spawn(function()
            local content, ready = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180)
            if currentSpySession == mySession then
                AvatarImage.Image = content
            end
        end)

        task.spawn(function()
            while currentSpySession == mySession and targetPlayer == player do
                updateInventorySpy(player)
                task.wait(1)
            end
        end)
    else
        targetPlayer = nil
        NameLabel.Text = "Esperando objetivo..."
        AvatarImage.Image = "rbxassetid://0"
        InventoryLabel.Text = "Ninguno"

        if loopTpConnection then
            loopTpConnection:Disconnect()
            loopTpConnection = nil
            LoopButton.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
            LoopStroke.Color = Color3.fromRGB(45, 45, 45)
        end
    end
end

TextBox:GetPropertyChangedSignal("Text"):Connect(function()
    local text = TextBox.Text:lower()
    if text == "" then updateTargetUI(nil) return end

    local found = false
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            if p.Name:lower():sub(1, #text) == text or p.DisplayName:lower():sub(1, #text) == text then
                updateTargetUI(p)
                found = true
                break
            end
        end
    end
    if not found then updateTargetUI(nil) end
end)

-- ==========================================
-- MECÁNICAS DE BOTONES
-- ==========================================
TPButton.MouseButton1Click:Connect(function()
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if myHRP then
            myHRP.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1.2)
        end
    end
end)

LoopButton.MouseButton1Click:Connect(function()
    if not targetPlayer then return end
    if loopTpConnection then
        loopTpConnection:Disconnect()
        loopTpConnection = nil
        LoopButton.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        LoopStroke.Color = Color3.fromRGB(45, 45, 45)
    else
        LoopButton.BackgroundColor3 = Color3.fromRGB(45, 5, 5)
        LoopStroke.Color = Color3.fromRGB(255, 0, 0)

        loopTpConnection = RunService.Heartbeat:Connect(function()
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if myHRP then
                    myHRP.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1.2)
                end
            else
                if loopTpConnection then
                    loopTpConnection:Disconnect()
                    loopTpConnection = nil
                    LoopButton.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
                    LoopStroke.Color = Color3.fromRGB(45, 45, 45)
                end
            end
        end)
    end
end)

SpecButton.MouseButton1Click:Connect(function()
    if not targetPlayer then 
        Workspace.CurrentCamera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        SpecButton.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        SpecStroke.Color = Color3.fromRGB(45, 45, 45)
        isSpectating = false
        return 
    end
    if isSpectating then
        Workspace.CurrentCamera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        SpecButton.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        SpecStroke.Color = Color3.fromRGB(45, 45, 45)
        isSpectating = false
    else
        if targetPlayer.Character and targetPlayer.Character:FindFirstChildOfClass("Humanoid") then
            Workspace.CurrentCamera.CameraSubject = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
            SpecButton.BackgroundColor3 = Color3.fromRGB(45, 5, 5)
            SpecStroke.Color = Color3.fromRGB(255, 0, 0)
            isSpectating = true
        end
    end
end)

-- ==========================================
-- LÓGICA HIGHLIGHT
-- ==========================================
local isHighlightEnabled = false
local highlightInstance = nil

HighButton.MouseButton1Click:Connect(function()
    isHighlightEnabled = not isHighlightEnabled
    if isHighlightEnabled then
        HighButton.BackgroundColor3 = Color3.fromRGB(45, 5, 5)
        HighStroke.Color = Color3.fromRGB(255, 0, 0)
        if targetPlayer and targetPlayer.Character then
            highlightInstance = Instance.new("Highlight")
            highlightInstance.FillColor = Color3.fromRGB(255, 0, 0)
            highlightInstance.FillTransparency = 0.5
            highlightInstance.Parent = targetPlayer.Character
        end
    else
        HighButton.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        HighStroke.Color = Color3.fromRGB(45, 45, 45)
        if highlightInstance then highlightInstance:Destroy() highlightInstance = nil end
    end
end)