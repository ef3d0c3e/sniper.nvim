# Sniper -- Precise movement plugin

Sniper lets you precisely jump to pre-configured marks around the cursor.

![Demo](./demo.mp4)

# Configuration

With `lazy.nvim`:
```
{
    "https://github.com/ef3d0c3e/sniper.nvim",
    opts = {
        marks =
        {
            paren =
            {
                hi = { bg = "#7f2fFF", fg = "#000000", bold = true },
                key = { "p", "P" },
                symbols = { "(", ")", },
            },
            braces =
            {
                hi = { bg = "#Ff8f4F", fg = "#000000", bold = true },
                key = { "b", "B" },
                symbols = { "{", "}", },
            },
            commas =
            {
                hi = { bg = "#FFFF00", fg = "#000000", bold = true },
                key = { "c", "C" },
                symbols = { ",", ";", },
            }
        }
    }
}
```

Each table in `marks` corresponds to a jump group for `sniper`:
 * `hi` set the highlight for that group;
 * `key` set the keys to jump forward and backward in that group;
 * `symbols` represent the list of symbols that will be matched by that group.

Feel free to set your own custom groups

Then just call `:SniperEnter` or make your own keybindings:
```
vim.keymap.set("n", "w", function ()
    local sniper = require("sniper")
    sniper.mode.sniper_mode_enter(sniper)
end)

-- Sniper also works in visual mode!
vim.keymap.set({"n", "v"}, "w", function ()
    local sniper = require("sniper")
    sniper.mode.sniper_mode_enter(sniper)
end)
```

# Plans

I plan to add more features to `sniper`. The main goal is to allow custom search and selection rules, eventually based on tree-sitter.

# License

This project is licensed under the MIT license.
