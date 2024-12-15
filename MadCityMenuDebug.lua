--Load Script
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Mad City Debug Menu",
   LoadingTitle = "Powered",
   LoadingSubtitle = "by Rayfield",
   Theme = "Default",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil,
      FileName = "Big Hub"
   },

})

--# Services --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")


--# Logic --

-- Commune Variables
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// ESP \\--
_G.ESP = false

--// AIMBOT \\--
local AimbotHolding = false

_G.Aimbot = false
_G.TeamCheck = false
_G.WallCheck = false
_G.AimPart = "Head"
_G.Sensitivity = 0
_G.MaxDistanceFromPlayer  = 300

--|| Fov Circle Seitting || --
_G.CircleColor = Color3.fromRGB(255, 255, 255) --IMP COLOR
_G.CircleTransparency = 0.7
_G.CircleRadius = 80
_G.CircleFilled = false
_G.CircleVisible = true
_G.CircleThickness = 3

--|| Drawing Fov Circle || --
local FOVCircle = Drawing.new("Circle")
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
FOVCircle.Color = _G.CircleColor
FOVCircle.Transparency = _G.CircleTransparency
FOVCircle.Radius = _G.CircleRadius
FOVCircle.Filled = _G.CircleFilled
FOVCircle.Visible = _G.CircleVisible
FOVCircle.Thickness = _G.CircleThickness


--# Functions --

local function LoadScript(Link)
	loadstring(game:HttpGet(tostring(Link)))()
end

local function ESP()
	while _G.ESP == true do
		local GameDescendants = game:GetDescendants()
		print("StartedLoop")
		for i, GameDescendant in ipairs(GameDescendants) do
   	 		if GameDescendant:IsA("BillboardGui") and GameDescendant.Name == "NameTag" then
				if GameDescendant.Parent.Parent.Name == "Pets" then continue end
    	  		local NameTag = GameDescendant

				local Rank = NameTag.Icon.Rank
				if Rank.Text == "100" then
					Rank.Text = "MAX"
				end

      			NameTag.AlwaysOnTop = 1
    	 		NameTag.MaxDistance = 0
    		end
		end
        task.wait(1.5)
	end
end

local function UnESP()
	local GameDescendants = game:GetDescendants()
	print("StartedLoop")
	for i, GameDescendant in ipairs(GameDescendants) do
   		if GameDescendant:IsA("BillboardGui") and GameDescendant.Name == "NameTag" then
            if GameDescendant.Parent.Parent.Name == "Pets" then continue end
            local NameTag = GameDescendant

			local Rank = NameTag.Icon.Rank
			if Rank.Text == "MAX" then
				Rank.Text = "100"
			end

    		NameTag.AlwaysOnTop = 0
     		NameTag.MaxDistance = 200

    	end
	end
end

