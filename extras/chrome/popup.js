window.background = null;

function onSignIn() {
  $("#spinner").show();
  var email = $("#email").val();
  var password = $("#password").val();
  if (email !== "" && password !== "") {
    window.background.signIn(email, password, updateDisplay);
  }
  return false;
}

function onSignOut() {
  window.background.signOut();
  updateDisplay();
  return false;
}

function updateDisplay() {
  $("#loading").hide();
  $("#spinner").hide();
  if (window.background.API_KEY) {
    $("#sign-in").hide();
    $("#index").show();
  } else {
    $("#index").hide();
    $("#sign-in").show();
  }
}

$(function () {
  // Show the appropriate page.
  window.background = chrome.extension.getBackgroundPage();

  // Install our button handlers.
  $("#sign-in form").submit(onSignIn);
  $("#index #sign-out-btn").click(onSignOut);

  updateDisplay();
});