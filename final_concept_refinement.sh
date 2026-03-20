#!/bin/bash

# 1. Update Navigation (Footer Taglines)
cat << 'INNER' > src/navigation.ts
import { getPermalink } from './utils/permalinks';

export const headerData = {
  links: [
    { text: 'Features', href: getPermalink('/#features') },
    { text: 'How It Works', href: getPermalink('/#howitworks') },
    { text: 'The Story', href: getPermalink('/about') },
    { text: 'Grab Your Vanity URL', href: getPermalink('/pricing') },
  ],
  actions: [
    { text: 'Get Started - $99', variant: 'primary', href: '/pricing' }
  ],
};

export const footerData = {
  links: [
    {
      title: 'Schedule.Hair — Boutique Booking for Stylists',
      links: [
        { text: "Claim Your Spot – $99", href: getPermalink('/pricing') },
        { text: 'Why We Love Salons', href: getPermalink('/about') },
        { text: 'Support', href: getPermalink('/contact') },
      ],
    },
  ],
  secondaryLinks: [
    { text: 'Terms of Service', href: getPermalink('/terms') },
    { text: 'Privacy Policy', href: getPermalink('/privacy') },
  ],
  socialLinks: [],
  footNote: '✂️ Schedule Hair — Fill Your Chairs on Autopilot. | © ' + new Date().getFullYear() + ' Schedule.Hair',
};
INNER

# 2. Update Pricing Page (New High-End Messaging)
cat << 'INNER' > src/pages/pricing.astro
---
import Layout from '~/layouts/PageLayout.astro';
import HeroText from '~/components/widgets/HeroText.astro';
import Pricing from '~/components/widgets/Pricing.astro';
import FAQs from '~/components/widgets/FAQs.astro';
import Features3 from '~/components/widgets/Features3.astro';
import { lifetimeDeal } from '~/data/pricingData';

const metadata = { 
  title: 'Pricing - Schedule.Hair | Professional Digital Presence', 
  description: 'Elevate your salon brand with a professional vanity URL. One-time fee for a lifetime of premium bookings.' 
};
---
<Layout metadata={metadata}>
  <HeroText 
    tagline="Elevate Your Digital Handshake"
    title="Your Professional Identity, <span class='text-accent'>Perfected.</span>" 
    subtitle="Generic booking links look temporary. We build you a branded vanity URL that integrates directly with your Google Business Profile 'Schedule' link. Make your first impression count with an experience that signals trust and artistry."
  />

  <Pricing prices={[lifetimeDeal]} />

  <Features3
    title="Premium Features Included"
    columns={3}
    items={[
      { title: 'Branded Vanity URL', description: 'A clean, memorable web address (yoursalon.schedule.hair) that belongs to you.', icon: 'tabler:link' },
      { title: 'Google Business Sync', description: 'Expert help linking your URL to the blue Google "Schedule" button for maximum SEO.', icon: 'tabler:brand-google' },
      { title: 'Boutique UX', description: 'A mobile-first booking interface designed to look like a luxury salon app.', icon: 'tabler:device-mobile' },
      { title: 'Unlimited Potential', description: 'Zero caps on appointments, services, or revenue. Your business, your growth.', icon: 'tabler:infinity' },
      { title: 'Immediate Trust', description: 'Show clients you are an established professional from the very first click.', icon: 'tabler:shield-check' },
      { title: 'Lifetime Setup', description: 'Pay once, own it forever. We handle hosting and technical maintenance.', icon: 'tabler:tool' },
    ]}
  />

  <FAQs
    title="Frequently Asked Questions"
    items={[
        { title: 'How does this help my Google ranking?', description: 'Google prioritizes salons with high-quality, relevant links. A clean schedule.hair domain linked to your profile signals to Google that your digital presence is managed and professional.', icon: 'tabler:trending-up' },
        { title: 'Can I use this with my existing calendar?', description: 'Yes! We act as your high-end front door. We can link your vanity URL to any existing system or provide you with our own custom calendar interface.', icon: 'tabler:layout' },
    ]}
  />
</Layout>
INNER

# 3. Update Pricing Widget (Dynamic PayPal Cart Description)
cat << 'INNER' > src/components/widgets/Pricing.astro
---
import { Icon } from 'astro-icon/components';
import Button from '~/components/ui/Button.astro';
import Headline from '~/components/ui/Headline.astro';
import WidgetWrapper from '~/components/ui/WidgetWrapper.astro';
import type { Price } from '~/types';

const { title, subtitle, tagline, prices = [], classes = {}, ...rest } = Astro.props;
---

