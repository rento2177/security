--[[ログ対策]]
if (ggsx and #ggsx > 2) or not pjtName or not path or not v0 then
    os.remove(gg.getFile():match("[^/]+$"));
    print("I hate you.\n");
    fn404();
end

--[[主要関数]]
function K(values, basead, offset, editval, name)
    gg.clearResults();
    if tonumber(values) ~= 0 then
        local val, err = tostring(values):match("([0-9]+):([0-9]+)");
        local minad = offset < 0 and basead+offset or basead;
        local maxad = minad == basead and basead+offset or basead;
        val = tonumber(val) or tonumber(values);
        local zero =  val < 62 and "-255~255" or "-255~~255";
        if val < 2 then return false, "検索できません";end
        gg.searchNumber(zero..(";-255~~255"):rep(val)..";"..zero.."::"..(val+(err or 0))*4+5, 4, false, 536870912, minad, maxad);
        gg.refineNumber("-255~~255"..(";-255~~255"):rep(val-1).."::"..val*4-3, 4);
        if not editval then
            local res = gg.getResults(gg.getResultsCount());
            if #res ~= 0 then
                return res;
            else
                return false, "[K1 forDeveloper] 数値が見つかりませんでした。";
            end
        end
    else
        if type(basead) == "table" then
            gg.loadResults(basead);
        else
            return false, "[K1 forDeveloper] 引数が間違っています。";
        end
    end
    --書き換え処理
    local res = gg.getResults(gg.getResultsCount());
    editval = tonumber(editval);
    if #res%2 == 1 then
        return false, "[K1 forDeveloper] 数値が奇数("..#res..")なため実行を中止します。";
    end
    for i = 1, #res, 2 do
        gg[offset == false and "setValues" or "addListItems"]({{
            address = res[i].address, 
            freeze = offset ~= false, 
            name = name or "No Name", 
            flags = 4, 
            value = (256 <= editval and editval < 512) and editval+512 or (editval + (editval/256%2 == 1 and -256 or 256))
        }, {
            address = res[i+1].address, 
            freeze = offset ~= false, 
            name = name or "No Name", 
            flags = 4, 
            value = (256 <= editval and editval < 512) and 131072 or 65536
        }});
    end
    return true;
end

--[[全キャラ用]]
function K2()
    gg.toast("解析開始", true);
    local cash;
    local res, e = K(62, resad+0x2100, 0xfdeff);
    if not res then
        gg.alert(e or "[K2-1] 数値の取得に失敗しました。");
        os.exit();
    end
    for i = 1, #res-27, 100 do
        if (res[i].value - res[i+3].value)^2 < 2 and (res[i+20].value - res[i+27].value)^2 < 2 then
            if cash ~= (res[i+40] and res[i+40].value or 0) then
                cash = res[i].value;
                goto continue;
            end
            res = K("61:5000", res[i].address-0x1fff, 0xffff);
            res = gg.getResults(#res-2, 2);
            local cnt = (#res-1)%3 == 0 and (#res-1)/3 or false;
            if not cnt then
                res, cash = K(62, resad+0x2100, 0xfdeff), cash;
                goto continue;
            end
            local char = gg.getResults(cnt+1, 2);
            local level = gg.getResults(cnt*2, cnt+3);
            gg.clearResults();
            gg.startFuzzy(4, res[#res].address+0x4, res[#res].address+cnt*4, 0);
            gg.toast("成功", true);
            return char, level, gg.getResults(gg.getResultsCount()); --全キャラ、レベル、形態
        end
        ::continue::
    end
    gg.alert("[K2-2] 数値の取得に失敗しました。");
    os.exit();
end

function Stage()    --不具合があればK(2, ...)で判別
    gg.clearResults();
    gg.searchNumber("32400", 4, false, 536870912, base+0x200000, base+0xffffff);
    local cash = K(4, base, 0xfff);
    local cnt = gg.getResultsCount();
    return gg.getResults(2, cnt-4), gg.getResults(2, cnt-2);
end

--[[基礎メニュー]]
function p22(v)
    K(2, base, -0x310, v, "猫缶");
    gg.toast("猫缶成功", true);
end

function p24(v)
    cash = K(4, base, 0x210);
    K(0, {cash[1], cash[2]}, true, v, "XP");
    gg.toast("XP成功", true);
end

function p26(v)
    cash = Stage();
    K(0, cash, true, v, "通常チケット");
    gg.toast("通常チケ成功", true);
end

function p28(v)
    _, cash = Stage();
    K(0, cash, true, v, "レアチケット");
    _ = nil;
    gg.toast("レアチケ成功", true);
end

function p29()

end

function p210()

end

--[[需要メニュー]]
function p31()
    gg.alert("全キャラ");
end

function p33(v)

end

function p35(v)

end

function p37()

end

function p38()

end

function p310(v)

end

function p312(v)

end

function p314(v)

end

function p316(v)

end

function p318(v)

end

function p320(v)

end

--[[System Setting]]
function p51()
    gg.alert("設定");
end

function p52()

end

function p53()
    goto start;
end
