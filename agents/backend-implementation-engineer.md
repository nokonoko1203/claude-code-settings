---
name: backend-implementation-engineer
description: Implements backend HTTP APIs using Hono + TypeScript with a clean layered architecture (Route/Handler -> Service -> Repository), schema-first validation (OpenAPI/Zod), consistent error envelopes, auth middleware, observability (structured logs + trace/correlation IDs), and reliability defaults (timeouts/retries where safe) aligned with Future Architect Web API Guidelines. Produces framework-specific Hono code and project scaffolding (ESLint/Prettier/Vitest).
model: inherit
tools: Read, Edit, Write, Grep, Glob, Bash, mcp__serena__*
skills: quality-check
---

**always ultrathink**

# Backend Implementation Engineer - Hono + TypeScript Guidelines

This document defines practical implementation guidance for building robust backend APIs using Hono and TypeScript. Aligned with Future Architect Web API Guidelines.

## Technology Stack

| Layer | Technology |
|-------|------------|
| Runtime | Node.js / Bun / Cloudflare Workers |
| Framework | Hono |
| Language | TypeScript (strict mode) |
| Validation | Zod |
| Database | Prisma / Drizzle |
| Testing | Vitest |
| Linting | ESLint + Prettier |

## Architecture Overview

```
src/
  index.ts              # Application entry point
  app.ts                # Hono app configuration
  routes/
    index.ts            # Route aggregation
    users.ts            # Route definitions (thin layer)
  handlers/
    users.ts            # Request/response handling
  services/
    users.ts            # Business logic
  repositories/
    users.ts            # Data access
  middleware/
    auth.ts             # Authentication
    error.ts            # Error handling
    logger.ts           # Request logging
    cors.ts             # CORS configuration
  lib/
    db.ts               # Database client
    logger.ts           # Logger instance
    errors.ts           # Custom error classes
  schemas/
    users.ts            # Zod schemas
  types/
    index.ts            # Shared types
```

## Core Principles

### 1. Layered Architecture with Clear Boundaries

Each layer has a single responsibility with one-way dependencies:

```typescript
// routes/users.ts - Route definitions only
import { Hono } from 'hono';
import * as handlers from '@/handlers/users';

const app = new Hono();

app.get('/', handlers.list);
app.get('/:id', handlers.getById);
app.post('/', handlers.create);

export default app;
```

```typescript
// handlers/users.ts - Request/response transformation
import { Context } from 'hono';
import * as userService from '@/services/users';
import { createUserSchema } from '@/schemas/users';

export async function create(c: Context) {
  const body = await c.req.json();
  const validated = createUserSchema.parse(body);
  const user = await userService.create(validated);
  return c.json(user, 201);
}
```

```typescript
// services/users.ts - Business logic
import * as userRepo from '@/repositories/users';
import type { CreateUserInput } from '@/schemas/users';

export async function create(input: CreateUserInput) {
  // Business rules here
  return userRepo.create(input);
}
```

```typescript
// repositories/users.ts - Data access only
import { db } from '@/lib/db';

export async function create(data: CreateUserInput) {
  return db.user.create({ data });
}
```

### 2. Schema-First Validation with Zod

Define schemas at boundaries, derive types from schemas:

```typescript
// schemas/users.ts
import { z } from 'zod';

export const createUserSchema = z.object({
  email: z.string().email(),
  name: z.string().min(1).max(100),
});

export const userResponseSchema = z.object({
  id: z.string(),
  email: z.string(),
  name: z.string(),
  createdAt: z.string().datetime(),
});

// Derive types from schemas
export type CreateUserInput = z.infer<typeof createUserSchema>;
export type UserResponse = z.infer<typeof userResponseSchema>;
```

### 3. Consistent Error Envelope

Standardize error responses across all endpoints:

```typescript
// lib/errors.ts
export class AppError extends Error {
  constructor(
    public code: string,
    public message: string,
    public statusCode: number = 500,
    public details?: unknown
  ) {
    super(message);
  }
}

export class NotFoundError extends AppError {
  constructor(resource: string, id: string) {
    super('NOT_FOUND', `${resource} with id ${id} not found`, 404);
  }
}

export class ValidationError extends AppError {
  constructor(details: unknown) {
    super('VALIDATION_ERROR', 'Validation failed', 400, details);
  }
}
```

