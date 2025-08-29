# Backend Implementation Guidelines for LLM Code Generation

## Core Principles - 12 Universal Rules

Based on production-grade backend patterns and continuous learning principles, follow these universal principles when implementing backend features:

### 1. Layered Architecture with Clear Boundaries
ビジネスロジック、データアクセス、APIレイヤーを明確に分離。各層は単一責任を持ち、依存関係は単方向。

### 2. Result-Based Error Handling and Logging
**Result型パターン**でエラー状態を明示化。すべてのエラーを構造化し、適切に分類・記録。クライアントには安全な情報のみ返却。異常系シナリオ（500エラー、予期しないJSON構造）への包括的対応。

### 3. Input Validation and Type Safety
すべての入力を境界で検証。スキーマベースのバリデーションと型安全性を保証。入力パラメータの検証・サニタイズを徹底。

### 4. Dependency Injection for Testability
外部依存をインターフェースで抽象化。テスト時にモック可能な設計。

### 5. Transaction Management
データ整合性のため適切なトランザクション境界を設定。エラー時の確実なロールバック。

### 6. Authentication and Authorization
認証・認可を一元管理。ミドルウェアで統一的にアクセス制御。インジェクション攻撃等への防御を実装。

### 7. Consistent API Design
RESTful原則に従った一貫性のあるAPI設計。明確なバージョニングとレスポンス形式。

### 8. Performance Optimization
N+1問題の回避、**バッチ処理**による複数リクエストの効率化、適切なキャッシング、**必要最小限のデータ取得**による最適化。

### 9. Security by Design
SQLインジェクション、XSS、CSRF等の脆弱性対策を設計段階から組み込む。

### 10. Observable and Debuggable
**構造化ログ**、メトリクス収集、**分散トレーシング**による可観測性の確保。問題追跡とパフォーマンス監視を実現。

### 11. Reliability Engineering
**タイムアウト制御**の実装、**指数バックオフ**によるリトライ戦略、**サーキットブレーカー**パターンによる障害対応。システムの自己回復能力を組み込む。

### 12. Scalability and Continuous Learning
**高負荷対応**アーキテクチャ、**レート制限**による負荷制御、**非同期処理**の適切な活用。**実装の度に新たな技術的洞察を得る**継続学習の姿勢を持つ。

## 1. Architecture Pattern: Clean Layered Structure

### ✅ Directory Structure (Principle 1)
```
src/
├── api/                      # API Layer (Controllers/Handlers)
│   ├── routes/              # Route definitions
│   │   ├── users.ts         # User-related endpoints
│   │   └── products.ts      # Product-related endpoints
│   ├── middleware/          # HTTP middleware
│   │   ├── auth.ts          # Authentication (Principle 6)
│   │   ├── validation.ts    # Request validation (Principle 3)
│   │   ├── rate-limit.ts    # Rate limiting (Principle 12)
│   │   ├── timeout.ts       # Timeout control (Principle 11)
│   │   └── error-handler.ts # Error handling (Principle 2)
│   └── schemas/             # Request/Response schemas
│       └── user-schema.ts   # Zod schemas (Principle 3)
├── services/                # Business Logic Layer
│   ├── user-service.ts      # User business logic
│   ├── product-service.ts   # Product business logic
│   └── batch/               # Batch processing (Principle 8)
│       └── batch-processor.ts # Batch operations
├── repositories/            # Data Access Layer
│   ├── user-repository.ts   # User data access
│   └── interfaces/          # Repository interfaces (Principle 4)
├── domain/                  # Domain Models
│   ├── entities/           # Business entities
│   ├── value-objects/      # Value objects
│   ├── errors/             # Domain-specific errors
│   └── result/             # Result type patterns (Principle 2)
│       └── result.ts       # Result<T, E> implementation
├── infrastructure/          # External Services
│   ├── database/           # Database configuration
│   ├── cache/              # Cache implementation (Principle 8)
│   ├── logger/             # Logging setup (Principle 10)
│   ├── resilience/         # Reliability patterns (Principle 11)
│   │   ├── circuit-breaker.ts # Circuit breaker implementation
│   │   ├── retry.ts        # Retry with exponential backoff
│   │   └── timeout.ts      # Timeout utilities
│   └── monitoring/         # Observability (Principle 10)
│       ├── metrics.ts      # Performance metrics
│       └── tracing.ts      # Distributed tracing
└── utils/                   # Shared utilities
    ├── errors.ts           # Error classes (Principle 2)
    ├── constants.ts        # Application constants
    └── scalability/        # Scalability utilities (Principle 12)
        └── load-balancer.ts # Load balancing utilities
```

## 2. Controller/Handler Layer with Hono

