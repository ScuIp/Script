local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()


local Window = Rayfield:CreateWindow({
   Name = "The Bees Kingdoms LavioMenu",
   LoadingTitle = "Powered",
   LoadingSubtitle = "by Rayfield",
   Theme = "Default",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil,
      FileName = "TBK"
   },

})

--# Services --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")


--# Logic --

-- G Veirables
_G.AutoDiging = false

_G.SelectedFieldFarm = workspace.Map.Fields.Sunflower
_G.AutoFarming = false
_G.FarmingTokens = false

_G.PlayerWalkSpeed = 25
_G.SelectedTeleportField = workspace.Map.Fields.Sunflower

-- Commune Variables
local LocalPlayer: Player = Players.LocalPlayer
local HumanoidRootPart: Part = LocalPlayer.Character.HumanoidRootPart
local Humanoid: Humanoid = LocalPlayer.Character.Humanoid
local Camera: Camera = workspace.CurrentCamera
-- Comune Function

-- # GetHive # --
local function GetHive()
	for i, Hive in workspace.Map.Hives:GetDescendants() do
    	if Hive:IsA("StringValue") then
        	if Hive.Value == LocalPlayer.Name then
				return Hive.Parent.Pad.Part
			end
        end
    end
end
-- # GetField # --
local function GetField(NameField)
	return workspace.Map.Fields[NameField]
end
-- # GetBackpackPercentage # --
local function GetBackpackPercentage()
   local PollenBar = LocalPlayer.PlayerGui.UI.Meters.Pollen.Bar

   local currentScale = PollenBar.Size.X.Scale
   local maxScale = 1

   local percentage = currentScale * 100
   return percentage
end

-- # TeleportPlayer # -- In Beta
local function TeleportPlayer(Instance: Instance)
   local TweenInfoForTeleport = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
   local TweenAnimationForTeleport = TweenService:Create(HumanoidRootPart.CFrame, TweenInfoForTeleport, {CFrame = Instance.CFrame})
   return TweenAnimationForTeleport
end

-- Comune Function

-- \\ Farm Tab // --

-- \\ Functions // --

-- # Collect Tokens # --
local function CollectTokens()
   print("Test")
   while _G.FarmingTokens and _G.AutoFarming and GetBackpackPercentage() < 100 do -- Sac et < de 100
      for _, Token in pairs(workspace.Map.Tokens:GetChildren()) do
         if Token:IsA("Part") and Token:GetAttribute("Name") ~= "Ticket" and Token:GetAttribute("Name") ~= "Royal Jelly" and (Token.Position - HumanoidRootPart.Position).magnitude <= 60 then
            HumanoidRootPart.CFrame = CFrame.new(Token.Position.x, HumanoidRootPart.Position.y, Token.Position.z)
            task.wait(0.25)
         end
      end

      for i, Present in workspace.Visual:GetChildren() do
            if Present:IsA("Model") and Present.Name == "Gift Box" and (Present.Root.Position - HumanoidRootPart.Position).magnitude <= 60 then
            HumanoidRootPart.CFrame = CFrame.new(Present.Root.Position.x, HumanoidRootPart.Position.y, Present.Root.Position.z)
            task.wait(0.25)
         end
      end

      for i, Ice in workspace.Visual:GetChildren() do
         if Ice:IsA("Part") and Ice.Name == "Warning Circle" and (Ice.Position - HumanoidRootPart.Position).magnitude <= 60 and Ice.Transparency <= 0.2 then
            HumanoidRootPart.CFrame = CFrame.new(Ice.Position.x, HumanoidRootPart.Position.y, Ice.Position.z)
            task.wait(1.2)
         end
      end
      task.wait(0.25)
   end
end

