import re
from xkeysnail.transform import *

define_timeout(1)

define_modmap({
    Key.CAPSLOCK: Key.LEFT_CTRL
})

global_remaps = {
    K("M-q"): K("M-f4"), # close app
}

terminal_apps = ("Alacritty", "Xfce4-terminal", "Konsole")

terminal_remaps = {
    K("M-c"): K("C-Shift-c"), # copy
    K("M-v"): K("C-Shift-v"), # paste
    **global_remaps,
}

gui_remaps = {
    K("M-c"): K("C-c"), # copy
    K("M-x"): K("C-x"), # cut
    K("M-v"): K("C-v"), # paste
    K("M-a"): K("C-a"), # select-all
    K("M-z"): K("C-z"), # undo
    K("M-Shift-z"): K("C-Shift-z"), # redo
    K("M-f"): K("C-f"), # find
    K("M-Shift-f"): K("C-Shift-f"), # find all
    K("M-r"): K("C-r"), # reload
    K("C-n"): K("down"), # next
    K("C-p"): K("up"), # previous
    **global_remaps,
}

define_keymap(lambda wm_class: wm_class not in terminal_apps, gui_remaps, "gui apps")

define_keymap(lambda wm_class: wm_class in terminal_apps, terminal_remaps, "terminal apps")

define_keymap(re.compile("firefox"), {
    K("M-t"): K("C-t"), # new tab
    K("M-w"): K("C-w"), # close tab
}, "Firefox")

