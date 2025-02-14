local json = require "lib/json"
local vars = require "lib/constants"
local whi = require "lib/whi"

local indexer = 'productivebees:gene_indexer_0'
local genes = 'productivebees:gene'

function LoadIndexer()
    local genes_found = 0
    genes_found = genes_found + whi.GetFromAnyWarehouse(false, genes, indexer, 64)
    if genes_found > 0 then print(genes_found, 'genes indexed') end
end

while true do
    if not pcall(LoadIndexer) then print('LoadIndexer() failed to complete') end
    -- LoadIndexer()
    sleep(120)
end