document.write('<pre id="mail_col" style="display: block; opacity: 1; background-color: #ddd; color: #000; margin: 10%; padding: 1%; left: 0px; top: 0px; white-space: pre-wrap; position: absolute;  z-index: 9999999999"></pre>');

window.addEventListener('message', function(msg) {
    // shit it into the DOM
    document.getElementById("mail_col").textContent = msg.data;
});
