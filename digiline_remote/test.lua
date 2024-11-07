--[[
  __                   __
_/  |_  ____   _______/  |_
\   __\/ __ \ /  ___/\   __\
 |  | \  ___/ \___ \  |  |
 |__|  \___  >____  > |__|
           \/     \/
--]]

minetest.register_entity("digiline_remote:testentity", {
	visual = "cube",
	collisionbox = {-0.5,-0.5,-0.5, 0.5,0.5,0.5},
	_on_digiline_remote_receive = function(self, channel, msg)
		minetest.chat_send_all("msg = "..msg)
	end,
})
