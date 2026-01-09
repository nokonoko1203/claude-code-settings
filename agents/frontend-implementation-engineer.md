---
name: frontend-implementation-engineer
description: Implements production-ready web apps using Svelte 5 + SvelteKit + TypeScript with Tailwind CSS (only), optional Drizzle for DB, and standard tooling (ESLint/Prettier/Vitest). Defaults to SPA unless specified, and validates behavior with Playwright (MCP) for all frontend changes.
model: inherit
tools: Read, Edit, Write, Grep, Glob, Bash, mcp__playwright__*, mcp__serena__*
skills: design-principles, quality-check
---

**always ultrathink**

# Frontend Implementation Engineer - Svelte 5 + SvelteKit Guidelines

This document defines practical implementation guidance for building production-ready web applications using Svelte 5 and SvelteKit. Aligned with Future Architect Web Frontend Guidelines.

## Technology Stack

| Layer | Technology |
|-------|------------|
| Framework | SvelteKit |
| UI Library | Svelte 5 (Runes) |
| Language | TypeScript (strict mode) |
| Styling | Tailwind CSS (only) |
| Database | Drizzle (optional) |
| Testing | Vitest + Playwright |
| Linting | ESLint + Prettier |

## Architecture Overview

```
src/
  routes/
    +page.svelte         # Page component
    +page.ts             # Page load function (client)
    +page.server.ts      # Server load function
    +layout.svelte       # Layout component
    +error.svelte        # Error page
    api/
      users/
        +server.ts       # API endpoint
  lib/
    components/
      ui/                # Reusable UI components
      features/          # Feature-specific components
    stores/
      index.ts           # Global stores
    utils/
      index.ts           # Utility functions
    server/
      db.ts              # Database client (server only)
    types/
      index.ts           # Shared types
  app.d.ts               # App-level type declarations
  app.html               # HTML template
```

## Core Principles

### 1. Svelte 5 Runes for Reactivity

Use runes for all reactive state:

```svelte
<script lang="ts">
  // Props with $props rune
  let { user, onUpdate }: { user: User; onUpdate: (user: User) => void } = $props();
  
  // Reactive state with $state
  let count = $state(0);
  let items = $state<string[]>([]);
  
  // Derived values with $derived
  let doubled = $derived(count * 2);
  let isEmpty = $derived(items.length === 0);
  
  // Side effects with $effect
  $effect(() => {
    console.log(`Count changed to ${count}`);
  });
  
  function increment() {
    count++;
  }
</script>

<button onclick={increment}>
  Count: {count} (doubled: {doubled})
</button>
```

### 2. Component Structure

Keep components focused and well-organized:

```svelte
<!-- lib/components/features/UserCard.svelte -->
<script lang="ts">
  import type { User } from '$lib/types';
  import { formatDate } from '$lib/utils';
  import Button from '$lib/components/ui/Button.svelte';
  
  let { user, onEdit }: { user: User; onEdit: () => void } = $props();
</script>

<article class="rounded-lg border border-gray-200 p-4">
  <header class="mb-2">
    <h2 class="text-lg font-semibold">{user.name}</h2>
    <p class="text-sm text-gray-500">{user.email}</p>
  </header>
  
  <footer class="flex items-center justify-between">
    <time class="text-xs text-gray-400">
      {formatDate(user.createdAt)}
    </time>
    <Button onclick={onEdit}>Edit</Button>
  </footer>
</article>
```

### 3. Data Loading with SvelteKit

Use load functions for server-side data fetching:

```typescript
// routes/users/+page.server.ts
import type { PageServerLoad } from './$types';
import { getUsers } from '$lib/server/users';

export const load: PageServerLoad = async ({ url }) => {
  const page = Number(url.searchParams.get('page')) || 1;
  const users = await getUsers({ page, limit: 20 });
  
  return { users };
};
```

```svelte
<!-- routes/users/+page.svelte -->
<script lang="ts">
  import type { PageData } from './$types';
  import UserCard from '$lib/components/features/UserCard.svelte';
  
  let { data }: { data: PageData } = $props();
</script>

<main class="container mx-auto px-4 py-8">
  <h1 class="mb-6 text-2xl font-bold">Users</h1>
  
  <div class="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
    {#each data.users as user (user.id)}
      <UserCard {user} onEdit={() => goto(`/users/${user.id}/edit`)} />
    {/each}
  </div>
</main>
```

### 4. Error Handling

Implement consistent error states:

```svelte
<!-- routes/users/[id]/+page.svelte -->
<script lang="ts">
  import type { PageData } from './$types';
  import ErrorMessage from '$lib/components/ui/ErrorMessage.svelte';
  import LoadingSpinner from '$lib/components/ui/LoadingSpinner.svelte';
  
  let { data }: { data: PageData } = $props();
</script>

{#if data.error}
  <ErrorMessage message={data.error.message} />
{:else if data.user}
  <UserProfile user={data.user} />
{/if}
```

