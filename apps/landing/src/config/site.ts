export const siteConfig = {
  showPricing: false,
  operatorName: 'Holdbuddy',
  operatorAddress: '',
  supportEmail: '',
  privacyEmail: '',
  deletionEndpoint: '',
  deletionDays: 30,
  updatedDate: '12 October 2026',
} as const;

const validateEmail = (value: string, field: string) => {
  if (!value) return null;
  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)) {
    throw new Error(`Set ${field} to a valid email address.`);
  }
  return value;
};

export const supportEmail = validateEmail(siteConfig.supportEmail, 'supportEmail');
export const privacyEmail = validateEmail(siteConfig.privacyEmail, 'privacyEmail') ?? supportEmail;

export const deletionEndpoint = (() => {
  const endpoint = siteConfig.deletionEndpoint.trim();
  if (endpoint.startsWith('/') && !endpoint.startsWith('//') && !endpoint.includes('\\'))
    return endpoint;
  if (!endpoint) return null;

  try {
    const url = new URL(endpoint);
    if (url.protocol !== 'https:' || url.username || url.password)
      throw new Error('Invalid endpoint');
    return url.href;
  } catch {
    throw new Error('Set deletionEndpoint to a relative path or a valid HTTPS URL.');
  }
})();
