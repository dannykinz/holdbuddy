export const supportTopics = [
  {
    id: 'getting_started',
    title: 'Getting started',
    description: 'Your first plan and the commitment',
    tone: 'sky',
  },
  {
    id: 'partners',
    title: 'Partners and witnesses',
    description: 'Invitations, requests, and holding each other',
    tone: 'pink',
  },
  {
    id: 'material',
    title: 'Material and focus',
    description: 'PDFs, audio, and fewer interruptions',
    tone: 'violet',
  },
  {
    id: 'billing',
    title: 'Purchases and billing',
    description: 'Restore purchases and manage subscriptions',
    tone: 'orange',
  },
] as const;

export interface HelpArticle {
  id: string;
  topic: (typeof supportTopics)[number]['id'];
  title: string;
  paragraphs: readonly string[];
  link?: { label: string; href: string };
}

export const helpArticles: readonly HelpArticle[] = [
  {
    id: 'reminders',
    topic: 'getting_started',
    title: 'My reminders are not arriving',
    paragraphs: [
      'Check that notifications are allowed for Holdbuddy in your phone settings. Then check the study days, time, and deadline reminders in your plan.',
      'Battery-saving settings and Do Not Disturb can delay or silence notifications. Review these settings if reminders still do not arrive. Keep a separate reminder for deadlines you cannot afford to miss.',
    ],
  },
  {
    id: 'change_witness',
    topic: 'partners',
    title: 'How do I change my witness?',
    paragraphs: [
      'Open the plan you want to update and review its witness or partner options. Choose someone who has agreed to support you, and check their contact details before sending a new invitation.',
      'A witness can decline or stop taking part. They only see the plan and updates you share, never your private notes or files.',
    ],
  },
  {
    id: 'restore_purchase',
    topic: 'billing',
    title: 'Restore a purchase on a new phone',
    paragraphs: [
      'Sign in to the same Google Play or Apple account you used for the purchase, then use the restore purchase option in Holdbuddy. Check that the purchase or subscription still appears in your store account.',
      'Subscriptions are managed by the store. To cancel a renewal or ask about a refund, use Google Play or Apple’s purchase support. Never send us your password or full card details.',
    ],
  },
  {
    id: 'local_files',
    topic: 'material',
    title: 'Where are my PDFs stored?',
    paragraphs: [
      'Your PDFs, documents, and audio stay in the location you selected on your phone. Holdbuddy remembers how to open them. If you move or delete a file, you may need to select it again.',
      'Notes and highlights are kept on your device. Export a backup before changing phones or uninstalling the app.',
    ],
  },
  {
    id: 'delete_account_help',
    topic: 'getting_started',
    title: 'How do I delete my account?',
    paragraphs: [
      'Open Holdbuddy and tap your profile photo. Go to Settings, then Edit profile, and choose Delete account. Confirm only when you are ready, because account deletion cannot be undone.',
      'Our account deletion page explains what is removed, what may be retained, and how to request help without reinstalling the app. Cancel any active store subscription separately.',
    ],
    link: { label: 'Open the account deletion page', href: '/delete-account/' },
  },
  {
    id: 'first_plan',
    topic: 'getting_started',
    title: 'Create your first study plan',
    paragraphs: [
      'Choose a course, add the chapters you want to cover, and select realistic study days and times. Set a finish date, then invite one person who has agreed to be your witness.',
      'Write the message you would want them to receive if you miss a session. If a day does not go to plan, return to the next chapter instead of starting over.',
    ],
  },
  {
    id: 'focus_mode',
    topic: 'material',
    title: 'How does focus mode work?',
    paragraphs: [
      'Start a study session to bring your timer, chapter tasks, notes, and materials together. On Android, allow Do Not Disturb access if you want Holdbuddy to silence other apps during the session.',
      'You control that permission in your device settings. You can still study without it, and you can pause or end a session when you need to.',
    ],
  },
];
