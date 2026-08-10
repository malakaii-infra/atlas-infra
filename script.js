/* =============================================
   MALAKAII — PORTFOLIO JAVASCRIPT
   Minimal, readable, and well-commented.

   What this file does:
   1. Sets the current year in the footer
   2. Adds a shadow to the nav when you scroll
   3. Toggles the mobile nav menu open/closed
   4. Reveals elements as you scroll down the page
   5. Closes the mobile menu when you click a link
============================================= */


/* ── 1. SET FOOTER YEAR ─────────────────────
   Automatically shows the current year in the footer
   so you don't have to update it manually each year.
─────────────────────────────────────────── */
const footerYear = document.getElementById('footer-year');
if (footerYear) {
  footerYear.textContent = new Date().getFullYear();
}


/* ── 2. STICKY NAV SHADOW ON SCROLL ─────────
   When the user scrolls down more than 10px,
   we add a "scrolled" class to the nav header.
   The CSS then adds a dark background and blur.
─────────────────────────────────────────── */
const navHeader = document.getElementById('nav-header');

function handleNavScroll() {
  if (window.scrollY > 10) {
    navHeader.classList.add('scrolled');
  } else {
    navHeader.classList.remove('scrolled');
  }
}

// Run on page load in case the page starts scrolled
handleNavScroll();

// Run every time the user scrolls
window.addEventListener('scroll', handleNavScroll);


/* ── 3. MOBILE NAV TOGGLE ───────────────────
   When the hamburger button is clicked,
   toggle the nav links open or closed.
─────────────────────────────────────────── */
const navToggle  = document.getElementById('nav-toggle');
const navLinks   = document.getElementById('nav-links');

navToggle.addEventListener('click', function () {
  // Toggle the "open" class on both elements
  navToggle.classList.toggle('open');
  navLinks.classList.toggle('open');

  // Update aria-expanded for screen readers (accessibility)
  const isOpen = navLinks.classList.contains('open');
  navToggle.setAttribute('aria-expanded', isOpen);
});


/* ── 4. CLOSE MOBILE MENU ON LINK CLICK ─────
   When a nav link is clicked on mobile,
   close the menu automatically.
─────────────────────────────────────────── */
const allNavLinks = document.querySelectorAll('.nav-link');

allNavLinks.forEach(function (link) {
  link.addEventListener('click', function () {
    // Close the mobile menu
    navToggle.classList.remove('open');
    navLinks.classList.remove('open');
    navToggle.setAttribute('aria-expanded', false);
  });
});


/* ── 5. SCROLL REVEAL ANIMATION ─────────────
   As the user scrolls down, elements with the
   "reveal" class fade in when they enter the screen.

   How it works:
   - IntersectionObserver watches every .reveal element
   - When an element is 10% visible, we add the "visible" class
   - The CSS handles the actual animation (opacity + translateY)
─────────────────────────────────────────── */

// Grab every element with the class "reveal"
const revealElements = document.querySelectorAll('.reveal');

// Create the observer — it fires when elements enter the viewport
const revealObserver = new IntersectionObserver(
  function (entries) {
    entries.forEach(function (entry) {
      // If the element is entering the screen...
      if (entry.isIntersecting) {
        entry.target.classList.add('visible');

        // Once revealed, stop watching this element
        // (so it doesn't re-animate if the user scrolls back up)
        revealObserver.unobserve(entry.target);
      }
    });
  },
  {
    threshold: 0.1,    // Trigger when 10% of the element is visible
    rootMargin: '0px 0px -40px 0px'  // Start 40px before it fully enters
  }
);

// Tell the observer to watch each reveal element
revealElements.forEach(function (el) {
  revealObserver.observe(el);
});