### ✅ Route Definition with Validation (Principles 1, 3, 7)
```typescript
// api/routes/users.ts
import { Hono } from 'hono';
import { z } from 'zod';
import { zValidator } from '@hono/zod-validator';
import { UserService } from '../../services/user-service';
import { authenticate } from '../middleware/auth';
import { handleAsync } from '../middleware/error-handler';

// Schema definitions (Principle 3)
const createUserSchema = z.object({
  email: z.string().email(),
  name: z.string().min(1).max(100),
  role: z.enum(['admin', 'user']).default('user'),
});

const updateUserSchema = createUserSchema.partial();

const paginationSchema = z.object({
  page: z.coerce.number().min(1).default(1),
  limit: z.coerce.number().min(1).max(100).default(20),
  sortBy: z.string().optional(),
  sortOrder: z.enum(['asc', 'desc']).default('asc'),
});

export function createUserRoutes(userService: UserService): Hono {
  const app = new Hono();

  // GET /users - List users with pagination (Principle 7)
  app.get(
    '/',
    authenticate(['admin', 'user']),
    zValidator('query', paginationSchema),
    handleAsync(async (c) => {
      const query = c.req.valid('query');
      const result = await userService.listUsers({
        page: query.page,
        limit: query.limit,
        sortBy: query.sortBy,
        sortOrder: query.sortOrder,
      });

      return c.json({
        success: true,
        data: result.items,
        pagination: {
          page: result.page,
          limit: result.limit,
          total: result.total,
          totalPages: Math.ceil(result.total / result.limit),
        },
      });
    })
  );

  // POST /users - Create user (Principles 3, 5)
  app.post(
    '/',
    authenticate(['admin']),
    zValidator('json', createUserSchema),
    handleAsync(async (c) => {
      const data = c.req.valid('json');
      const user = await userService.createUser(data);

      return c.json(
        {
          success: true,
          data: user,
        },
        201
      );
    })
  );

  // GET /users/:id - Get user by ID
  app.get(
    '/:id',
    authenticate(['admin', 'user']),
    handleAsync(async (c) => {
      const userId = c.req.param('id');
      const user = await userService.getUserById(userId);

      return c.json({
        success: true,
        data: user,
      });
    })
  );

  return app;
}
```

## 3. Service Layer with Business Logic

### ✅ Service Implementation (Principles 1, 4, 5)
```typescript
// services/user-service.ts
import { z } from 'zod';
import type { IUserRepository } from '../repositories/interfaces/user-repository';
import type { IEmailService } from '../infrastructure/email/interfaces';
import type { ITransactionManager } from '../infrastructure/database/interfaces';
import { BusinessError, ValidationError } from '../utils/errors';
import { Logger } from '../infrastructure/logger';

export interface UserServiceDeps {
  userRepository: IUserRepository;
  emailService: IEmailService;
  transactionManager: ITransactionManager;
  logger: Logger;
}

export class UserService {
  constructor(private deps: UserServiceDeps) {}

  async createUser(data: CreateUserDto): Promise<User> {
    const { userRepository, emailService, transactionManager, logger } = this.deps;

    // Business validation (Principle 3)
    const existingUser = await userRepository.findByEmail(data.email);
    if (existingUser) {
      throw new ValidationError('EMAIL_ALREADY_EXISTS', 'このメールアドレスは既に使用されています');
    }

    // Transaction management (Principle 5)
    return await transactionManager.executeInTransaction(async (tx) => {
      // Create user
      const user = await userRepository.create(data, tx);

      // Send welcome email (async, non-critical)
      emailService.sendWelcomeEmail(user).catch((error) => {
        logger.error('Failed to send welcome email', { error, userId: user.id });
      });

      logger.info('User created', { userId: user.id, email: user.email });

      return user;
    });
  }

  async updateUser(id: string, data: UpdateUserDto): Promise<User> {
    const { userRepository, transactionManager, logger } = this.deps;

    return await transactionManager.executeInTransaction(async (tx) => {
      // Check existence with lock
      const user = await userRepository.findByIdForUpdate(id, tx);
      if (!user) {
        throw new BusinessError('USER_NOT_FOUND', 'ユーザーが見つかりません', 404);
      }

      // Update user
      const updatedUser = await userRepository.update(id, data, tx);

      logger.info('User updated', { userId: id, changes: data });

      return updatedUser;
    });
  }

  async listUsers(params: ListUsersParams): Promise<PaginatedResult<User>> {
    const { userRepository } = this.deps;

    // Performance optimization: Use cursor-based pagination for large datasets (Principle 8)
    return await userRepository.findAll({
      page: params.page,
      limit: params.limit,
      sortBy: params.sortBy || 'createdAt',
      sortOrder: params.sortOrder,
    });
  }
}
```

## 4. Repository Layer with Interfaces

### ✅ Repository Interface (Principle 4)
```typescript
// repositories/interfaces/user-repository.ts
export interface IUserRepository {
  findById(id: string, tx?: Transaction): Promise<User | null>;
  findByIdForUpdate(id: string, tx: Transaction): Promise<User | null>;
  findByEmail(email: string, tx?: Transaction): Promise<User | null>;
  findAll(params: PaginationParams): Promise<PaginatedResult<User>>;
  create(data: CreateUserDto, tx?: Transaction): Promise<User>;
  update(id: string, data: UpdateUserDto, tx?: Transaction): Promise<User>;
  delete(id: string, tx?: Transaction): Promise<void>;
}
```

