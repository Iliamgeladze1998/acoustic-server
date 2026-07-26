(function () {
  'use strict';

  /* ---------- sticky header shadow + back to top ---------- */
  var header = document.getElementById('header');
  var up = document.getElementById('up');
  function onScroll() {
    var y = window.scrollY;
    header.classList.toggle('is-stuck', y > 8);
    up.classList.toggle('is-on', y > 600);
  }
  window.addEventListener('scroll', onScroll, { passive: true });
  onScroll();
  up.addEventListener('click', function () {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  });

  /* ---------- mega menu ---------- */
  var catbtn = document.getElementById('catbtn');
  var mega = document.getElementById('mega');
  var scrim = document.getElementById('scrim');

  function closeMega() {
    mega.classList.remove('is-open');
    catbtn.classList.remove('is-open');
    scrim.classList.remove('is-on');
  }
  catbtn.addEventListener('click', function (ev) {
    ev.stopPropagation();
    var open = mega.classList.toggle('is-open');
    catbtn.classList.toggle('is-open', open);
    scrim.classList.toggle('is-on', open);
  });
  scrim.addEventListener('click', closeMega);
  document.addEventListener('click', function (ev) {
    if (mega.classList.contains('is-open') && !mega.contains(ev.target)) closeMega();
  });
  document.addEventListener('keydown', function (ev) {
    if (ev.key === 'Escape') closeMega();
  });

  mega.querySelectorAll('[data-mega]').forEach(function (btn) {
    var activate = function () {
      var id = btn.getAttribute('data-mega');
      mega.querySelectorAll('[data-mega]').forEach(function (b) { b.classList.remove('is-active'); });
      mega.querySelectorAll('[data-panel]').forEach(function (p) { p.classList.remove('is-active'); });
      btn.classList.add('is-active');
      var panel = mega.querySelector('[data-panel="' + id + '"]');
      if (panel) panel.classList.add('is-active');
    };
    btn.addEventListener('mouseenter', activate);
    btn.addEventListener('click', activate);
  });

  /* ---------- product rails ---------- */
  document.querySelectorAll('[data-rail]').forEach(function (btn) {
    btn.addEventListener('click', function () {
      var rail = document.getElementById(btn.getAttribute('data-rail'));
      if (!rail) return;
      var card = rail.querySelector('.pcard');
      var step = card ? (card.offsetWidth + 16) * 2 : 400;
      rail.scrollBy({ left: step * parseInt(btn.getAttribute('data-dir'), 10), behavior: 'smooth' });
    });
  });

  /* ---------- soft reveal on scroll ---------- */
  if ('IntersectionObserver' in window) {
    var io = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) {
          entry.target.style.opacity = '1';
          entry.target.style.transform = 'none';
          io.unobserve(entry.target);
        }
      });
    }, { rootMargin: '0px 0px -60px 0px' });

    document.querySelectorAll('.cat, .service, .pcard, .promo, .bcard').forEach(function (el, i) {
      el.style.opacity = '0';
      el.style.transform = 'translateY(14px)';
      el.style.transition = 'opacity .5s ease ' + ((i % 8) * 40) + 'ms, transform .5s ease ' + ((i % 8) * 40) + 'ms, box-shadow .2s ease';
      io.observe(el);
    });
  }
})();
