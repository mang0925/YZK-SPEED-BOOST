local UserInputService = game:GetService("UserInputService")

local Players = game:GetService("Players")

local RunService = game:GetService("RunService")

local CoreGui = game:GetService("CoreGui")

local lp = Players.LocalPlayer

-- Color Palette

local COLORS = {

    MainBG = Color3.fromRGB(20, 25, 30),

    Border = Color3.fromRGB(140, 80, 255),

    TextActive = Color3.fromRGB(180, 140, 255),

    TextInactive = Color3.fromRGB(200, 200, 200)

}

-------------------------------------------------------------------------

-- UI CORE ENGINE

-------------------------------------------------------------------------

local function create(class, props)

    local obj = Instance.new(class)

    for k, v in pairs(props) do if k ~= "Parent" then obj[k] = v end end

    obj.Parent = props.Parent

    return obj

end

-------------------------------------------------------------------------

-- SPEED CUSTOMIZER MODULE

-------------------------------------------------------------------------

local SpeedCustomizer = {

    Enabled = false,

    MainFrame = nil,

    MinimizeBtn = nil,

    ToggleBtn = nil,

    Title = nil,

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

    CharacterConn = nil

}

-- Setup character

local function setupSpeedCharacter(char)

    SpeedCustomizer.character = char

    SpeedCustomizer.hrp = char:WaitForChild("HumanoidRootPart")

    SpeedCustomizer.hum = char:WaitForChild("Humanoid")

end

-- Create UI

