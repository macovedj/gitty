// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"

import renderCollaborator from "./collaborator"

window.onerror = function (msg, url, lineNo, columnNo, error) {
    fetch("/api/reporterror", {
        method: "POST",
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            name: error.name,
            message: error.message,
            stack: error.stack,
        }),
    })

    return false;
}

const collaborator = document.getElementById("collaborator");
if (collaborator) {
    renderCollaborator(collaborator);
}
