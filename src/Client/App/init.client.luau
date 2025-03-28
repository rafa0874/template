--!strict
--!native
--!optimize 2
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Packages = ReplicatedStorage:WaitForChild("Packages")

local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)

local Screen = require(script.Components.UI.Screen)

local e = React.createElement
local Root = ReactRoblox.createRoot(Instance.new("Folder"))

Root:render(ReactRoblox.createPortal({
	e(Screen, {
		key = "template",
	}, {}),
}, PlayerGui))
