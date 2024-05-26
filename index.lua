path = "/sdcard/ggsx/";

::setup::
local fr = io.open(path.."id.txt", "r");
if fr then
    fr:close();
    pjtName = gg.makeRequest("https://scrty.netlify.app/cfg/projectName").content;
    if not pjtName then
        print("ネットに接続してください。");
        gg.setVisible(true);
        os.exit();
    elseif v0 ~= gg.makeRequest("https://scrty.netlify.app/index.lua").content then
        gg.toast("スクリプトを修正します");
        gg.sleep(1000);
        local fw = io.open(gg.getFile():match("[^/]+$"), "w");
        fw:write(gg.makeRequest("https://scrty.netlify.app/index.lua").content);
        fw:close();
        dofile(gg.getFile():match("[^/]+$"));
        os.exit();
    end
    pjtName = pjtName:gsub("\n", "");

    --プログラム認証
    gg.toast("認証を開始");
    local auth = gg.makeRequest("https://"..pjtName..".glitch.me", nil, '{"type": "Auth", "pro": "'..(function(fr, str)
        fr = io.open(gg.getFile(), "r");
        local fr = io.open(gg.getFile(), "r");
        local k = fr:read("a");
        local al = {['\b']='9f‍',['\n']='ef‍',['"']='98f‍',[',']='fcf‍',['%.']='113f‍',['\'']='c7d‍',['a']='4b05‍',['b']='4c8f‍',['c']='4e1d‍',['d']='4faf‍',['e']='5145‍',['f']='52df‍',['g']='547d‍',['h']='561f‍',['i']='57c5‍',['j']='596f‍',['k']='5b1d‍',['l']='5ccf‍',['m']='5e85‍',['n']='603f‍',['o']='61fd‍',['p']='63bf‍',['q']='6585‍',['r']='674f‍',['s']='691d‍',['t']='6aef‍',['u']='6cc5‍',['v']='6e9f‍',['w']='707d‍',['x']='725f‍',['y']='7445‍',['z']='762f‍',['=']='761f‍',[';']='adf'}
        for i, v in pairs(al) do k = k:gsub(i, v);end
        return k;
    end)()..'"}');
    if type(auth) ~= "table" or auth ~= 200 then
        gg.alert("サーバーが停止しています。\n復旧には数分以上掛かる場合があります。");
        gg.setVisible(true);
        os.exit();
    elseif auth.content:find("Access Filter") then
        local fw = io.open(gg.getFile():match("[^/]+$"), "w");
        fw:write(gg.makeRequest("https://scrty.netlify.app/index.lua").content);
        fw:close();
        gg.alert(auth.content);
        print("自己修正機能により補正されました。");
        gg.setVisible(true);
        os.exit();
    end

    --ggsx導入
    local fw = io.open("./cash(x4.1).lua", "w");  --特殊ID
    fw:write(gg.makeRequest("https://"..pjtName..".glitch.me", nil, '{"type": "ggsx", "id": "'..auth.content..'"}').content);
    fw:close();
    ggsx = dofile("./cash(x4.1).lua");
    os.remove("./cash(x4.1).lua");
    ggsx.logCatch(nil, true);

    --サーバーにリクエスト
    cerid = gg.makeRequest("https://"..pjtName..".glitch.me", nil, '{"type": "setup", "cerid": "'..cerid..'",  "id": "'..ggsx.id..'"}');
    if cerid.content:find("Access Filter") then
        gg.alert(cerid.content);
        gg.setVisible(true);
        os.exit();
    end
    local se = gg.makeRequest("https://"..pjtName..".glitch.me", nil, '{"type": "execute", "cerid": "'..cerid.content..'",  "id": "'..ggsx.id..'"}');
    if se.content:find("Access Filter") then
        gg.alert(se.content);
        gg.setVisible(true);
        os.exit();
    end
    gg.toast("認証に成功");
    local bol, re = xpcall(ggsx.logGuard(se.content), function(e)
        if not e:find("os.exit") then
            gg.makeRequest("https://"..pjtName..".glitch.me", nil, '"Import Error": ID: '..ggsx.id..'\n\n'..e);
            gg.alert("予期しないエラーが発生したためスクリプトを終了します。");
        end
    end);
    if not bol and type(re) == "table" then  --dtc("猫缶");などの関数を作る返り値は配列　人的エラー
        gg.alert(re[1].."でエラーが発生しましたためスクリプトを終了します。");
        gg.makeRequest("https://"..pjtName..".glitch.me", nil, '"Import Error": ID: '..ggsx.id..'\n\n'..re[2]);
    end
    gg.setVisible(true);
else
    local id = gg.prompt({"IDを入力してください。"}, nil, {"text"});
    if id and id[1] ~= "" then
        gg.saveList(path.."id.txt");
        local fw = io.open(path.."id.txt", "w");
        fw:write(id[1]);
        fw:close();
        goto setup;
    else
        print("IDを入力してください。");
        gg.setVisible(true);
        os.exit();
    end
end
