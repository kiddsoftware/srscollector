// Confirm that we have saved a text snippet.
function notifyUser(title, text) {
  var notification = webkitNotifications.createNotification(
    "16.png", title, text);
  notification.show();
  setTimeout(function () { notification.cancel(); }, 2500);
}

// One-time setup that we don't want to run every time we get unloaded and
// loaded again.
function initializeUI() {
  chrome.contextMenus.create({
    id: "save",
    contexts: ["selection"],
    title: chrome.i18n.getMessage("contextMenuSave")
  });
  updateUI();
}

// Update our context menu and badge. Runs asynchronously.
function updateUI() {
  ApiKey.getPromise().then(function (api_key) {
    if (api_key) {
      chrome.browserAction.setBadgeText({ text: "" });
    } else {
      // Let the user know they need to log in.
      chrome.browserAction.setBadgeBackgroundColor({ color: "#840" });
      chrome.browserAction.setBadgeText({ text: "!" });   
    }
  }).fail(function (reason) {
    console.log("Unable to update UI:", reason);
  });
}

// Save selection (called from context menu.
function onSaveSelection(info, tab) {
  var text = info.selectionText;
  // Escape tags and convert newlines to <br>.
  var html = $("<div>").text(text.trim()).html().replace(/\n/, '<br>');
  var card = { front: html };
  // In Incognito mode, we still save the text that the user asked us to
  // save, because we received a direct command from the user to do so.  But
  // we can at least avoid saving the page title and the source URL.
  if (!tab.incognito) {
    card["source"] = tab.title; // Thanks to activeTab permission.
    card["source_url"] = info.pageUrl;    
  }
  ApiKey.getPromise().then(function (api_key) {
    if (!api_key) {
      notifyUser(chrome.i18n.getMessage("noticeTitlePleaseLogIn"),
                 chrome.i18n.getMessage("noticeTextLogInInstructions"));
    } else {
      var jqxhr = $.ajax({
        url: "http://www.srscollector.com/api/v1/cards.json",
        method: 'POST',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ card: card, api_key: api_key }),
        dataType: 'text' // Handle 201 CREATED responses.
      }).then(function () {
        notifyUser(chrome.i18n.getMessage("noticeTitleTextSaved"), text);
      }).fail(function (reason) {
        notifyUser(chrome.i18n.getMessage("noticeTitleCantSaveText"),
                   reason.status);
      }); 
    }
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
    notifyUser(chrome.i18n.getMessage("noticeTitleSignedIn"),
               chrome.i18n.getMessage("noticeTextExclamation"));
    updateUI();
  }).fail(function (reason) {
    notifyUser(chrome.i18n.getMessage("noticeTitleSignInFailed"), reason.status);
  });
};

// Sign out of our site.
window.signOutPromise = function () {
  return ApiKey.setPromise(null).then(updateUI()).fail(function (reason) {
    console.log("Unable to sign out:", reason);
  });
};

// Update our UI when we first run.
chrome.runtime.onInstalled.addListener(initializeUI);

// We could use menu IDs to tell our menu items apart, if we
// had more than one.
chrome.contextMenus.onClicked.addListener(onSaveSelection);

// Update our UI when we start.
updateUI();
