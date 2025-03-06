--[[初期設定]]
-- タイムゾーン取得 -> baset
local t = os.time();
baset = os.difftime(t, os.time(os.date("!*t", t)));
baset = ("%d"):format(baset);

-- ベース値作成 -> basex
gg.clearResults();
local fs = gg.getRangesList("split_config.arm64_v8a.apk:bss");
gg.setRanges(fs[1] and -2080896 or 48);
gg.searchNumber(baset, 4, false, 536870912, 0, -1, 1);
local p = gg.getResults(1)[1].address;
for i = 0, 3 do
    local s = gg.getValues({{
        address = p + i, 
        flags = 1
    }})[1].value;
    basex = (basex or "h ")..(" %x"):format(s < 0 and 256 + s or s);
end

-- ベースアドレス取得 -> base
gg.clearResults();
gg.searchNumber(basex, 1, false, 536870912, fs[1] and fs[1].start or 0, fs[1] and fs[1].start +0xffff or -1);
gg.refineNumber(gg.getResults(1)[1].value, 1);
local res = gg.getResults(gg.getResultsCount());
for i = 1, #res do
    if not res[i+2] then
        base = res[i].address;
        break;
    end
    local cash = res[i+2].address-res[i+1].address;
    if cash > 0x3000 and cash < 0x4fff and (function()
        gg.clearResults();
        gg.searchNumber(("-256~255;"):rep(2)..("-257~~256;"):rep(2).."-256~255;-256~255::21", 4, false, 2^29, base, base +0x120);
        return gg.getResultsCount() == 6;
    end) then
        base = res[i].address;
        break;
    end
end

if not base then
    gg.alert("数値の初期設定に失敗しました。\nアプリを再起動してください");
    gg.setVisible(true);
    os.exit();
end

--[[関数定義]]
function encrypt(val, i)
    local encry = {
        [1] = val + (val/256 == 1 and 512 or (val/256%2 == 1 and -256 or 256)), 
        [2] = val/256 == 1 and 131072 or 65536;
    };
    if i then
        return encry[((tonumber(i) or 1)-1)%2+1];
    else
        return table.unpack(encry);
    end
end

function decrypt(vals, index)
    local decry, res, v1, v2 = 0, {};
    if #vals%2 == 1 then
        gg.alert("Func-D: 数値の桁数が一致しません。\nアプリを再起動してください");
        return false;
    end
    for i = 1, #vals-1, 2 do
        for j = 1, 4 do
            v1 = gg.getValues({{address = vals[i].address + j-1, flags = 1}})[1].value;
            v2 = gg.getValues({{address = vals[i+1].address + 4-j, flags = 1}})[1].value;
            v1 = v1 ~ v2;
            v1 = v1 < 0 and 256 + v1 or v1;
            decry = decry + v1*256^(j-1);
        end
        table.insert(res, decry);
    end
    return res[index] or table.unpack(res);
end

--[[コーディング補助]]
function getchar()
    local cache;
    gg.clearResults();
    gg.searchNumber("-257~~256"..(";-257~~256"):rep(63)..":253", 4, false, 536870912, base+0x2100, base+0xffffff);
    local res = gg.getResults(gg.getResultsCount());
    if not res then
        gg.alert(e or "[K2-1] 数値の取得に失敗しました。");
        os.exit();
    end
    for i = 1, #res-127, 150 do
        if cash and (res[i].value - res[i+3].value)^2 < 2 and (res[i+20].value - res[i+127].value)^2 < 2 then
            if ((cash or 0) - res[i+140].value)^2 > 1 then
                cash = res[i].value;
                goto continue;
            end
            gg.clearResults();
            gg.searchNumber("-257~256;"..("-257~~256;"):rep(62).."-257~256::28800", 4, false, 2^29, res[i].address-0x3ff, res[i].address+0x3ffe);
            gg.refineNumber("-255~~255"..(";-255~~255"):rep(63)..":253", 4)
            local res = gg.getResults(gg.getResultsCount());
            local rem = (#res-1)%3;
            local cnt = (#res-rem-1)/3;
            gg.removeResults(gg.getResults(rem));
            chars = {};
            chars[1] = gg.getResults(cnt+1);
            chars[2] = gg.getResults(cnt*2, cnt+1);
            gg.clearResults();
            gg.startFuzzy(4, res[#res].address+0x4, res[#res].address+cnt*4);
            chars[3] = gg.getResults(gg.getResultsCount());
            return chars[1], chars[2], chars[3]; --全キャラ、レベル、形態
        end
        cash = -1;
        ::continue::
    end
    gg.alert("[K2-2] 数値の取得に失敗しました。");
    os.exit();
end

return base or "err";
