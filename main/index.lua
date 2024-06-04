print(gg.getFile():match("[^/]+$"));
local fr = io.open(gg.getFile():match("[^/]+$"), "r");
print(fr:read("a"));
fr:close();
