
document.querySelectorAll(".post-card").forEach(function (card) {
  card.addEventListener("click", function (e) {
    console.log(e.target)
    // Prevent click if a link or button was clicked inside the card
    if (e.target.closest("a") || e.target.closest("button")) return;

    const url = card.getAttribute("data-url");
    if (url) {
      window.location.href = url;
    }
  });
});
