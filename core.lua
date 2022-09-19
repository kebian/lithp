Lithp = CreateFrame("Frame")

function Lithp:ModifyText(originalText)
    local newText = originalText:gsub("ss", "th")
    newText = newText:gsub("SS", "TH")
    newText = newText:gsub("s", "th")
    newText = newText:gsub("S", "Th")
    newText = newText:gsub("ci", "thi")
    newText = newText:gsub("Ci", "Thi")
    newText = newText:gsub("CI", "THI")
    newText = newText:gsub("ce", "the")
    newText = newText:gsub("Ce", "The")
    newText = newText:gsub("CE", "THE")
    newText = newText:gsub("zz", "th")
    newText = newText:gsub("ZZ", "TH")
    newText = newText:gsub("z", "th")
    newText = newText:gsub("Z", "Th")
    return newText
end

function Lithp:TestText(originalText)
    local newText = self:ModifyText(originalText)
    self:Print(newText)
end

function Lithp:RegisterSlashCommand()
    SLASH_LITHP1 = "/lithp"    
    SlashCmdList["LITHP"] = function(msg)
        self:OnSlashCommand(msg)
    end
end

function Lithp:OnSlashCommand(msg)
    local _, _, command, args = string.find(msg, "%s?(%w+)%s?(.*)")

    if command then
        command = command:lower()
    end    

    if command == "test" then
        self:TestText(args)
    else        
        LithpDb.enabled = not LithpDb.enabled
        self:PrintStatus()
    end 
end

function Lithp:PrintStatus()
    if LithpDb.enabled == true then
        self:Print("Enabled")
    else
        self:Print("Disabled")
    end
end

function Lithp:Startup()
    if LithpDb == nil then        
        LithpDb = {
            enabled = false
        }
    end

    self:RegisterSlashCommand()
    
    hooksecurefunc("ChatEdit_ParseText", function(chatEntry, send)
        if LithpDb.enabled == false then
            return
        end
        if (send == 1) then
            local originalText = chatEntry:GetText()
            if (originalText == '') then
                return
            end
            local newText = self:ModifyText(originalText)
            chatEntry:SetText(newText)  
        end
    end)
    self:PrintStatus()
end

function Lithp:Print(...)
    print("|cFF3399FF[Lithp]|r " .. ...)
end

function Lithp:RegisterForStartup()
    self:SetScript('OnEvent', function(self, event, ...)
		self[event](self, ...)
    end)
    self:RegisterEvent("ADDON_LOADED")
end

function Lithp:ADDON_LOADED(name)
    if name == "Lithp" then
        self:Startup()
    end
end

Lithp:RegisterForStartup()