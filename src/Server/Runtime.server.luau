--!strict
--!optimize 2
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Server = ServerScriptService:WaitForChild("Server")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Services = Server.Services

local Promise = require(Packages.Promise)

local t = os.clock() -- Used to calculate execute time

-- Initializing / Starting services
for _, Location in pairs(Services:GetChildren()) do
	for _, Service in pairs(Location:GetDescendants()) do
		if not Service.Name:match("Service$") then
			continue
		end
		if Service:IsA("ModuleScript") then
			local Module
			local success, err = pcall(function()
				Module = require(Service)
			end)
			if not success then
				warn(
					string.format(
						"[SERVER Runtime]: Error when loading service %s, error: %s, error traceback: %s",
						Service:GetFullName(),
						tostring(err),
						debug.traceback()
					)
				)
				continue
			end

			if Module.Init ~= nil then
				if typeof(Module.Init) == "function" then
					Promise.new(function()
						Module:Init()
					end):catch(function(er)
						warn(er)
					end)
				end
			end
			if Module.Start ~= nil then
				if typeof(Module.Start) == "function" then
					Promise.new(function()
						Module:Start()
					end):catch(function(er)
						warn(er)
					end)
				end
			end
		end
	end
end
print(string.format("[SERVER]: Initialized and started services in %dms", (os.clock() - t) * 1000))

print(string.format("[SERVER]: Completed in %dms", (os.clock() - t) * 1000))
