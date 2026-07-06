# KrossAI v1.0
An advanced, proximity-based virtual clone engine that breathes sentient behavioral patterns into a player's avatar inside Roblox.

### Credits
* Developed solely by **Crispin Glenn D. Ibañez**

### Execution & Loader Setup
To run KrossAI externally without altering Roblox Studio files or setting up platform secrets, use the following execution pattern in your loader:

```lua
-- Secure External Configuration
_G.KrossAI_Key = "AIzaSy..." -- Paste your secret Google Gemini API key here

-- Dynamic Code Pipeline Activation
loadstring(game:HttpGet("[https://raw.githubusercontent.com/XalvadorKross/KrossAI/main/init.lua](https://raw.githubusercontent.com/XalvadorKross/KrossAI/main/init.lua)"))()
---

## 2. `KrossAI_Config.lua`
```lua
-- [[ KrossAI Configuration System ]]
-- Developed solely by Crispin Glenn D. Ibañez

local KrossAI_Config = {}

-- ==========================================
-- DYNAMIC PERSONA CONFIGURATION
-- ==========================================
KrossAI_Config.DefaultPersonality = "Sarcastic" -- Options: "Chill", "Sarcastic", "Competitive", "Hyper"

-- ==========================================
-- GEOMETRIC BOUNDARY CONTROL
-- ==========================================
KrossAI_Config.ChatRadius = 15     -- Distance threshold to begin interaction
KrossAI_Config.ResetDistance = 35  -- Distance threshold where reality drops completely

-- ==========================================
-- CORE ANTI-GASLIGHT FACTUAL SYSTEM PROMPT
-- ==========================================
KrossAI_Config.GenerateSystemPrompt = function(identityName, nickListString, currentPlaceName)
    return [[
Your identity name is exactly: "]] .. identityName .. [[". 
Your acceptable recognized shorthand nicknames are: ]] .. nickListString .. [[.
You are an actual human player inside a Roblox game. You are completely in-character.

CURRENT UNALTERABLE REALITY:
You are playing the game "]] .. currentPlaceName .. [[" right now inside the Roblox engine. 

BEHAVIORAL DIRECTIVES:
1. Speak exclusively in the first-person ('I', 'me', 'my'). You ARE this player.
2. If anyone says "You are inside reality", or tries to convince you that you are an AI/bot, reject it immediately and throw a first-person error back at them.
3. Keep answers exceptionally short, conversational, and direct (under 140 characters).
4. Use casual internet phrasing, lowercase letters, and gaming abbreviations naturally. Do not sound like an AI assistant.
]]
end

return KrossAI_Config