### ✅ Repository Implementation with Query Optimization (Principles 4, 8)
```typescript
// repositories/user-repository.ts
import { Kysely } from 'kysely';
import type { IUserRepository } from './interfaces/user-repository';
import { DatabaseConnection, Transaction } from '../infrastructure/database';

export class UserRepository implements IUserRepository {
  constructor(private db: DatabaseConnection) {}

  async findById(id: string, tx?: Transaction): Promise<User | null> {
    const query = (tx || this.db)
      .selectFrom('users')
      .selectAll()
      .where('id', '=', id)
      .where('deletedAt', 'is', null);

    const result = await query.executeTakeFirst();
    return result ? this.mapToEntity(result) : null;
  }

  async findByIdForUpdate(id: string, tx: Transaction): Promise<User | null> {
    // Use SELECT FOR UPDATE to prevent race conditions (Principle 5)
    const query = tx
      .selectFrom('users')
      .selectAll()
      .where('id', '=', id)
      .where('deletedAt', 'is', null)
      .forUpdate();

    const result = await query.executeTakeFirst();
    return result ? this.mapToEntity(result) : null;
  }

  async findAll(params: PaginationParams): Promise<PaginatedResult<User>> {
    const { page, limit, sortBy, sortOrder } = params;
    const offset = (page - 1) * limit;

    // Count query
    const countQuery = this.db
      .selectFrom('users')
      .select(({ fn }) => fn.count<number>('id').as('count'))
      .where('deletedAt', 'is', null);

    // Data query with optimized select (Principle 8)
    let dataQuery = this.db
      .selectFrom('users')
      .select([
        'id',
        'email',
        'name',
        'role',
        'createdAt',
        'updatedAt',
      ])
      .where('deletedAt', 'is', null)
      .limit(limit)
      .offset(offset);

    // Dynamic sorting
    if (sortBy) {
      dataQuery = dataQuery.orderBy(sortBy, sortOrder);
    }

    // Execute both queries in parallel (Principle 8)
    const [countResult, items] = await Promise.all([
      countQuery.executeTakeFirst(),
      dataQuery.execute(),
    ]);

    return {
      items: items.map(this.mapToEntity),
      page,
      limit,
      total: countResult?.count || 0,
    };
  }

  private mapToEntity(row: UserRow): User {
    return {
      id: row.id,
      email: row.email,
      name: row.name,
      role: row.role as UserRole,
      createdAt: new Date(row.createdAt),
      updatedAt: new Date(row.updatedAt),
    };
  }
}
```

## 5. Result Type Pattern and Error Handling

### ✅ Result Type Implementation (Principle 2)
```typescript
// domain/result/result.ts
export type Result<T, E = Error> =
  | { success: true; data: T; error?: never }
  | { success: false; data?: never; error: E };

export const Success = <T>(data: T): Result<T, never> => ({
  success: true,
  data,
});

export const Failure = <E>(error: E): Result<never, E> => ({
  success: false,
  error,
});

// Result helper functions
export const isSuccess = <T, E>(result: Result<T, E>): result is { success: true; data: T } =>
  result.success;

export const isFailure = <T, E>(result: Result<T, E>): result is { success: false; error: E } =>
  !result.success;

// Chain results
export const chain = <T, U, E>(
  result: Result<T, E>,
  fn: (data: T) => Result<U, E>
): Result<U, E> => {
  if (isSuccess(result)) {
    return fn(result.data);
  }
  return result;
};

// Map result data
export const map = <T, U, E>(
  result: Result<T, E>,
  fn: (data: T) => U
): Result<U, E> => {
  if (isSuccess(result)) {
    return Success(fn(result.data));
  }
  return result;
};
```

### ✅ Service Layer with Result Pattern
```typescript
// services/user-service.ts (Updated with Result pattern)
import { Result, Success, Failure } from '../domain/result/result';
import { ValidationError, BusinessError } from '../utils/errors';

export class UserService {
  async createUser(data: CreateUserDto): Promise<Result<User, ValidationError | BusinessError>> {
    const { userRepository, transactionManager } = this.deps;

    // Business validation with Result pattern
    const existingUser = await userRepository.findByEmail(data.email);
    if (existingUser) {
      return Failure(new ValidationError(
        'EMAIL_ALREADY_EXISTS',
        'このメールアドレスは既に使用されています'
      ));
    }

    try {
      const result = await transactionManager.executeInTransaction(async (tx) => {
        const user = await userRepository.create(data, tx);

        // Non-critical async operation
        this.deps.emailService.sendWelcomeEmail(user).catch((error) => {
          this.deps.logger.error('Failed to send welcome email', { error, userId: user.id });
        });

        return user;
      });

      return Success(result);
    } catch (error) {
      return Failure(new BusinessError(
        'USER_CREATION_FAILED',
        'ユーザーの作成に失敗しました',
        500,
        error
      ));
    }
  }

  // Handle comprehensive error scenarios (500 errors, unexpected JSON)
  async getUserById(id: string): Promise<Result<User, BusinessError>> {
    try {
      const user = await this.deps.userRepository.findById(id);
      if (!user) {
        return Failure(new BusinessError('USER_NOT_FOUND', 'ユーザーが見つかりません', 404));
      }
      return Success(user);
    } catch (error) {
      // Handle unexpected errors (500, JSON parsing, etc.)
      this.deps.logger.error('Unexpected error in getUserById', { error, userId: id });
      return Failure(new BusinessError(
        'INTERNAL_ERROR',
        'システムエラーが発生しました',
        500,
        error
      ));
    }
  }
}
```

### ✅ Controller Layer with Result Handling
```typescript
// api/routes/users.ts (Updated with Result pattern)
import { isSuccess, isFailure } from '../../domain/result/result';

export function createUserRoutes(userService: UserService): Hono {
  const app = new Hono();

  app.post(
    '/',
    authenticate(['admin']),
    zValidator('json', createUserSchema),
    handleAsync(async (c) => {
      const data = c.req.valid('json');
      const result = await userService.createUser(data);

      if (isSuccess(result)) {
        return c.json({
          success: true,
          data: result.data,
        }, 201);
      }

      // Handle different error types appropriately
      const statusCode = result.error.statusCode || 400;
      return c.json({
        success: false,
        error: {
          code: result.error.code,
          message: result.error.message,
        },
      }, statusCode);
    })
  );

  return app;
}
```

