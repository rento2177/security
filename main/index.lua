local fr = io.open(gg.getFile():match("[^/]+$"), "r");
    local cash = fr:read("a");
    fr:close();
print("通過", cash);
