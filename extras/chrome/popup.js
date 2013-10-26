// Load our background process if it isn't running.
function getBackgroundPagePromise() {
  return new RSVP.Promise(function (resolve, reject) {
    chrome.runtime.getBackgroundPage(resolve);
  });
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
  // Show the appropriate page.
  window.background = chrome.extension.getBackgroundPage();

  // Install our button handlers.
  $("#sign-in form").submit(onSignIn);
  $("#index #sign-out-btn").click(onSignOut);

  // Update our display.
  updateDisplay();
});