window.ApiKey = {
  // Get our stored API key.
  getPromise: function () {
    return new RSVP.Promise(function (resolve, reject) {
      chrome.storage.sync.get("api_key", function (result) {
        if (chrome.runtime.lastError) {
          //console.log("Unable to get api_key:", chrome.runtime.lastError);
          reject(chrome.runtime.lastError);
        } else {
          //console.log("Got api_key:", result.api_key);
          resolve(result.api_key);
        }
      });
    });
  },

  // Update our stored API key.
  setPromise: function (api_key) {
    return new RSVP.Promise(function (resolve, reject) {
      chrome.storage.sync.set({ api_key: api_key }, function () {
        if (chrome.runtime.lastError) {
          //console.log("Unable to set api_key:", chrome.runtime.lastError);
          reject(chrome.runtime.lastError);
        } else {
          //console.log("Set api_key:", api_key);
          resolve();            
        }
      });
    });    
  } 
};
