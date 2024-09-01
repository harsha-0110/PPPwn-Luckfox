function getPayload(payload, onLoadEndCallback) {
  const req = new XMLHttpRequest();
  req.open("GET", payload);
  req.responseType = "arraybuffer";
  req.onload = (event) => onLoadEndCallback && onLoadEndCallback(req, event);
  req.send();
}

function sendPayload(url, data, onLoadEndCallback) {
  const req = new XMLHttpRequest();
  req.open("POST", url, true);
  req.onload = (event) => onLoadEndCallback && onLoadEndCallback(req, event);
  req.send(data);
}

function injectPayload(file) {
  if (file.endsWith(".bz2")) {
    loadPayloadBZ2(file);
  } else {
    loadPayload(file);
  }
}

function loadPayload(file) {
  const statusUrl = "http://127.0.0.1:9090/status";
  const payloadUrl = "http://127.0.0.1:9090";
  const req = new XMLHttpRequest();
  req.open("POST", statusUrl);
  req.onerror = () =>
    alert("Cannot Load Payload Because The BinLoader Server Is Not Running");
  req.onload = () => {
    const responseJson = JSON.parse(req.responseText);
    if (responseJson.status === "ready") {
      getPayload(file, (req) => {
        if ((req.status === 200 || req.status === 304) && req.response) {
          sendPayload(payloadUrl, req.response, (req) => {
            progress.innerHTML =
              req.status === 200 ? "Payload Loaded" : "Cannot send payload";
          });
        }
      });
    } else {
      alert("Cannot Load Payload Because The BinLoader Server Is Busy");
    }
  };
  req.send();
}

function loadPayloadBZ2(file) {
  const statusUrl = "http://127.0.0.1:9090/status";
  const payloadUrl = "http://127.0.0.1:9090";
  var req = new XMLHttpRequest();
  req.open("POST", statusUrl);
  req.onerror = () =>
    alert("Cannot Load Payload Because The BinLoader Server Is Not Running");
  req.onload = () => {
    var responseJson = JSON.parse(req.responseText);
    if (responseJson.status == "ready") {
      getPayload(file, (req) => {
        if ((req.status === 200 || req.status === 304) && req.response) {
          let payloadData = new Uint8Array(req.response);
          try {
            payloadData = bzip2.simple(bzip2.array(payloadData));
          } catch (error) {
            throw error;
          }
          sendPayload(payloadUrl, payloadData.buffer, (req) => {
            progress.innerHTML =
              req.status === 200 ? "Payload Loaded" : "Cannot send payload";
          });
        }
      });
    } else {
      alert("Cannot Load Payload Because The BinLoader Server Is Busy");
      return;
    }
  };
  req.send();
}