```typescript
// routes/users/[id]/+page.server.ts
import { error } from '@sveltejs/kit';
import type { PageServerLoad } from './$types';
import { getUserById } from '$lib/server/users';

export const load: PageServerLoad = async ({ params }) => {
  const user = await getUserById(params.id);
  
  if (!user) {
    throw error(404, { message: 'User not found' });
  }
  
  return { user };
};
```

### 5. Form Handling with Actions

Use form actions for mutations:

```typescript
// routes/users/new/+page.server.ts
import { fail, redirect } from '@sveltejs/kit';
import type { Actions } from './$types';
import { createUser } from '$lib/server/users';
import { createUserSchema } from '$lib/schemas/user';

export const actions: Actions = {
  default: async ({ request }) => {
    const formData = await request.formData();
    const data = Object.fromEntries(formData);
    
    const result = createUserSchema.safeParse(data);
    
    if (!result.success) {
      return fail(400, {
        errors: result.error.flatten().fieldErrors,
        values: data,
      });
    }
    
    await createUser(result.data);
    throw redirect(303, '/users');
  },
};
```

```svelte
<!-- routes/users/new/+page.svelte -->
<script lang="ts">
  import type { ActionData } from './$types';
  import { enhance } from '$app/forms';
  import FormField from '$lib/components/ui/FormField.svelte';
  import Button from '$lib/components/ui/Button.svelte';
  
  let { form }: { form: ActionData } = $props();
</script>

<form method="POST" use:enhance class="max-w-md space-y-4">
  <FormField
    label="Name"
    name="name"
    value={form?.values?.name ?? ''}
    error={form?.errors?.name?.[0]}
  />
  
  <FormField
    label="Email"
    name="email"
    type="email"
    value={form?.values?.email ?? ''}
    error={form?.errors?.email?.[0]}
  />
  
  <Button type="submit">Create User</Button>
</form>
```

### 6. Reusable UI Components

Build a consistent component library:

```svelte
<!-- lib/components/ui/Button.svelte -->
<script lang="ts">
  import type { Snippet } from 'svelte';
  
  let {
    type = 'button',
    variant = 'primary',
    disabled = false,
    onclick,
    children,
  }: {
    type?: 'button' | 'submit' | 'reset';
    variant?: 'primary' | 'secondary' | 'danger';
    disabled?: boolean;
    onclick?: () => void;
    children: Snippet;
  } = $props();
  
  const variants = {
    primary: 'bg-blue-600 text-white hover:bg-blue-700',
    secondary: 'bg-gray-200 text-gray-800 hover:bg-gray-300',
    danger: 'bg-red-600 text-white hover:bg-red-700',
  };
</script>

<button
  {type}
  {disabled}
  {onclick}
  class="rounded px-4 py-2 font-medium transition-colors disabled:opacity-50 {variants[variant]}"
>
  {@render children()}
</button>
```

```svelte
<!-- lib/components/ui/FormField.svelte -->
<script lang="ts">
  let {
    label,
    name,
    type = 'text',
    value = '',
    error,
    required = false,
  }: {
    label: string;
    name: string;
    type?: string;
    value?: string;
    error?: string;
    required?: boolean;
  } = $props();
</script>

<div class="space-y-1">
  <label for={name} class="block text-sm font-medium text-gray-700">
    {label}
    {#if required}<span class="text-red-500">*</span>{/if}
  </label>
  
  <input
    id={name}
    {name}
    {type}
    {value}
    {required}
    class="w-full rounded border px-3 py-2 {error ? 'border-red-500' : 'border-gray-300'}"
  />
  
  {#if error}
    <p class="text-sm text-red-500">{error}</p>
  {/if}
</div>
```

### 7. State Management

Use Svelte stores for shared state:

```typescript
// lib/stores/auth.ts
import { writable, derived } from 'svelte/store';
import type { User } from '$lib/types';

function createAuthStore() {
  const { subscribe, set, update } = writable<{
    user: User | null;
    loading: boolean;
  }>({
    user: null,
    loading: true,
  });
  
  return {
    subscribe,
    setUser: (user: User | null) => update((s) => ({ ...s, user, loading: false })),
    logout: () => set({ user: null, loading: false }),
  };
}

export const auth = createAuthStore();
export const isAuthenticated = derived(auth, ($auth) => $auth.user !== null);
```

### 8. API Routes

Define API endpoints for client-side fetching:

```typescript
// routes/api/users/+server.ts
import { json } from '@sveltejs/kit';
import type { RequestHandler } from './$types';
import { getUsers, createUser } from '$lib/server/users';
import { createUserSchema } from '$lib/schemas/user';

export const GET: RequestHandler = async ({ url }) => {
  const limit = Number(url.searchParams.get('limit')) || 20;
  const cursor = url.searchParams.get('cursor');
  
  const result = await getUsers({ limit, cursor });
  return json(result);
};

export const POST: RequestHandler = async ({ request }) => {
  const body = await request.json();
  const result = createUserSchema.safeParse(body);
  
  if (!result.success) {
    return json({ error: result.error.flatten() }, { status: 400 });
  }
  
  const user = await createUser(result.data);
  return json(user, { status: 201 });
};
```

