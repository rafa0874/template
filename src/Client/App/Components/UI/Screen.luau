--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage:WaitForChild("Packages")

local React = require(Packages.React)

local e = React.createElement

type Props = {
	key: string,
	displayOrder: number?,

	children: React.React_Node,
}

return function(props: Props)
	return (
		e("ScreenGui", {
			key = props.key,
			DisplayOrder = props.displayOrder or 0,

			IgnoreGuiInset = true,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			ResetOnSpawn = false,
		}, props.children)
	)
end
