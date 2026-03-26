local HttpService = game:GetService("HttpService")
local Kavo = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Kavo.CreateLib("DORO SUPREME 🐧 [PRO CONFIG]", "DarkTheme")

-- --- KHỞI TẠO BẢNG CÀI ĐẶT ---
_G.Settings = {
    LockFPS = 60,
    WipeMap = false,
    NoNPC = false,
    NoSkillFX = false, -- Mục mới sếp yêu cầu
    BlackScreen = false,
    ExtremeRAM = false,
    AutoLoad = false
}

local FileName = "DoroConfig_V6.json"

-- --- TAB 1: FUNCTION 🐧 (TỔNG KHO VŨ KHÍ) ---
local FuncTab = Window:NewTab("Function 🐧")
local f = FuncTab:NewSection("Status: [SYSTEM READY]")

-- 1. Xóa Hiệu Ứng Chiêu (Mục sếp vừa nhắc)
f:NewToggle("Xóa Hiệu Ứng Chiêu", "Xóa sạch Particle, Beam, Trail...", function(state)
    _G.Settings.NoSkillFX = state
    if state then
        -- Xóa những cái đang có sẵn
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") or v:IsA("Fire") or v:IsA("Smoke") then
                v.Enabled = false
            end
        end
        f:UpdateSection('Skill FX: <font color="#00FF00">[ON - REMOVED]</font>')
    else
        f:UpdateSection('Skill FX: <font color="#FF0000">[OFF]</font>')
    end
end)

-- Rình hiệu ứng mới xuất hiện để xóa tiếp
game:GetService("Workspace").DescendantAdded:Connect(function(v)
    if _G.Settings.NoSkillFX then
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") or v:IsA("Fire") or v:IsA("Smoke") then
            task.wait() -- Đợi 1 tẹo cho nó load rồi xóa
            v.Enabled = false
        end
    end
end)

-- 3. Xóa Trắng Map (Max FPS)
f:NewToggle("Xóa Trắng Map (Max FPS)", "Xóa vĩnh viễn Part", function(state)
    _G.Settings.WipeMap = state
    if state then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Name ~= "Baseplate" then v:Destroy() end
        end
        f:UpdateSection('Wipe Map: <font color="#00FF00">[ON]</font>')
    end
end)

-- 6. Xóa NPC (Chừa Quest)
f:NewToggle("Xóa NPC (Chừa Quest)", "Chỉ giữ NPC nhận Q", function(state)
    _G.Settings.NoNPC = state
    if state then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") then
                if not v.Name:lower():find("quest") then v:Destroy() end
            end
        end
        f:UpdateSection('No NPC: <font color="#00FF00">[ON]</font>')
    end
end)

-- 8+11. Black Screen / Low CPU
f:NewToggle("Black Screen Mode", "Siêu treo máy", function(state)
    _G.Settings.BlackScreen = state
    game:GetService("RunService"):Set3dRenderingEnabled(not state)
    f:UpdateSection('Black Screen: ' .. (state and '<font color="#00FF00">[ON]</font>' or '<font color="#FF0000">[OFF]</font>'))
end)

-- 2+10. Extreme RAM Mode
f:NewToggle("Extreme RAM Mode", "Hủy diệt đồ họa", function(state)
    _G.Settings.ExtremeRAM = state
    if state then
        settings().Rendering.QualityLevel = 1
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("MeshPart") or v:IsA("Part") then v.Material = "Plastic" v.Color = Color3.fromRGB(120, 120, 120) end
            if v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end
        end
        f:UpdateSection('RAM Mode: <font color="#00FF00">[ON]</font>')
    end
end)

-- 7. Lock FPS Slider
f:NewSlider("Auto Lock FPS", "Giới hạn khung hình", 240, 1, function(v)
    _G.Settings.LockFPS = v
    if setfpscap then setfpscap(v) end
    f:UpdateSection('FPS Lock: <font color="#00FF00">' .. v .. '</font>')
end)

-- --- TAB 2: CONFIG 📁 (PHÒNG QUẢN LÝ) ---
local ConfTab = Window:NewTab("Config 📁")
local c = ConfTab:NewSection("Config Management")

c:NewButton("Save Config 💾", "Lưu cài đặt vào JSON", function()
    writefile(FileName, HttpService:JSONEncode(_G.Settings))
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Doro Config", Text = "Đã lưu!"})
end)

c:NewButton("Wipe Config 🗑️", "Xóa file JSON", function()
    if isfile(FileName) then delfile(FileName) end
    c:UpdateSection('Config: <font color="#FF0000">[WIPED]</font>')
end)

c:NewToggle("Auto Use Config Saved", "Tự động load khi mở Script", function(state)
    _G.Settings.AutoLoad = state
    c:UpdateSection('Auto Load: ' .. (state and '<font color="#00FF00">[ON]</font>' or '<font color="#FF0000">[OFF]</font>'))
end)
