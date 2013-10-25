// Confirm that we have saved a text snippet.
function notifyUser(title, text) {
  var notification = webkitNotifications.createNotification(
    "16.png", title, text);
  notification.show();
  setTimeout(function () { notification.cancel(); }, 2500);
}

// Let the user know whether they need to log in.  Runs asynchronously.
function updateBadge() {
  ApiKey.getPromise().then(function (api_key) {
    if (api_key) {
      chrome.browserAction.setBadgeText({ text: "" });
    } else {
      chrome.browserAction.setBadgeBackgroundColor({ color: "#840" });
      chrome.browserAction.setBadgeText({ text: "!" });   
    }
  }).fail(function (reason) {
    console.log("Unable to update badge:", reason);
  });
}

// Save selection (called from context menu.
function onSaveSelection(info, tab) {
  var selection = info.selectionText;
  var card = {
    front: selection,
    source: tab.title, // Thanks to activeTab permission.
    source_url: info.pageUrl
  };
  ApiKey.getPromise().then(function (api_key) {
    $.ajax({
      url: "http://www.srscollector.com/api/v1/cards.json",
      method: 'POST',
      contentType: "application/json; charset=utf-8",
      data: JSON.stringify({ card: card, api_key: api_key }),
      dataType: 'text' // Handle 201 CREATED responses.
    });
  }).then(function () {
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
window.signInPromise = function (email, password) {
  var user = { email: email, password: password };
  var jqxhr = $.ajax({
    url: "http://www.srscollector.com/api/v1/users/api_key.json",
    method: 'POST',
    contentType: "application/json; charset=utf-8",
    data: JSON.stringify({ user: user })
  });
  return RSVP.resolve(jqxhr).then(function (json) {
    ApiKey.setPromise(json["user"]["api_key"]);
  }).then(function () {
    onSignedIn();
    notifyUser("Signed In", "Whoo!");
    updateBadge();
  }).fail(function (reason) {
    notifyUser("Sign In Failed", reason.status);
  });
};

// Sign out of our site.
window.signOutPromise = function () {
  chrome.contextMenus.removeAll();
  return ApiKey.setPromise(null).then(updateBadge()).fail(function (reason) {
    console.log("Unable to sign out:", reason);
  });
};

// Update our badge when we first run.
updateBadge();