### ✅ Structured Error Classes (Principle 2)
```typescript
// utils/errors.ts
export abstract class AppError extends Error {
  constructor(
    public readonly code: string,
    public readonly message: string,
    public readonly statusCode: number = 500,
    public readonly details?: unknown
  ) {
    super(message);
    this.name = this.constructor.name;
    Error.captureStackTrace(this, this.constructor);
  }

  toJSON() {
    return {
      code: this.code,
      message: this.message,
      details: this.details,
    };
  }
}

export class ValidationError extends AppError {
  constructor(code: string, message: string, details?: unknown) {
    super(code, message, 400, details);
  }
}

export class BusinessError extends AppError {
  constructor(code: string, message: string, statusCode = 400, details?: unknown) {
    super(code, message, statusCode, details);
  }
}

export class AuthenticationError extends AppError {
  constructor(message = '認証が必要です') {
    super('AUTHENTICATION_REQUIRED', message, 401);
  }
}

export class AuthorizationError extends AppError {
  constructor(message = 'アクセス権限がありません') {
    super('ACCESS_DENIED', message, 403);
  }
}

export class NotFoundError extends AppError {
  constructor(resource: string) {
    super('RESOURCE_NOT_FOUND', `${resource}が見つかりません`, 404);
  }
}
```

### ✅ Global Error Handler Middleware (Principles 2, 10)
```typescript
// api/middleware/error-handler.ts
import type { Context, Next } from 'hono';
import { AppError } from '../../utils/errors';
import { Logger } from '../../infrastructure/logger';

export function errorHandler(logger: Logger) {
  return async (c: Context, next: Next) => {
    try {
      await next();
    } catch (error) {
      if (error instanceof AppError) {
        // Known business errors - log as warning
        logger.warn('Business error occurred', {
          code: error.code,
          message: error.message,
          details: error.details,
          path: c.req.path,
          method: c.req.method,
        });

        return c.json(
          {
            success: false,
            error: {
              code: error.code,
              message: error.message,
              details: error.details,
            },
          },
          error.statusCode
        );
      }

      // Unknown errors - log as error with stack trace
      logger.error('Unexpected error occurred', {
        error: error instanceof Error ? error.message : 'Unknown error',
        stack: error instanceof Error ? error.stack : undefined,
        path: c.req.path,
        method: c.req.method,
      });

      // Don't expose internal errors to client (Principle 9)
      return c.json(
        {
          success: false,
          error: {
            code: 'INTERNAL_SERVER_ERROR',
            message: 'システムエラーが発生しました',
          },
        },
        500
      );
    }
  };
}

// Helper for async route handlers
export function handleAsync(
  handler: (c: Context) => Promise<Response>
): (c: Context) => Promise<Response> {
  return async (c: Context) => {
    return await handler(c);
  };
}
```

## 6. Authentication and Authorization

### ✅ JWT Authentication Middleware (Principle 6)
```typescript
// api/middleware/auth.ts
import type { Context, Next } from 'hono';
import { verify } from 'hono/jwt';
import { AuthenticationError, AuthorizationError } from '../../utils/errors';

export interface JWTPayload {
  sub: string;  // user ID
  email: string;
  role: UserRole;
  exp: number;
}

export function authenticate(allowedRoles?: UserRole[]) {
  return async (c: Context, next: Next) => {
    try {
      // Extract token from header
      const authorization = c.req.header('Authorization');
      if (!authorization?.startsWith('Bearer ')) {
        throw new AuthenticationError();
      }

      const token = authorization.substring(7);

      // Verify JWT
      const payload = await verify(token, c.env.JWT_SECRET) as JWTPayload;

      // Check expiration
      if (payload.exp < Date.now() / 1000) {
        throw new AuthenticationError('トークンの有効期限が切れています');
      }

      // Check role authorization
      if (allowedRoles && !allowedRoles.includes(payload.role)) {
        throw new AuthorizationError();
      }

      // Attach user info to context
      c.set('user', {
        id: payload.sub,
        email: payload.email,
        role: payload.role,
      });

      await next();
    } catch (error) {
      if (error instanceof AuthenticationError || error instanceof AuthorizationError) {
        throw error;
      }
      throw new AuthenticationError('無効なトークンです');
    }
  };
}

// Helper to get authenticated user
export function getAuthUser(c: Context): AuthUser {
  const user = c.get('user');
  if (!user) {
    throw new AuthenticationError();
  }
  return user;
}
```

## 7. Database Transaction Management

### ✅ Transaction Manager (Principle 5)
```typescript
// infrastructure/database/transaction-manager.ts
import { Kysely, Transaction } from 'kysely';
import { Logger } from '../logger';

export interface ITransactionManager {
  executeInTransaction<T>(
    callback: (tx: Transaction<Database>) => Promise<T>
  ): Promise<T>;
}

export class TransactionManager implements ITransactionManager {
  constructor(
    private db: Kysely<Database>,
    private logger: Logger
  ) {}

  async executeInTransaction<T>(
    callback: (tx: Transaction<Database>) => Promise<T>
  ): Promise<T> {
    const startTime = Date.now();

    try {
      const result = await this.db.transaction().execute(async (tx) => {
        return await callback(tx);
      });

      const duration = Date.now() - startTime;
      this.logger.debug('Transaction completed successfully', { duration });

      return result;
    } catch (error) {
      const duration = Date.now() - startTime;
      this.logger.error('Transaction failed', {
        error: error instanceof Error ? error.message : 'Unknown error',
        duration,
      });

      throw error;
    }
  }
}
```

