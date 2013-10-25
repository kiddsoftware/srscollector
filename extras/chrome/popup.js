window.background = null;

function onSignIn() {
  $("#spinner").show();
  var email = $("#email").val();
  var password = $("#password").val();
  if (email !== "" && password !== "")
    window.background.signInPromise(email, password).then(updateDisplay);
  return false;
}

function onSignOut() {
  window.background.signOutPromise().then(updateDisplay);
  return false;
}

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
    }
  }).fail(function (reason) {
    console.log("Unable to display:", reason);
  });
}

$(function () {
  // Show the appropriate page.
  window.background = chrome.extension.getBackgroundPage();

  // Install our button handlers.
  $("#sign-in form").submit(onSignIn);
  $("#index #sign-out-btn").click(onSignOut);

  updateDisplay();
});