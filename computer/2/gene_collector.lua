local json = require "lib/json"
local vars = require "lib/constants"
local whi = require "lib/whi"
local net = require "lib/network"
local sc = require "lib/sc"

-- local combs_source = 'enderstorage:ender_chest_5'
local indexer = 'productivebees:gene_indexer'
local genes = 'productivebees:gene'

function LoadIndexer()
    local indexers = net.ListMatchingDevices(indexer)
    local genes_found = 0

    for _, ind in pairs(indexers) do
        --genes_found = genes_found + whi.GetFromAnyWarehouse(false, genes, ind, 64)
        genes_found = genes_found + sc.pull(genes, 64, true, ind)
    end
    
    if genes_found > 0 then print(genes_found, 'genes indexed') end
end

while true do
    pcall(LoadIndexer)
    sleep(10)
end
