/*global arizona*/
'use strict';

const connectParams = {};
arizona.connect(connectParams);

arizona.subscribe('connect', () => {
  console.info("[Client] I'm connected!");
});
