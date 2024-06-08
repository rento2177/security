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
        local res = gg.getResults(gg.getResultsCount());
        if not editval and #res ~= 0 then
            return res;
        elseif #res == 0 then
            return false, "[K1 forDeveloper] 数値が見つかりませんでした。";
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
    if chars then return chars[1], chars[2], chars[3];end
    gg.toast("解析開始", true);
    local cash;
    local res, e = K(62, base+0x2100, 0xfdeff);
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
                res, cash = K(62, base+0x2100, 0xfdeff), cash;
                goto continue;
            end
            chars = {};
            chars[1] = gg.getResults(cnt+1, 2);
            chars[2] = gg.getResults(cnt*2, cnt+3);
            gg.clearResults();
            gg.startFuzzy(4, res[#res].address+0x4, res[#res].address+cnt*4, 0);
            chars[3] = gg.getResults(gg.getResultsCount());
            return chars[1], chars[2], chars[3]; --全キャラ、レベル、形態
        end
        ::continue::
    end
    gg.alert("[K2-2] 数値の取得に失敗しました。");
    os.exit();
end

function Ticket()    --不具合があればK(2, ...)で判別
    gg.clearResults();
    gg.searchNumber("32400", 4, false, 536870912, base+0x200000, base+0xffffff);
    local cash = K(4, gg.getResults(2)[2].address, 0xfff);
    if not cash then return gg.alert("[チケット] 数値の特定に失敗しました。");end
    local cnt = gg.getResultsCount();
    return gg.getResults(2, cnt-4), gg.getResults(2, cnt-2);
end

--[[基礎メニュー]]
function p22(v)
    cash = K(2, base, -0x310, v, "猫缶");
    if not cash then return gg.alert("[猫缶] 数値の特定に失敗しました。");end
    gg.toast("猫缶成功", true);
end

function p24(v)
    cash = K(4, base, 0x210);
    if not cash then return gg.alert("[XP] 数値の特定に失敗しました。");
    elseif v == "" then
        return gg.alert("[XP] 変更値の取得に失敗しました。");
    end
    K(0, {cash[1], cash[2]}, true, v, "XP");
    gg.toast("XP成功", true);
end

function p26(v)
    cash = Ticket();
    if not cash then return gg.alert("[通常チケット] 数値の特定に失敗しました。");
    elseif v == "" then
        return gg.alert("[通常チケット] 変更値の取得に失敗しました。");
    end
    K(0, cash, true, v, "通常チケット");
    gg.toast("通常チケ成功", true);
end

function p28(v)
    _, cash = Ticket();
    if not _ then return gg.alert("[レアチケット] 数値の特定に失敗しました。");
    elseif v == "" then
        return gg.alert("[レアチケット] 変更値の取得に失敗しました。");
    end
    K(0, cash, true, v, "レアチケット");
    _ = nil;
    gg.toast("レアチケ成功", true);
end

function p29()  --範囲Oで動くか不明
    gg.clearResults();
    gg.searchNumber("3200;4400;1~2147483647::29", 4, false, 536870912, base, base+0xffffff);
    if gg.getResultsCount() < 4 then return gg.alert("試合中に実行してください。");end
    gg.addListItems({{
        address = gg.getResults(1, gg.getResultsCount()-1)[1].address, 
        name = "敵城", 
        freeze = true, 
        flags = 4, 
        value = 0;
    }});
    gg.toast("即勝利成功", true);
end

function p210()
    cash = K("61:5000", base+0x210, 0x2000);
    if not cash then return gg.alert("[ステージ開放] 数値の特定に失敗しました。");end
    gg.getResults(11);
    gg.editAll("304"..(";304"):rep(9)..";256", 4);
    gg.getResults(520, 11);
    gg.editAll("257"..(";257"):rep(47)..(";256"):rep(4), 4);    --差がクリア数
    gg.toast("ステ解放成功", true);
end

--[[需要メニュー]]
function p31()
    cash = K2();
    if not cash then return gg.alert("[全キャラ] 数値の特定に失敗しました。");end
    gg.loadResults(cash);
    gg.getResults(#cash-1);
    gg.editAll(cash[1].value, 4);
    gg.toast("全キャラ成功", true);
end

function p33(v)
    _, cash = K2();
    if not cash then return gg.alert("[全レベル] 数値の特定に失敗しました。");
    elseif v == "" then
        return gg.alert("[全レベル] 変更値の取得に失敗しました。");
    end
    local lv, plus = v:match("([0-9]+)(.*)");
    lv, plus = tonumber(lv), tonumber(plus);
    gg.loadResults(cash);
    K(0, cash, true, ((lv > 0 and lv or 1)-1)*65536+(plus or 0), "キャラレベル");
    gg.toast("レベル成功", true);
end

function p35(v)
    local _, lv, form = K2();
    local info = gg.makeRequest("https://battlecats-db.com/unit/frm_final.html").content;
    if not form then return gg.alert("[全形態] 数値の特定に失敗しました。");
    elseif v == "" then
        return gg.alert("[全形態] 変更値の取得に失敗しました。");
    end
    for i = 1, #form do
        local n = info:match("<td>"..("%03d"):format(i).."%-([0-6])</td>");
        v, n = tonumber(v), tonumber(n);
        if n then
            cash = v < n and v or n;
            gg.setValues({{
                address = form[i].address, 
                flags = 4, 
                value = cash-1
            }});
        end
    end
    gg.toast("形態成功", true);
end

function p37()
    
end

function p38()
    local info = gg.makeRequest("https://battlecats-db.com/unit/r_all.html").content;
    local char = K2();
    if not char then return gg.alert("[エラーキャラ] 数値の特定に失敗しました。");end
    for i = 1, #char-1 do
        if not info:find("<td>"..("%03d"):format(i).."</td>") or i == 674 then
            char[i].value = char[#char].value;
            gg.setValues({char[i]});
        end
    end
    gg.toast("エラキャラ成功", true);
end

function p310(v)

end

function p312(v)
    cash = K(4, base, 0x210);
    if not cash then return gg.alert("[NP] 数値の特定に失敗しました。");
    elseif v == "" then
        return gg.alert("[NP] 変更値の取得に失敗しました。");
    end
    K(0, {cash[3], cash[4]}, true, v, "NP");
    gg.toast("NP成功", true);
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
    gg.alert([[＊利用規約＊

    ・スクリプトの復号禁止

    ・二次配布、転売及びソースの抜き出し禁止

    ・サーバーへの攻撃的なアクセス禁止

以上の規約に違反した場合は利用を停止させて頂きます。
詳細はサポートサーバーにてご確認ください。]]);
end

function p52()
    local mp52 = gg.choice({
        "Number式(標準)", 
        "Seekbar式"
    }, typea == "number" and 1 or 2, "入力形式の設定");
    if mp52 then
        typea = mp52 == 1 and "number" or "seekbar";
        local fw = io.open(path.."inputType.lua", "w");
        fw:write("return \""..(mp52 == 1 and "number" or "seekbar").."\";");
        fw:close();
        gg.toast("再実行すると反映されます");
    end
end