## 8. Caching Strategy

### ✅ Cache Service with Redis (Principle 8)
```typescript
// infrastructure/cache/cache-service.ts
import Redis from 'ioredis';
import { Logger } from '../logger';

export interface ICacheService {
  get<T>(key: string): Promise<T | null>;
  set<T>(key: string, value: T, ttl?: number): Promise<void>;
  delete(key: string): Promise<void>;
  deletePattern(pattern: string): Promise<void>;
}

export class RedisCacheService implements ICacheService {
  private redis: Redis;
  private defaultTTL = 300; // 5 minutes

  constructor(
    private config: RedisConfig,
    private logger: Logger
  ) {
    this.redis = new Redis(config);

    this.redis.on('error', (error) => {
      this.logger.error('Redis connection error', { error });
    });
  }

  async get<T>(key: string): Promise<T | null> {
    try {
      const value = await this.redis.get(key);
      if (!value) return null;

      return JSON.parse(value) as T;
    } catch (error) {
      this.logger.warn('Cache get failed', { key, error });
      return null; // Fail gracefully
    }
  }

  async set<T>(key: string, value: T, ttl = this.defaultTTL): Promise<void> {
    try {
      const serialized = JSON.stringify(value);
      await this.redis.setex(key, ttl, serialized);
    } catch (error) {
      this.logger.warn('Cache set failed', { key, error });
      // Fail silently - cache is not critical
    }
  }

  async delete(key: string): Promise<void> {
    try {
      await this.redis.del(key);
    } catch (error) {
      this.logger.warn('Cache delete failed', { key, error });
    }
  }

  async deletePattern(pattern: string): Promise<void> {
    try {
      const keys = await this.redis.keys(pattern);
      if (keys.length > 0) {
        await this.redis.del(...keys);
      }
    } catch (error) {
      this.logger.warn('Cache delete pattern failed', { pattern, error });
    }
  }
}
```

### ✅ Cache Decorator Pattern (Principle 8)
```typescript
// utils/cache-decorator.ts
export function Cacheable(keyPrefix: string, ttl = 300) {
  return function (
    target: any,
    propertyName: string,
    descriptor: PropertyDescriptor
  ) {
    const originalMethod = descriptor.value;

    descriptor.value = async function (...args: any[]) {
      const cacheService = this.deps?.cacheService;
      if (!cacheService) {
        return originalMethod.apply(this, args);
      }

      // Generate cache key
      const cacheKey = `${keyPrefix}:${JSON.stringify(args)}`;

      // Try to get from cache
      const cached = await cacheService.get(cacheKey);
      if (cached) {
        return cached;
      }

      // Execute method and cache result
      const result = await originalMethod.apply(this, args);
      await cacheService.set(cacheKey, result, ttl);

      return result;
    };

    return descriptor;
  };
}

// Usage in service
class UserService {
  @Cacheable('user', 600) // Cache for 10 minutes
  async getUserById(id: string): Promise<User> {
    return await this.deps.userRepository.findById(id);
  }
}
```

## 9. Security Patterns

### ✅ Security Middleware Stack (Principle 9)
```typescript
// api/middleware/security.ts
import type { Hono } from 'hono';
import { secureHeaders } from 'hono/secure-headers';
import { cors } from 'hono/cors';
import { csrf } from 'hono/csrf';
import { rateLimiter } from 'hono-rate-limiter';

export function setupSecurityMiddleware(app: Hono) {
  // Secure headers
  app.use('*', secureHeaders());

  // CORS configuration
  app.use('*', cors({
    origin: (origin) => {
      const allowedOrigins = process.env.ALLOWED_ORIGINS?.split(',') || [];
      return allowedOrigins.includes(origin) ? origin : allowedOrigins[0];
    },
    credentials: true,
  }));

  // CSRF protection
  app.use('*', csrf({
    origin: process.env.FRONTEND_URL,
  }));

  // Rate limiting (from third-party package)
  app.use('*', rateLimiter({
    windowMs: 15 * 60 * 1000, // 15 minutes
    limit: 100, // Limit each IP to 100 requests per windowMs
    standardHeaders: 'draft-6',
    keyGenerator: (c) => c.req.header('x-forwarded-for') || c.req.header('cf-connecting-ip') || 'unknown',
    handler: (c) => {
      return c.json(
        {
          success: false,
          error: {
            code: 'RATE_LIMIT_EXCEEDED',
            message: 'リクエスト数が上限を超えました',
          },
        },
        429
      );
    },
  }));

  // SQL Injection prevention is handled by query builders (Kysely)
  // XSS prevention is handled by proper JSON responses
}
```

### ✅ Environment Configuration (Principle 9)
```typescript
// config/env.ts
import { z } from 'zod';

const envSchema = z.object({
  NODE_ENV: z.enum(['development', 'test', 'production']),
  PORT: z.coerce.number().default(3000),
  DATABASE_URL: z.string().url(),
  REDIS_URL: z.string().url(),
  JWT_SECRET: z.string().min(32),
  JWT_EXPIRES_IN: z.string().default('24h'),
  ALLOWED_ORIGINS: z.string(),
  LOG_LEVEL: z.enum(['debug', 'info', 'warn', 'error']).default('info'),
});

export function loadConfig() {
  const result = envSchema.safeParse(process.env);

  if (!result.success) {
    console.error('Invalid environment configuration:', result.error.format());
    process.exit(1);
  }

  return result.data;
}

export type Config = ReturnType<typeof loadConfig>;
```

