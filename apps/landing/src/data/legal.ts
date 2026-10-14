import { siteConfig, privacyEmail } from '../config/site';

export interface LegalSection {
  id: string;
  title: string;
  paragraphs?: readonly string[];
  items?: readonly string[];
  link?: { label: string; href: string };
}

export interface LegalDocument {
  title: string;
  description: string;
  intro: string;
  sections: readonly LegalSection[];
}

export const privacyPolicy: LegalDocument = {
  title: 'Privacy Policy',
  description:
    'How Holdbuddy handles your account, study plans, files, reminders, and personal information.',
  intro:
    'Your study work belongs to you. Holdbuddy keeps your notes and learning materials on your phone, and uses the information needed to run your plans, deliver reminders, and connect you with the people you choose.',
  sections: [
    {
      id: 'who_we_are',
      title: 'Who we are',
      paragraphs: [
        `${siteConfig.operatorName} provides Holdbuddy, a study planning and accountability app. This policy explains how we handle information when you use the app, our website, and our support services.${siteConfig.operatorAddress ? ` Our address is ${siteConfig.operatorAddress}.` : ''}`,
      ],
      link: {
        label: 'Contact us about privacy',
        href: privacyEmail ? `mailto:${privacyEmail}` : '/support/#contact',
      },
    },
    {
      id: 'what_we_collect',
      title: 'What we collect',
      items: [
        'Account information: your name, email address, and profile photo. If you use Google sign-in, we receive the basic profile information you choose to share.',
        'Study information: course and chapter names, study days and times, session outcomes, tasks, and deadline reminders.',
        'Partner information: the names and contact details of people you invite, their invitation status, and messages you choose to share with them.',
        'Technical information: app version, device information, notification tokens, and diagnostic reports used to deliver reminders and resolve problems.',
        'Purchase information: store transaction and entitlement records used to verify purchases. Google Play or Apple processes payments; we do not receive your payment card details.',
        'Support information: the account email and details you provide when you ask for help or request account deletion.',
      ],
    },
    {
      id: 'on_your_phone',
      title: 'What stays on your phone',
      paragraphs: [
        'Notes and highlights stay on your device. PDFs, documents, and audio remain in the location you choose; Holdbuddy remembers how to open them. We do not receive the contents of these learning materials. Backup files you export are stored wherever you save them. Keep a copy before switching phones or uninstalling the app.',
      ],
    },
    {
      id: 'witness_visibility',
      title: 'What your witness sees',
      paragraphs: [
        'A witness can see the plan you share, whether a study session happened, and the message you wrote for them. They cannot see your private notes, files, or other plans. Invite people who agree to take part, and share only contact details you have permission to use.',
      ],
    },
    {
      id: 'advertising',
      title: 'Advertising and third parties',
      paragraphs: [
        'The free app may show Google AdMob advertisements outside study sessions. AdMob may process device identifiers, advertising identifiers, and usage information to deliver and measure ads. You can manage advertising preferences in your device settings. An active ad-free purchase removes in-app advertisements.',
        'Service providers may process information on our behalf to support sign-in, hosting, notifications, diagnostics, and payments. We share only what is needed for those services. We do not sell your personal information. Information may also be disclosed when required by law or necessary to protect users and the service.',
      ],
    },
    {
      id: 'permissions',
      title: 'Permissions you control',
      items: [
        'Notifications let us remind you about sessions and deadlines.',
        'Do Not Disturb access on Android lets focus mode silence interruptions during a session you start.',
        'Contacts access is used only when you choose a witness from your contacts.',
        'File access lets Holdbuddy open the learning materials you select.',
      ],
      paragraphs: [
        'You can refuse or revoke permissions in your device settings. Features that depend on a permission may stop working until you enable it again.',
      ],
    },
    {
      id: 'use_and_security',
      title: 'How we use and protect information',
      paragraphs: [
        'We use information to maintain your account, run study plans, send reminders, deliver witness messages, verify purchases, answer requests, and improve reliability. We use appropriate access controls and security measures to protect information. No system is completely secure, so keep your sign-in details private and tell us if you suspect unauthorised account access.',
        'Some service providers may process information outside your country. Where applicable, we use safeguards required by data protection law for these transfers.',
      ],
    },
    {
      id: 'retention_and_deletion',
      title: 'Keeping and deleting your data',
      paragraphs: [
        `We keep account information while your account is active. When a deletion request is verified, we aim to remove your account and associated plans, sessions, tasks, reminders, partner connections, and messages within ${siteConfig.deletionDays} days. We may retain purchase records or other limited information where required by law, for fraud prevention, or to resolve a dispute. Retained information is restricted to those purposes.`,
        'Deleting an account does not cancel a store subscription. Manage subscriptions in Google Play or your Apple account. Local notes and files are separate from your online account; export anything you need and remove local copies yourself.',
      ],
      link: { label: 'See account deletion options', href: '/delete-account/' },
    },
    {
      id: 'your_rights',
      title: 'Your choices and rights',
      paragraphs: [
        'You can update your profile, control permissions, export local notes, and request account deletion. Depending on applicable law, you may also ask to access, correct, export, restrict, or object to the use of your personal information. We may verify your identity before completing a request. You can raise a concern with the data protection authority in your country, including the Nigeria Data Protection Commission where applicable.',
      ],
      link: { label: 'Ask about your data', href: '/support/#contact' },
    },
    {
      id: 'children',
      title: 'Age requirements',
      paragraphs: [
        'Holdbuddy is intended for people aged 18 and over. We do not knowingly collect personal information from children under 18. If you believe a child has provided information, contact us so we can investigate and remove it.',
      ],
    },
    {
      id: 'changes_and_contact',
      title: 'Changes and contact',
      paragraphs: [
        'We update the date at the top of this page when this policy changes. Significant changes will also be communicated through the app where appropriate. Our Support page provides the current contact options for privacy questions and requests.',
      ],
      link: { label: 'Go to Support', href: '/support/#contact' },
    },
  ],
};

