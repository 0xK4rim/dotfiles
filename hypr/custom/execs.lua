-- This file will not be overwritten across dots-hyprland updates.
-- The file name is for the sake of organization and does not matter
-- See the corresponding files in ~/.config/hypr/hyprland for examples

hl.on("hyprland.start", function()
    -- hl.exec_cmd("ticktick", { workspace = "8 silent" })
    hl.exec_cmd("portmaster", { workspace = "10 silent" })
end)
