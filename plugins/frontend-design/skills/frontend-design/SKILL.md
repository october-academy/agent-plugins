---
name: frontend-design
description: Create distinctive, production-grade frontend interfaces with high design quality. Use when the user asks to build or style web components, pages, websites, landing pages, dashboards, or applications — including HTML/CSS files, React components, navigation, forms, animations, and responsive layouts. Generates creative, polished UI code with intentional typography, color, and motion, avoiding generic AI aesthetics. Ideal for requests involving visual design, CSS styling, UI polish, or building any interactive frontend element.
user-invocable: true
argument-hint: [component description]
allowed-tools: WebSearch
---

# Frontend Design Skill

## Conceptual Direction

Before writing any code, choose a clear aesthetic direction and execute it with precision — consider the audience, the context, and what will make this design memorable.

## Typography

Choose fonts that are beautiful, unique, and interesting. Avoid generic fonts like Arial and Inter; opt instead for distinctive choices that elevate the frontend's aesthetics.

**Recommended Font Pairings** (use Google Fonts):
- **Editorial / Literary**: Playfair Display (headings) + Source Sans 3 (body) — `https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Source+Sans+3:wght@300;400;600&display=swap`
- **Modern / Tech**: Space Grotesk (headings) + DM Sans (body) — `https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@500;700&family=DM+Sans:wght@300;400&display=swap`
- **Warm / Humanist**: Fraunces (headings) + Nunito (body) — `https://fonts.googleapis.com/css2?family=Fraunces:wght@300;700&family=Nunito:wght@400;600&display=swap`
- **Futuristic**: Rajdhani (headings) + Share Tech Mono (code/accents) — `https://fonts.googleapis.com/css2?family=Rajdhani:wght@500;700&family=Share+Tech+Mono&display=swap`

**Base typography setup**:
```css
:root {
  --font-display: 'Playfair Display', Georgia, serif;
  --font-body: 'Source Sans 3', system-ui, sans-serif;
  --scale-xs: clamp(0.75rem, 1.5vw, 0.875rem);
  --scale-sm: clamp(0.875rem, 2vw, 1rem);
  --scale-base: clamp(1rem, 2.5vw, 1.125rem);
  --scale-lg: clamp(1.25rem, 3vw, 1.5rem);
  --scale-xl: clamp(1.75rem, 5vw, 2.5rem);
  --scale-2xl: clamp(2.5rem, 8vw, 4rem);
}

body {
  font-family: var(--font-body);
  font-size: var(--scale-base);
  line-height: 1.6;
}
```

## Color & Theme

Establish a cohesive color palette using CSS variables. Build your theme around a dominant color that sets the mood, sharp accent colors for interactive elements, and thoughtful contrast ratios for accessibility. Avoid clichéd color schemes (like generic purple gradients); choose colors that match the specific context and purpose.

**Example palette setup**:
```css
:root {
  /* Dominant */
  --color-bg: #0d0f14;
  --color-surface: #161a23;
  --color-border: rgba(255, 255, 255, 0.08);

  /* Text */
  --color-text-primary: #f0ede8;
  --color-text-secondary: #8b8fa8;

  /* Accent */
  --color-accent: #e8c547;
  --color-accent-hover: #f0d060;
  --color-accent-muted: rgba(232, 197, 71, 0.12);

  /* Semantic */
  --color-success: #4caf82;
  --color-error: #e05c5c;
}
```

## Motion & Animation

Prioritize CSS-only solutions or the Motion library for React. Focus on high-impact moments: orchestrated page load sequences with staggered reveals, meaningful hover states, and smooth transitions between states. Avoid scattered micro-interactions that don't serve a purpose.

**Accessible animation pattern** (always include this):
```css
@media (prefers-reduced-motion: no-preference) {
  .reveal {
    opacity: 0;
    transform: translateY(20px);
    animation: revealUp 0.5s cubic-bezier(0.16, 1, 0.3, 1) forwards;
  }

  .reveal:nth-child(2) { animation-delay: 0.1s; }
  .reveal:nth-child(3) { animation-delay: 0.2s; }

  @keyframes revealUp {
    to { opacity: 1; transform: translateY(0); }
  }
}

/* Respect user preference */
@media (prefers-reduced-motion: reduce) {
  * { animation-duration: 0.01ms !important; transition-duration: 0.01ms !important; }
}
```

**Hover state example**:
```css
.card {
  transition: transform 0.2s cubic-bezier(0.34, 1.56, 0.64, 1),
              box-shadow 0.2s ease;
}

.card:hover {
  transform: translateY(-4px);
  box-shadow: 0 16px 40px rgba(0, 0, 0, 0.3);
}
```

## Spatial Composition

Move beyond predictable grid layouts. Consider asymmetrical arrangements that create visual interest, strategic use of overlap and layering, diagonal flow and unexpected alignments, and either generous negative space OR controlled density (not both).

