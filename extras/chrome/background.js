// We could display the number of snippets ready to mark up.
//chrome.browserAction.setBadgeText({ text: "1" });
//chrome.browserAction.setBadgeBackgroundColor({ color: "#008" });

// Confirm that we have saved a text snippet.
function notifyUser(title, text) {
  var notification = webkitNotifications.createNotification(
    "16.png", title, text);
  notification.show();
  setTimeout(function () { notification.cancel(); }, 2500);
}

// Display a context menu when text is selected.
function onSaveSelection(info, tab) {
  var selection = info.selectionText;
  RSVP.resolve($.ajax({
    url: "http://www.srscollector.com/api/v1/cards.json",
    method: 'POST',
    contentType: "application/json; charset=utf-8",
    data: JSON.stringify({ card: { front: selection } }),
    dataType: 'text' // Handle 201 CREATED responses.
  })).then(function (json) {
    notifyUser("Text Saved", selection);
  }).fail(function (reason) {
    notifyUser("Can't Save Text", reason.status);
  });
}

// Install our context menu.
chrome.contextMenus.create({
  contexts: ["selection"],
  title: "Save selection to SRS Collector",
  onclick: onSaveSelection
});
