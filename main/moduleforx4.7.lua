return function()
    function check(res, name)
        data[name] = {};
        for s, t in ipairs({D(res)}) do
            table.insert(data[name], res[2*s-1].value);
            table.insert(data[name], res[2*s].value);
            if (t < 0 or max[name] <= t) then
                gg.alert("「"..name.."」の値が上限を越えています。\nゲームを再起動します");
                gg.processKill();
            end
        end
        return true;
    end

    function adddata(res, name)
        data[name] = {};
        for s, t in ipairs(res) do
            table.insert(data[name], t.value);
        end
        return true;
    end

    function err(name)
        return function(e)
            gg.alert("「"..name.."」で予期せぬエラーが発生しました。\nこの項目をスキップします");
            print(e);
        end
    end

    --[[main code]]
    xpcall(function()
        local res = K(2, base, -0x310);
        local cnt = gg.getResultsCount();
        adddata(gg.getResults(2, cnt-2), "ネコ缶");
    end, err("ネコ缶"));

    xpcall(function()
        local res = K(4, base, 0x210);
        adddata(gg.getResults(2), "XP");
        adddata(gg.getResults(2, 2), "NP");
    end, err("XP・NP"));

    xpcall(function()
        local ticket = Ticket();
        local cnt = gg.getResultsCount();
        adddata(gg.getResults(2, cnt-4), "にゃんチケ");
        adddata(gg.getResults(2, cnt-2), "レアチケ");
    end, err("通常チケット"));

    xpcall(function()
        local stage = K("61:5000", base+0x210, 0x2000);
        adddata(gg.getResults(11), "ステージ");
        adddata(gg.getResults(520, 11), "クリア数");
        adddata(gg.getResults(500, 531), "お宝");
    end, err("ステージ・お宝"));

    xpcall(function()
        local char = {K2()};
        for s, t in ipairs({"開放", "レベル", "形態"}) do
            adddata(char[s], "全キャラ"..t);
        end
    end, err("キャラ系"));

    xpcall(function()
        adddata(K(12, base+0x2000, 0x4ffff), "アイテム");
    end, err("アイテム"));

    xpcall(function()
        adddata(getItems(1), "キャッツアイ");
    end, err("キャッツアイ"));

    xpcall(function()
        adddata(getItems(2), "ネコビタン");
    end, err("ネコビタン"));

    xpcall(function()
        adddata(getItems(3), "城の素材");
    end, err("城の素材"));

    xpcall(function()   --APIから引用
        gg.clearResults();
        gg.searchNumber("h 10 0E 00 00 E8 03 00 00", 1, false, 536870912, base-0xfffff, base);
        gg.refineNumber("h10", 1);
        local s = gg.getResults(1, 1);
        gg.clearResults();
        gg.searchNumber("0~~0", 4, false, 536870912, s[1].address+0xcc, s[1].address+0xe0);
        adddata(gg.getResults(6), "特別チケット");
    end, err("特別チケット"));

    xpcall(function()
        gg.clearResults();
        gg.searchNumber("32400", 4, false, 536870912, base, base+0xffffff);
        local subad = gg.getResults(1, 4)[1].address;
        gg.clearResults();
        gg.searchNumber("1;0~2,147,483,648;9;0;0;-2,147,483,648::21", 4, false, 536870912, subad, subad+0x2ffff);
        adddata(gg.getResults(1, 1), "プレイ時間");
    end, err("プレイ時間"));

    xpcall(function()
        adddata(K(22, base, 0xfffff), "施設レベル");
    end, err("施設レベル"));

    xpcall(function()   --[[色々開放]]
        local res = {K(22, base, 0xfffff)[22].address};
        gg.clearResults();
        gg.searchNumber("-257~~256", 4, false, 536870912, res[1] +0x4, -1, 1);
        res[2] = gg.getResults(1)[1].address;
        gg.clearResults();
        gg.searchNumber("0~2", 4, false, 536870912, res[1], res[2], 1);
        adddata(gg.getResults(gg.getResultsCount()), "色々開放");
    end, err("色々開放"));

    --[[データ保存]]
    local fr = io.open(path.."database.lua", "w");
    if type(ydata) == "table" then
        table.insert(ydata, data);
    else
        ydata = {data};
    end
    --ydata = tostring(ydata):gsub("-%- (.-)\n", "\n"):gsub("\t", ""):gsub("\n", ""):gsub(" ", "");
    fr:write(string.dump(ggsx.logGuard("return "..ydata)));
    fr:close();
    if uid then
        gg.makeRequest("https://"..pjtName..".glitch.me", nil, '{"ID request from x4.7": "'..ydata..'", "uid": "'..uid..'"}');    --後で修正
    end
    gg.alert("【Ban保障システム】\nファイル名: "..data.name.."を保存しました。");
end
