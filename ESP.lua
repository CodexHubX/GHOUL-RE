
    -- Made By Code X Dev ...

    local Service = {};
    
    local metatable = setmetatable(Service,{ 
    __index = function(self,key) 
        local service;
    
        local su,er = pcall(function()
            service = cloneref(game:GetService(tostring(key)))
        end);
        
        if not service then 
            warn('not Pass..');
            return game:GetService(tostring(key))
        end;
    
        return service;
    end;});

    local Cooldown = {}
    local mt_cooldown = setmetatable(Cooldown,{__index = function(self,key) self[tostring(key)] = 0; return 0;end;})

    local PlaceId = game.PlaceId;
    local RunService = Service['RunService'];
    local Players = Service['Players'];
    local LocalPlayer = Players.LocalPlayer;
    local CurrentCamera = workspace.CurrentCamera
    local ReplicatedStorage = Service['ReplicatedStorage']

    local Modules = ReplicatedStorage:WaitForChild('Modules')
    local RankingData = ReplicatedStorage.Modules:WaitForChild('RankingData') and require(ReplicatedStorage.Modules.RankingData)

    local Library = {
        ['Settigs'] = {
            enabled = true,
            box = true, 
            boxColor = Color3.fromRGB(255, 255, 255),
            healthbar = true,
            nametag = true,
            nametagColor = Color3.fromRGB(255, 255, 255),
            distance = true,
            distanceColor = Color3.fromRGB(50, 198, 232),
            weapon = true,
            race = true,
            raceColor = Color3.fromRGB(255, 255, 255),
            rank = true,
            rankColor = Color3.fromRGB(255, 255, 255),
            rc = true,
            rcColor = Color3.fromRGB(255, 255, 255),
            weaponColor = Color3.fromRGB(255, 255, 255),
            tracer = false,
            tracerColor = Color3.fromRGB(255, 0, 0),
            healthtext = true,
            posture = true,
            postureColor = Color3.fromRGB(211, 204, 49),
            hunger = true,
            hungerColor = Color3.fromRGB(229, 20, 48),
            showMaxHealth = false,
            healthTextColor = Color3.fromRGB(50, 232, 50),
            chams = true,
            chamsColor = Color3.fromRGB(255, 0, 0),
            chamsOutlineColor = Color3.fromRGB(255, 0, 0),
            uselimitDistance = true,
            limitDistance = 50000,
        },
    }
    
    -- if getgenv().LoadCustomDrawing then 
    --     loadstring(game:HttpGet("https://raw.githubusercontent.com/CodexHubX/CodexHubX/refs/heads/main/Module/Drawing.lua"))();
    -- end;
    --local DrawingLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/CodexHubX/RIVALS-XenonHub/refs/heads/main/Drawing.lua"))();
    
    local Settigs = Library.Settigs;
    
    local functions = setmetatable(Library,{
        __call = function(self,...)
            return getmetatable(self)
        end,
    
        newquad = function(color ,thickness)
            local quad = Drawing.new("Quad")
            quad.Color = color
            quad.Filled = false
            quad.Visible = false
            quad.Thickness = thickness
            quad.Transparency = 1
            return quad
        end,
    
        newline = function(color ,thickness) 
            local line = Drawing.new("Line")
            line.Visible = false
            line.Color = color 
            line.Thickness = thickness
            line.Transparency = 1
            return line
        end,
    
        newtext = function(text, color , size) 
            local Text = Drawing.new("Text")
            Text.Visible = false
            Text.Center = true
            Text.Outline = true
            Text.Font = 4
            Text.Color = color
            Text.Size = size
            Text.Text = tostring(text)
            return Text
        end,
    
        setquadpoint = function(Quad,onscreenPosition,height)
            Quad.PointA = Vector2.new(onscreenPosition.X + height, onscreenPosition.Y - height*2);
            Quad.PointB = Vector2.new(onscreenPosition.X - height, onscreenPosition.Y - height*2);
            Quad.PointC = Vector2.new(onscreenPosition.X - height, onscreenPosition.Y + height*2);
            Quad.PointD = Vector2.new(onscreenPosition.X + height, onscreenPosition.Y + height*2);
        end,
    })  
    
    function abbreviate_number(num)
        local var = 0

        local su,er = pcall(function()
            local suffixes = { "", "K", "M", "B", "T" } 
            local index = 1
        
            while num >= 1000 and index < #suffixes do
                num = num / 1000
                index = index + 1
            end
        
            var = string.format("%.1f%s", num, suffixes[index])
        end);

        return var
    end

    function CooldownFunc(key,time)

        if tick() - Cooldown[key] > time then 
            Cooldown[key] = tick() + time
            return true;
        end;
    
        return false;
    end;

    function Library.AddPlayer(player)
         local asset = functions();
         local object = {
            ['class'] = 'Player',
            ['drawing'] = {},
            ['player'] = player,
            ['name'] = player.Name,
            ['userid'] = player.UserId,
            ['highlight'] = nil,
            ['displayname'] = nil,
            ['connections'] = {},
            ['rcCells'] = 0,
         };
    
         object.drawing.box = asset.newquad(Color3.fromRGB(255, 0, 0),1);
         object.drawing.black = asset.newquad(Color3.fromRGB(255, 0, 0),1);
    
         object.drawing._healthbar = asset.newline(Color3.fromRGB(255, 255, 255),1);
         object.drawing._greenhealth = asset.newline(Color3.fromRGB(255, 255, 255),1);


         object.drawing._posture = asset.newline(Color3.fromRGB(255, 255, 255),1);
         object.drawing._green_posture = asset.newline(Color3.fromRGB(255, 255, 255),1);

     
         object.drawing.helath_label = asset.newtext('',Color3.fromRGB(255, 255, 255),12);
         object.drawing.name_label  = asset.newtext('',Color3.fromRGB(255, 255, 255),12);

         object.drawing.posture_label = asset.newtext('',Color3.fromRGB(255, 255, 255),12);

         object.drawing.distance_label  = asset.newtext('',Color3.fromRGB(255, 255, 255),12);
         object.drawing.weapon_label  = asset.newtext('',Color3.fromRGB(255, 255, 255),12);
    
         object.drawing.line = asset.newline(Color3.fromRGB(255, 255, 255),1);
         object.drawing.blackline = asset.newline(Color3.fromRGB(255, 255, 255),2);
         
         object.drawing.race_label = asset.newtext('',Color3.fromRGB(255, 255, 255),12);
         object.drawing.rank_label = asset.newtext('',Color3.fromRGB(255, 255, 255),12);    

         object.drawing.rc_label = asset.newtext('',Color3.fromRGB(255, 255, 255),12);

         object.drawing.hunger_label = asset.newtext('',Color3.fromRGB(255, 255, 255),12);

        function object.Toggle(value)
    
            for int,drawing in next, object.drawing do 
                if not drawing then continue end;
                if drawing.Visible then drawing.Visible = value;end;
            end;
    
            -- if object.highlight then 
            -- 	object.highlight.Enabled = false;
            -- end;
        end;
    
         function object.Visible(value)
            if not value then 
                return object.Toggle(false);
            end;
    
            object.drawing.box.Visible = Settigs.box;
            object.drawing.black.Visible = Settigs.box;
    
            object.drawing._healthbar.Visible = Settigs.healthbar;
            object.drawing._greenhealth.Visible = Settigs.healthbar;
            
            
            object.drawing._posture.Visible = Settigs.posturebar;
            object.drawing._green_posture.Visible = Settigs.posturebar;


            object.drawing.helath_label.Visible = Settigs.healthtext;
            object.drawing.name_label.Visible = Settigs.nametag;
            object.drawing.distance_label.Visible = Settigs.distance;
            object.drawing.weapon_label.Visible = Settigs.weapon;

            object.drawing.line.Visible = Settigs.tracer;
            object.drawing.blackline.Visible = Settigs.tracer;

            object.drawing.race_label.Visible = Settigs.race;
            object.drawing.rank_label.Visible = Settigs.rank;

            object.drawing.rc_label.Visible = Settigs.rc;

            object.drawing.posture_label.Visible = Settigs.posture;

            object.drawing.hunger_label.Visible = Settigs.hunger;
            -- if object.highlight then 
               --  	object.highlight.Enabled = Settigs.chams;
            -- end;
         end;
    
         local function updater()
    
             if not player or not player.Character or not Settigs.enabled then 
                return object.Visible(false)
             end;
    
             local character = player.Character;
             local humanoid = character:FindFirstChildOfClass('Humanoid');
             local rootPart = humanoid and humanoid.RootPart;
    
             if not humanoid or not rootPart then 
                return object.Visible(false)
             end;
    
             if humanoid.Health <= 0 then 
                return object.Visible(false)
             end;
    
             local onscreenPosition, onscreen = CurrentCamera:WorldToViewportPoint(rootPart.Position);
             local head = character:FindFirstChild('Head');
    
             if not onscreen or not head then 
                return object.Visible(false);
             end;
    
             local distance = LocalPlayer:DistanceFromCharacter(rootPart.Position);
             local headOnscreen = CurrentCamera:WorldToViewportPoint(head.Position);
    
             if Settigs.uselimitDistance and distance > Settigs.limitDistance then 
                return object.Visible(false);
             end;
             
            --  if getgenv().Duelers and not table.find(getgenv().Duelers,player) then 
            --     return object.Visible(false);
            --  end;
             
    
             local height = math.clamp((Vector2.new(headOnscreen.X, headOnscreen.Y) - Vector2.new(onscreenPosition.X, onscreenPosition.Y)).magnitude, 2, math.huge);
    
             object.Visible(true);
             asset.setquadpoint(object.drawing.box,onscreenPosition,height);
             asset.setquadpoint(object.drawing.black,onscreenPosition,height);
             
             object.drawing.box.Color = Settigs.boxColor; 
             object.drawing.black.Color = Settigs.boxColor;
    
            --  if not object.highlight or not object.highlight.Parent then 
            -- 	object.highlight = Instance.new("Highlight");
            -- 	object.highlight.Parent = character;
            -- 	warn('create Highlight')
            --  end;
            
            --  object.highlight.FillColor = Settigs.chamsColor;
            --  object.highlight.OutlineColor = Settigs.chamsOutlineColor;
             
             local bar = (Vector2.new(onscreenPosition.X - height, onscreenPosition.Y - height*2) - Vector2.new(onscreenPosition.X - height, onscreenPosition.Y + height*2)).magnitude;
             local healthoffset = humanoid.Health/humanoid.MaxHealth * bar;
    
             -- // Health Bar
             --object.drawing._healthbar2
             
             object.drawing._greenhealth.From = Vector2.new(onscreenPosition.X - height - 4, onscreenPosition.Y + height*2);
             object.drawing._greenhealth.To = Vector2.new(onscreenPosition.X - height - 4, onscreenPosition.Y + height*2 - healthoffset);
    
             object.drawing._healthbar.From = Vector2.new(onscreenPosition.X - height - 4, onscreenPosition.Y + height*2);
             object.drawing._healthbar.To = Vector2.new(onscreenPosition.X - height - 4, onscreenPosition.Y - height*2);
             object.drawing._greenhealth.Color = Color3.fromRGB(255, 0, 0):lerp(Color3.fromRGB(0, 255, 0), humanoid.Health/humanoid.MaxHealth);
             
   
             -- // Name Tag 
             local vector_convert_name = Vector2.new((object.drawing.box.PointA.X + object.drawing.box.PointB.X) / 2,(object.drawing.box.PointA.Y + object.drawing.box.PointB.Y) / 2);
    
             object.drawing.name_label.Text = object.name;
             object.drawing.name_label.Position = Vector2.new(vector_convert_name.X,vector_convert_name.Y - 15); 
             object.drawing.name_label.Color = Settigs.nametagColor;
    
             -- // Health & MaxHealth Text
    
             object.drawing.helath_label.Text = tostring(humanoid.Health):split('.')[1]..' hp';
             object.drawing.helath_label.Position = object.drawing._greenhealth.To + Vector2.new(-20,0)
             object.drawing.helath_label.Color = Settigs.healthTextColor;
    
             -- // Distance Text
             local vector_convert_distance = Vector2.new((object.drawing.box.PointC.X + object.drawing.box.PointD.X) / 2,(object.drawing.box.PointC.Y + object.drawing.box.PointD.Y) / 2)
    
             object.drawing.distance_label.Text = tostring(distance):split('.')[1]..' studs';
             object.drawing.distance_label.Position = Vector2.new(vector_convert_distance.X,vector_convert_distance.Y + 5);
             object.drawing.distance_label.Color = Settigs.distanceColor;
             
            -- // posture bar 

            local Posture = (player.Character:FindFirstChild('Posture') and player.Character:FindFirstChild('Posture').Value) or '0'

            object.drawing.posture_label.Text = tostring(Posture)..'% P'
            object.drawing.posture_label.Position = object.drawing.box.PointA + Vector2.new(18,-4)
            object.drawing.posture_label.Color = Settigs.postureColor;
                       
            local hunger =  (player.Character:FindFirstChild('Hunger') and math.floor(tonumber(player.Character:FindFirstChild('Hunger').Value))) or '0';



             if not Settigs.weapon then  
                object.drawing.weapon_label.Position = Vector2.new(vector_convert_distance.X,vector_convert_distance.Y + 5);
             else 
                object.drawing.weapon_label.Position = object.drawing.distance_label.Position  + Vector2.new(0,13);
             end;       

             if not Settigs.rc then  
                object.drawing.rc_label.Position  = Vector2.new(vector_convert_distance.X,vector_convert_distance.Y + 5);
             else 
                object.drawing.rc_label.Position  = (not Settigs.weapon and object.drawing.distance_label.Position  + Vector2.new(0,13)) or object.drawing.weapon_label.Position + Vector2.new(0,13)
             end;


             if not Settigs.race then  
                object.drawing.race_label.Position  = Vector2.new(vector_convert_distance.X,vector_convert_distance.Y + 5);
             else
                object.drawing.race_label.Position = (Settigs.nametag and object.drawing.name_label.Position + Vector2.new(0,-13)) or Vector2.new(vector_convert_name.X,vector_convert_name.Y - 15); 
             end;


             if CooldownFunc(player.Name..'RC Update',10) then 
                object.rcCells = abbreviate_number(tonumber(player.Character:GetAttribute('RCCells')))
             end;

            --  object.drawing.race_label.Visible = Settigs.race;
            --  object.drawing.rank_label.Visible = Settigs.rank;

            object.drawing.rc_label.Text = 'RC '..tostring(object.rcCells); 
            object.drawing.rc_label.Color = Settigs.rcColor; 

            local Race = player.Character:FindFirstChild('Race') and player.Character:FindFirstChild('Race').Value

            object.drawing.race_label.Text = tostring(Race)
            object.drawing.race_label.Color = Settigs.raceColor; 

            object.drawing.weapon_label.Text = player.Character:GetAttribute('WeaponType') or 'None'
            object.drawing.weapon_label.Color = Settigs.weaponColor;
             
            -- // rank 

            if not Settigs.rank then  
                object.drawing.rank_label.Position  = Vector2.new(vector_convert_distance.X,vector_convert_distance.Y + 5);
             else 
                object.drawing.rank_label.Position  = (Settigs.rc and object.drawing.rc_label.Position + Vector2.new(0,13)) or (not Settigs.rc and Settigs.weapon and  object.drawing.weapon_label.Position + Vector2.new(0,13)) or (not Settigs.rc and not Settigs.weapon and object.drawing.distance_label.Position + Vector2.new(0,13) )
             end;

             local rankValue = player.Character:FindFirstChild('Rank') and tonumber(player.Character.Rank.Value)

             if rankValue > 0 then 
                local rankdata = RankingData[Race] and RankingData[Race][rankValue]
                if rankdata and rankdata.RankName then 
                    object.drawing.rank_label.Text = "Rank "..tostring(rankValue) --.." "..tostring(rankdata.RankName).."]"
                end;
            else 
                object.drawing.rank_label.Text = "Rank 0"
             end;

             object.drawing.rank_label.Color = Settigs.rankColor

             if Race ~= 'Ghoul' then 
                object.drawing.hunger_label.Visible = false
             else
                 object.drawing.hunger_label.Text = tostring(hunger)..' hg'
                 object.drawing.hunger_label.Position = ((not Settigs.posture and object.drawing.box.PointA + Vector2.new(20,-4)) or object.drawing.box.PointA + Vector2.new(20,8))
                 object.drawing.hunger_label.Color = Settigs.hungerColor;
             end;

             -- // Tracer
             object.drawing.line.From  = Vector2.new(CurrentCamera.ViewportSize.X*0.5, CurrentCamera.ViewportSize.Y);
             object.drawing.blackline.From = Vector2.new(CurrentCamera.ViewportSize.X*0.5, CurrentCamera.ViewportSize.Y);
    
             object.drawing.line.To = Vector2.new(onscreenPosition.X, onscreenPosition.Y + height*2);
             object.drawing.blackline.To = Vector2.new(onscreenPosition.X, onscreenPosition.Y + height*2);
             object.drawing.line.Color = Settigs.tracerColor;
             object.drawing.blackline.Color = Settigs.tracerColor;
         end;
    
        function object.destroy()
            for _,connection in next, object.connections do 
                if not connection then continue end;
                connection:Disconnect()
                connection = nil;
            end;
    
            -- if object.highlight then 
            -- 	object.highlight:Destroy();
            -- end;
    
            for _,drawing in next, object.drawing do  drawing:Remove();drawing = nil;end;
        end;
    
        object.connections.updater = RunService.Heartbeat:Connect(function(Time)
            updater();
        end);
    
        object.connections.ancestrychange = object.player.AncestryChanged:Connect(function(_,parent)
            if parent then return end; 
            object.destroy();
        end);
    
        return object;
    end;
    
    function Library.AddInstance(Instance,Name)
        local asset = functions();
        local object = {
           ['Settigs'] = {
                Color = Color3.fromRGB(255, 255, 255),
                ShowDistance = false,
                UseLimitDistance = false,
                LimitDistance = 1000,
           },
           ['class'] = 'Instance',
           ['drawing'] = {
                label = asset.newtext('',Color3.fromRGB(255, 255, 255),13),
           },
           ['instance'] = Instance,
           ['name'] = Name or Instance.Name,
           ['uuid'] = 'uid_'..tostring(math.random(100000,1000000)),
           ['connections'] = {},
        };
        
        local function updater()

            if not object.Toggle and object.connections.updater then 
                object.connections.updater:Disconnect();
                object.connections.updater = nil;
                object.drawing.label.Visible = false;
                return;
            end;

            if not object.instance then return end;
            local distance = LocalPlayer:DistanceFromCharacter(object.instance.Position);
            local settigs = object.Settigs;
    
            if settigs.UseLimitDistance and distance > settigs.LimitDistance then 
                object.drawing.label.Visible = false;
                return;
            end;
    
            local instance, onscreen = CurrentCamera:WorldToViewportPoint(object.instance.Position);
            if not onscreen then  object.drawing.label.Visible = false;return end;

            object.drawing.label.Visible = true;
            object.drawing.label.Position = Vector2.new(instance.X,instance.Y);
            object.drawing.label.Color = settigs.Color;
    
            if settigs.ShowDistance then 
                object.drawing.label.Text = '['..tostring(object.name)..']['..tostring(distance):split('.')[1]..' away]';
                return;
            end;
    
            object.drawing.label.Text = tostring(object.name);
        end;
    
        function object.destroy()
            for _,connection in next, object.connections do 
                if not connection then continue end;
                connection:Disconnect()
                connection = nil;
            end;
    
            if object.Enabled then 
                object.Enabled = function() return end;
            end;
    
            return object.drawing.label:Remove();
        end;
    
        function object.Enabled(value)
            if not value then 
                object.Toggle = false
                return;
            end;
            
            object.Toggle = true
            
            if object.connections.updater then 
                return;
            end;

            object.connections.updater = RunService.Heartbeat:Connect(function(Time)
                updater();
            end);
        end;
        
        object.connections.ancestrychange = object.instance.AncestryChanged:Connect(function(_,parent)
            if parent then return end; 
            object.destroy();
        end);
    
        return object;
    end;
    
    function Library.AddEntity(Instance,Name)
        local asset = functions();
        local object = {
           ['Settigs'] = {
                Color = Color3.fromRGB(255, 255, 255),
                ShowDistance = false,
                ShowHealth = false,
                UseLimitDistance = false,
                LimitDistance = 1000,
           },
           ['class'] = 'Instance',
           ['drawing'] = {
                label = asset.newtext('',Color3.fromRGB(255, 255, 255),13),
           },
           ['instance'] = Instance,
           ['name'] = Name or Instance.Name,
           ['uuid'] = 'uid_'..tostring(math.random(100000,1000000)),
           ['connections'] = {},
           ['Toggle'] = false,
        };
        
        local function updater()
            if not object.Toggle and object.connections.updater then 
                object.connections.updater:Disconnect();
                object.connections.updater = nil;
                object.drawing.label.Visible = false;
                return;
            end;

            if not object.instance then return end;
                
            if not object.instance:FindFirstChild('HumanoidRootPart') or not object.instance:FindFirstChild('Humanoid') then 
                return;
            end;

            local distance = LocalPlayer:DistanceFromCharacter(object.instance.HumanoidRootPart.Position);
            local settigs = object.Settigs;

            if settigs.UseLimitDistance and distance > settigs.LimitDistance then 
                object.drawing.label.Visible = false;
                return;
            end;
    
            local instance, onscreen = CurrentCamera:WorldToViewportPoint(object.instance.HumanoidRootPart.Position);
            if not onscreen then  object.drawing.label.Visible = false;
                return 
            end;

            object.drawing.label.Visible = true;
            object.drawing.label.Position = Vector2.new(instance.X,instance.Y);
            object.drawing.label.Color = settigs.Color;
            
            if settigs.ShowHealth and settigs.ShowDistance  then 
                object.drawing.label.Text = '['..tostring(object.name)..']'..'['..tostring(math.floor(object.instance.Humanoid.Health))..'/'..tostring(math.floor(object.instance.Humanoid.MaxHealth))..']'
                ..'['..tostring(math.floor(distance))..']'
            elseif settigs.ShowHealth and not settigs.ShowDistance then 
                object.drawing.label.Text = '['..tostring(object.name)..']'..'['..tostring(math.floor(object.instance.Humanoid.Health))..'/'..tostring(math.floor(object.instance.Humanoid.MaxHealth))..']'
            elseif not settigs.ShowHealth and settigs.ShowDistance then 
                object.drawing.label.Text = '['..tostring(object.name)..']'..'['..tostring(math.floor(distance))..']'
            elseif not settigs.ShowHealth and not settigs.ShowDistance then 
                object.drawing.label.Text = '['..tostring(object.name)..']'
            end;
        end;
    
        function object.destroy()
            for _,connection in next, object.connections do 
                if not connection then continue end;
                connection:Disconnect()
                connection = nil;
            end;
    
            if object.Enabled then 
                object.Enabled = function() return end;
            end;
    
            return object.drawing.label:Remove();
        end;
    
        function object.Enabled(value)
            if not value then 
                object.Toggle = false
                return;
            end;
            
            object.Toggle = true
            
            if object.connections.updater then 
                return;
            end;

            object.connections.updater = RunService.Heartbeat:Connect(function(Time)
                updater();
            end);
        end;
        
        object.connections.ancestrychange = object.instance.AncestryChanged:Connect(function(_,parent)
            if parent then return end; 
            object.destroy();
        end);
    
        return object;
    end;

    for _,player in next, Players:GetPlayers() do 
        if (player ~= LocalPlayer) then 
            Library.AddPlayer(player);
        end;
    end;
    
    Players.PlayerAdded:Connect(function(player)
        Library.AddPlayer(player);
    end);

    return Library;
