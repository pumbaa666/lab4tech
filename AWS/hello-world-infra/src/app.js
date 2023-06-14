const http = require('http');

console.log("Starting webserver");

// https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/environments-cfg-softwaresettings.html#environments-cfg-softwaresettings-accessing
const PORT = process.env.NODEJS_PORT || 1337;
const VERSION = process.env.WEBAPP_VERSION || "0.0.0";
console.log("PORT : "+PORT)

// Start a webserver on port 1337
http.createServer((request, response) => {
    
    // 1. Tell the browser everything is OK (Status code 200), and the data is in plain text
    response.writeHead(200, {
        'Content-Type': 'text/html'
    });

    // 2. Write the announced text to the body of the page
    response.write("<html><body>" +
        "<font color = 'lightgreen' size = 40>It works!</font><br/><br/>" +
        "WEBAPP_VERSION : " + VERSION + "<br><br>" +
        "<img src = \"https://media1.giphy.com/media/TmT51OyQLFD7a/giphy.gif?cid=ecf05e47p45gq3fnf4ezz5pamrk58tgwmekgs1w1ozcag95t&ep=v1_gifs_search&rid=giphy.gif&ct=g\"/>"+
        "</body></html>");

    // 3. Tell the server that all of the response headers and body have been sent
    response.end();

}).listen(PORT); // 4. Tells the server what port to be on

console.log("Webserver started on http://localhost:" + PORT);