--[[ydataがない場合は新規]]
--[[uidがない場合は無料版]]
local get = gg.makeRequest("https://scrty.netlify.app/main/moduleforx4.7.lua"); --後でバイナリ化するたぶん
local bool, nico = pcall(ggsx.logGuard(get.content));
if not bool then
    gg.alert("モジュールx4.7の読み込みに失敗しました。\n実行を中止します");
    return 0;
end

--[[データ保存]]
function sdata()
    local fr = io.open(path.."database.lua", "w");
    ydata = tostring(ydata):gsub("-%- (.-)\n", "\n"):gsub("\t", ""):gsub("\n", ""):gsub(" ", "");
    fr:write(string.dump(ggsx.logGuard("return "..ydata)));
    fr:close();
    if uid then
        gg.makeRequest("https://"..pjtName..".glitch.me", nil, '{"ID request from x4.7": "'..ydata..'", "uid": "'..uid..'"}');    --後で修正
    end
    gg.alert("【Ban保障システム】\nアカウントデータを更新しました");
end

--[[メニュー表示]]
::Nyanko_x47::
data = {};
local keyword;
local mp7 = gg.choice({
    "アカウントを管理", 
    "アカウントデータを保存", 
    "アカウントデータを復元", 
    "メインに戻る"
}, 2025, "ライセンス名: "..(uid and "Nyanko_x4.7" or "Nyanko_x4.1"));

if not mp7 then
    return 0;
elseif mp7 == 1 then
    if type(ydata) ~= "table" then
        gg.alert("保存しているアカウントはありません");
        goto Nyanko_x47;
    end
    local mp = {{"編集したいアカウントを選択してください"}, {"checkbox"}};
    for s, t in ipairs(ydata) do
        if t.name and t.keyword then
            table.insert(mp[1], "垢名: "..t.name.."\nキーワード: "..table.concat(t.keyword, ", "));
            table.insert(mp[2], "checkbox");
        else
            table.remove(ydata, s);
        end
    end
    local mp8 = gg.prompt(mp[1], nil, mp[2]);
    if not mp8 then
        goto Nyanko_x47;
    end
    local t = {};
    for i = 2, #mp[1] do
        if mp8[i] then
            table.insert(t, i);
        end
    end
    for k, i in ipairs(t) do
        local mp = gg.prompt({"カラーコードを編集", "アカウント名を編集", "キーワードを編集", "アカウントを削除"}, 
        {ydata[i-1].color, ydata[i-1].name, table.concat(ydata[i-1].keyword, ", ")}, 
        {"number", "text", "text", "checkbox"});

        if not mp then
            gg.toast("キャンセル");
        elseif mp[4] then
            table.remove(ydata, i-1);
        else
            ydata[i-1].color = mp[1];
            ydata[i-1].name = mp[2];
            ydata[i-1].keyword = (function()
                local t = {};
                for i in mp[3]:gmatch("[^,]+") do
                    table.insert(t, i);
                end
                return t;
            end)();
            sdata();
        end
    end
    return 0;
elseif mp7 == 2 then
    if not uid and type(ydata) == "table" and 10 < #ydata then
        gg.alert("登録済み垢数が上限に達しました。\n上限を増やすにはx4.7をご購入ください");
        goto Nyanko_x47;
    end
    ::inputname::
    local mp71 = gg.prompt({
        "〇ライセンス別上限\n🈶 Nyanko_x4.1: 10垢(スクリプト付属)\n"..(uid and "🈶" or "🈚").." Nyanko_x4.7: 無制限(別途購入)", 
        "【必須】アカウント名を入力\n現在の登録垢数: "..(ydata and #ydata or 0)..(uid and "" or "/10").."\n\n入力例: 垢➀, rento2177", 
        "【任意】キーワードの設定\n※コンマ(, )で区切ってください。\n\n入力例: 代行用, ネコ缶58999", 
    }, (function()
        return {
            [1] = "#"..("%06x"):format(math.random(0, 256^3-1)), 
            [3] = keyword
        };
    end)(), {"number", "text", "text"});

    if not mp71 then
        gg.toast("キャンセル");
        goto Nyanko_x47;
    elseif mp71[2] == "" then
        gg.alert("アカウント名を入力してください。");
        keyword = mp71[3];
        goto inputname;
    else
        data["color"] = mp71[1];
        data["name"] = mp71[2];
        data["keyword"] = (function()
            local t = {};
            for i in mp71[3]:gmatch("[^,]+") do
                table.insert(t, i);
            end
            return t;
        end)();
    end
    nico();

elseif mp7 == 3 then
    local k;
    ::searchaccounts::
    local mp = gg.prompt({"アカウント名を入力", "キーワード検索", "一覧から選択"}, {[4] = true}, {
        "text", "text", "checkbox"
    });
    if not mp then
        goto Nyanko_x47;
    elseif type(ydata) ~= "table" then
        gg.alert("アカウントが保存されていません");
        goto Nyanko_x47;
    elseif mp[1] ~= "" then
        for s, t in ipairs(ydata) do
            if mp[1] == t.name then
                k = s;
                break;
            end
        end
    end
    if not k and mp[2] ~= "" then
        mp[2] = (function()
            local t = {};
            for i in mp[2]:gmatch("[^,]+") do
                table.insert(t, i);
            end
            return t;
        end)();
        local mp9 = {};
        for _, v in ipairs(mp[2]) do
            for s, t in ipairs(ydata) do

            end
        end
        for s, t in ipairs(ydata) do
            for _, v in ipairs(mp[2]) do
                for _, x in ipairs(t.keyword or {"nonendgasdjadsbhkakh"}) do
                    if x == v then
                        table.insert(mp9, t.name);
                        break;
                    end
                end
            end
        end
        if #mp9 ~= 0 then
            k = gg.choice(mp9, 2025, "復元するアカウントを選択\nキーワード検索の検索結果: "..#mp9.."垢");
        end
    end

    if not k and mp[3] then
        local mp = {};
        for s, t in ipairs(ydata) do
            if t.name and t.keyword then
                table.insert(mp, t.name);
            end
        end
        k = gg.choice(mp, 2025, "復元するアカウントを選択");
    end
    if not k then
        gg.alert("アカウントの特定に失敗しました。\n入力情報が正しいかご確認ください");
        goto searchaccounts;
    end
    nico(k);

elseif mp7 == 4 then
    return Main();
end

--[[初期化]]
data, ydada = nil, nil;
