const http = require('http');

const PORT = 1337;

console.log("Starting webserver");

// https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/environments-cfg-softwaresettings.html#environments-cfg-softwaresettings-accessing
const PORT_FROM_CONFIG = process.env.NODEJS_PORT; // TODO fix ! I got nothing.
console.log("process.env : "+process.env)
console.log("PORT_FROM_CONFIG : "+PORT_FROM_CONFIG)

// Start a webserver on port 1337
http.createServer((request, response) => {
    
    // 1. Tell the browser everything is OK (Status code 200), and the data is in plain text
    response.writeHead(200, {
        'Content-Type': 'text/plain'
    });

    // 2. Write the announced text to the body of the page
    response.write("It works!");

    // 3. Tell the server that all of the response headers and body have been sent
    response.end();

}).listen(PORT); // 4. Tells the server what port to be on

console.log("Webserver started on http://localhost:" + PORT);