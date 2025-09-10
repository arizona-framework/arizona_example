/* global arizona */

// Import the new Arizona client
import Arizona from '/assets/js/arizona.min.js';

// Initialize the Arizona client
globalThis.arizona = new Arizona();

// Connect to the WebSocket server
arizona.connect({ wsPath: '/live' });

document.addEventListener('arizonaEvent', (event) => {
  const { type, data } = event.detail;
  if (type !== 'reply') return;
  if (typeof data?.reload !== 'string') return;
  window.location.reload();
});
