-- by qhav on discord
while true do
    repeat wait() until game:IsLoaded()
    repeat wait() until game.Players.LocalPlayer.Character
    repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
    repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    wait(2)
    local serverhop = getgenv().serverHopType

    local serverHops = {
        ["MostEmptyServer"] = function()
            local PlaceID = game.PlaceId
            local AllIDs = {}
            local foundAnything = ""
            local actualHour = os.date("!*t").hour
            local Deleted = false

            local File = pcall(function()
                AllIDs = game:GetService('HttpService'):JSONDecode(readfile("NotSameServers.json"))
            end)
            if not File then
                table.insert(AllIDs, actualHour)
                writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
            end
            function TPReturner()
                local Site;
                if foundAnything == "" then
                    Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' ..
                        PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
                else
                    Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' ..
                        PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
                end
                local ID = ""
                if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
                    foundAnything = Site.nextPageCursor
                end
                local num = 0;
                local extranum = 0
                for i, v in pairs(Site.data) do
                    extranum += 1
                    local Possible = true
                    ID = tostring(v.id)
                    if tonumber(v.maxPlayers) > tonumber(v.playing) then
                        if extranum ~= 1 and tonumber(v.playing) < last or extranum == 1 then
                            last = tonumber(v.playing)
                        elseif extranum ~= 1 then
                            continue
                        end
                        for _, Existing in pairs(AllIDs) do
                            if num ~= 0 then
                                if ID == tostring(Existing) then
                                    Possible = false
                                end
                            else
                                if tonumber(actualHour) ~= tonumber(Existing) then
                                    local delFile = pcall(function()
                                        delfile("NotSameServers.json")
                                        AllIDs = {}
                                        table.insert(AllIDs, actualHour)
                                    end)
                                end
                            end
                            num = num + 1
                        end
                        if Possible == true then
                            table.insert(AllIDs, ID)
                            wait()
                            pcall(function()
                                writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
                                wait()
                                print("Teleporting...") -- to be sure
                                game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID,
                                    game.Players.LocalPlayer)
                            end)
                            wait(4)
                        end
                    end
                end
            end

            function Teleport()
                while wait() do
                    pcall(function()
                        TPReturner()
                        if foundAnything ~= "" then
                            TPReturner()
                        end
                    end)
                end
            end

            Teleport()
        end,
        ["RandomServer"] = function()
            local a, b = pcall(function()
                local servers = {}
                local req = request({
                    Url = "https://games.roblox.com/v1/games/" ..
                        game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true"
                })
                local body = game:GetService("HttpService"):JSONDecode(req.Body)

                if body and body.data then
                    for i, v in next, body.data do
                        if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= game.JobId then
                            table.insert(servers, 1, v.id)
                        end
                    end
                end

                print(#servers)
                if #servers > 0 then
                    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,
                        servers[math.random(1, #servers)],
                        game.Players.LocalPlayer)
                else
                    if #game.Players:GetChildren() <= 1 then
                        Players.LocalPlayer:Kick("\nRejoining...")
                        wait()
                        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
                    else
                        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId,
                            game.Players.LocalPlayer)
                    end
                end
            end)

            print(a, b)

            if not a then
                shop()
            end

            task.spawn(function()
                while wait(5) do
                    shop()
                end
            end)
        end
    }

    wait(1)

    game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").Died:Connect(function()
        serverHops[serverhop]()
    end)

    task.spawn(function()
        for real = 1, 25 do
            task.wait(0.2)
            print("by qhav on discord for free using")
        end
    end)

    if game.Players.LocalPlayer.PlayerGui.MainGUI:FindFirstChild("TeleportEffect") then
        game.Players.LocalPlayer.PlayerGui.MainGUI.TeleportEffect:Destroy()
    end

    local Lasers = {
        workspace.Ignore.WorldObjects["Lasers Club"],
        workspace.Ignore.WorldObjects:GetChildren()[18],
        workspace.Ignore.WorldObjects:GetChildren()[17],
        workspace.Ignore.WorldObjects:GetChildren()[19],
        workspace.Casino.CasinoDoor.SpinLaser1,
        workspace.Casino.CasinoDoor.SpinLaser2,
        workspace.Casino.CasinoDoor.SpinLaser3,
    }
    
    for i, v in ipairs(Lasers) do
        v:Destroy()
    end

    local function TweenTP(x, y, z)
        local player = game.Players.LocalPlayer
        local HumanoidRootPart = player.Character:WaitForChild("HumanoidRootPart")
        
        local TweenService = game:GetService("TweenService")
        
        local TPInfo = TweenInfo.new(3.25, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
        
        -- Use CFrame instead of Position for tweening
        local targetCFrame = CFrame.new(x, y, z)
        
        -- Create the tween for the HumanoidRootPart
        local TweenTPAnim = TweenService:Create(HumanoidRootPart, TPInfo, {CFrame = targetCFrame})
        
        -- Play the tween
        TweenTPAnim:Play()
        
        
    end

    local MiniRobberies = {
        "Cash",
        "CashRegister",
        "DiamondBox",
        "Laptop",
        "Phone",
        "Luggage",
        "ATM",
        "TV",
        "Safe"
    }
    local function getevent(v)
        for i, v in next, v:GetDescendants() do
            if not v:IsA("RemoteEvent") then continue end
            return v
        end
    end

    local function getrobbery()
        for i, v in next, workspace.ObjectSelection:GetChildren() do
            if not table.find(MiniRobberies, v.Name) then continue end
            if v:FindFirstChild("Nope") then continue end
            if not getevent(v) then continue end
            return v
        end
    end

    local function robMiniRobberies()
        pcall(function()
            repeat
                local robbery = getrobbery()
                if robbery then
                    for i = 1, 5 do
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(
                            robbery:GetPivot().Position.x,
                            robbery:GetPivot().Position.y + 5, robbery:GetPivot().Position.z)
                        getevent(robbery):FireServer()
                        task.wait()
                    end
                end
            until getrobbery() == nil
        end)
    end



    local robHeists = getgenv().HeistsRobbing
    if robHeists == true then
        local colissionDb = false
        
        local function JewelryStore()
            TweenTP(-82, 86, 807)
            task.wait(5)
            for i, v in pairs(workspace.JewelryStore.JewelryBoxes:GetChildren()) do
                task.spawn(function()
                    for i = 1, 5 do
                        workspace.JewelryStore.JewelryBoxes.JewelryManager.Event:FireServer(v)
                    end
                end)
            end
            task.wait(2)
            TweenTP(2115, 26, 420)
            task.wait(5)
        end

        local function casino()
            if game:GetService("ReplicatedStorage").HeistStatus.Casino.Locked.Value == false then

                TweenTP(1644, 41, 448)
                task.wait(5)
                workspace.ObjectSelection.Lever1.Lever.Lever.Event:FireServer()
                task.wait(0.5)
        
                TweenTP(1758, 41, 498)
                task.wait(5)
                workspace.ObjectSelection.Lever2.Lever.Lever.Event:FireServer()
                task.wait(0.5)
        
                TweenTP(1620, 41, 480)
                task.wait(5)
                workspace.ObjectSelection.Lever3.Lever.Lever.Event:FireServer()
                task.wait(0.5)
        
                TweenTP(1744, 41, 447)
                task.wait(5)
                workspace.ObjectSelection.Lever4.Lever.Lever.Event:FireServer()
                task.wait(0.5)


                TweenTP(1700, 41, 515)
                task.wait(27)
                TweenTP(2115, 26, 420)
                task.wait(5)
            else
                return
            end
        end
        local function club()
            if game:GetService("ReplicatedStorage").HeistStatus.Club.Locked.Value == false then
                TweenTP(1365, 45, -152)
				task.wait(5)
                TweenTP(1327, 145.5, -128.5)
                task.wait(27)
                TweenTP(2115, 26, 420)
                task.wait(5)
            else
                return
            end
        end
        local function bank()
            if game:GetService("ReplicatedStorage").HeistStatus.Bank.Locked.Value == false then
                TweenTP(673, 82, 561)
                task.wait(5)
                TweenTP(681, 82, 581)
                task.wait(25)
                TweenTP(2115, 26, 420)
                task.wait(5)
            end
        end
        local rJewerlyStore = getgenv().robJewerlyStore
        print(rJewerlyStore)
        local rCasino = getgenv().robCasino
        print(rCasino)
        local rClub = getgenv().robClub
        print(rClub)
        local rBank = getgenv().robBank
        print(rBank)
        if rCasino == true then
            JewelryStore()
        end
        if rCasino == true then
            casino()
        end
        if rClub == true then
            club()
        end
        if rBank == true then
            bank()
        end
    end
    robMiniRobberies()
    serverHops[serverhop]()
end
