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
    for i = 1, #res-15, 120 do
        if cache and (res[i].value - res[i+3].value)^2 < 2 and (res[i+10].value - res[i+15].value)^2 < 2 then
            if cache ~= res[i+14].value then
                cache = res[i].value;
                goto continue_analy;
            end
            gg.clearResults();
            gg.searchNumber((res[i].value-1).."~"..res[i].value+1, 4, false, 536870912, res[i].address-0x500, res[i].address+0x6400);
            local startad = gg.getResults(1)[1].address;
            gg.clearResults();
            gg.searchNumber("0~10", 4, false, 536870912, res[i].address, res[i].address+0x6400);
            local endad = gg.getResults(1)[1].address-0x4;
            local num = (endad - startad)/3;
            local function A(minad, maxad)
                gg.clearResults();
                gg.searchNumber("0~~0", 4, false, 536870912, minad, maxad);
                return gg.getResults(maxad-minad);
            end
            char = {A(startad, startad+num), A(startad+num+0x4, endad), A(endad+0x4, endad+num)};
            break;
        end
        cache = -1;
        ::continue_analy::
    end
end

return base or "err";
