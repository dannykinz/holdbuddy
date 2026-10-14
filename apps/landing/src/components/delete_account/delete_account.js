const initializeDeletionForm = () => {
  const form = document.querySelector('[data-deletion-form]');
  const status = document.querySelector('#deletion_status');
  if (!form || !status) return;

  const submitButton = form.querySelector('[type="submit"]');
  if (!submitButton) return;

  const controller = new AbortController();
  const endpoint = form.dataset.endpoint ?? '';
  const contactEmail = form.dataset.contactEmail ?? '';
  const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  let submitting = false;

  form.addEventListener(
    'submit',
    async (event) => {
      event.preventDefault();
      if (submitting || !form.reportValidity()) return;

      const values = new FormData(form);
      const email = String(values.get('email') ?? '').trim();
      const reason = String(values.get('reason') ?? '').trim();
      const confirmed = values.get('confirmed') === 'yes';

      if (!emailPattern.test(email) || email.length > 254 || reason.length > 1000 || !confirmed) {
        status.textContent =
          'Enter a valid account email and confirm that you understand deletion is permanent.';
        return;
      }

      if (!endpoint && !emailPattern.test(contactEmail)) {
        status.textContent =
          'Online requests are not available yet. Please use the in-app deletion steps.';
        return;
      }

      if (!endpoint) {
        const subject = encodeURIComponent('Holdbuddy account deletion request');
        const body = encodeURIComponent(
          `Please delete my Holdbuddy account and associated data.\n\nAccount email: ${email}\nReason: ${reason || 'Not provided'}\n\nI understand that account deletion cannot be undone.`,
        );
        window.location.assign(`mailto:${contactEmail}?subject=${subject}&body=${body}`);
        status.textContent =
          'Send the prepared email to complete your request. We will verify account ownership before deletion.';
        return;
      }

      submitting = true;
      submitButton.disabled = true;
      form.setAttribute('aria-busy', 'true');
      status.textContent = 'Sending your request…';

      try {
        const response = await fetch(endpoint, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
          body: JSON.stringify({ email, reason, confirmed }),
          signal: AbortSignal.any([controller.signal, AbortSignal.timeout(15000)]),
        });

        if (!response.ok) throw new Error(`Deletion request failed with status ${response.status}`);
        status.textContent =
          'Your request was received. We will verify account ownership before deleting your data.';
        form.reset();
      } catch (error) {
        if (controller.signal.aborted) return;
        console.error('Could not submit the account deletion request.', error);
        status.textContent =
          'We could not send your request. Please try again or use the email contact option.';
      } finally {
        submitting = false;
        submitButton.disabled = false;
        form.removeAttribute('aria-busy');
      }
    },
    { signal: controller.signal },
  );

  window.addEventListener('pagehide', () => controller.abort(), { once: true });
};

initializeDeletionForm();
window.addEventListener('pageshow', (event) => {
  if (event.persisted) initializeDeletionForm();
});
