// We could display the number of snippets ready to mark up.
//chrome.browserAction.setBadgeText({ text: "1" });
//chrome.browserAction.setBadgeBackgroundColor({ color: "#008" });

// Needed to access our API.  Will be updated once we're logged in.
window.API_KEY = null;

// Confirm that we have saved a text snippet.
function notifyUser(title, text) {
  var notification = webkitNotifications.createNotification(
    "16.png", title, text);
  notification.show();
  setTimeout(function () { notification.cancel(); }, 2500);
}

// Let the user know whether they need to log in.
function updateBadge() {
  if (window.API_KEY) {
    chrome.browserAction.setBadgeText({ text: "" });
  } else {
    chrome.browserAction.setBadgeBackgroundColor({ color: "#840" });
    chrome.browserAction.setBadgeText({ text: "!" });   
  }
}

// Display a context menu when text is selected.
function onSaveSelection(info, tab) {
  var selection = info.selectionText;
  var card = {
    front: selection,
    source: tab.title, // Thanks to activeTab permission.
    source_url: info.pageUrl
  };
  RSVP.resolve($.ajax({
    url: "http://www.srscollector.com/api/v1/cards.json",
    method: 'POST',
    contentType: "application/json; charset=utf-8",
    data: JSON.stringify({ card: card, api_key: API_KEY }),
    dataType: 'text' // Handle 201 CREATED responses.
  })).then(function () {
    notifyUser("Text Saved", selection);
  }).fail(function (reason) {
    notifyUser("Can't Save Text", reason.status);
  });
}

// Install our context menu.
function onSignedIn() {
  chrome.contextMenus.create({
    id: "save",
    contexts: ["selection"],
    title: "Save selection to SRS Collector",
    onclick: onSaveSelection
  });    
}

// Sign into our site.  Call 'callback' when we know one way or another.
window.signIn = function (email, password, callback) {
  var user = { email: email, password: password };
  RSVP.resolve($.ajax({
    url: "http://www.srscollector.com/api/v1/users/api_key.json",
    method: 'POST',
    contentType: "application/json; charset=utf-8",
    data: JSON.stringify({ user: user })
  })).then(function (json) {
    API_KEY = json["user"]["api_key"];
    onSignedIn();
    notifyUser("Signed In", "Whoo!");
    updateBadge();
    callback();
  }).fail(function (reason) {
    notifyUser("Sign In Failed", reason.status);
    callback();
  });
};

// Sign out of our site.
window.signOut = function () {
  chrome.contextMenus.removeAll();
  window.API_KEY = null;
  updateBadge();
};

// Update our badge when we first run.
updateBadge();
