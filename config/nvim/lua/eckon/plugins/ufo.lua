require('ufo').setup()

local nnoremap = require('eckon.utils').nnoremap

nnoremap('zM', require('ufo').closeAllFolds)
nnoremap('zR', require('ufo').openAllFolds)
nnoremap('zm', require('ufo').closeFoldsWith)
nnoremap('zr', require('ufo').openFoldsExceptKinds)
