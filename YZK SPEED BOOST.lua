local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer

-- === DARK AESTHETIC PALETTE ===
local COLORS = {
    MainBG          = Color3.fromRGB(10, 10, 15),
    Border          = Color3.fromRGB(160, 60, 255),
    Accent          = Color3.fromRGB(200, 80, 255),
    TextPrimary     = Color3.fromRGB(255, 255, 255),
    TextSecondary   = Color3.fromRGB(200, 200, 220),
    InputBG         = Color3.fromRGB(25, 25, 35),
    HeaderON        = Color3.fromRGB(120, 40, 220),
    HeaderOFF       = Color3.fromRGB(80, 80, 90)
}

-- ==================== TRANSPARENCE DE LA FENÊTRE ====================
local WindowTransparency = 0.15     -- ← Valeur modifiée : peu transparent (on voit très peu à travers)

-------------------------------------------------------------------------
-- SPEED CUSTOMIZER MODULE
-------------------------------------------------------------------------
local SpeedCustomizer = {
    Enabled = false,
    Running = true,
    MainFrame = nil,
    MinimizeBtn = nil,
    CloseBtn = nil,
    ToggleBtn = nil,
    Header = nil,
    SpeedLabel = nil,
    StealLabel = nil,
    JumpLabel = nil,
    SpeedInput = nil,
    StealInput = nil,
    JumpInput = nil,
    IsMinimized = false,
    
    SpeedValue = 58,
    StealValue = 29,
    JumpValue = 80,
    character = nil,
    hrp = nil,
    hum = nil,
    
    HeartbeatConn = nil,
    JumpConn = nil,
    CharacterConn = nil
}

local function setupSpeedCharacter(char)
    SpeedCustomizer.character = char
    SpeedCustomizer.hrp = char:WaitForChild("HumanoidRootPart")
    SpeedCustomizer.hum = char:WaitForChild("Humanoid")
end