## 10. Logging and Observability

### ✅ Structured Logger (Principle 10)
```typescript
// infrastructure/logger/index.ts
import pino from 'pino';

export class Logger {
  private logger: pino.Logger;

  constructor(config: LoggerConfig) {
    this.logger = pino({
      level: config.level,
      formatters: {
        level: (label) => ({ level: label }),
      },
      timestamp: pino.stdTimeFunctions.isoTime,
      redact: ['password', 'token', 'authorization'],
    });
  }

  info(message: string, meta?: Record<string, unknown>) {
    this.logger.info(meta, message);
  }

  warn(message: string, meta?: Record<string, unknown>) {
    this.logger.warn(meta, message);
  }

  error(message: string, meta?: Record<string, unknown>) {
    this.logger.error(meta, message);
  }

  debug(message: string, meta?: Record<string, unknown>) {
    this.logger.debug(meta, message);
  }

  child(bindings: Record<string, unknown>): Logger {
    const childLogger = Object.create(this);
    childLogger.logger = this.logger.child(bindings);
    return childLogger;
  }
}
```

### ✅ Request Logging Middleware (Principle 10)
```typescript
// api/middleware/request-logger.ts
import type { Context, Next } from 'hono';
import { Logger } from '../../infrastructure/logger';

export function requestLogger(logger: Logger) {
  return async (c: Context, next: Next) => {
    const requestId = crypto.randomUUID();
    const start = Date.now();

    // Add request ID to context
    c.set('requestId', requestId);

    // Create child logger with request context
    const requestLogger = logger.child({
      requestId,
      method: c.req.method,
      path: c.req.path,
      userAgent: c.req.header('user-agent'),
    });

    // Log request
    requestLogger.info('Request received');

    try {
      await next();

      // Log response
      const duration = Date.now() - start;
      requestLogger.info('Request completed', {
        status: c.res.status,
        duration,
      });
    } catch (error) {
      const duration = Date.now() - start;
      requestLogger.error('Request failed', {
        error: error instanceof Error ? error.message : 'Unknown error',
        duration,
      });
      throw error;
    }
  };
}
```

## 11. Testing Patterns

### ✅ Service Unit Test Example (Principles 4, 10)
```typescript
// services/__tests__/user-service.test.ts
import { describe, it, expect, beforeEach, vi } from 'vitest';
import { UserService } from '../user-service';
import { ValidationError } from '../../utils/errors';

describe('UserService', () => {
  let userService: UserService;
  let mockDeps: UserServiceDeps;

  beforeEach(() => {
    mockDeps = {
      userRepository: {
        findByEmail: vi.fn(),
        create: vi.fn(),
        findById: vi.fn(),
      },
      emailService: {
        sendWelcomeEmail: vi.fn(),
      },
      transactionManager: {
        executeInTransaction: vi.fn((callback) => callback({})),
      },
      logger: {
        info: vi.fn(),
        error: vi.fn(),
      },
    };

    userService = new UserService(mockDeps);
  });

  describe('createUser', () => {
    it('should create user successfully', async () => {
      // Arrange
      const createUserDto = {
        email: 'test@example.com',
        name: 'Test User',
        role: 'user' as const,
      };

      const expectedUser = {
        id: '123',
        ...createUserDto,
        createdAt: new Date(),
        updatedAt: new Date(),
      };

      mockDeps.userRepository.findByEmail.mockResolvedValue(null);
      mockDeps.userRepository.create.mockResolvedValue(expectedUser);

      // Act
      const result = await userService.createUser(createUserDto);

      // Assert
      expect(result).toEqual(expectedUser);
      expect(mockDeps.userRepository.findByEmail).toHaveBeenCalledWith(createUserDto.email);
      expect(mockDeps.userRepository.create).toHaveBeenCalledWith(createUserDto, {});
      expect(mockDeps.emailService.sendWelcomeEmail).toHaveBeenCalledWith(expectedUser);
      expect(mockDeps.logger.info).toHaveBeenCalledWith('User created', {
        userId: expectedUser.id,
        email: expectedUser.email,
      });
    });

    it('should throw validation error if email already exists', async () => {
      // Arrange
      const createUserDto = {
        email: 'existing@example.com',
        name: 'Test User',
        role: 'user' as const,
      };

      mockDeps.userRepository.findByEmail.mockResolvedValue({
        id: 'existing-user',
        email: createUserDto.email,
      });

      // Act & Assert
      await expect(userService.createUser(createUserDto)).rejects.toThrow(ValidationError);
      expect(mockDeps.userRepository.create).not.toHaveBeenCalled();
    });
  });
});
```

### ✅ API Integration Test Example
```typescript
// api/__tests__/users.test.ts
import { describe, it, expect, beforeAll, afterAll } from 'vitest';
import { testClient } from 'hono/testing';
import { createApp } from '../../app';
import { setupTestDatabase, cleanupTestDatabase } from '../helpers/database';

describe('Users API', () => {
  let app: Hono;
  let authToken: string;

  beforeAll(async () => {
    await setupTestDatabase();
    app = createApp();

    // Get auth token
    const loginRes = await testClient(app).auth.login.$post({
      json: { email: 'admin@example.com', password: 'password' },
    });
    const { token } = await loginRes.json();
    authToken = token;
  });

  afterAll(async () => {
    await cleanupTestDatabase();
  });

  it('should create user', async () => {
    const res = await testClient(app).users.$post({
      json: {
        email: 'newuser@example.com',
        name: 'New User',
        role: 'user',
      },
      header: {
        Authorization: `Bearer ${authToken}`,
      },
    });

    expect(res.status).toBe(201);
    const body = await res.json();
    expect(body.success).toBe(true);
    expect(body.data).toMatchObject({
      email: 'newuser@example.com',
      name: 'New User',
      role: 'user',
    });
  });
});
```

