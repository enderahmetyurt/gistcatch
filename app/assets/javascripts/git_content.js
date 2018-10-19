$(document).on("click", "button", function () {
  if ($(this).attr("aria-expanded") == "true")
    this.firstElementChild.click();
});