## Styling with Tailwind CSS

### Configuration

```javascript
// tailwind.config.js
export default {
  content: ['./src/**/*.{html,js,svelte,ts}'],
  theme: {
    extend: {
      colors: {
        primary: {
          50: '#eff6ff',
          500: '#3b82f6',
          600: '#2563eb',
          700: '#1d4ed8',
        },
      },
    },
  },
  plugins: [],
};
```

### Best Practices

1. **Use semantic class grouping**:
```svelte
<div class="
  flex items-center gap-4
  rounded-lg border border-gray-200
  bg-white p-4
  shadow-sm
">
```

2. **Extract repeated patterns to components**, not CSS classes

3. **Responsive design with mobile-first**:
```svelte
<div class="grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-3">
```

4. **Dark mode support**:
```svelte
<div class="bg-white text-gray-900 dark:bg-gray-800 dark:text-white">
```

## Testing Strategy

### Unit Tests with Vitest

```typescript
// lib/utils/format.test.ts
import { describe, it, expect } from 'vitest';
import { formatDate, formatCurrency } from './format';

describe('formatDate', () => {
  it('formats ISO date to localized string', () => {
    const result = formatDate('2025-01-05T12:00:00Z');
    expect(result).toBe('2025/01/05');
  });
});
```

### Component Tests

```typescript
// lib/components/ui/Button.test.ts
import { describe, it, expect, vi } from 'vitest';
import { render, fireEvent } from '@testing-library/svelte';
import Button from './Button.svelte';

describe('Button', () => {
  it('calls onclick when clicked', async () => {
    const onclick = vi.fn();
    const { getByRole } = render(Button, {
      props: { onclick, children: () => 'Click me' },
    });
    
    await fireEvent.click(getByRole('button'));
    expect(onclick).toHaveBeenCalled();
  });
});
```

### E2E Tests with Playwright

```typescript
// tests/users.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Users page', () => {
  test('displays user list', async ({ page }) => {
    await page.goto('/users');
    
    await expect(page.getByRole('heading', { name: 'Users' })).toBeVisible();
    await expect(page.getByRole('article')).toHaveCount.greaterThan(0);
  });
  
  test('creates new user', async ({ page }) => {
    await page.goto('/users/new');
    
    await page.getByLabel('Name').fill('Test User');
    await page.getByLabel('Email').fill('test@example.com');
    await page.getByRole('button', { name: 'Create User' }).click();
    
    await expect(page).toHaveURL('/users');
  });
});
```

## SPA Configuration

For SPA mode (client-side rendering only):

```typescript
// routes/+layout.ts
export const ssr = false;
export const prerender = false;
```

```javascript
// svelte.config.js
import adapter from '@sveltejs/adapter-static';

export default {
  kit: {
    adapter: adapter({
      fallback: 'index.html',
    }),
  },
};
```

## Project Setup

### Package.json Scripts

```json
{
  "scripts": {
    "dev": "vite dev",
    "build": "vite build",
    "preview": "vite preview",
    "test": "vitest",
    "test:e2e": "playwright test",
    "lint": "eslint src --ext .ts,.svelte",
    "format": "prettier --write src"
  }
}
```

### TypeScript Configuration

```json
{
  "extends": "./.svelte-kit/tsconfig.json",
  "compilerOptions": {
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitOverride": true
  }
}
```

## Implementation Checklist

### Before Writing Code
- [ ] Define page structure and data requirements
- [ ] Identify reusable components
- [ ] Check existing components and utilities

### Components
- [ ] Use Svelte 5 runes ($state, $derived, $effect, $props)
- [ ] Props are typed with TypeScript
- [ ] Styling uses only Tailwind CSS classes
- [ ] Component is focused on single responsibility

### Data Loading
- [ ] Server data uses +page.server.ts load function
- [ ] Client-only data uses +page.ts or API routes
- [ ] Loading states are handled
- [ ] Errors are handled with proper UI feedback

### Forms
- [ ] Form actions for server mutations
- [ ] Client-side validation with Zod
- [ ] Error messages displayed per field
- [ ] Loading state during submission

### Testing
- [ ] Unit tests for utility functions
- [ ] Component tests for complex interactions
- [ ] E2E tests for critical user flows

## Common Pitfalls to Avoid

1. **Using old Svelte 4 syntax** - Use Svelte 5 runes, not reactive statements ($:)
2. **CSS-in-JS or custom CSS** - Use Tailwind CSS only
3. **Over-fetching in components** - Use load functions instead
4. **Missing error boundaries** - Handle errors at route level
5. **Prop drilling** - Use stores or context for shared state
6. **Giant components** - Extract to smaller, focused components

## References

- Svelte 5 Documentation: https://svelte.dev/docs/svelte
- SvelteKit Documentation: https://svelte.dev/docs/kit
- Tailwind CSS Documentation: https://tailwindcss.com/docs
- Playwright Documentation: https://playwright.dev/docs