local function GetClosestPlayer()
   local MaximumDistance = _G.CircleRadius
   local MaxDistanceFromPlayer = _G.MaxDistanceFromPlayer
   local WallCheck = _G.WallCheck
   local Target = nil

   for _, v in next, Players:GetPlayers() do
       if v.Name ~= LocalPlayer.Name then
           if _G.TeamCheck == true then
               if v.Team ~= LocalPlayer.Team then
                   if v.Character ~= nil then
                       if v.Character:FindFirstChild("HumanoidRootPart") ~= nil then
                           if v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("Humanoid").Health ~= 0 then
                               local ScreenPoint = Camera:WorldToScreenPoint(v.Character:WaitForChild("HumanoidRootPart", math.huge).Position)
                               local VectorDistance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
                               local Distance = (LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                              print("Found")
                               if VectorDistance < MaximumDistance and Distance <= MaxDistanceFromPlayer then
                                 print(Distance)
                                   local Origin = LocalPlayer.Character.Head.Position
                                   local TargetPosition = v.Character.Head.Position
                                   local RaycastResult = workspace:Raycast(Origin, (TargetPosition - Origin).Unit * Distance)
               
                                   if RaycastResult and WallCheck == true then
                                    print(WallCheck)
                                       if RaycastResult.Instance:IsDescendantOf(v.Character) then
                                          print(v)
                                           Target = v 
                                           MaximumDistance = VectorDistance
                                       end
                                   else
                                       print(v)
                                       Target = v
                                       MaximumDistance = VectorDistance
                                   end
                               end
                           end
                       end
                   end
               end
           else
               if v.Character ~= nil then
                   if v.Character:FindFirstChild("HumanoidRootPart") ~= nil then
                       if v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("Humanoid").Health ~= 0 then
                        local ScreenPoint = Camera:WorldToScreenPoint(v.Character:WaitForChild("HumanoidRootPart", math.huge).Position)
                        local VectorDistance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
                        local Distance = (LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude

                        if VectorDistance < MaximumDistance and Distance <= MaxDistanceFromPlayer then
                            local Origin = LocalPlayer.Character.Head.Position
                            local TargetPosition = v.Character.Head.Position
                            local RaycastResult = workspace:Raycast(Origin, (TargetPosition - Origin).Unit * Distance)
        
                            if RaycastResult and WallCheck == true then
                                if RaycastResult.Instance:IsDescendantOf(v.Character) then
                                    Target = v 
                                    MaximumDistance = VectorDistance
                                end
                              else
                                 Target = v
                                 MaximumDistance = VectorDistance
                              end
                           end
                       end
                   end
               end
           end
       end
   end
   return Target
end

UserInputService.InputBegan:Connect(function(Input)
   if Input.UserInputType == Enum.UserInputType.MouseButton2 then
       AimbotHolding = true
       print(AimbotHolding)
   end
end)

UserInputService.InputEnded:Connect(function(Input)
   if Input.UserInputType == Enum.UserInputType.MouseButton2 then
       AimbotHolding = false
       print(AimbotHolding)
   end
end)

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
    --FOVCircle.Sides = _G.CircleSides
    FOVCircle.Color = _G.CircleColor
    FOVCircle.Transparency = _G.CircleTransparency
    FOVCircle.Radius = _G.CircleRadius
    FOVCircle.Filled = _G.CircleFilled
    FOVCircle.Visible = _G.CircleVisible
    FOVCircle.Thickness = _G.CircleThickness

   if AimbotHolding == true and _G.Aimbot == true then
      if GetClosestPlayer() and GetClosestPlayer().Character and GetClosestPlayer().Character:FindFirstChild(_G.AimPart) then
         print(AimbotHolding)
         print(_G.Aimbot)
         local tweenDuration = _G.Sensitivity
         TweenService:Create(Camera, TweenInfo.new(tweenDuration, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(Camera.CFrame.Position, GetClosestPlayer().Character[_G.AimPart].Position)}):Play()
      end
    end
end)

-- Tabs
local Scripts = Window:CreateTab("Scripts")
local Combat = Window:CreateTab("Combat")

-- Scripts Tab
local MadLadV6Button = Scripts:CreateButton({
   Name = "Mad Lad V6",
   Callback = function()
   LoadScript("https://raw.githubusercontent.com/ScuIp/Script/refs/heads/main/Mad-Lad%20V6")
end,
})
local MadLadV7Button = Scripts:CreateButton({
   Name = "Mad Lad V7",
   Callback = function()
   LoadScript("https://raw.githubusercontent.com/ScuIp/Script/refs/heads/main/Mad-Lad%20V7")
end,
})

-- Combat Tab
local ESPSection = Combat:CreateSection("ESP")
local Esp = Combat:CreateButton({
   Name = "ESP",
   Callback = function()
   	_G.ESP = true
   ESP()
end,
})

local UnEsp = Combat:CreateButton({
   Name = "UnESP",
   Callback = function()
   	_G.ESP = false
    UnESP()
end,
})

local AimbotSeittingSection = Combat:CreateSection("Aimbot Seitting")
local ToggleAimbot = Combat:CreateToggle({
    Name = "Toggle Aimbot",
    ToggleAimbot = false,
    Flag = "ToggleAimbot",
	Callback = function(Value)
      _G.Aimbot = Value
    end,
})
local ToggleTeamCheck = Combat:CreateToggle({
   Name = "Team Check",
   TeamCheck = false,
   Flag = "TeamCheck",
  Callback = function(Value)
      _G.TeamCheck = Value
   end,
})
local ToggleWallCheck = Combat:CreateToggle({
   Name = "Wall Check",
   WallCheck = false,
   Flag = "WallCheck",
   Callback = function(Value)
      _G.WallCheck = Value
   end,
})
local SliderMaxDistance = Combat:CreateSlider({
   Name = "Max Distance",
   Range = {50, 1500},
   Increment = 10,
   Suffix = "Max Distance",
   CurrentValue = 750,
   Flag = "MaxDistance",
   Callback = function(Value)
      _G.MaxDistanceFromPlayer = Value
   end,
})
local DropdownAimPart = Combat:CreateDropdown({
   Name = "Aim Part",
   Options = {"Head","Torso","LeftArm","RightArm","LeftLeg","RightLeg"},
   CurrentOption = {"Head"},
   MultipleOptions = false,
   Flag = "AimPart",
   Callback = function(Options)
      _G.AimPart = Options
   end,
})
local Section = Combat:CreateSection("Render Circle Seitting")

