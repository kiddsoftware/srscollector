// Load our background process if it isn't running.
function getBackgroundPagePromise() {
  return new RSVP.Promise(function (resolve, reject) {
    chrome.runtime.getBackgroundPage(resolve);
  });
}

// See http://developer.chrome.com/extensions/examples/api/downloads/download_manager/popup.js
// for details about internationalization of HTML in extensions.
function localize(css_selector, field, message) {
  document.querySelector(css_selector)[field] = chrome.i18n.getMessage(message);
}

// Apply all our translations.
function localizeAll() {
  localize("#loading", "innerText", "loading");
  localize("#sign-in .site-link a", "innerText", "linkNewAccount");
  localize("#sign-in h3", "innerText", "titleSignIn");
  localize("#index .site-link a", "innerText", "linkGoToSite");
  localize("#email", "placeholder", "formEmail");
  localize("#password", "placeholder", "formPassword");
  localize("#sign-in-btn", "value", "formSignIn");
  localize("#sign-out-btn", "innerText", "formSignOut");
}

// Called when the user clicks "Sign In".
function onSignIn() {
  var email = $("#email").val();
  var password = $("#password").val();
  if (email !== "" && password !== "") {
    $("#sign-in input").prop("disabled", true);
    $("#spinner").show();
    getBackgroundPagePromise().then(function (background) {
      return background.signInPromise(email, password);
    }).then(updateDisplay);
  }
  return false;
}

// Called when the user clicks "Sign Out".
function onSignOut() {
  getBackgroundPagePromise().then(function (background) {
    return background.signOutPromise();
  }).then(updateDisplay);
  return false;
}

// Update the display
function updateDisplay() {
  ApiKey.getPromise().then(function (api_key) {
    $("#loading").hide();
    $("#spinner").hide();
    if (api_key) {
      $("#sign-in").hide();
      $("#index").show();
    } else {
      $("#index").hide();
      $("#sign-in").show();
      $("#sign-in input").prop("disabled", false);
    }
  }).fail(function (reason) {
    console.log("Unable to update display:", reason);
  });
}

$(function () {
  // Apply our translations as soon as possible.
  localizeAll();

  // Install our button handlers.
  $("#sign-in form").submit(onSignIn);
  $("#index #sign-out-btn").click(onSignOut);

  // Update our display.
  updateDisplay();
});