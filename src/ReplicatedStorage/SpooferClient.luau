------------------------------------------------------------
-- spoofer v1.0
-- Copyright � 2023-2024 Studio Phantym (@saaawdust)
--
-- This software is provided �as-is�, without any express or implied warranty.
-- In no event will the authors be held liable for any damages arising from the use of this software.
--
-- Permission is granted to anyone to use this software for any purpose,
-- including commercial applications, and to alter it and redistribute it freely,
-- subject to the following restrictions:
--
-- 1. The origin of this software must not be misrepresented;
--    you must not claim that you wrote the original software.
--    If you use this software in a product, an acknowledgment
--    in the product documentation would be appreciated but is not required.
--
-- 2. Altered source versions must be plainly marked as such,
--    and must not be misrepresented as being the original software.
--
-- 3. This notice may not be removed or altered from any source distribution.
--
------------------------------------------------------------

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

export type SanitizedPlayer = {
	Name: string,
	DisplayName: string,
	UserId: number,
	PlayerGui: PlayerGui,
	Backpack: Backpack,

	isFake: boolean,
}

local function sendRequest(message: string, ...)
	local repl = ReplicatedStorage:FindFirstChild("SpooferClient") :: RemoteEvent
	if not repl then
		return Players.LocalPlayer.UserId
	end

	repl:FireServer(message, ...)
	local res = repl.OnClientEvent:Wait()
	return res
end

return {

    -- Returns the spoofing userId
	-- 
	-- @since v1.0
	getSpoofId = function(): number
		return sendRequest("getSpoofId")
	end,

    -- Returns the spoofing client
	-- 
	-- @since v1.0
	getLocalPlayer = function(): SanitizedPlayer
		return sendRequest("getLocalPlayer")
	end,

    -- Returns if the client has been indexed
	-- 
	-- @since v1.0
    isIndexed = function(): boolean
		return sendRequest("isIndexed")
	end,
    
    -- Returns the client is spoofing
	-- 
	-- @since v1.0
    isSpoofing = function(): boolean
		return sendRequest("isSpoofing")
	end,

    -- Requests the server to spoof with the given userId or username
	-- 
	-- @since v1.0
    requestSpoof = function(usernameOrUserId: number | string): boolean
        if (type(usernameOrUserId) == "string") then
            usernameOrUserId = Players:GetUserIdFromNameAsync(usernameOrUserId)
        end
        
		return sendRequest("RequestSpoof", usernameOrUserId)
	end,
}
