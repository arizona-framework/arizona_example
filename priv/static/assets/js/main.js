/*global arizona*/
'use strict';

const connectParams = {};
arizona.connect(connectParams, (connected) => {
  if (connected) {
    console.info("[Client] I'm connected =)");
  } else {
    console.info("[Client] I'm disconnected =(");
  }
});

arizona
  .event("broadcast:incr", "app")
  .handle((count) => {
    console.log("[incr] Received:", count)
  })
  .join()
  .then((payload) => {
    console.info("[incr] Joined =)", payload)
  })
  .catch((reason) => {
    console.error("[incr] Not joined =(", reason)
  })
