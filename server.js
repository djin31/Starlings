const express = require('express');
const app = express();

const PORT = 4100;

// Static Content
app.use(express.static('static'));

// Defining routes
app.get('/', function (req, res) {
    res.sendFile(__dirname + '/templates/index.html');
});

app.listen(PORT, function () {
    console.log('App running. Visit http://localhost:' + PORT);
})