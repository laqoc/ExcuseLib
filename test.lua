-- Hub menu: Criminality Script (dark UI, animations, image id 30139193)
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- --- ====== reuse from your main script: anti-spy helpers ====== ---
local function isSolara()
	local executor = (identifyexecutor and identifyexecutor()) or (getexecutorname and getexecutorname()) or "Unknown"
	return executor == "Solara"
end

local function generateFakeUrl()
	local domains = {"raw.githubusercontent.com", "pastebin.com/raw", "gist.githubusercontent.com", "example.com"}
	local users = {"user", "scriptkid", "robloxhacker", "fakeuser", "randomguy", "exploitlord"}
	local repos = {"repo", "scripts", "main", "hacks", "exploits", "fake"}
	local files = {"script.lua", "main.lua", "hack.lua", "exploit.lua", "fake.txt"}
	local domain = domains[math.random(1,#domains)]
	local user = users[math.random(1,#users)]..math.random(100,999)
	local repo = repos[math.random(1,#repos)]..math.random(10,99)
	local file = files[math.random(1,#files)]
	return "https://"..domain.."/"..user.."/"..repo.."/main/"..file
end

local function antiSpy()
	if isSolara() then return end
	for _=1,20 do
		pcall(function()
			task.spawn(function()
				if stf and stf.palka_nigga then
					-- try to use your wrapper if exists
					pcall(stf.palka_nigga, "game_httpget", generateFakeUrl())
				else
					-- fallback: try game:HttpGet (pcall because it may error/restricted)
					pcall(function() game:HttpGet(generateFakeUrl()) end)
				end
			end)
		end)
		task.wait(math.random(10,60)/1000)
	end
end
-- --- ============================================================ ---


-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false
screenGui.Name = "CriminalityHub"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main container
local container = Instance.new("Frame", screenGui)
container.Size = UDim2.new(0, 420, 0, 260)
container.Position = UDim2.new(0.5, -210, 0.5, -130)
container.AnchorPoint = Vector2.new(0.5, 0.5)
container.BackgroundColor3 = Color3.fromRGB(15,15,15)
container.BorderSizePixel = 0
container.ClipsDescendants = true
Instance.new("UICorner", container).CornerRadius = UDim.new(0,12)

-- Title bar (draggable area)
local titleBar = Instance.new("Frame", container)
titleBar.Size = UDim2.new(1,0,0,44)
titleBar.Position = UDim2.new(0,0,0,0)
titleBar.BackgroundTransparency = 1

local titleLabel = Instance.new("TextLabel", titleBar)
titleLabel.Size = UDim2.new(1,-60,1,0)
titleLabel.Position = UDim2.new(0,12,0,0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Criminality Script"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.TextColor3 = Color3.fromRGB(245,245,245)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Close button
local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0,36,0,28)
closeBtn.Position = UDim2.new(1,-46,0,8)
closeBtn.BackgroundColor3 = Color3.fromRGB(25,25,25)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.TextColor3 = Color3.fromRGB(230,230,230)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,6)

-- Image area
local imageFrame = Instance.new("Frame", container)
imageFrame.Size = UDim2.new(1,-24,0,160)
imageFrame.Position = UDim2.new(0,12,0,52)
imageFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
imageFrame.BorderSizePixel = 0
Instance.new("UICorner", imageFrame).CornerRadius = UDim.new(0,8)

local thumbnail = Instance.new("ImageLabel", imageFrame)
thumbnail.Size = UDim2.new(1,0,1,0)
thumbnail.Position = UDim2.new(0,0,0,0)
thumbnail.BackgroundTransparency = 1
thumbnail.Image = "rbxassetid://7415993722" -- твой ID
thumbnail.ScaleType = Enum.ScaleType.Crop
thumbnail.ClipsDescendants = true

-- overlay title on image (semi-transparent band)
local overlay = Instance.new("Frame", imageFrame)
overlay.Size = UDim2.new(1,0,0,36)
overlay.Position = UDim2.new(0,0,0,0)
overlay.BackgroundColor3 = Color3.fromRGB(10,10,10)
overlay.BackgroundTransparency = 0.15
Instance.new("UICorner", overlay).CornerRadius = UDim.new(0,8)

local overlayLabel = Instance.new("TextLabel", overlay)
overlayLabel.Size = UDim2.new(1,-16,1,0)
overlayLabel.Position = UDim2.new(0,8,0,0)
overlayLabel.BackgroundTransparency = 1
overlayLabel.Text = "Criminality Script"
overlayLabel.Font = Enum.Font.GothamBold
overlayLabel.TextSize = 16
overlayLabel.TextColor3 = Color3.fromRGB(245,245,245)
overlayLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Load button area
local loadBtn = Instance.new("TextButton", container)
loadBtn.Size = UDim2.new(0,160,0,36)
loadBtn.Position = UDim2.new(0.5,-80,1,-48)
loadBtn.BackgroundColor3 = Color3.fromRGB(25,25,25)
loadBtn.Text = "Load"
loadBtn.Font = Enum.Font.GothamSemibold
loadBtn.TextSize = 16
loadBtn.TextColor3 = Color3.fromRGB(230,230,230)
Instance.new("UICorner", loadBtn).CornerRadius = UDim.new(0,8)

-- small hint text under button
local hint = Instance.new("TextLabel", container)
hint.Size = UDim2.new(1,-24,0,18)
hint.Position = UDim2.new(0,12,1,-24)
hint.BackgroundTransparency = 1
hint.Text = "Single game | press Load to execute"
hint.Font = Enum.Font.Gotham
hint.TextSize = 12
hint.TextColor3 = Color3.fromRGB(160,160,160)
hint.TextXAlignment = Enum.TextXAlignment.Center

-- Initial state: invisible -> animate in
container.BackgroundTransparency = 1
for _, child in ipairs(container:GetDescendants()) do
	if child:IsA("TextLabel") or child:IsA("TextButton") then
		child.TextTransparency = 1
		if child:IsA("Frame") then
			-- ignore frame bg
		else
			-- smooth
		end
	end
	if child:IsA("ImageLabel") then
		child.ImageTransparency = 1
	end
end

-- Entrance tweens
TweenService:Create(container, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
TweenService:Create(thumbnail, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
TweenService:Create(titleLabel, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
TweenService:Create(loadBtn, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
TweenService:Create(overlayLabel, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
TweenService:Create(hint, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()

-- Draggable by title
local dragging, dragInput, dragStart, startPos
local function update(input)
	local delta = input.Position - dragStart
	container.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = container.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)
titleBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- Close behavior with animation
closeBtn.MouseButton1Click:Connect(function()
	for _, child in ipairs(container:GetChildren()) do
		if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("ImageLabel") then
			pcall(function()
				TweenService:Create(child, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
					TextTransparency = 1,
					ImageTransparency = 1
				}):Play()
			end)
		end
	end
	TweenService:Create(container, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		BackgroundTransparency = 1,
		Position = container.Position + UDim2.new(0,0,0,-80)
	}):Play()
	task.delay(0.45, function() pcall(function() screenGui:Destroy() end) end)
end)

-- Button hover / click micro-animations
loadBtn.MouseEnter:Connect(function()
	TweenService:Create(loadBtn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(35,35,35)}):Play()
end)
loadBtn.MouseLeave:Connect(function()
	TweenService:Create(loadBtn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(25,25,25)}):Play()
end)
loadBtn.MouseButton1Down:Connect(function()
	TweenService:Create(loadBtn, TweenInfo.new(0.08), {Size = UDim2.new(0,150,0,34), Position = UDim2.new(0.5,-75,1,-50)}):Play()
end)
loadBtn.MouseButton1Up:Connect(function()
	TweenService:Create(loadBtn, TweenInfo.new(0.08), {Size = UDim2.new(0,160,0,36), Position = UDim2.new(0.5,-80,1,-48)}):Play()
end)

-- When pressing Load: run antiSpy and print a message (simulates loading)
loadBtn.MouseButton1Click:Connect(function()
	-- small feedback
	loadBtn.Text = "Loading..."
	loadBtn.Active = false

	-- start anti-spy in background
	task.spawn(function()
		pcall(antiSpy)
	end)

	-- simulate load action (here: simple print)
	task.delay(0.15, function()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
		-- if you want to simulate loadstring usage uncomment next block:
		-- if stf and stf.palka_nigga then pcall(stf.palka_nigga, "loadstring", 'print("loadstring activated")') end
	end)

	-- close UI with animation
	for _, child in ipairs(container:GetChildren()) do
		if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("ImageLabel") then
			pcall(function()
				TweenService:Create(child, TweenInfo.new(0.35), {TextTransparency = 1, ImageTransparency = 1}):Play()
			end)
		end
	end
	TweenService:Create(container, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		BackgroundTransparency = 1,
		Position = container.Position + UDim2.new(0,0,0,-120)
	}):Play()

	task.delay(0.5, function()
		pcall(function() screenGui:Destroy() end)
	end)
end)

-- End of hub