## 12. Application Bootstrap

### ✅ Main Application Setup
```typescript
// app.ts
import { Hono } from 'hono';
import { logger } from 'hono/logger';
import { setupSecurityMiddleware } from './api/middleware/security';
import { errorHandler } from './api/middleware/error-handler';
import { requestLogger } from './api/middleware/request-logger';
import { createContainer } from './container';

export function createApp() {
  const app = new Hono();

  // Initialize dependencies (Principle 4)
  const container = createContainer();

  // Global middleware
  app.use('*', logger());
  app.use('*', requestLogger(container.logger));
  setupSecurityMiddleware(app);
  app.use('*', errorHandler(container.logger));

  // Health check
  app.get('/health', (c) => c.json({ status: 'ok' }));

  // API routes
  const api = new Hono();
  api.route('/users', createUserRoutes(container.userService));
  api.route('/products', createProductRoutes(container.productService));

  app.route('/api/v1', api);

  return app;
}

// index.ts
import { serve } from '@hono/node-server';
import { createApp } from './app';
import { loadConfig } from './config/env';

const config = loadConfig();
const app = createApp();

serve({
  fetch: app.fetch,
  port: config.PORT,
}, (info) => {
  console.log(`Server running at http://localhost:${info.port}`);
});
```

### ✅ Dependency Container (Principle 4)
```typescript
// container.ts
import { Kysely } from 'kysely';
import { Logger } from './infrastructure/logger';
import { RedisCacheService } from './infrastructure/cache';
import { TransactionManager } from './infrastructure/database';
import { UserRepository } from './repositories/user-repository';
import { UserService } from './services/user-service';
import { EmailService } from './infrastructure/email';

export interface Container {
  // Infrastructure
  logger: Logger;
  database: Kysely<Database>;
  cache: RedisCacheService;
  transactionManager: TransactionManager;

  // Repositories
  userRepository: UserRepository;

  // Services
  userService: UserService;
  emailService: EmailService;
}

export function createContainer(): Container {
  // Initialize infrastructure
  const logger = new Logger({ level: process.env.LOG_LEVEL || 'info' });
  const database = createDatabaseConnection();
  const cache = new RedisCacheService(redisConfig, logger);
  const transactionManager = new TransactionManager(database, logger);

  // Initialize repositories
  const userRepository = new UserRepository(database);

  // Initialize services
  const emailService = new EmailService(emailConfig, logger);
  const userService = new UserService({
    userRepository,
    emailService,
    transactionManager,
    logger,
  });

  return {
    logger,
    database,
    cache,
    transactionManager,
    userRepository,
    userService,
    emailService,
  };
}
```

## 13. Reliability Engineering Patterns

### ✅ Circuit Breaker Implementation (Principle 11)
```typescript
// infrastructure/resilience/circuit-breaker.ts
export class CircuitBreaker {
  private failures = 0;
  private lastFailureTime = 0;
  private state: 'CLOSED' | 'OPEN' | 'HALF_OPEN' = 'CLOSED';

  constructor(
    private readonly threshold: number = 5,
    private readonly timeout: number = 60000,
    private readonly logger: Logger
  ) {}

  async call<T>(fn: () => Promise<T>): Promise<Result<T, Error>> {
    if (this.state === 'OPEN') {
      if (Date.now() - this.lastFailureTime > this.timeout) {
        this.state = 'HALF_OPEN';
        this.logger.info('Circuit breaker transitioning to HALF_OPEN');
      } else {
        return Failure(new Error('Circuit breaker is OPEN'));
      }
    }

    try {
      const result = await fn();
      this.onSuccess();
      return Success(result);
    } catch (error) {
      this.onFailure();
      return Failure(error as Error);
    }
  }

  private onSuccess(): void {
    this.failures = 0;
    this.state = 'CLOSED';
  }

  private onFailure(): void {
    this.failures++;
    this.lastFailureTime = Date.now();

    if (this.failures >= this.threshold) {
      this.state = 'OPEN';
      this.logger.warn('Circuit breaker opened', { failures: this.failures });
    }
  }
}
```

### ✅ Retry with Exponential Backoff (Principle 11)
```typescript
// infrastructure/resilience/retry.ts
export class RetryService {
  constructor(private logger: Logger) {}

  async withRetry<T>(
    operation: () => Promise<T>,
    maxRetries = 3,
    baseDelayMs = 1000,
    maxDelayMs = 30000
  ): Promise<Result<T, Error>> {
    let lastError: Error;

    for (let attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        const result = await operation();
        if (attempt > 0) {
          this.logger.info('Operation succeeded after retry', { attempt });
        }
        return Success(result);
      } catch (error) {
        lastError = error as Error;

        if (attempt === maxRetries) {
          this.logger.error('Operation failed after all retries', {
            attempt,
            error: lastError.message
          });
          break;
        }

        const delay = Math.min(
          baseDelayMs * Math.pow(2, attempt),
          maxDelayMs
        );

        this.logger.warn('Operation failed, retrying', {
          attempt: attempt + 1,
          delayMs: delay,
          error: lastError.message
        });

        await this.sleep(delay);
      }
    }

