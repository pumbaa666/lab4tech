const http = require('http');

const PORT = 1337;

console.log("Starting webserver");

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