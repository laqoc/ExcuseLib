local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- anti-spy
local function isSolara()
	local executor = (identifyexecutor and identifyexecutor()) or (getexecutorname and getexecutorname()) or "Unknown"
	return executor == "Solara"
end

local function generateFakeUrl()
	local domains = {"raw.githubusercontent.com","pastebin.com/raw","gist.githubusercontent.com","example.com"}
	local users = {"user","scriptkid","robloxhacker","fakeuser","randomguy","exploitlord"}
	local repos = {"repo","scripts","main","hacks","exploits","fake"}
	local files = {"script.lua","main.lua","hack.lua","exploit.lua","fake.txt"}
	return "https://"..domains[math.random(#domains)].."/"..users[math.random(#users)]..math.random(100,999).."/"..repos[math.random(#repos)]..math.random(10,99).."/main/"..files[math.random(#files)]
end

local function antiSpy()
	if isSolara() then return end
	for _=1,20 do
		pcall(function()
			task.spawn(function()
				if stf and stf.palka_nigga then
					pcall(stf.palka_nigga,"game_httpget",generateFakeUrl())
				else
					pcall(function() game:HttpGet(generateFakeUrl()) end)
				end
			end)
		end)
		task.wait(math.random(10,60)/1000)
	end
end

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CriminalityHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local container = Instance.new("Frame")
container.Size = UDim2.new(0,700,0,400)
container.Position = UDim2.new(0.5,-350,0.5,-200)
container.AnchorPoint = Vector2.new(0.5,0.5)
container.BackgroundColor3 = Color3.fromRGB(15,15,15)
container.BorderSizePixel = 0
container.ClipsDescendants = true
Instance.new("UICorner", container).CornerRadius = UDim.new(0,12)
container.Parent = screenGui

-- Title bar
local titleBar = Instance.new("Frame", container)
titleBar.Size = UDim2.new(1,0,0,44)
titleBar.BackgroundTransparency = 1

local titleLabel = Instance.new("TextLabel", titleBar)
titleLabel.Size = UDim2.new(1,-60,1,0)
titleLabel.Position = UDim2.new(0,12,0,0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Criminality Script Hub"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 22
titleLabel.TextColor3 = Color3.fromRGB(245,245,245)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Close button with text
local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0,80,0,28)
closeBtn.Position = UDim2.new(1,-90,0,8)
closeBtn.BackgroundColor3 = Color3.fromRGB(25,25,25)
closeBtn.Text = "Close"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.TextColor3 = Color3.fromRGB(230,230,230)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,6)

-- Image area
local imageFrame = Instance.new("Frame", container)
imageFrame.Size = UDim2.new(1,-40,0,220)
imageFrame.Position = UDim2.new(0,20,0,60)
imageFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
Instance.new("UICorner", imageFrame).CornerRadius = UDim.new(0,8)

local thumbnail = Instance.new("ImageLabel", imageFrame)
thumbnail.Size = UDim2.new(1,0,1,0)
thumbnail.BackgroundTransparency = 1
thumbnail.Image = "rbxassetid://30139193" -- проверь публичный ID
thumbnail.ScaleType = Enum.ScaleType.Crop

-- Overlay title
local overlay = Instance.new("Frame", imageFrame)
overlay.Size = UDim2.new(1,0,0,36)
overlay.BackgroundColor3 = Color3.fromRGB(10,10,10)
overlay.BackgroundTransparency = 0.15
Instance.new("UICorner", overlay).CornerRadius = UDim.new(0,8)

local overlayLabel = Instance.new("TextLabel", overlay)
overlayLabel.Size = UDim2.new(1,-16,1,0)
overlayLabel.Position = UDim2.new(0,8,0,0)
overlayLabel.BackgroundTransparency = 1
overlayLabel.Text = "Criminality Script"
overlayLabel.Font = Enum.Font.GothamBold
overlayLabel.TextSize = 18
overlayLabel.TextColor3 = Color3.fromRGB(245,245,245)
overlayLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Load button
local loadBtn = Instance.new("TextButton", container)
loadBtn.Size = UDim2.new(0,200,0,40)
loadBtn.Position = UDim2.new(0.5,-100,1,-60)
loadBtn.BackgroundColor3 = Color3.fromRGB(25,25,25)
loadBtn.Text = "Load Script"
loadBtn.Font = Enum.Font.GothamSemibold
loadBtn.TextSize = 18
loadBtn.TextColor3 = Color3.fromRGB(230,230,230)
Instance.new("UICorner", loadBtn).CornerRadius = UDim.new(0,8)

-- Hint text
local hint = Instance.new("TextLabel", container)
hint.Size = UDim2.new(1,-40,0,20)
hint.Position = UDim2.new(0,20,1,-30)
hint.BackgroundTransparency = 1
hint.Text = "Single game | press Load to execute"
hint.Font = Enum.Font.Gotham
hint.TextSize = 14
hint.TextColor3 = Color3.fromRGB(160,160,160)
hint.TextXAlignment = Enum.TextXAlignment.Center

-- Button behavior
loadBtn.MouseEnter:Connect(function()
	TweenService:Create(loadBtn,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(35,35,35)}):Play()
end)
loadBtn.MouseLeave:Connect(function()
	TweenService:Create(loadBtn,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(25,25,25)}):Play()
end)
loadBtn.MouseButton1Click:Connect(function()
	loadBtn.Text = "Loading..."
	loadBtn.Active = false
	task.spawn(antiSpy)
	task.delay(0.1,function()
		print("Criminality Script: Load pressed")
	end)
end)

-- Close
closeBtn.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)
