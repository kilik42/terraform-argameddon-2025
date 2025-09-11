const http = require('http');
const PORT = process.env.PORT || 8080;
const MSG = process.env.MSG || 'App 2 says hello 👋';
http.createServer((req,res)=>{
  res.writeHead(200, {'Content-Type':'text/plain'});
  res.end(MSG + '\n');
}).listen(PORT);
console.log(`Listening on port ${PORT}`);