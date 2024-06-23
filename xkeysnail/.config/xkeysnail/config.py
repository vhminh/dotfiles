import re
from xkeysnail.transform import *

define_timeout(1)

define_modmap({
    Key.CAPSLOCK: Key.LEFT_CTRL
})

terminal_apps = ("Alacritty", "Xfce4-terminal")

terminal_remaps = {
    K("M-c"): K("C-Shift-c"), # copy
    K("M-v"): K("C-Shift-v"), # paste
}

gui_remaps = {
    K("M-c"): K("C-c"), # copy
    K("M-v"): K("C-v"), # paste
    K("M-a"): K("C-a"), # select-all
    K("M-f"): K("C-f"), # search
    K("C-n"): K("down"), # next
    K("C-p"): K("up"), # previous
}

define_keymap(lambda wm_class: wm_class not in terminal_apps, gui_remaps, "gui apps")

define_keymap(lambda wm_class: wm_class in terminal_apps, terminal_remaps, "terminal apps")

define_keymap(re.compile("firefox"), {
    K("M-t"): K("C-t"), # new tab
    K("M-w"): K("C-w"), # close tab
}, "Firefox")

