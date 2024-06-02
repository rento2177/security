local domain = gg.makeRequest("https://scrty.netlify.app/cfg/projectName");
local source = gg.makeRequest("https://scrty.netlify.app/main/index.lua");
local func = gg.makeRequest("https://scrty.netlify.app/main/func.lua");
local _, type = xpcall(loadfile(path.."inputType.lua"), function(fw)
    fw = io.open(path.."inputType.lua", "w");
    fw:write("return \"number\";");
    fw:close();
    return "number";
end);
--[[
if not ggsx then
    gg.alert("[x4.1] ggsxの読み込みに失敗しました。");
    os.exit();
elseif domain.code ~= 200 then
    ggsx.logCatch("[main.lua] スクリプトの単体実行", false);
    os.exit();
elseif source.code == 200 and (function(fr)
    fr = io.open(gg.getFile():match("[^/]+$"), "r");
    local cash = fr:read("a");
    fr:close();
    return cash;
end)() ~= source.content then
    ggsx.logCatch("[main.lua] プログラム改竄", true);
    os.remove(gg.getFile());
    os.exit();
end
dm = dm:gsub("\n", "");
ggsx.logGuard(co.content);
ggsx.net = true;
]]

function Main()
    local mn1 = gg.choice({
        "基礎メニュー", 
        "需要しかないメニュー", 
        "APIを取得する", 
        "スクリプト設定", 
        "終了する"}, 2024, "れんれん");
    if mn1 then _ENV["mn"..mn1+1]();end
end

function mn2()
    local mn2 = gg.prompt({
        "猫缶 [ON]", 
        "猫缶"..typeb("[0;58999]"), 
        "XP [ON]", 
        "XP"..typeb("[0;999999999]"), 
        "通常チケット [ON]", 
        "通常チケット"..typeb("[0;999]"), 
        "レアチケット [ON]", 
        "レアチケット"..typeb("[0;999]"), 
        "即勝利", 
        "ステージ開放", 
        "メインに戻る"
    }, typec("mn2", {
        [2] = 58000, 
        [4] = 777777777, 
        [6] = 200, 
        [8] = 200
    }), typed(11, {2, 4, 6, 8}));
    if not mn2 then return nil;end
    for i, b in ipairs(mn2) do
        if i == #mn2 then
            if b then Main();end
        elseif b == true then   --チェックボックス真
            execute("p"..i+1);
        elseif typec("mn2")[i-1] == false and tonumber(b) ~= typec("mn2")[i] then
            execute("p"..i);
        end
    end
end

function mn3()
    local mn3 = gg.prompt({
        "全キャラ開放", 
        "全キャラレベル [ON]", 
        "レベル変更"..typeb("[0;999]"), 
        "全キャラ形態 [ON]", 
        "形態変更"..typeb("[1;4]"), 
        "指定キャラまとめ", 
        "エラーキャラ削除", 
        "お宝解放", 
        "NP [ON]", 
        "NP"..typeb("[0;99999]"), 
        "アイテム [ON]", 
        "アイテム"..typeb("[0;9999]"), 
        "キャッツアイ [ON]", 
        "キャッツアイ"..typeb("[0;999]"), 
        "ネコビタン [ON]", 
        "ネコビタン"..typeb("[0;999]"), 
        "城の素材 [ON]", 
        "城の素材"..typeb("[0;999]"), 
        "メインに戻る"
    }, {
        [3] = 20, 
        [5] = 2, 
        [10] = 2000, 
        [12] = 2000, 
        [14] = 200, 
        [16] = 200, 
        [18] = 200
    }, typed(19, {3, 5, 10, 12, 14, 16, 18}));


end

function mn4()

end

function mn5()
    local mn5 = gg.choice({
        "利用規約", 
        "入力形式の変更", 
        "スクリプト再起動", 
        "メインに戻る"}, 2024, "れんれん");


end

function mn6()
    gg.setRanges(rest.ranges);
    gg.loadResults(rest.values);
    print("制作者: 蓮斗");
    os.exit();
end

function typeb(rge)
    return type == "number" and "" or rge;
end

function typec(name, tbl)
    if not tbl then return page[name];end
    page[name] = tbl;
    return tbl;
end

function typed(len, tbl)
    local n, cash = 1, {};
    for i = 1, len do
        cash[i] = tbl[n] == i and "number" or "checkbox";
        n = cash[i] == "number" and n + 1 or n;
    end
    return cash;
end

function execute(_FUNC, _ARGU, cash)
    xpcall(function()_ENV[_FUNC](_ARGU);end, function(e)
        gg.alert("関数: ".._FUNC.."(".._ARGU..") でエラーが発生しましたため実行をスキップします。");
        gg.makeRequest("https://"..pjtName..".glitch.me", nil, '"Import Error": ID: '..ggsx.id..'\n関数名: '.._FUNC..'('.._ARGU..')\n\n'..e:gsub(0, 200));
        return false;
    end);
    return true;
end

::start::
page = nil;
rest = {["ranges"] = gg.getRanges(), ["values"] = gg.getResults(20)};
if not pcall(function()ggsx.logGuard(func.content)();end) then
    gg.alert("関数の読み込みに失敗しました。");
    mn6();
end
--ベース値設定

while true do
    if gg.isVisible() or not page then
        gg.setVisible(false);
        page = page or {};
        Main();
    end
end
