--!strict
--!optimize 2
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Controllers = Shared.Controllers

local SmartBone = require(Packages.SmartBone)
local Promise = require(Packages.Promise)
local Replica = require(Packages.Replica)

local t = os.clock() -- Used to calculate execute time

-- Start packages
SmartBone.Start()

-- Initializing / Starting controllers
for _, Location in pairs(Controllers:GetChildren()) do
	for _, Controller in pairs(Location:GetDescendants()) do
		if not Controller.Name:match("Controller$") then
			continue
		end
		if Controller:IsA("ModuleScript") then
			local Module
			local success, err = pcall(function()
				Module = require(Controller)
			end)
			if not success then
				warn(
					string.format(
						"[CLIENT Runtime]: Error when loading controller %s, error: %s, error traceback: %s",
						Controller:GetFullName(),
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

Replica.RequestData()

print(string.format("[CLIENT]: Completed client loading in %dms", (os.clock() - t) * 1000))