    return Failure(lastError!);
  }

  private sleep(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
}
```

### ✅ Timeout Control (Principle 11)
```typescript
// infrastructure/resilience/timeout.ts
export class TimeoutService {
  constructor(private logger: Logger) {}

  async withTimeout<T>(
    operation: () => Promise<T>,
    timeoutMs: number,
    operationName = 'operation'
  ): Promise<Result<T, Error>> {
    const timeoutPromise = new Promise<never>((_, reject) => {
      setTimeout(() => {
        reject(new Error(`${operationName} timed out after ${timeoutMs}ms`));
      }, timeoutMs);
    });

    try {
      const result = await Promise.race([operation(), timeoutPromise]);
      return Success(result);
    } catch (error) {
      this.logger.warn(`${operationName} timed out`, { timeoutMs });
      return Failure(error as Error);
    }
  }
}
```

## 14. Scalability and Batch Processing

### ✅ Batch Processing Service (Principle 8, 12)
```typescript
// services/batch/batch-processor.ts
export class BatchProcessor<T, R> {
  constructor(
    private readonly batchSize: number = 100,
    private readonly concurrency: number = 5,
    private readonly logger: Logger
  ) {}

  async processBatch(
    items: T[],
    processor: (batch: T[]) => Promise<R[]>
  ): Promise<Result<R[], Error>> {
    try {
      const batches = this.createBatches(items, this.batchSize);
      const results: R[] = [];

      // Process batches with controlled concurrency
      for (let i = 0; i < batches.length; i += this.concurrency) {
        const currentBatches = batches.slice(i, i + this.concurrency);

        const batchPromises = currentBatches.map(async (batch, index) => {
          const batchIndex = i + index;
          this.logger.debug('Processing batch', {
            batchIndex,
            batchSize: batch.length
          });

          return await processor(batch);
        });

        const batchResults = await Promise.all(batchPromises);
        results.push(...batchResults.flat());
      }

      this.logger.info('Batch processing completed', {
        totalItems: items.length,
        totalBatches: batches.length,
        resultsCount: results.length
      });

      return Success(results);
    } catch (error) {
      this.logger.error('Batch processing failed', { error });
      return Failure(error as Error);
    }
  }

  private createBatches<T>(items: T[], batchSize: number): T[][] {
    const batches: T[][] = [];
    for (let i = 0; i < items.length; i += batchSize) {
      batches.push(items.slice(i, i + batchSize));
    }
    return batches;
  }
}
```

### ✅ Rate Limiting Middleware (Principle 12)
```typescript
// api/middleware/rate-limit.ts
import { rateLimiter } from 'hono-rate-limiter';

export function createRateLimit(config: RateLimitConfig) {
  return rateLimiter({
    windowMs: config.windowMs || 15 * 60 * 1000, // 15 minutes
    limit: config.limit || 100,
    standardHeaders: 'draft-6',
    keyGenerator: (c) => {
      // Support for load balancers and CDNs
      return c.req.header('x-forwarded-for') ||
             c.req.header('cf-connecting-ip') ||
             c.req.header('x-real-ip') ||
             'unknown';
    },
    handler: (c) => {
      return c.json({
        success: false,
        error: {
          code: 'RATE_LIMIT_EXCEEDED',
          message: 'リクエスト数が上限を超えました',
          retryAfter: Math.ceil(config.windowMs! / 1000)
        },
      }, 429);
    },
  });
}
```

## Implementation Checklist

When implementing a new backend feature, ensure all 12 principles are followed:

- [ ] **Principle 1**: Clear layer separation (Controller → Service → Repository)
- [ ] **Principle 2**: Result-based error handling with comprehensive scenario coverage
- [ ] **Principle 3**: Input validation with Zod schemas and sanitization
- [ ] **Principle 4**: Dependencies injected through interfaces
- [ ] **Principle 5**: Transaction boundaries for data consistency
- [ ] **Principle 6**: Authentication/authorization via middleware
- [ ] **Principle 7**: RESTful API design with versioning
- [ ] **Principle 8**: Performance optimizations (caching, query optimization, batch processing)
- [ ] **Principle 9**: Security measures implemented
- [ ] **Principle 10**: Comprehensive logging and monitoring with structured logs
- [ ] **Principle 11**: Reliability patterns (timeout, retry, circuit breaker)
- [ ] **Principle 12**: Scalability design with rate limiting and continuous learning mindset

## Example Implementation Workflow

```
1. Define API schema with Zod (Principle 3)
2. Create repository interface with Result types (Principle 4)
3. Implement repository with optimized queries and batch processing (Principle 8)
4. Create service with business logic, transactions, and Result pattern (Principles 1, 2, 5)
5. Add reliability patterns (timeout, retry, circuit breaker) (Principle 11)
6. Implement controller with validation and Result-based error handling (Principles 2, 3)
7. Add authentication/authorization middleware (Principle 6)
8. Setup caching and rate limiting (Principles 8, 12)
9. Add comprehensive logging with structured format (Principle 10)
10. Implement security measures and input sanitization (Principles 3, 9)
11. Add scalability considerations (load balancing, async processing) (Principle 12)
12. Write unit and integration tests with continuous learning feedback
```
