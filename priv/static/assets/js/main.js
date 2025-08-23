// Import the new Arizona client
import Arizona from '/assets/js/arizona.min.js';

// Initialize the Arizona client
globalThis.arizona = new Arizona();

// Connect to the WebSocket server
arizona.connect({ wsPath: '/live' });
