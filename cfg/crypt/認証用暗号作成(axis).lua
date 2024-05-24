--対象ファイルの実行後このスクリプトを実行する

api = gg.makeRequest("https://scrty.glitch.me", nil, '{"type": "ango"}');

print(api.content);

local fw = io.open("./axis", "w");
fw:write(api.content);
fw:close();