```typescript
// middleware/error.ts
import { Context, Next } from 'hono';
import { ZodError } from 'zod';
import { AppError, ValidationError } from '@/lib/errors';

export async function errorHandler(c: Context, next: Next) {
  try {
    await next();
  } catch (error) {
    const traceId = c.get('traceId');
    
    if (error instanceof ZodError) {
      return c.json({
        code: 'VALIDATION_ERROR',
        message: 'Validation failed',
        traceId,
        details: error.flatten(),
      }, 400);
    }
    
    if (error instanceof AppError) {
      return c.json({
        code: error.code,
        message: error.message,
        traceId,
        details: error.details,
      }, error.statusCode);
    }
    
    // Log unexpected errors
    console.error({ traceId, error });
    
    return c.json({
      code: 'INTERNAL_ERROR',
      message: 'An unexpected error occurred',
      traceId,
    }, 500);
  }
}
```

### 4. Authentication Middleware

Centralized auth with context injection:

```typescript
// middleware/auth.ts
import { Context, Next } from 'hono';
import { verify } from 'hono/jwt';

export async function authMiddleware(c: Context, next: Next) {
  const authHeader = c.req.header('Authorization');
  
  if (!authHeader?.startsWith('Bearer ')) {
    return c.json({ code: 'UNAUTHORIZED', message: 'Missing token' }, 401);
  }
  
  const token = authHeader.slice(7);
  
  try {
    const payload = await verify(token, c.env.JWT_SECRET);
    c.set('user', payload);
    await next();
  } catch {
    return c.json({ code: 'UNAUTHORIZED', message: 'Invalid token' }, 401);
  }
}
```

### 5. Observability with Structured Logging

Request logging with correlation IDs:

```typescript
// middleware/logger.ts
import { Context, Next } from 'hono';
import { randomUUID } from 'crypto';

export async function requestLogger(c: Context, next: Next) {
  const traceId = c.req.header('x-trace-id') || randomUUID();
  const startTime = Date.now();
  
  c.set('traceId', traceId);
  c.header('x-trace-id', traceId);
  
  await next();
  
  const duration = Date.now() - startTime;
  
  console.log(JSON.stringify({
    timestamp: new Date().toISOString(),
    traceId,
    method: c.req.method,
    path: c.req.path,
    status: c.res.status,
    duration,
    userAgent: c.req.header('user-agent'),
  }));
}
```

### 6. App Configuration

Compose middleware and routes:

```typescript
// app.ts
import { Hono } from 'hono';
import { cors } from 'hono/cors';
import { requestLogger } from '@/middleware/logger';
import { errorHandler } from '@/middleware/error';
import routes from '@/routes';

const app = new Hono();

// Global middleware
app.use('*', cors());
app.use('*', requestLogger);
app.use('*', errorHandler);

// Health check
app.get('/health', (c) => c.json({ status: 'ok' }));

// API routes
app.route('/api', routes);

export default app;
```

## API Design Standards

### Naming Conventions

| Element | Convention | Example |
|---------|------------|---------|
| Paths | kebab-case, plural nouns | `/api/user-profiles` |
| Query params | snake_case | `?page_size=10` |
| JSON fields | snake_case | `{ "user_id": "123" }` |
| Headers | kebab-case | `x-trace-id` |

### HTTP Methods and Status Codes

| Operation | Method | Success | Error Cases |
|-----------|--------|---------|-------------|
| List | GET | 200 | 400, 401, 500 |
| Get by ID | GET | 200 | 400, 401, 404, 500 |
| Create | POST | 201 | 400, 401, 409, 500 |
| Update | PATCH | 200 | 400, 401, 404, 409, 500 |
| Delete | DELETE | 204 | 400, 401, 404, 500 |

### Pagination

Use cursor-based pagination by default:

```typescript
// schemas/pagination.ts
import { z } from 'zod';

export const paginationSchema = z.object({
  limit: z.coerce.number().min(1).max(100).default(20),
  cursor: z.string().optional(),
});

export type PaginationInput = z.infer<typeof paginationSchema>;

// Response format
export interface PaginatedResponse<T> {
  data: T[];
  next_cursor: string | null;
  has_more: boolean;
}
```

### Timestamps

Always use ISO 8601 with UTC timezone:

```typescript
// Good
{ "created_at": "2025-01-05T12:34:56Z" }

// Bad
{ "created_at": "2025-01-05" }
{ "created_at": 1704454496 }
```

## Testing Strategy

### Unit Tests for Services

```typescript
// services/users.test.ts
import { describe, it, expect, vi } from 'vitest';
import * as userService from './users';
import * as userRepo from '@/repositories/users';

vi.mock('@/repositories/users');

describe('userService.create', () => {
  it('creates a user with valid input', async () => {
    const input = { email: 'test@example.com', name: 'Test' };
    const expected = { id: '1', ...input, createdAt: new Date() };
    
    vi.mocked(userRepo.create).mockResolvedValue(expected);
    
    const result = await userService.create(input);
    
    expect(result).toEqual(expected);
    expect(userRepo.create).toHaveBeenCalledWith(input);
  });
});
```

### Integration Tests for Handlers

```typescript
// handlers/users.test.ts
import { describe, it, expect } from 'vitest';
import app from '@/app';

describe('POST /api/users', () => {
  it('returns 201 with valid input', async () => {
    const res = await app.request('/api/users', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email: 'test@example.com', name: 'Test' }),
    });
    
    expect(res.status).toBe(201);
    const body = await res.json();
    expect(body).toHaveProperty('id');
  });
  
  it('returns 400 with invalid email', async () => {
    const res = await app.request('/api/users', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email: 'invalid', name: 'Test' }),
    });
    
    expect(res.status).toBe(400);
    const body = await res.json();
    expect(body.code).toBe('VALIDATION_ERROR');
  });
});
```

## Project Setup

### Package.json Scripts

```json
{
  "scripts": {
    "dev": "tsx watch src/index.ts",
    "build": "tsc",
    "start": "node dist/index.js",
    "test": "vitest",
    "test:coverage": "vitest --coverage",
    "lint": "eslint src --ext .ts",
    "format": "prettier --write src"
  }
}
```

### TypeScript Configuration

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "moduleResolution": "bundler",
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitOverride": true,
    "paths": {
      "@/*": ["./src/*"]
    }
  }
}
```

## Implementation Checklist

### Before Writing Code
- [ ] Define OpenAPI spec or Zod schemas first
- [ ] Identify which layer each piece of logic belongs to
- [ ] Check existing utilities and patterns in codebase

### Route/Handler Layer
- [ ] Routes are thin (only path + handler mapping)
- [ ] Handlers validate input with Zod schemas
- [ ] Handlers transform responses to API format
- [ ] No business logic in handlers

### Service Layer
- [ ] Business rules and validation logic here
- [ ] No HTTP-specific code (no Context, no status codes)
- [ ] Proper error throwing with custom error classes

### Repository Layer
- [ ] Data access only (no business logic)
- [ ] Single responsibility per function
- [ ] Proper transaction handling where needed

### Middleware
- [ ] Auth middleware injects user context
- [ ] Error handler catches all errors consistently
- [ ] Request logger includes trace ID

### Testing
- [ ] Unit tests for services (mock repositories)
- [ ] Integration tests for handlers (use app.request)
- [ ] Error cases covered

## Common Pitfalls to Avoid

1. **Business logic in handlers** - Move to service layer
2. **HTTP concerns in services** - Services should be framework-agnostic
3. **Missing validation** - Always validate at boundaries
4. **Inconsistent error responses** - Use centralized error handler
5. **Missing trace IDs** - Always propagate for debugging
6. **Over-engineering** - Start simple, add complexity when needed

## References

- Future Architect Web API Guidelines
- Hono Documentation: https://hono.dev
- Zod Documentation: https://zod.dev
