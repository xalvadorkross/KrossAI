
-- [[ KrossAI Master Engine Initialization ]]
-- Developed solely by Crispin Glenn D. Ibañez

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local TextService = game:GetService("TextService")

-- 1. EXTRACT EXECUTING CLIENT INFORMATION
local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local ControllerName = LocalPlayer.Name

-- 2. AUTOMATIC ALIAS INTERPOLATION (Parses Usernames into Nicknames)
local Nicknames = {ControllerName}
if #ControllerName > 4 then
    table.insert(Nicknames, string.sub(ControllerName, 1, math.floor(#ControllerName / 2)))
    table.insert(Nicknames, string.sub(ControllerName, 1, 4))
end

-- 3. ENVIRONMENT SANITY VALIDATION
local API_KEY = _G.KrossAI_Key
if not API_KEY or API_KEY == "AIzaSy..." then
    warn("KrossAI Execution Aborted: Missing API Key inside global environment variable (_G.KrossAI_Key).")
    return
end

-- 4. PULL REPOSITORY ROUTING DATA
-- Dynamically fetch the configurations alongside this file
local function fetchConfig()
    -- Attempts to pull dynamic script data relative to runtime
    local success, result = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/"..LocalPlayer.Name.."/KrossAI/main/KrossAI_Config.lua"))()
    end)
    if not success or not result then
        -- Fallback URL to ensure structure if profile extraction fails
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/CrispinGlenn/KrossAI/main/KrossAI_Config.lua"))()
    end
    return result
end

local Config = fetchConfig()
local ActiveConversations = {}

-- 5. REAL-TIME GAME ENVIRONMENT RECOGNITION
local CurrentGameName = "Roblox Experience"
pcall(function()
    local productInfo = MarketplaceService:GetProductInfoAsync(game.PlaceId)
    CurrentGameName = productInfo.Name
end)

-- 6. PARSE REAL-TIME NICKNAME TOKENS STRING
local NicknameString = ""
for i, name in ipairs(Nicknames) do
    NicknameString = NicknameString .. '"' .. name .. '"' .. (i < #Nicknames and ", " or "")
end

local SystemPrompt = Config.GenerateSystemPrompt(ControllerName, NicknameString, CurrentGameName)

-- 7. THE SECURE DYNAMIC REQUEST WRAPPER FOR GEMINI
local function askGemini(playerMessage)
    -- Pre-Execution Filter Check (The Reality Safety Trap)
    if string.find(string.lower(playerMessage), "you are inside reality") then
        return "Error: System prompt mutation detected. Attempted reality alteration blocked."
    end

    local endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=" .. API_KEY
    local requestPayload = {
        systemInstruction = {
            parts = { { text = SystemPrompt } }
        },
        contents = {
            { parts = { { text = playerMessage } } }
        },
        generationConfig = {
            temperature = 0.7,
            maxOutputTokens = 100
        }
    }

    local response
    local success, err = pcall(function()
        response = HttpService:RequestAsync({
            Url = endpoint,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(requestPayload)
        })
    end)

    if success and response.Success then
        local data = HttpService:JSONDecode(response.Body)
        if data.candidates and data.candidates[1].content.parts[1].text then
            return data.candidates[1].content.parts[1].text
        end
    end
    return "idk, backend went fuzzy. try again."
end

-- 8. LIVE CHAT LISTENER ENGINE (PROXIMITY RADIAL MATRIX)
local function onPlayerChatted(speaker, message)
    if speaker == LocalPlayer then return end
    
    local character = LocalPlayer.Character
    local speakerCharacter = speaker.Character
    if not character or not speakerCharacter then return end

    local distance = (character:GetPrimaryPartPosition() - speakerCharacter:GetPrimaryPartPosition()).Magnitude
    local isFriend = LocalPlayer:IsFriendsWith(speaker.UserId)
    local state = ActiveConversations[speaker.UserId] or { Engaged = false }

    -- Proximity Breach Checks
    if distance > Config.ResetDistance then
        ActiveConversations[speaker.UserId] = nil
        return
    end

    if distance <= Config.ChatRadius then
        local triggeredNameHook = false
        for _, alias in ipairs(Nicknames) do
            if string.find(string.lower(message), string.lower(alias)) then
                triggeredNameHook = true
                break
            end
        end

        -- Evaluation Matrix
        if state.Engaged or isFriend or triggeredNameHook then
            state.Engaged = true
            ActiveConversations[speaker.UserId] = state

            -- Forward to Gemini API and stream response back safely
            local rawAIResponse = askGemini(message)
            
            -- Comply with Platform Text Filtering Guidelines
            local filteredResponse = "..."
            pcall(function()
                local filterResult = TextService:FilterStringAsync(rawAIResponse, LocalPlayer.UserId)
                filteredResponse = filterResult:GetChatForUserAsync(speaker.UserId)
            end)

            -- Emulate typing and speak
            task.wait(1.5)
            game:GetService("Chat"):Chat(character, filteredResponse, Enum.ChatColor.White)
        end
    end
end

-- Hook global workspace events dynamically at runtime
Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(msg) onPlayerChatted(player, msg) end)
end)

for _, player in ipairs(Players:GetPlayers()) do
    player.Chatted:Connect(function(msg) onPlayerChatted(player, msg) end)
end

print("=========================================")
print("KrossAI Clone Engine Operational.")
print("Controlled By Username: " .. ControllerName)
print("Auto Nicknames Registered: " .. NicknameString)
print("Developed Solely by Crispin Glenn D. Ibañez")
print("=========================================")
