local onoremap = require("eckon.utils").onoremap
local xnoremap = require("eckon.utils").xnoremap

-- custom textobject for indentations
onoremap("ii", ':lua require("eckon.custom.textobjects").indent_inner_textobject()<CR>')
xnoremap("ii", ':<C-u>lua require("eckon.custom.textobjects").indent_inner_textobject()<CR>')
onoremap("ai", ':lua require("eckon.custom.textobjects").indent_around_textobject(true)<CR>')
xnoremap("ai", ':<C-u>lua require("eckon.custom.textobjects").indent_around_textobject(true)<CR>')
onoremap("aI", ':lua require("eckon.custom.textobjects").indent_around_textobject()<CR>')
xnoremap("aI", ':<C-u>lua require("eckon.custom.textobjects").indent_around_textobject()<CR>')
