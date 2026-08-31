// ═══════════════════════════════════════════════════════════════
//  TERMINARZ — uzupełnij wydarzenia poniżej
//  Format: { time: "HH:MM", title: "...", desc: "opcjonalny opis" }
// ═══════════════════════════════════════════════════════════════

const SCHEDULE = {
  piatek: [
    { time: "18:00", title: "Przyjazd i rejestracja", desc: "Powitanie uczestników" },
    { time: "19:00", title: "Networking & prezentacje futures", desc: "" },
    { time: "21:00", title: "Kasyno", desc: "Wieczór w kasynie" },
  ],
  sobota: [
    { time: "07:00", title: "Long Run 12 km z Prevencem Belą", desc: "" },
    { time: "12:00", title: "Mistrzostwa ulicy Błotnej 13 w Chomiki", desc: "" },
    { time: "16:00", title: "Wyjście w góry z Marcinem Woźniakiem", desc: "" },
    { time: "20:00", title: "Eksploracja TempleOS", desc: "Wydarzenie specjalne" },
  ],
  niedziela: [
    { time: "10:00", title: "Śniadanie i podsumowanie", desc: "" },
    { time: "12:00", title: "Wyjazd uczestników", desc: "" },
  ],
};

const DAY_LABELS = {
  piatek: "Piątek",
  sobota: "Sobota",
  niedziela: "Niedziela",
};

// ── Render schedule ──

function renderScheduleItem(item) {
  const desc = item.desc
    ? `<p>${item.desc}</p>`
    : "";
  return `
    <div class="schedule-item">
      <div class="schedule-time">${item.time}</div>
      <div class="schedule-body">
        <h4>${item.title}</h4>
        ${desc}
      </div>
    </div>
  `;
}

function renderDay(day) {
  const events = SCHEDULE[day];
  if (!events || events.length === 0) {
    return '<p class="schedule-empty">Brak wydarzeń — dodaj je w SCHEDULE</p>';
  }
  return events.map(renderScheduleItem).join("");
}

Object.keys(SCHEDULE).forEach((day) => {
  const panel = document.getElementById(`panel-${day}`);
  if (panel) {
    panel.innerHTML = renderDay(day);
    panel.setAttribute("data-label", DAY_LABELS[day]);
  }
});

// ── Schedule tabs (mobile) ──

const tabs = document.querySelectorAll(".tab");
const panels = document.querySelectorAll(".schedule-panel");

tabs.forEach((tab) => {
  tab.addEventListener("click", () => {
    const day = tab.dataset.day;

    tabs.forEach((t) => {
      t.classList.remove("active");
      t.setAttribute("aria-selected", "false");
    });
    tab.classList.add("active");
    tab.setAttribute("aria-selected", "true");

    panels.forEach((panel) => {
      const isActive = panel.id === `panel-${day}`;
      panel.classList.toggle("active", isActive);
      panel.hidden = !isActive;
    });
  });
});

// ── Mobile nav ──

const navToggle = document.querySelector(".nav-toggle");
const navLinks = document.querySelector(".nav-links");

if (navToggle && navLinks) {
  navToggle.addEventListener("click", () => {
    const open = navToggle.classList.toggle("open");
    navLinks.classList.toggle("open", open);
    navToggle.setAttribute("aria-expanded", String(open));
  });

  navLinks.querySelectorAll("a").forEach((link) => {
    link.addEventListener("click", () => {
      navToggle.classList.remove("open");
      navLinks.classList.remove("open");
      navToggle.setAttribute("aria-expanded", "false");
    });
  });
}

// ── Scroll reveal ──

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
  { threshold: 0.12 }
);

revealItems.forEach((item) => observer.observe(item));
