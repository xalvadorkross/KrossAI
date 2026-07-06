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
