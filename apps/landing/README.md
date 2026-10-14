# Holdbuddy website

Responsive Astro website based on the Holdva Product Design Figma file, with Lenis smooth scrolling and subtle reveal animations.

## Run locally

Use Node.js 22.12 or newer:

```sh
npm install
npm run dev
```

Open http://localhost:4321. The development server runs in the background.

```sh
npm run dev:status
npm run dev:logs
npm run dev:stop
npm run build
npm run preview
npm run format
npm run format:check
```

## Pages

| Route            | Page                                           |
| ---------------- | ---------------------------------------------- |
| /                | Landing page                                   |
| /privacy/        | Privacy Policy                                 |
| /terms/          | Terms of Service                               |
| /support/        | Searchable help centre and contact options     |
| /delete-account/ | Account deletion instructions and request form |

Navigation and footer links connect the pages. Product links return to the correct landing page section. Store buttons intentionally use # until you add the store URLs in src/data/landing.ts.

## Component structure

Every component has a dedicated folder containing its Astro markup and CSS. Each Astro component imports its own stylesheet. Behavior belongs in a separate JavaScript file where needed.

```text
src/
  components/
    brand/Brand.astro + brand.css
    navbar/TheNavbar.astro + navbar.css
    hero/HeroSection.astro + hero.css
    comeback/ComebackSection.astro + comeback.css
    features/FeaturesSection.astro + features.css
    how_it_works/HowItWorksSection.astro + how_it_works.css
    pricing/PricingSection.astro + pricing.css
    faq/FaqSection.astro + faq.css
    download/DownloadSection.astro + download.css
    footer/TheFooter.astro + footer.css
    page_header/PageHeader.astro + page_header.css
    legal_document/LegalDocument.astro + legal_document.css
    support_center/SupportCenter.astro + support_center.css + support_center.js
    delete_account/DeleteAccount.astro + delete_account.css + delete_account.js
  config/site.ts
  data/landing.ts + legal.ts + support.ts
  layouts/Layout.astro + DocumentLayout.astro + document_layout.css
  pages/index.astro + privacy.astro + terms.astro + support.astro + delete-account.astro
  scripts/script.js
  styles/global.css + tokens.css + base.css + shared.css + landing.css
```

Global CSS contains only design tokens, resets, base element styles, and shared button/tag patterns. Component CSS owns its layout and responsive rules. Files use two-space formatting and blank lines between rules. Prettier maintains the format.

## Spacing and motion

Set --page_gap in src/styles/tokens.css to control the header, main, and footer rhythm. Set --section_gap to control every landing section gap, including the hero and comeback section. Each section is a direct child of the flex main wrapper. The setup cards share equal grid row heights.

The mobile navbar contains only the logo and app button, spaced apart. Lenis and reveals use the shared 600ms easing preset, respect reduced motion, and clean up listeners and observers on page exit. Touch scrolling stays native. FAQs and help articles use native keyboard-accessible disclosures.

## Pricing switch

Pricing is hidden. Change showPricing to true in src/config/site.ts to restore both the section and its navbar/footer links. Its component, styles, and plan data are retained for that purpose.

## Contact and account deletion

Update src/config/site.ts:

- operatorName and operatorAddress for the published operator details.
- supportEmail and privacyEmail for live contact links. Privacy falls back to the support inbox.
- deletionEndpoint for an optional HTTPS or same-origin POST endpoint.
- deletionDays and updatedDate to match the actual deletion process and policy date.

Until an inbox or endpoint is configured, the website explains that online requests are unavailable and disables the request button. It does not collect or pretend to submit requests. The in-app deletion instructions remain visible.

When an inbox is configured without an endpoint, submitting the validated form opens a prepared email. The user must send that email to complete the request. When an endpoint is configured, the form POSTs JSON containing email, reason, and confirmed. A successful 2xx response means the request was received, not that deletion has already happened. Errors retain the form contents and show a retry message.

The receiving service must validate the request, verify account ownership, rate-limit abuse, and carry out deletion. No backend, inbox, or account database is provisioned by this static website.

The policy copy follows the app behavior described in Figma, including local files, witnesses, optional advertising/purchases, age 18+, and a 30-day deletion target. Confirm those statements against the shipped Flutter app and its SDKs before publication. Google Play requires an accessible privacy policy and a functional external account deletion request path for apps that create accounts:

- https://support.google.com/googleplay/android-developer/answer/10144311
- https://support.google.com/googleplay/android-developer/answer/13327111

## Artwork

public/images contains original Figma assets. All raster artwork was re-exported at 3× resolution: hero 3936 × 1680, comeback 1860 × 1800, phone cards 1008 × 1761, dark app preview 960 × 1320, and avatars 282 × 282. Images preserve their original aspect ratios; phone export padding is clipped by the feature visual wrapper. Icons and patterns remain SVG. Fonts are self-hosted with their license in public/fonts.
