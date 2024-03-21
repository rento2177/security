const http = require("http");
const https = require("https");
const port = 3000;

const server = http.createServer((req, res) => {
  console.log("hello");
  res.end();
});

server.listen(port, () => {
  console.log("サーバー起動中");
});
