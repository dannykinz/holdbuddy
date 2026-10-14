const initializeSupportCenter = () => {
  const center = document.querySelector('[data-support-center]');
  if (!center) return;

  const searchInput = center.querySelector('[data-help-search]');
  const resetButton = center.querySelector('[data-reset-search]');
  const emptyState = center.querySelector('[data-no-results]');
  const searchStatus = center.querySelector('[data-search-status]');
  if (!searchInput || !resetButton || !emptyState || !searchStatus) return;

  const articles = [...center.querySelectorAll('[data-help-article]')];
  const topicButtons = [...center.querySelectorAll('[data-help-topic]')];
  const controller = new AbortController();
  let selectedTopic = '';

  const filterArticles = () => {
    const query = searchInput.value.trim().normalize('NFKC').toLocaleLowerCase();
    const words = query.split(/\s+/).filter(Boolean);
    let visibleCount = 0;

    for (const article of articles) {
      const content = article.textContent?.normalize('NFKC').toLocaleLowerCase() ?? '';
      const matchesTopic = !selectedTopic || article.dataset.topic === selectedTopic;
      article.hidden = !matchesTopic || !words.every((word) => content.includes(word));
      if (!article.hidden) visibleCount += 1;
    }

    for (const button of topicButtons) {
      button.setAttribute('aria-pressed', String(button.dataset.helpTopic === selectedTopic));
    }

    emptyState.hidden = visibleCount > 0;
    resetButton.hidden = !query && !selectedTopic;
    searchStatus.textContent = `${visibleCount} ${visibleCount === 1 ? 'article' : 'articles'} found.`;
  };

  searchInput.addEventListener('input', filterArticles, { signal: controller.signal });

  for (const button of topicButtons) {
    button.addEventListener(
      'click',
      () => {
        selectedTopic =
          selectedTopic === button.dataset.helpTopic ? '' : (button.dataset.helpTopic ?? '');
        filterArticles();
      },
      { signal: controller.signal },
    );
  }

  resetButton.addEventListener(
    'click',
    () => {
      selectedTopic = '';
      searchInput.value = '';
      filterArticles();
      searchInput.focus();
    },
    { signal: controller.signal },
  );

  window.addEventListener('pagehide', () => controller.abort(), { once: true });
  filterArticles();
};

initializeSupportCenter();
window.addEventListener('pageshow', (event) => {
  if (event.persisted) initializeSupportCenter();
});
