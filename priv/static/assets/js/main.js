/*global arizona*/
'use strict';

arizona.subscribe('connect', () => {
  console.info("[Client] I'm connected!");
});

const connectParams = {};
arizona.connect(connectParams);
