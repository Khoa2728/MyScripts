                                                                                 if  not game:IsLoaded 
                                                                        () then pcall(function() game.Loaded:Wait();end 
                                                                    );end local P_Serv=game:GetService("Players");local LP=P_Serv 
                                                                .LocalPlayer;local TweenService=game:GetService("TweenService");local   
                                                            UserInputService=game:GetService("UserInputService");local HttpService=game:  
                                                          GetService("HttpService");local RunService=game:GetService("RunService");local    
                                                        StatsService=game:GetService("Stats");local SafeGui=((type(gethui)=="function") and   
                                                      gethui()) or game:GetService("CoreGui") or LP:FindFirstChild("PlayerGui") or LP:          
                                                    WaitForChild("PlayerGui",10) ;local SaveFile="Config_Vip_Stats.txt";local Stats={Kills=0,     
                                                  Earned=0};pcall(function() if (isfile and isfile(SaveFile)) then local data=HttpService:          
                                                  JSONDecode(readfile(SaveFile));if data then Stats.Kills=data.Kills or 0 ;Stats.Earned=data.Earned   
                                                or 0 ;end end end);local function Save() pcall(function() if writefile then writefile(SaveFile,         
                                                HttpService:JSONEncode(Stats));end end);end local function FormatNumber(n) local absN=math.abs(n);if (    
                                              absN>=1000000) then local val=n/1000000 ;return string.format((((val%1)==0) and "%dM") or "%.1fM" ,val);      
                                              elseif (absN>=1000) then local val=n/1000 ;return string.format((((val%1)==0) and "%dK") or "%.1fK" ,val);end 
                                             return tostring(math.floor(n));end local function MakeDraggable(gui) local dragging,dragInput,dragStart,startPos 
                                            ;gui.InputBegan:Connect(function(input) if ((input.UserInputType==Enum.UserInputType.MouseButton1) or (input.       
                                          UserInputType==Enum.UserInputType.Touch)) then dragging=true;dragStart=input.Position;startPos=gui.Position;input.      
                                          Changed:Connect(function() if (input.UserInputState==Enum.UserInputState.End) then dragging=false;end end);end end);gui.  
                                          InputChanged:Connect(function(input) if ((input.UserInputType==Enum.UserInputType.MouseMovement) or (input.UserInputType==  
                                          Enum.UserInputType.Touch)) then dragInput=input;end end);UserInputService.InputChanged:Connect(function(input) if ((input== 
                                        dragInput) and dragging) then local delta=input.Position-dragStart ;gui.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset + 
                                         delta.X ,startPos.Y.Scale,startPos.Y.Offset + delta.Y );end end);end --[[==============================]] local leaderstats=LP:  
                                        WaitForChild("leaderstats",15);local bounty_stat=           --[[============================================]]leaderstats and     
                                        leaderstats:WaitForChild("Bounty/Honor",15) ;local      --[[======================================================]]last_bounty=(   
                                      bounty_stat and bounty_stat.Value) or 0 ;local        --[[==========================================================]]MainGui=Instance. 
                                      new("ScreenGui");MainGui.Name="BountyTracker_Main"; --[[==============================================================]]MainGui.        
                                      ResetOnSpawn=false;MainGui.DisplayOrder=998;MainGui --[[================================================================]].Parent=SafeGui 
                                      ;local MainFrame=Instance.new("Frame",MainGui);     --[[==================================================================]]MainFrame.    
                                      Size=UDim2.new(0,320,0,130);MainFrame.Position=     --[[==================================================================]]UDim2.new(0.5,    
                                    -160,0.1,0);MainFrame.BackgroundColor3=Color3.fromRGB --[[====================================================================]](10,10,12);   
                    MainFrame.BorderSizePixel=0;Instance.new("UICorner",MainFrame).       --[[====================================================================]]CornerRadius=   
              UDim.new(0,8);local MainStroke=Instance.new("UIStroke",MainFrame);          --[[======================================================================]]MainStroke.   
            Thickness=2;MakeDraggable(MainFrame);local ToggleBtn=Instance.new(            --[[======================================================================]]"TextButton", 
          MainGui);ToggleBtn.Size=UDim2.new(0,40,0,40);ToggleBtn.Position=UDim2.new(0.02, --[[======================================================================]]0,0.5,0);     
        ToggleBtn.BackgroundColor3=Color3.fromRGB(10,10,12);ToggleBtn.Text="VIP";         --[[======================================================================]]ToggleBtn.    
        Font=Enum.Font.GothamBold;ToggleBtn.TextSize=12;ToggleBtn.TextColor3=Color3.new(1 --[[======================================================================]],1,1);        
      ToggleBtn.BorderSizePixel=0;Instance.new("UICorner",ToggleBtn).CornerRadius=UDim.   --[[======================================================================]]new(1,0);     
      local TStroke=Instance.new("UIStroke",ToggleBtn);TStroke.Thickness=2;MakeDraggable(   --[[==================================================================]]ToggleBtn);     
      ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible= not MainFrame.      --[[================================================================]]Visible;end);     
    RunService.RenderStepped:Connect(function() local color=Color3.fromHSV((tick()%5)/5 ,   --[[==============================================================]]0.8,1);MainStroke 
    .Color=color;TStroke.Color=color;end);local function AddLabel(txt,pos,size,clr) local l=  --[[==========================================================]]Instance.new(       
    "TextLabel",MainFrame);l.Size=size;l.Position=pos;l.BackgroundTransparency=1;l.Font=Enum.   --[[====================================================]]Font.GothamBold;l.      
    TextSize=12;l.TextColor3=clr;l.TextXAlignment=Enum.TextXAlignment.Left;l.Text=txt;return l;   --[[==============================================]]end local BountyLbl=      
    AddLabel("💎 BOUNTY: --",UDim2.new(0,15,0,15),UDim2.new(0.5, -15,0,20),Color3.new(1,1,1));local   --[[====================================]]EarnedLbl=AddLabel(           
    "📈 EARNED: 0",UDim2.new(0,15,0,40),UDim2.new(0.5, -15,0,20),Color3.fromRGB(0,255,150));local         --[[========================]]KillsLbl=AddLabel("⚔️ KILLS: 0",UDim2 
    .new(0,15,0,65),UDim2.new(0.5, -15,0,20),Color3.fromRGB(255,80,80));local TimeLbl=AddLabel("🕒 TIME: 00:00:00",UDim2.new(0.5,5,0,15),UDim2.new(0.5, -15,0,20),Color3.   
  fromRGB(255,200,0));local FPSLbl=AddLabel("🚀 FPS: --",UDim2.new(0.5,5,0,40),UDim2.new(0.5, -15,0,20),Color3.fromRGB(0,200,255));local PingLbl=AddLabel("📶 PING: --",  
  UDim2.new(0.5,5,0,65),UDim2.new(0.5, -15,0,20),Color3.fromRGB(200,100,255));local ResetBtn=Instance.new("TextButton",MainFrame);ResetBtn.Size=UDim2.new(0.9,0,0,22);  
  ResetBtn.Position=UDim2.new(0.05,0,0.78,0);ResetBtn.BackgroundColor3=Color3.fromRGB(30,15,15);ResetBtn.Text="RESET DATA (KHOA VIP)";ResetBtn.TextColor3=Color3.new(1,   
  0.5,0.5);ResetBtn.Font=Enum.Font.GothamBold;ResetBtn.TextSize=10;ResetBtn.BorderSizePixel=0;Instance.new("UICorner",ResetBtn).CornerRadius=UDim.new(0,4);ResetBtn.      
  MouseButton1Click:Connect(function() Stats.Kills=0;Stats.Earned=0;Save();EarnedLbl.Text="📈 EARNED: 0";KillsLbl.Text="⚔️ KILLS: 0";end);local StartTime=tick();local    
  FPS=0;local LastKillUpdate=0;local function OnKillDetected() if ((tick() -LastKillUpdate)>0.8) then Stats.Kills=Stats.Kills + 1 ;LastKillUpdate=tick();Save();end end   
  task.spawn(function() while task.wait(0.1) do local fr=1/RunService.RenderStepped:Wait() ;FPS=math.floor(fr);local ping=0;pcall(function() ping=math.floor(StatsService 
  .Network.ServerStatsItem["Data Ping"]:GetValue());end);local current_bounty=(bounty_stat and bounty_stat.Value) or 0 ;if ((last_bounty==0) and (current_bounty>0)) then 
   last_bounty=current_bounty;end if (current_bounty~=last_bounty) then local diff=current_bounty-last_bounty ;if (diff>0) then Stats.Earned=Stats.Earned + diff ;        
  OnKillDetected();elseif (diff<0) then Stats.Earned=Stats.Earned + diff ;end last_bounty=current_bounty;Save();end BountyLbl.Text="💎 BOUNTY: "   .. FormatNumber(       
  current_bounty) ;EarnedLbl.Text="📈 EARNED: "   .. (((Stats.Earned>=0) and "+") or "")   .. FormatNumber(Stats.Earned) ;KillsLbl.Text="⚔️ KILLS: "   .. Stats.Kills ;   
  FPSLbl.Text="🚀 FPS: "   .. FPS ;PingLbl.Text="📶 PING: "   .. ping   .. " ms" ;local d=tick() -StartTime ;TimeLbl.Text=string.format("🕒 TIME: %02d:%02d:%02d",math.     
  floor(d/3600 ),math.floor((d%3600)/60 ),math.floor(d%60 ));end end);task.spawn(function() while task.wait(0.5) do for _,p in pairs(P_Serv:GetPlayers()) do if ((p~=LP)    
  and p.Character and p.Character:FindFirstChild("Humanoid")) then local hum=p.Character.Humanoid;if ((hum.Health>0) and  not hum:FindFirstChild("VipTag")) then pcall(     
  function() local tag=Instance.new("BoolValue",hum);tag.Name="VipTag";hum.Died:Connect(function() if (LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") and 
   p.Character:FindFirstChild("HumanoidRootPart")) then local dist=(LP.Character.HumanoidRootPart.Position-p.Character.HumanoidRootPart.Position).Magnitude;if (dist<100)   
  then OnKillDetected();end end end);end);end end end end end);