-- # AutoFarm # --
local function AutoFarm()
   task.spawn(function()
      _G.AutoFarming = true
      local InField = false 

      while _G.AutoFarming do
         task.wait(2.3)
         print(GetBackpackPercentage())
         -- Si la barre de pollen est pleine, aller à la ruche
         if GetBackpackPercentage() == 100 then
            print("Plein")
            Rayfield:Notify({
               Title = "Information",
               Content = "Teleported player to the hive!",
               Duration = 2.5,
               Image = "rewind",
            })
            _G.FarmingTokens = false 
            local PartHive = GetHive()

               -- Téléportation à la ruche
            HumanoidRootPart.CFrame = CFrame.new(PartHive.Position + Vector3.new(0, 6, 0), HumanoidRootPart.Position)
            InField = false
            Rayfield:Notify({
               Title = "Information",
               Content = "Please do not move!",
               Duration = 2.5,
               Image = "rewind",
            })
            task.wait(3)

            game:GetService("ReplicatedStorage").Shared.Network.Converting:FireServer()

            -- Attente de la conversion du pollen
            while GetBackpackPercentage() > 0 do
               Rayfield:Notify({
                  Title = "Information",
                  Content = "Converting!",
                  Duration = 2.5,
                  Image = "rewind",
               })
               task.wait(1.5)
            end
         end
            Rayfield:Notify({
               Title = "Information",
               Content = "You can move!",
               Duration = 2.5,
               Image = "rewind",
            })
           -- Si le joueur n'est pas déjà dans le champ, il s'y téléporte
         if not InField then
            HumanoidRootPart.CFrame = _G.SelectedFieldFarm.CFrame
            InField = true 
         end

         -- Lancer la collecte des tokens
         Rayfield:Notify({
            Title = "Information",
            Content = "Teleport to field!",
            Duration = 2.5,
            Image = "rewind",
         })
         _G.FarmingTokens = true
         CollectTokens()
         task.wait(3)
       end
   end)
end


-- \\ Functions // --

local FarmTab = Window:CreateTab("Farm Tab", "rewind")

local AutoDigLabel = FarmTab:CreateLabel("Auto Dig Section:")
local AutoDigToggle = FarmTab:CreateToggle({
   Name = "Auto Dig",
   CurrentValue = false,
   Flag = "AutoDig",
   Callback = function(Value)
       Rayfield:Notify({
         Title = "Information",
         Content = "Auto Dig set to ".. tostring(Value) .. "!",
         Duration = 2.5,
         Image = "rewind",
      })
      _G.AutoDiging = Value
       if _G.AutoDiging then
           task.spawn(function()
               while _G.AutoDiging do
                   task.wait(0.15)
                   game:GetService("ReplicatedStorage").Shared.Network.UseCollector:FireServer()
               end
           end)
       end
   end,
})

local Divider = FarmTab:CreateDivider()
local FarmaLabel = FarmTab:CreateLabel("Auto Farm Section:")


local AutoFarmToggle = FarmTab:CreateToggle({
   Name = "Auto Farm",
   CurrentValue = false,
   Flag = "AutoFarm",
   Callback = function(Value)
      Rayfield:Notify({
        Title = "Information",
        Content = "Auto Farm set to ".. tostring(Value) .. "!",
        Duration = 2.5,
        Image = "rewind",
     })
      _G.AutoFarming = Value

      if _G.AutoFarming then
         AutoFarm()
      end
   end,
})


local SelectedFieldFarmDropDown = FarmTab:CreateDropdown({
   Name = "Select Field",
   Options = {"Sunflower", "Daisy", "Mushroom", "Blue Flowers", "Dandelion", "Strawberry", "Lilly", "Beetroot", "Violet", "Cactus", "Clover", "Cherry", "Crystals", "Blackberry", "Water Lilly", "Angry Flower"},
   CurrentOption = {"Sunflower"},
   MultipleOptions = false,
   Flag = "SelectedFieldFarmDropDown",
   Callback = function(Options)
      local SelectedField = table.concat(Options, ", ")
      local FieldLocation = GetField(SelectedField)

      Rayfield:Notify({
        Title = "Information",
        Content = "player selected: ".. tostring(SelectedField) .. "!",
        Duration = 2.5,
        Image = "rewind",
     })

      if FieldLocation then
         _G.SelectedFieldFarm = FieldLocation
      else
         _G.SelectedFieldFarm = workspace.Map.Fields.Sunflower
         warn("Invalid field name: " .. SelectedField)
      end
   end,
})

