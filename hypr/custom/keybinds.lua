-- This file will not be overwritten across dots-hyprland updates.
-- The file name is for the sake of organization and does not matter
-- See the corresponding files in ~/.config/hypr/hyprland for examples

--#! User
hl.bind("CTRL + SUPER + Slash", hl.dsp.exec_cmd("xdg-open ~/.config/illogical-impulse/config.json")) -- Edit shell config
hl.bind("CTRL + SUPER + ALT + Slash", hl.dsp.exec_cmd("xdg-open ~/.config/hypr/custom/keybinds.conf")) -- Edit extra keybinds

-- Apps
hl.bind("SUPER + B", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/launch_first_available.sh firefox")) -- Browser
hl.bind("SUPER + CTRL + B", hl.dsp.exec_cmd("firefox --private-window")) -- Open private tab
hl.bind("SUPER + O", hl.dsp.exec_cmd("sh -c 'sleep 0.2 && hyprctl dispatch dpms off'")) -- Turn the screen off
