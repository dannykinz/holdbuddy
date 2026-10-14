import Lenis from 'lenis';

const motionPreference = window.matchMedia('(prefers-reduced-motion: reduce)');
const tokens = getComputedStyle(document.documentElement);
const durationToken = tokens.getPropertyValue('--motion_duration').trim();
const durationValue = Number.parseFloat(durationToken);
const durationMilliseconds = durationToken.endsWith('ms')
  ? durationValue
  : durationToken.endsWith('s')
    ? durationValue * 1000
    : Number.NaN;
const motionPreset = {
  duration: durationMilliseconds,
  easing: tokens.getPropertyValue('--motion_easing').trim(),
  distance: tokens.getPropertyValue('--motion_distance').trim(),
};

const createScrollEasing = (easing) => {
  const values = easing.match(/[\d.]+/g)?.map(Number);
  if (!values || values.length !== 4 || values.some((value) => !Number.isFinite(value)))
    return null;
  const [firstX, firstY, secondX, secondY] = values;
  const bezierPoint = (progress, first, second) =>
    3 * (1 - progress) ** 2 * progress * first +
    3 * (1 - progress) * progress ** 2 * second +
    progress ** 3;

  return (progress) => {
    if (progress <= 0 || progress >= 1) return progress;
    let lowerBound = 0;
    let upperBound = 1;
    let parameter = progress;
    for (let iteration = 0; iteration < 14; iteration += 1) {
      parameter = (lowerBound + upperBound) / 2;
      if (bezierPoint(parameter, firstX, secondX) < progress) lowerBound = parameter;
      else upperBound = parameter;
    }
    return bezierPoint(parameter, firstY, secondY);
  };
};

const initializeSmoothScroll = (signal) => {
  const easing = createScrollEasing(motionPreset.easing);
  if (!easing || !Number.isFinite(motionPreset.duration)) return;

  let smoothScroll;
  const updateScrollPreference = () => {
    smoothScroll?.destroy();
    smoothScroll = undefined;
    if (motionPreference.matches || signal.aborted) return;

    smoothScroll = new Lenis({
      autoRaf: true,
      anchors: true,
      duration: motionPreset.duration / 1000,
      easing,
    });
  };

  updateScrollPreference();
  motionPreference.addEventListener('change', updateScrollPreference, { signal });
  signal.addEventListener('abort', () => smoothScroll?.destroy(), { once: true });
};

const initializeReveals = (signal) => {
  const elements = document.querySelectorAll('[data-reveal]');
  if (!elements.length || !('IntersectionObserver' in window) || motionPreference.matches) return;
  const { duration, easing, distance } = motionPreset;
  if (!Number.isFinite(duration) || !easing || !distance) return;

  const activeAnimations = new Set();
  const stopReveals = () => {
    observer.disconnect();
    activeAnimations.forEach((animation) => animation.cancel());
    activeAnimations.clear();
  };

  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach(({ target, isIntersecting }) => {
        if (!isIntersecting || !(target instanceof HTMLElement)) return;
        observer.unobserve(target);
        if (motionPreference.matches || typeof target.animate !== 'function') return;

        const animation = target.animate(
          [
            { opacity: 0, transform: `translateY(${distance})` },
            { opacity: 1, transform: 'translateY(0)' },
          ],
          { duration, easing },
        );

        activeAnimations.add(animation);
        animation.addEventListener('finish', () => activeAnimations.delete(animation), {
          once: true,
        });
      });
    },
    { threshold: 0.12 },
  );

  elements.forEach((element) => observer.observe(element));
  motionPreference.addEventListener('change', stopReveals, { signal });
  signal.addEventListener('abort', stopReveals, { once: true });
};

let lifecycle;
const initializePageMotion = () => {
  lifecycle?.abort();
  lifecycle = new AbortController();
  initializeSmoothScroll(lifecycle.signal);
  initializeReveals(lifecycle.signal);
};

initializePageMotion();
window.addEventListener('pagehide', () => lifecycle?.abort());
window.addEventListener('pageshow', (event) => {
  if (!event.persisted) return;
  initializePageMotion();
});
