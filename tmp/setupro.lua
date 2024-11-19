--[[初期設定]]
gg.setVisible(false);
gg.clearResults();
local fs = gg.getRangesList("split_config.arm64_v8a.apk:bss");
gg.setRanges(fs[1] and -2080896 or 48);
gg.searchNumber("h 90 7E 00 00", 1, false, 536870912, fs[1] and fs[1].start or 0, fs[1] and fs[1].start + 0xffff or -1);
gg.refineNumber("h 90", 1);
local res = gg.getResults(gg.getResultsCount());
for i = 1, #res-2 do
    local offs = res[i+2].address-res[i+1].address;
    if offs > 0x3000 and offs < 0x4fff and (function()
        gg.clearResults();
        gg.searchNumber("-256~255;"..("-257~~256;"):rep(2).."-256~255::13", 4, false, 536870912, res[i].address, res[i].address+0x72);
        return gg.getResultsCount() ~= 0;
    end)() then
        base = res[i].address;
        gg.toast("ベース成功", true);
        break;
    end
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
        return gg.alert("【D1】アプリを再起動してください");
    end
    for i = 1, #vals-1, 2 do
        for j = 1, 4 do
            v1 = gg.getValues({{address = vals[i].address + j-1, flags = 1}})[1].value;
            v2 = gg.getValues({{address = vals[i+1].address + 4-j, flags = 1}})[1].value;
            v1 = v1 ~ v2;
            v1 = v1 < 0 and 256 + v1 or v1;
            decry = decry + v1*256^(j-1);
        end
        table.insert(res, tostring(decry));
    end
    if not index then
        return table.unpack(res);
    else
        return res[index];
    end
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
