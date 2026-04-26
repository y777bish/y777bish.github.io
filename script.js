const revealItems = document.querySelectorAll(".reveal");

const observer = new IntersectionObserver(
  (entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.classList.add("visible");
        observer.unobserve(entry.target);
      }
    });
  },
  { threshold: 0.16 }
);

revealItems.forEach((item) => observer.observe(item));

const typingTarget = document.getElementById("typing-text");
const typingLine = "aggregate.updateDomainEvent();";
let charIndex = 0;
let typingForward = true;

function animateTyping() {
  if (!typingTarget) return;

  if (typingForward) {
    charIndex += 1;
    typingTarget.textContent = typingLine.slice(0, charIndex);
    if (charIndex >= typingLine.length) {
      typingForward = false;
      setTimeout(animateTyping, 1100);
      return;
    }
  } else {
    charIndex -= 1;
    typingTarget.textContent = typingLine.slice(0, charIndex);
    if (charIndex <= 0) {
      typingForward = true;
    }
  }

  const speed = typingForward ? 62 : 34;
  setTimeout(animateTyping, speed);
}

animateTyping();
