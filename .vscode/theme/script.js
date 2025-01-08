document.addEventListener("DOMContentLoaded", function () {
  const checkDiv = setInterval(() => {
    const dialog = document.querySelector(".quick-input-widget");
    if (dialog) {
      if (dialog.style.display !== "none") run();
      const observer = new MutationObserver((cb) => cb.forEach((mutation) => {
        if (!(mutation.type === "attributes" && mutation.attributeName === "style")) return;
        if (dialog.style.display === "none") handleEscape();
        else run();
      }));

      observer.observe(dialog, { attributes: true });
      clearInterval(checkDiv);
    } else {
      console.log("Command dialog not found yet. Retrying...");
    }
  }, 500);

  document.addEventListener("keydown", function (event) {
    if ((event.metaKey || event.ctrlKey) && event.key === "p") {
      event.preventDefault();
      run();
    } else if (event.key === "Escape" || event.key === "Esc") {
      event.preventDefault();
      handleEscape();
    }
  });

  document.addEventListener("keydown", function (event) {
    if (event.key === "Escape" || event.key === "Esc") handleEscape();
  }, true);

  function run() {
    const targetDiv = document.querySelector(".monaco-workbench");
    const existingDiv = document.getElementById("command-blur");
    if (existingDiv) existingDiv.remove();

    const div = document.createElement("div");
    div.setAttribute("id", "command-blur");
    div.addEventListener("click", div.remove);
    targetDiv.appendChild(div);
  }

  function handleEscape() {
    const div = document.getElementById("command-blur");
    if (div) div.click();
  }
});