## Visual Details

Add atmosphere through subtle gradients and color transitions, textures and patterns where appropriate, shadows and depth effects, and context-specific decorative elements.

**Depth and texture example**:
```css
.hero {
  background:
    radial-gradient(ellipse 80% 60% at 50% -10%, rgba(232, 197, 71, 0.15), transparent),
    linear-gradient(180deg, var(--color-bg) 0%, var(--color-surface) 100%);
}

.glass-card {
  background: rgba(255, 255, 255, 0.04);
  backdrop-filter: blur(12px);
  border: 1px solid var(--color-border);
  border-radius: 16px;
}
```

## Mini-Example: Styled Hero Component

Here is a complete example applying all principles — typography, color, animation, and composition:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Source+Sans+3:wght@300;400;600&display=swap" rel="stylesheet" />
  <style>
    :root {
      --font-display: 'Playfair Display', Georgia, serif;
      --font-body: 'Source Sans 3', system-ui, sans-serif;
      --color-bg: #0d0f14;
      --color-text-primary: #f0ede8;
      --color-text-secondary: #8b8fa8;
      --color-accent: #e8c547;
    }

    * { box-sizing: border-box; margin: 0; padding: 0; }

    body {
      background: var(--color-bg);
      color: var(--color-text-primary);
      font-family: var(--font-body);
      min-height: 100vh;
      display: grid;
      place-items: center;
    }

    .hero {
      text-align: center;
      padding: 4rem 2rem;
      max-width: 720px;
    }

    .hero__label {
      font-size: 0.75rem;
      letter-spacing: 0.2em;
      text-transform: uppercase;
      color: var(--color-accent);
      margin-bottom: 1.5rem;
    }

    .hero__title {
      font-family: var(--font-display);
      font-size: clamp(2.5rem, 8vw, 5rem);
      line-height: 1.1;
      margin-bottom: 1.5rem;
    }

    .hero__subtitle {
      font-size: clamp(1rem, 2.5vw, 1.2rem);
      color: var(--color-text-secondary);
      line-height: 1.7;
      margin-bottom: 2.5rem;
    }

    .hero__cta {
      display: inline-block;
      padding: 0.875rem 2rem;
      background: var(--color-accent);
      color: #0d0f14;
      font-weight: 600;
      text-decoration: none;
      border-radius: 4px;
      transition: transform 0.2s cubic-bezier(0.34, 1.56, 0.64, 1),
                  box-shadow 0.2s ease;
    }

    .hero__cta:hover {
      transform: translateY(-3px);
      box-shadow: 0 8px 24px rgba(232, 197, 71, 0.35);
    }

    @media (prefers-reduced-motion: no-preference) {
      .reveal { opacity: 0; transform: translateY(20px);
        animation: revealUp 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
      .reveal:nth-child(2) { animation-delay: 0.1s; }
      .reveal:nth-child(3) { animation-delay: 0.2s; }
      .reveal:nth-child(4) { animation-delay: 0.3s; }
      @keyframes revealUp { to { opacity: 1; transform: translateY(0); } }
    }
  </style>
</head>
<body>
  <section class="hero">
    <p class="hero__label reveal">Design &amp; Technology</p>
    <h1 class="hero__title reveal">Craft that speaks<br /><em>for itself.</em></h1>
    <p class="hero__subtitle reveal">Interfaces built with intention — every pixel, every interaction, every detail.</p>
    <a href="#" class="hero__cta reveal">Get Started</a>
  </section>
</body>
</html>
```

## What to Avoid

- Overused font families (Inter, Poppins everywhere)
- Clichéd color schemes without context-specific thought
- Predictable, generic card-based layouts
- Scattered micro-interactions that don't serve a purpose
- Designs lacking character specific to their purpose and audience

Each interface should reflect its unique purpose and audience — take creative risks matched to the context.

## Implementation Approach

Match implementation complexity to vision: maximalist designs require elaborate, detailed code; minimalist designs demand precision and restraint. Every line of code should serve the aesthetic vision.

## Validation Checklist

After implementing, verify the following before presenting the result:

- [ ] **Contrast**: Text meets WCAG AA contrast ratios (4.5:1 for body text, 3:1 for large text)
- [ ] **Reduced motion**: Animations are wrapped in `@media (prefers-reduced-motion: no-preference)` or disabled via the `reduce` query
- [ ] **Font loading**: Google Fonts `<link>` tags are present and use `display=swap`
- [ ] **Responsive**: Layout works at 375px (mobile), 768px (tablet), and 1280px+ (desktop)
- [ ] **Interactivity**: Hover/focus states are visible and meaningful
- [ ] **Coherence**: Typography, color, spacing, and motion form a unified aesthetic