export const termsOfService: LegalDocument = {
  title: 'Terms of Service',
  description:
    'The terms for using Holdbuddy, sharing plans with a witness, managing purchases, and closing your account.',
  intro:
    'Holdbuddy helps you make a plan and keep going. These terms explain the responsibilities we share when you use the app and website. By creating an account or using Holdbuddy, you agree to them.',
  sections: [
    {
      id: 'using_holdbuddy',
      title: 'Using Holdbuddy',
      paragraphs: [
        `Holdbuddy is provided by ${siteConfig.operatorName}. You must be at least 18 years old to use it. Keep your account details accurate, protect your sign-in credentials, and contact us if you believe someone else has accessed your account. You are responsible for activity carried out through your account.`,
      ],
    },
    {
      id: 'plans_and_partners',
      title: 'Plans, witnesses, and partners',
      paragraphs: [
        'A study plan is a commitment you make to yourself. Invite a witness only with their permission. Witnesses and partners may decline invitations or stop taking part. You are responsible for the contact details and messages you provide. Keep messages respectful, and do not use accountability features to pressure, threaten, or harass anyone.',
      ],
    },
    {
      id: 'your_content',
      title: 'Your content belongs to you',
      paragraphs: [
        'You retain ownership of your notes, study content, and learning materials. Only add or share material you have the right to use. We use the account and plan information you provide only as needed to operate Holdbuddy, as described in our Privacy Policy. You are responsible for keeping backups of local notes and files.',
      ],
      link: { label: 'Read the Privacy Policy', href: '/privacy/' },
    },
    {
      id: 'purchases',
      title: 'Free access and purchases',
      paragraphs: [
        'Available features and purchase options are shown in the app. If you buy an optional paid plan, the price, billing period, and renewal terms shown by Google Play or the App Store apply at checkout. Do not rely on an earlier advertised price.',
        'Manage, restore, or cancel purchases through the store account used to buy them. Cancellation normally stops future renewals; access continues for the period already paid for, subject to the store’s terms. Refunds follow the relevant store policy and any rights you have under applicable law. Deleting Holdbuddy or your account does not cancel a subscription.',
      ],
    },
    {
      id: 'acceptable_use',
      title: 'Use the service respectfully',
      items: [
        'Do not harass others, impersonate someone, or share unlawful material.',
        'Do not access accounts without permission, bypass safeguards, or interfere with the service.',
        'Do not misuse invitations, reminders, or messages to send spam.',
      ],
      paragraphs: [
        'We may restrict or close accounts that breach these terms, harm other users, or put the service at risk. Where appropriate, we will explain the reason and how to contact us about the decision.',
      ],
    },
    {
      id: 'availability_and_results',
      title: 'Availability and study outcomes',
      paragraphs: [
        'Holdbuddy supports planning and accountability. It does not guarantee grades, completion dates, or academic results. Reminder delivery can depend on device permissions, connectivity, battery settings, and external services. Keep a separate record of important deadlines.',
        'We may improve, change, or temporarily interrupt features for maintenance and updates. Where a material change affects a paid service, we will provide notice and any remedy required by applicable law.',
      ],
    },
    {
      id: 'ending_your_account',
      title: 'Ending your account',
      paragraphs: [
        'You can stop using Holdbuddy at any time. Delete your account through the app or use the options on our account deletion page. Export local notes you want to keep and cancel any active store subscription separately. The Privacy Policy explains what is deleted and when limited records may be retained.',
      ],
      link: { label: 'Delete your account', href: '/delete-account/' },
    },
    {
      id: 'liability',
      title: 'Responsibility and liability',
      paragraphs: [
        'To the extent permitted by law, Holdbuddy is provided on an as-available basis, without a promise that it will always be uninterrupted or error-free. We are not responsible for indirect losses arising from use of the service. Nothing in these terms excludes rights, warranties, or liabilities that cannot lawfully be excluded, including mandatory consumer protections.',
      ],
    },
    {
      id: 'governing_law',
      title: 'Governing law and changes',
      paragraphs: [
        'These terms are governed by the laws of the Federal Republic of Nigeria, without removing mandatory rights that apply where you live. We will update the date above when the terms change and provide notice of significant changes where appropriate.',
      ],
    },
    {
      id: 'contact',
      title: 'Talk to us',
      paragraphs: [
        'For questions about these terms, billing help, or account concerns, use the contact options on our Support page. Include enough detail for us to help, but never send your password or full payment card details.',
      ],
      link: { label: 'Contact Holdbuddy', href: '/support/#contact' },
    },
  ],
};