local function createSpeedUI()
    local SpeedScreenGui = Instance.new("ScreenGui")
    SpeedScreenGui.Name = "YZK_SpeedUI"
    SpeedScreenGui.ResetOnSpawn = false
    SpeedScreenGui.Parent = CoreGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "SpeedMainFrame"
    MainFrame.Size = UDim2.new(0, 270, 0, 245)
    MainFrame.Position = UDim2.new(0.5, -135, 0.4, 0)
    MainFrame.BackgroundColor3 = COLORS.MainBG
    MainFrame.BackgroundTransparency = WindowTransparency   -- Transparence appliquée ici
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = SpeedScreenGui

    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
    local stroke = Instance.new("UIStroke", MainFrame)
    stroke.Color = COLORS.Border
    stroke.Thickness = 2.5

    -- Titre
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -80, 0, 38)
    Title.Position = UDim2.new(0, 18, 0, 8)
    Title.BackgroundTransparency = 1
    Title.Text = "YZK Speed Boost"
    Title.TextColor3 = COLORS.Accent
    Title.TextSize = 19
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Font = Enum.Font.GothamBlack
    Title.Parent = MainFrame

    -- Bouton Minimize "–"
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Name = "MinimizeBtn"
    MinimizeBtn.Size = UDim2.new(0, 26, 0, 26)
    MinimizeBtn.Position = UDim2.new(1, -62, 0, 11)
    MinimizeBtn.BackgroundTransparency = 1
    MinimizeBtn.Text = "–"
    MinimizeBtn.TextColor3 = COLORS.TextPrimary
    MinimizeBtn.TextSize = 24
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.Parent = MainFrame
    SpeedCustomizer.MinimizeBtn = MinimizeBtn

    -- Bouton Close "×"
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "CloseBtn"
    CloseBtn.Size = UDim2.new(0, 26, 0, 26)
    CloseBtn.Position = UDim2.new(1, -32, 0, 11)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
    CloseBtn.TextSize = 26
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = MainFrame
    SpeedCustomizer.CloseBtn = CloseBtn

    -- Header ON/OFF
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, -20, 0, 48)
    Header.Position = UDim2.new(0, 10, 0, 54)
    Header.BackgroundColor3 = COLORS.HeaderOFF
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame
    Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)
    SpeedCustomizer.Header = Header

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
    ToggleBtn.BackgroundTransparency = 1
    ToggleBtn.Text = "OFF"
    ToggleBtn.TextColor3 = COLORS.TextPrimary
    ToggleBtn.TextSize = 22
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.Parent = Header
    SpeedCustomizer.ToggleBtn = ToggleBtn

    -- === INPUT ROWS ===
    local function createInputRow(labelText, defaultValue, yPos)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.55, 0, 0, 30)
        label.Position = UDim2.new(0, 18, 0, yPos)
        label.BackgroundTransparency = 1
        label.Text = labelText
        label.TextColor3 = COLORS.TextSecondary
        label.TextSize = 15
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.Gotham
        label.Parent = MainFrame

        local box = Instance.new("TextBox")
        box.Size = UDim2.new(0, 92, 0, 36)
        box.Position = UDim2.new(1, -110, 0, yPos)
        box.BackgroundColor3 = COLORS.InputBG
        box.Text = tostring(defaultValue)
        box.TextColor3 = COLORS.TextPrimary
        box.TextSize = 17
        box.Font = Enum.Font.GothamBold
        box.ClearTextOnFocus = false
        box.Parent = MainFrame

        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)
        local boxStroke = Instance.new("UIStroke", box)
        boxStroke.Color = COLORS.Border
        boxStroke.Thickness = 1.5
        boxStroke.Transparency = 0.6

        return label, box
    end

    local SpeedLabel,  SpeedInput  = createInputRow("Speed",     58, 118)
    local StealLabel,  StealInput  = createInputRow("Steal Spd", 29, 158)
    local JumpLabel,   JumpInput   = createInputRow("Jump",      80, 198)

    SpeedCustomizer.SpeedLabel = SpeedLabel
    SpeedCustomizer.StealLabel = StealLabel
    SpeedCustomizer.JumpLabel  = JumpLabel
    SpeedCustomizer.SpeedInput = SpeedInput
    SpeedCustomizer.StealInput = StealInput
    SpeedCustomizer.JumpInput  = JumpInput

    -- Toggle
    ToggleBtn.MouseButton1Click:Connect(function()
        SpeedCustomizer.Enabled = not SpeedCustomizer.Enabled
        if SpeedCustomizer.Enabled then
            ToggleBtn.Text = "ON"
            Header.BackgroundColor3 = COLORS.HeaderON
        else
            ToggleBtn.Text = "OFF"
            Header.BackgroundColor3 = COLORS.HeaderOFF
        end
    end)

    -- Input validation
    local function validateInput(box, varName, min, max)
        box.FocusLost:Connect(function()
            local num = tonumber(box.Text)
            if num then
                num = math.clamp(num, min, max)
                box.Text = tostring(num)
                SpeedCustomizer[varName] = num
            else
                box.Text = tostring(SpeedCustomizer[varName])
            end
        end)
    end

    validateInput(SpeedInput,  "SpeedValue",  1, 200)
    validateInput(StealInput, "StealValue",  1, 200)
    validateInput(JumpInput,  "JumpValue",   1, 200)

    -- Minimize
    local originalSize = UDim2.new(0, 270, 0, 245)
    local minimizedSize = UDim2.new(0, 270, 0, 115)

    MinimizeBtn.MouseButton1Click:Connect(function()
        SpeedCustomizer.IsMinimized = not SpeedCustomizer.IsMinimized
        if SpeedCustomizer.IsMinimized then
            MainFrame.Size = minimizedSize
            SpeedLabel.Visible = false
            StealLabel.Visible = false
            JumpLabel.Visible = false
            SpeedInput.Visible = false
            StealInput.Visible = false
            JumpInput.Visible = false
        else
            MainFrame.Size = originalSize
            SpeedLabel.Visible = true
            StealLabel.Visible = true
            JumpLabel.Visible = true
            SpeedInput.Visible = true
            StealInput.Visible = true
            JumpInput.Visible = true
        end
    end)

    -- Close Button
    CloseBtn.MouseButton1Click:Connect(function()
        SpeedCustomizer.Running = false
        if SpeedCustomizer.HeartbeatConn then SpeedCustomizer.HeartbeatConn:Disconnect() end
        if SpeedCustomizer.JumpConn then SpeedCustomizer.JumpConn:Disconnect() end
        if SpeedCustomizer.CharacterConn then SpeedCustomizer.CharacterConn:Disconnect() end
        SpeedScreenGui:Destroy()
        print("YZK Speed Boost → Fully closed and stopped")
    end)

    return SpeedScreenGui
end

-------------------------------------------------------------------------
-- INITIALIZATION
-------------------------------------------------------------------------
if lp.Character then setupSpeedCharacter(lp.Character) end
SpeedCustomizer.CharacterConn = lp.CharacterAdded:Connect(setupSpeedCharacter)

SpeedCustomizer.SpeedUI = createSpeedUI()

-- Speed & Jump logic
SpeedCustomizer.HeartbeatConn = RunService.Heartbeat:Connect(function()
    if not SpeedCustomizer.Running or not SpeedCustomizer.Enabled or not SpeedCustomizer.hrp or not SpeedCustomizer.hum then return end
    local moveDir = SpeedCustomizer.hum.MoveDirection
    if moveDir.Magnitude > 0 then
        local isSteal = SpeedCustomizer.hum.WalkSpeed < 25
        local targetSpeed = isSteal and SpeedCustomizer.StealValue or SpeedCustomizer.SpeedValue
        SpeedCustomizer.hrp.AssemblyLinearVelocity = Vector3.new(
            moveDir.X * targetSpeed,
            SpeedCustomizer.hrp.AssemblyLinearVelocity.Y,
            moveDir.Z * targetSpeed
        )
    end
end)

SpeedCustomizer.JumpConn = UserInputService.JumpRequest:Connect(function()
    if not SpeedCustomizer.Running or not SpeedCustomizer.Enabled or not SpeedCustomizer.hum or SpeedCustomizer.hum.FloorMaterial == Enum.Material.Air then return end
    SpeedCustomizer.hrp.AssemblyLinearVelocity = Vector3.new(
        SpeedCustomizer.hrp.AssemblyLinearVelocity.X,
        SpeedCustomizer.JumpValue,
        SpeedCustomizer.hrp.AssemblyLinearVelocity.Z
    )
end)