<WidgetWrapper {...rest} id="pricing" classes={{ container: 'max-w-7xl scroll-mt-16', ...classes.container }} hasBackground>
  <Headline {title} {subtitle} {tagline} classes={{ headline: 'max-w-3xl' }} />
  
  <div class="flex justify-center">
    {prices.map((price) => (
      <div class="relative overflow-visible flex flex-col rounded-xl border-2 border-blue-600 p-8 text-center shadow-2xl w-full max-w-lg bg-white dark:bg-slate-900">
        
        <div class="absolute -top-4 left-1/2 transform -translate-x-1/2 bg-blue-600 text-white px-6 py-1 rounded-full text-xs font-black uppercase tracking-widest shadow-lg">
            Guaranteed Same-Day Setup
        </div>

        <h3 class="text-3xl font-black text-slate-900 dark:text-white mt-4">{price.title}</h3>
        
        <div class="mt-8 flex-1">
          <div class="flex items-end justify-center">
            <span class="text-6xl font-black tracking-tighter text-blue-600">$99</span>
            <span class="ml-2 text-lg font-bold text-slate-500 uppercase">one-time</span>
          </div>
          
          <ul role="list" class="mt-8 space-y-4 text-left border-t border-slate-100 pt-8 dark:border-slate-800">
            {price.items.map((item) => (
              <li class="flex items-start">
                <Icon name="tabler:circle-check-filled" class="w-6 h-6 text-green-500 flex-shrink-0" />
                <p class="ml-3 text-base font-bold text-slate-700 dark:text-slate-300">{item.description}</p>
              </li>
            ))}
          </ul>
        </div>
        
        <div class="mt-10 p-6 rounded-2xl bg-slate-50 dark:bg-slate-800/50 border border-slate-200 dark:border-slate-700 shadow-inner">
          <form id="paypal-form" action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_blank">
            <input type="hidden" name="cmd" value="_xclick" />
            <input type="hidden" name="business" value="ZFG89TK2KESFG" />
            
            {/* THIS ITEM NAME IS UPDATED DYNAMICALLY BY THE SCRIPT BELOW */}
            <input type="hidden" id="dynamic-item-name" name="item_name" value="Schedule Hair Professional Vanity URL Setup" />
            
            <input type="hidden" name="item_number" value="SHURL99" />
            <input type="hidden" name="amount" value="99.00" />
            <input type="hidden" name="currency_code" value="USD" />
            <input type="hidden" name="no_shipping" value="1" />
            <input type="hidden" name="landing_page" value="billing" />
            <input type="hidden" name="solution_type" value="sole" />

            <div class="text-left mb-6">
              <label class="block text-sm font-black uppercase tracking-tight mb-2 text-slate-800 dark:text-gray-200">
                1. Choose Your Vanity URL
              </label>
              <input type="hidden" name="on0" value="Vanity URL" />
              <input 
                  type="text" 
                  id="vanity-input" 
                  name="os0" 
                  required 
                  class="w-full px-4 py-4 border-2 border-slate-300 rounded-xl focus:ring-4 focus:ring-blue-600/20 focus:border-blue-600 dark:bg-slate-900 dark:border-slate-600 transition-all font-bold text-lg" 
                  placeholder="yoursalon" 
              />
              
              <div class="mt-3 p-4 bg-white dark:bg-slate-950 rounded-xl border-2 border-dashed border-blue-600/30 flex items-center gap-3">
                <Icon name="tabler:world" class="w-5 h-5 text-blue-600" />
                <span class="text-sm font-bold truncate text-slate-600 dark:text-slate-400">
                    https://<span id="vanity-preview" class="text-blue-600 underline decoration-2 underline-offset-4">yoursalon</span>.schedule.hair
                </span>
              </div>
            </div>

            <div class="text-left mb-8">
              <label class="block text-sm font-black uppercase tracking-tight mb-2 text-slate-800 dark:text-gray-200">
                2. Salon Name
              </label>
              <input type="hidden" name="on1" value="Salon Name" />
              <input 
                type="text" 
                id="salon-input"
                name="os1" 
                required 
                class="w-full px-4 py-4 border-2 border-slate-300 rounded-xl focus:ring-4 focus:ring-blue-600/20 focus:border-blue-600 dark:bg-slate-900 dark:border-slate-600 transition-all font-bold text-lg" 
                placeholder="Business Name" 
              />
            </div>

            <button type="submit" class="w-full py-5 px-4 bg-blue-600 hover:bg-blue-700 text-white font-black rounded-xl shadow-xl hover:shadow-2xl transform hover:-translate-y-1 transition-all duration-200 text-xl uppercase tracking-tighter">
              Secure My URL Today
            </button>
            
            <div class="flex items-center justify-center gap-2 mt-6 text-slate-400">
                <Icon name="tabler:credit-card" class="w-4 h-4" />
                <p class="text-[10px] font-black uppercase tracking-widest">Secure Checkout (Card or PayPal)</p>
            </div>
          </form>
        </div>
      </div>
    ))}
  </div>
</WidgetWrapper>

<script is:inline>
  function initVanity() {
    const form = document.getElementById('paypal-form');
    const input = document.getElementById('vanity-input');
    const salonInput = document.getElementById('salon-input');
    const preview = document.getElementById('vanity-preview');
    const dynamicItem = document.getElementById('dynamic-item-name');

    if (input && preview) {
      input.addEventListener('input', (e) => {
        let val = e.target.value.toLowerCase().replace(/[^a-z0-9]/g, '');
        input.value = val;
        preview.textContent = val || 'yoursalon';
      });
    }

    if (form) {
      form.addEventListener('submit', () => {
        const url = input.value || 'yoursalon';
        const salon = salonInput.value || 'Salon Name';
        // This updates the PayPal cart text dynamically on click
        dynamicItem.value = `Setup: ${url}.schedule.hair | Salon: ${salon}`;
      });
    }
  }
  document.addEventListener('astro:page-load', initVanity);
  initVanity();
</script>
INNER

# Commit and Push
git add .
git commit -m "Final Concept Refinement: Dynamic PayPal Cart info, updated pricing copy, and footer taglines"
git push

echo "ALL UPDATES APPLIED: Check the checkout to see the custom cart info!"
