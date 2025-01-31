local lib_files = {
    "json.lua",
    "tsdb.lua",
    "sc.lua"
}
print("removing old sc library files")
for _, lib_file in pairs(lib_files) do
    print("lib/" .. lib_file)
    fs.delete("lib/" .. lib_file)
end
print("copying new sc library files")
for _, lib_file in pairs(lib_files) do
    print("disk/" .. lib_file .. " -> " .. "lib/" .. lib_file)
    fs.copy("disk/" .. lib_file, "lib/" .. lib_file)
end