local function createSpeedUI()

    local SpeedScreenGui = create("ScreenGui", {

        Name = "YZK_SpeedUI",

        ResetOnSpawn = false,

        Parent = CoreGui

    })

    local MainFrame = create("Frame", {

        Name = "SpeedMainFrame",

        Size = UDim2.new(0, 240, 0, 220),

        Position = UDim2.new(0.5, -120, 0.4, 0),

        BackgroundColor3 = COLORS.MainBG,

        BackgroundTransparency = 0.2,

        BorderSizePixel = 0,

        Active = true,

        Draggable = true,

        Parent = SpeedScreenGui

    })

    create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = MainFrame})

    create("UIStroke", {Color = COLORS.Border, Thickness = 2, Parent = MainFrame})

    -- Titre (toujours visible)

    local Title = create("TextLabel", {

        Size = UDim2.new(1, -60, 0, 30),

        Position = UDim2.new(0, 12, 0, 8),

        BackgroundTransparency = 1,

        Text = "YZK Speed Customizer",

        TextColor3 = COLORS.TextActive,

        TextSize = 14,

        TextXAlignment = Enum.TextXAlignment.Left,

        Font = Enum.Font.GothamBold,

        Parent = MainFrame

    })

    SpeedCustomizer.Title = Title

    -- Barre des 3 lignes (toujours visible)

    local MinimizeBar = create("TextButton", {

        Name = "MinimizeBar",

        Size = UDim2.new(0, 40, 0, 24),

        Position = UDim2.new(1, -48, 0, 8),

        BackgroundColor3 = Color3.fromRGB(70, 70, 80),

        Text = "≡",

        TextColor3 = Color3.fromRGB(255, 255, 255),

        TextSize = 18,

        Font = Enum.Font.GothamBold,

        BorderSizePixel = 0,

        Parent = MainFrame

    })

    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = MinimizeBar})

    SpeedCustomizer.MinimizeBtn = MinimizeBar

    -- Header ON/OFF

    local Header = create("Frame", {

        Size = UDim2.new(1, -20, 0, 45),

        Position = UDim2.new(0, 10, 0, 45),

        BackgroundColor3 = Color3.fromRGB(200, 60, 60),

        BorderSizePixel = 0,

        Parent = MainFrame

    })

    create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Header})

    local ToggleBtn = create("TextButton", {

        Size = UDim2.new(1, 0, 1, 0),

        BackgroundTransparency = 1,

        Text = "OFF",

        TextColor3 = Color3.fromRGB(255, 255, 255),

        TextSize = 20,

        Font = Enum.Font.GothamBold,

        Parent = Header

    })

    SpeedCustomizer.ToggleBtn = ToggleBtn

    SpeedCustomizer.Header = Header

    -- === INPUTS (Speed, Steal, Jump) ===

    local function createInputRow(labelText, defaultValue, yPos)

        local label = create("TextLabel", {

            Size = UDim2.new(0.55, 0, 0, 30),

            Position = UDim2.new(0, 15, 0, yPos),

            BackgroundTransparency = 1,

            Text = labelText,

            TextColor3 = COLORS.TextInactive,

            TextSize = 15,

            TextXAlignment = Enum.TextXAlignment.Left,

            Font = Enum.Font.Gotham,

            Parent = MainFrame

        })

        local box = create("TextBox", {

            Size = UDim2.new(0, 85, 0, 32),

            Position = UDim2.new(1, -100, 0, yPos),

            BackgroundColor3 = Color3.fromRGB(30, 35, 40),

            Text = tostring(defaultValue),

            TextColor3 = Color3.fromRGB(255, 255, 255),

            TextSize = 16,

            Font = Enum.Font.GothamBold,

            ClearTextOnFocus = false,

            Parent = MainFrame

        })

        create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = box})

        return label, box

    end

    local SpeedLabel, SpeedInput   = createInputRow("Speed", SpeedCustomizer.SpeedValue, 105)

    local StealLabel, StealInput   = createInputRow("Steal Spd", SpeedCustomizer.StealValue, 145)

    local JumpLabel, JumpInput     = createInputRow("Jump", SpeedCustomizer.JumpValue, 185)

    SpeedCustomizer.SpeedLabel = SpeedLabel

    SpeedCustomizer.StealLabel = StealLabel

    SpeedCustomizer.JumpLabel  = JumpLabel

    SpeedCustomizer.SpeedInput = SpeedInput

    SpeedCustomizer.StealInput = StealInput

    SpeedCustomizer.JumpInput  = JumpInput

    -- Toggle ON/OFF

    ToggleBtn.MouseButton1Click:Connect(function()

        SpeedCustomizer.Enabled = not SpeedCustomizer.Enabled

        ToggleBtn.Text = SpeedCustomizer.Enabled and "ON" or "OFF"

        Header.BackgroundColor3 = SpeedCustomizer.Enabled and Color3.fromRGB(80, 180, 80) or Color3.fromRGB(200, 60, 60)

    end)

    -- Validation des inputs

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

    validateInput(SpeedInput, "SpeedValue", 1, 200)

    validateInput(StealInput, "StealValue", 1, 200)

    validateInput(JumpInput, "JumpValue", 1, 200)

    -- ===================== MINIMIZE / RESTORE =====================

    local originalSize = UDim2.new(0, 240, 0, 220)

    local minimizedSize = UDim2.new(0, 240, 0, 105)   -- Titre + Barre + ON/OFF seulement

    MinimizeBar.MouseButton1Click:Connect(function()

        SpeedCustomizer.IsMinimized = not SpeedCustomizer.IsMinimized

        if SpeedCustomizer.IsMinimized then

            -- Mode réduit : seulement Titre + ≡ + ON/OFF

            MainFrame.Size = minimizedSize

            SpeedCustomizer.SpeedLabel.Visible = false

            SpeedCustomizer.StealLabel.Visible = false

            SpeedCustomizer.JumpLabel.Visible = false

            SpeedCustomizer.SpeedInput.Visible = false

            SpeedCustomizer.StealInput.Visible = false

            SpeedCustomizer.JumpInput.Visible = false

            Header.Position = UDim2.new(0, 10, 0, 45)

        else

            -- Mode normal

            MainFrame.Size = originalSize

            SpeedCustomizer.SpeedLabel.Visible = true

            SpeedCustomizer.StealLabel.Visible = true

            SpeedCustomizer.JumpLabel.Visible = true

            SpeedCustomizer.SpeedInput.Visible = true

            SpeedCustomizer.StealInput.Visible = true

            SpeedCustomizer.JumpInput.Visible = true

            Header.Position = UDim2.new(0, 10, 0, 45)

        end

    end)

    return SpeedScreenGui

end

-------------------------------------------------------------------------

-- INITIALIZATION

-------------------------------------------------------------------------

if lp.Character then setupSpeedCharacter(lp.Character) end

SpeedCustomizer.CharacterConn = lp.CharacterAdded:Connect(setupSpeedCharacter)

SpeedCustomizer.SpeedUI = createSpeedUI()

-- Speed logic

RunService.Heartbeat:Connect(function()

    if not SpeedCustomizer.Enabled or not SpeedCustomizer.hrp or not SpeedCustomizer.hum then return end

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

-- Jump logic

UserInputService.JumpRequest:Connect(function()

    if SpeedCustomizer.Enabled and SpeedCustomizer.hum and SpeedCustomizer.hum.FloorMaterial ~= Enum.Material.Air then

        SpeedCustomizer.hrp.AssemblyLinearVelocity = Vector3.new(

            SpeedCustomizer.hrp.AssemblyLinearVelocity.X,

            SpeedCustomizer.JumpValue,

            SpeedCustomizer.hrp.AssemblyLinearVelocity.Z

        )

    end

end)

print("YZK Speed Customizer Loaded - Clique sur ≡ pour réduire/agrandir")
 
