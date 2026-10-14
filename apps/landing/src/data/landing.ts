import { siteConfig } from '../config/site';

export const appLinks = {
  googlePlay: '#',
  appStore: '#',
  support: '/support/',
  contact: '/support/#contact',
  deleteAccount: '/delete-account/',
  privacy: '/privacy/',
  terms: '/terms/',
} as const;

export const navigation = [
  { label: 'How it works', href: '/#how_it_works' },
  { label: 'Features', href: '/#features' },
  { label: 'Pricing', href: '/#pricing' },
  { label: 'FAQ', href: '/#faq' },
].filter(({ label }) => label !== 'Pricing' || siteConfig.showPricing);