-- \\ Farm Tab // --


-- \\ Teleports Tab // --

-- \\ Functions // --

-- \\ Functions // --

local TeleportsTab = Window:CreateTab("Teleports Tab", "rewind")
-- To Hive
local HiveTeleportLabel = TeleportsTab:CreateLabel("Teleport To Hive Section:")
local TeleportToHive = TeleportsTab:CreateButton({
   Name = "Teleport To Hive",
   Callback = function()
      Rayfield:Notify({
         Title = "Information",
         Content = "Teleported player to the hive!",
         Duration = 2.5,
         Image = "rewind",
      })
	   local PartHive: Part = GetHive()
      HumanoidRootPart.CFrame = CFrame.new(PartHive.Position + Vector3.new(0, 6, 0), HumanoidRootPart.Position)
   end,
})

-- \\ Devider // --
local Divider = TeleportsTab:CreateDivider()
local FieldTeleportLabel = TeleportsTab:CreateLabel("Field Teleport Section:")
--To Fields
local FieldTeleportDropDown = TeleportsTab:CreateDropdown({
   Name = "Select Field",
   Options = {"Sunflower", "Daisy", "Mushroom", "Blue Flowers", "Dandelion", "Strawberry", "Lilly", "Beetroot", "Violet", "Cactus", "Clover", "Cherry", "Crystals", "Blackberry", "Water Lilly", "Angry Flower"},
   CurrentOption = {"Sunflower"},
   MultipleOptions = false,
   Flag = "FieldTeleportDropDown",
   Callback = function(Options)
      local SelectedField = table.concat(Options, ", ")
      local FieldLocation = GetField(SelectedField)
      Rayfield:Notify({
         Title = "Information",
         Content = "Selected Field: ".. tostring(SelectedField) .."!",
         Duration = 2.5,
         Image = "rewind",
      })
      if FieldLocation then
         _G.SelectedTeleportField = FieldLocation
      else
         _G.SelectedTeleportField = workspace.Map.Fields.Sunflower
         warn("Invalid field name: " .. SelectedField)
      end
   end,
})
local TeleportButton = TeleportsTab:CreateButton({
   Name = "Teleport",
   Callback = function()
      Rayfield:Notify({
         Title = "Information",
         Content = "Teleported player to: ".. tostring(_G.SelectedTeleportField) .." Field!",
         Duration = 2.5,
         Image = "rewind",
      })
   HumanoidRootPart.CFrame = _G.SelectedTeleportField.CFrame
   end,
})
-- \\ Teleports Tab // --

-- \\ Player Tab // --

-- \\ Functions // --
Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
   if HumanoidRootPart.Parent.Humanoid.WalkSpeed ~= _G.PlayerWalkSpeed then
      HumanoidRootPart.Parent.Humanoid.WalkSpeed = _G.PlayerWalkSpeed
   end
end)
-- \\ Functions // --

local PlayerTab = Window:CreateTab("Player Tab", "rewind")

local WalkspeedSlider = PlayerTab:CreateSlider({
   Name = "Walkspeed Slider",
   Range = {0, 100},
   Increment = 1,
   Suffix = "Walkspeed",
   CurrentValue = 25,
   Flag = "WalkspeedSlider",
   Callback = function(Value)
      Rayfield:Notify({
         Title = "Information",
         Content = "player set walkspeed to: ".. tostring(Value) .."!",
         Duration = 2.5,
         Image = "rewind",
      })
      _G.PlayerWalkSpeed = Value
      HumanoidRootPart.Parent.Humanoid.WalkSpeed = Value
   end,
})


-- \\ Player Tab // --
