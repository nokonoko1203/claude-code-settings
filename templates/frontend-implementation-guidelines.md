# Frontend Implementation Guidelines for LLM Code Generation

## Core Principles - 10 Universal Rules

Based on high-quality production code patterns, follow these universal principles when implementing frontend features:

### 1. Separation of Concerns Through Custom Hooks
ビジネスロジック、状態管理、UIレンダリングを明確に分離する。カスタムフック（useMapDataQuery, useMapLayersなど）でロジックをカプセル化。

### 2. Comprehensive Error Handling
すべての非同期処理とユーザー操作にエラーハンドリングを実装。専用のErrorScreenコンポーネントとrefetch機能を提供。

### 3. Loading State Management
すべての非同期処理に対してローディング状態を管理。LoadingScreenコンポーネントで一貫したUXを提供。

### 4. Performance Optimization Through Memoization
計算コストの高い処理やコールバック関数は適切にメモ化。不要な再レンダリングを防止。

### 5. Type Safety with TypeScript
すべてのデータ構造、関数の引数、戻り値に明示的な型定義。型ガードで実行時の安全性も確保。

### 6. Component Decomposition
UIを責務ごとに小さなコンポーネントに分割（MapInfoPanel, LoadingScreen, ErrorScreenなど）。再利用性と保守性を向上。

### 7. Declarative UI Design
命令的な操作より宣言的な記述を優先。状態に基づいてUIが自動的に更新される設計。

### 8. Centralized Data Management
データフェッチングとキャッシュ管理を統一的に扱う（React Query的なパターン）。重複リクエストの防止と最適化。

### 9. Externalization of Constants
設定値、初期状態（INITIAL_VIEW_STATEなど）、エラーメッセージを定数として外部化。保守性と再利用性を向上。

### 10. Avoiding Props Drilling
深いコンポーネント階層でのプロップの受け渡しを避ける。Context APIやカスタムフックで状態を共有。

## 1. Architecture Pattern: Universal Layer Structure

### ✅ Layer Structure
```
src/routes/[feature]/
├── +page.svelte              # Main component (orchestration only)
├── components/               # UI components (presentation layer)
│   ├── FeatureEditForm.svelte
│   ├── FeatureInfo.svelte
│   ├── LoadingScreen.svelte  # Principle 3
│   ├── ErrorScreen.svelte    # Principle 2
│   └── FeatureCard.svelte
├── lib/                      # Business logic layer
│   ├── types.ts              # Type definitions (Principle 5)
│   ├── constants.ts          # Constants and configurations (Principle 9)
│   ├── use-feature-query.svelte.ts     # Data fetching hook (Principles 1, 8)
│   ├── use-feature-form.svelte.ts      # Form state management (Principle 1)
│   └── use-feature-actions.svelte.ts   # API operations (Principle 1)
└── [id]/                     # Dynamic routes
```

### ✅ Responsibility Assignment (Principles 1, 6)
- **Page Component**: Orchestration and state coordination only
- **UI Components**: Pure presentation, receive props and emit events
- **Custom Hooks**: Business logic, state management, API calls
- **Type Files**: All interfaces and type definitions
- **Constants**: Configuration values and error messages
- **Context/Store**: Shared state to avoid props drilling (Principle 10)

## 2. Custom Hook Patterns - Universal State Management

### ✅ Data Query Hook with Cache Management (Principles 1, 8)
```typescript
// use-[feature]-query.svelte.ts
export function useFeatureQuery(id: string) {
  let data = $state<FeatureDetail | null>(null);
  let isLoading = $state(false);
  let isRefetching = $state(false);
  let error = $state<string | null>(null);
  let lastFetchTime = $state<number>(0);

  const CACHE_TIME = 5 * 60 * 1000; // 5 minutes

  // Memoized check for stale data (Principle 4)
  const isStale = $derived(
    Date.now() - lastFetchTime > CACHE_TIME
  );

  async function fetchData() {
    // Prevent duplicate requests (Principle 8)
    if (isLoading || isRefetching) return;

    const isInitialLoad = !data;
    if (isInitialLoad) {
      isLoading = true;
    } else {
      isRefetching = true;
    }
    error = null;

    try {
      const client = makeApiClient(fetch);
      const result = await getFeatureDetail(client, id);

      if (result.status === 200) {
        data = result.data;
        lastFetchTime = Date.now();
      } else {
        error = getErrorMessage(result.status);
      }
    } catch (err) {
      error = "通信エラーが発生しました";
      console.error("Fetch error:", err);
    } finally {
      isLoading = false;
      isRefetching = false;
    }
  }

  // Refetch function for error recovery (Principle 2)
  async function refetch() {
    await fetchData();
  }

  return {
    get data() { return data; },
    get isLoading() { return isLoading; },
    get isRefetching() { return isRefetching; },
    get error() { return error; },
    get isStale() { return isStale; },
    fetchData,
    refetch
  };
}
```

### ✅ Form State Management Hook with Validation (Principles 1, 5)
```typescript
// use-[feature]-form.svelte.ts
export function useFeatureForm(initialData: FeatureFormData) {
  // State management with type safety
  let formData = $state<FeatureFormData>({ ...initialData });
  let originalData = $state<FeatureFormData>({ ...initialData });
  let touchedFields = $state<Set<keyof FeatureFormData>>(new Set());

  // Memoized validation (Principle 4)
  const fieldErrors = $derived(validateFormData(formData, touchedFields));
  const isDirty = $derived(isFormDirty(formData, originalData));
  const hasErrors = $derived(Object.values(fieldErrors).some(Boolean));
  const isValid = $derived(isDirty && !hasErrors);

  // Type-safe field update (Principle 5)
  function updateField<K extends keyof FeatureFormData>(
    field: K,
    value: FeatureFormData[K]
  ) {
    formData[field] = value;
    touchedFields.add(field);
  }

  function reset() {
    formData = { ...originalData };
    touchedFields.clear();
  }

  function setOriginalData(data: FeatureFormData) {
    originalData = { ...data };
    formData = { ...data };
    touchedFields.clear();
  }

  return {
    get formData() { return formData; },
    get errors() { return fieldErrors; },
    get isDirty() { return isDirty; },
    get isValid() { return isValid; },
    updateField,
    reset,
    setOriginalData
  };
}
```

### ✅ Optimized Actions Hook (Principles 1, 2, 4)
```typescript
// use-[feature]-actions.svelte.ts
export function useFeatureActions() {
  let isUpdating = $state(false);
  let isDeleting = $state(false);

  // Action methods
  async function updateFeature(id: string, data: FeatureFormData): Promise<ActionResult> {
    if (isUpdating) return { success: false, error: "更新中です" };

    isUpdating = true;

    try {
      const client = makeApiClient(fetch);
      const result = await updateFeatureApi(client, id, data);

      if (result.status === 200) {
        return { success: true, data: result.data };
      }

      // Centralized error handling (Principle 2)
      return {
        success: false,
        error: getErrorMessage(result.status)
      };
    } catch (error) {
      console.error("Update error:", error);
      return {
        success: false,
        error: "通信エラーが発生しました"
      };
    } finally {
      isUpdating = false;
    }
  }

  async function deleteFeature(id: string): Promise<ActionResult> {
    if (isDeleting) return { success: false, error: "削除中です" };

    isDeleting = true;

    try {
      const client = makeApiClient(fetch);
      const result = await deleteFeatureApi(client, id);

      if (result.status === 200) {
        return { success: true };
      }

      return {
        success: false,
        error: getErrorMessage(result.status)
      };
    } catch (error) {
      console.error("Delete error:", error);
      return {
        success: false,
        error: "通信エラーが発生しました"
      };
    } finally {
      isDeleting = false;
    }
  }

  return {
    get isUpdating() { return isUpdating; },
    get isDeleting() { return isDeleting; },
    updateFeature,
    deleteFeature
  };
}
```

## 3. Component Implementation Patterns

### ✅ Main Page Component with Error & Loading States (Principles 2, 3, 6, 7)
```svelte
<!-- +page.svelte -->
<script lang="ts">
  import { onMount } from "svelte";
  import { page } from "$app/stores";

  // Import custom hooks (Principle 1)
  import { useFeatureQuery } from "./lib/use-feature-query.svelte";
  import { useFeatureForm } from "./lib/use-feature-form.svelte";
  import { useFeatureActions } from "./lib/use-feature-actions.svelte";

  // Import UI components (Principle 6)
  import LoadingScreen from "./components/LoadingScreen.svelte";
  import ErrorScreen from "./components/ErrorScreen.svelte";
  import FeatureEditForm from "./components/FeatureEditForm.svelte";
  import FeatureInfo from "./components/FeatureInfo.svelte";

  // Get page params
  const { params } = $derived(page);
  const featureId = $derived(params.id);

  // Initialize hooks
  const featureQuery = useFeatureQuery(featureId);
  const featureForm = useFeatureForm(INITIAL_FORM_DATA);
  const featureActions = useFeatureActions();

  // Local UI state
  let isEditMode = $state(false);
  let showDeleteModal = $state(false);

  // Load data on mount
  onMount(async () => {
    await featureQuery.fetchData();
  });

  // Sync form when data loads (Principle 7)
  $effect(() => {
    if (featureQuery.data) {
      featureForm.setOriginalData(featureQuery.data);
    }
  });

  // Event handlers
  async function handleSave() {
    const result = await featureActions.updateFeature(
      featureId,
      featureForm.formData
    );

    if (result.success) {
      await featureQuery.refetch();
      isEditMode = false;
    }
  }
</script>

<!-- Declarative UI with loading/error states (Principles 3, 7) -->
{#if featureQuery.isLoading}
  <LoadingScreen />
{:else if featureQuery.error}
  <ErrorScreen
    error={featureQuery.error}
    onRetry={featureQuery.refetch}
  />
{:else if featureQuery.data}
  {#if isEditMode}
    <FeatureEditForm
      formData={featureForm.formData}
      errors={featureForm.errors}
      isValid={featureForm.isValid}
      isDirty={featureForm.isDirty}
      isProcessing={featureActions.isUpdating}
      onFieldUpdate={featureForm.updateField}
      onSave={handleSave}
      onCancel={() => isEditMode = false}
    />
  {:else}
    <FeatureInfo
      data={featureQuery.data}
      onEdit={() => isEditMode = true}
    />
  {/if}
{/if}
```

### ✅ Reusable Error Screen Component (Principle 2)
```svelte
<!-- components/ErrorScreen.svelte -->
<script lang="ts">
  interface Props {
    error: string;
    onRetry?: () => void;
  }

  let { error, onRetry }: Props = $props();
</script>

<div class="error-container">
  <p class="error-message">{error}</p>
  {#if onRetry}
    <button onclick={onRetry} class="retry-button">
      再試行
    </button>
  {/if}
</div>
```

### ✅ Form Component with Optimized Rendering (Principles 4, 6, 7)
```svelte
<!-- components/FeatureEditForm.svelte -->
<script lang="ts">
  import type { FeatureFormData, FeatureFormErrors } from "../lib/types";

  interface Props {
    formData: FeatureFormData;
    errors: FeatureFormErrors;
    isValid: boolean;
    isDirty: boolean;
    isProcessing: boolean;
    onFieldUpdate: <K extends keyof FeatureFormData>(
      field: K,
      value: FeatureFormData[K]
    ) => void;
    onSave: () => void;
    onCancel: () => void;
  }

  let {
    formData,
    errors,
    isValid,
    isDirty,
    isProcessing,
    onFieldUpdate,
    onSave,
    onCancel
  }: Props = $props();

  // Event handlers
  function handleFieldChange(field: keyof FeatureFormData) {
    return (e: Event) => {
      const target = e.currentTarget as HTMLInputElement;
      onFieldUpdate(field, target.value);
    };
  }
</script>

<form onsubmit={(e) => { e.preventDefault(); onSave(); }}>
  <!-- Declarative field rendering (Principle 7) -->
  <input
    value={formData.field}
    oninput={handleFieldChange('field')}
    class:error={errors.field}
    disabled={isProcessing}
  />
  {#if errors.field}
    <p class="error-text">{errors.field}</p>
  {/if}

  <div class="form-actions">
    <button
      type="submit"
      disabled={!isValid || isProcessing}
    >
      {isProcessing ? "保存中..." : "保存"}
    </button>
    <button
      type="button"
      onclick={onCancel}
      disabled={isProcessing}
    >
      キャンセル
    </button>
  </div>
</form>
```

## 4. Type Safety Patterns (Principle 5)

### ✅ Comprehensive Type Definitions
```typescript
// lib/types.ts

// Domain types with strict typing
export interface FeatureDetail {
  id: string;
  name: string;
  status: FeatureStatus;
  createdAt: Date;
  updatedAt: Date;
}

// Form types with validation
export interface FeatureFormData {
  name: string;
  description: string;
  settings: FeatureSettings;
}

// Error types matching form structure
export type FeatureFormErrors = {
  [K in keyof FeatureFormData]?: string | null;
};

// Action result with discriminated union
export type ActionResult<T = unknown> =
  | { success: true; data?: T }
  | { success: false; error: string };

// Type guards for runtime safety
export function isFeatureDetail(value: unknown): value is FeatureDetail {
  return (
    typeof value === 'object' &&
    value !== null &&
    'id' in value &&
    'name' in value
  );
}
```

## 5. Data Management Patterns (Principle 8)

### ✅ Centralized Query Management
```typescript
// lib/query-client.ts
export interface QueryState<T> {
  data: T | null;
  isLoading: boolean;
  isRefetching: boolean;
  error: string | null;
  lastFetchTime: number;
}

// Query key factory for consistent caching
export const queryKeys = {
  feature: (id: string) => ['feature', id],
  featureList: (filters?: FeatureFilters) => ['features', filters],
} as const;

// Shared query utilities
export function createQueryState<T>(): QueryState<T> {
  return {
    data: null,
    isLoading: false,
    isRefetching: false,
    error: null,
    lastFetchTime: 0,
  };
}
```

## 6. Performance Optimization Patterns (Principle 4)

### ✅ Svelte's Built-in Optimization
```typescript
// Svelte automatically optimizes component updates through its compiler.
// Use $derived for computed values that are automatically memoized:

// lib/use-expensive-calculation.svelte.ts
export function useExpensiveCalculation(data: DataItem[]) {
  // This will only recalculate when data changes
  const processedData = $derived(
    data.reduce((acc, item) => {
      // Expensive operation
      return acc + calculateComplexValue(item);
    }, 0)
  );

  const sortedData = $derived(
    [...data].sort((a, b) => a.value - b.value)
  );

  return {
    get processedData() { return processedData; },
    get sortedData() { return sortedData; }
  };
}
```

### ✅ Event Handler Optimization
```svelte
<script lang="ts">
  // For event handlers that need parameters, create them once
  function createClickHandler(id: string) {
    return () => {
      console.log('Clicked:', id);
    };
  }

  // For simple handlers, define them directly
  function handleSubmit() {
    // Handle form submission
  }
</script>
```

### ✅ List Rendering Optimization
```svelte
<!-- Svelte automatically optimizes list rendering with keyed each blocks -->
{#each items as item (item.id)}
  <ListItem
    {item}
    onSelect={() => handleSelect(item.id)}
  />
{/each}

<!-- For better performance with large lists, consider virtual scrolling -->
<script lang="ts">
  import { VirtualList } from '@sveltejs/svelte-virtual-list';
</script>

<VirtualList items={largeDataset} let:item>
  <ListItem {item} />
</VirtualList>
```

## 7. Error Handling Patterns (Principle 2)

### ✅ Centralized Error Management
```typescript
// lib/constants/errors.ts
export const ERROR_MESSAGES = {
  // Network errors
  NETWORK_ERROR: "通信エラーが発生しました",
  TIMEOUT_ERROR: "タイムアウトしました",

  // Validation errors
  FIELD_REQUIRED: "このフィールドは必須です",
  FIELD_MIN_LENGTH: (min: number) => `${min}文字以上で入力してください`,
  FIELD_MAX_LENGTH: (max: number) => `${max}文字以内で入力してください`,

  // API errors
  400: "入力内容に誤りがあります",
  401: "認証が必要です",
  403: "アクセス権限がありません",
  404: "データが見つかりません",
  409: "データが競合しています",
  500: "サーバーエラーが発生しました",
} as const;

// Error message resolver
export function getErrorMessage(
  status: number | string,
  fallback = ERROR_MESSAGES.NETWORK_ERROR
): string {
  return ERROR_MESSAGES[status as keyof typeof ERROR_MESSAGES] || fallback;
}
```

### ✅ Global Error Boundary Pattern
```typescript
// lib/use-error-boundary.svelte.ts
export function useErrorBoundary() {
  let error = $state<Error | null>(null);
  let resetKey = $state(0);

  function captureError(err: Error) {
    console.error('Error captured:', err);
    error = err;
  }

  function reset() {
    error = null;
    resetKey += 1;
  }

  return {
    get error() { return error; },
    get resetKey() { return resetKey; },
    captureError,
    reset
  };
}
```

## 8. State Sharing Without Props Drilling (Principle 10)

### ✅ Context Pattern for Shared State
```typescript
// lib/contexts/feature-context.svelte.ts
import { getContext, setContext } from 'svelte';

export interface FeatureContextValue {
  selectedId: string | null;
  filters: FeatureFilters;
  updateFilters: (filters: Partial<FeatureFilters>) => void;
}

// Context key
const FEATURE_CONTEXT_KEY = Symbol('feature-context');

// Function to create and set context
export function createFeatureContext() {
  let selectedId = $state<string | null>(null);
  let filters = $state<FeatureFilters>({});

  function updateFilters(newFilters: Partial<FeatureFilters>) {
    filters = { ...filters, ...newFilters };
  }

  const context: FeatureContextValue = {
    get selectedId() { return selectedId; },
    get filters() { return filters; },
    updateFilters
  };

  setContext(FEATURE_CONTEXT_KEY, context);
  return context;
}

// Hook for consuming context
export function useFeatureContext() {
  const context = getContext<FeatureContextValue>(FEATURE_CONTEXT_KEY);
  if (!context) {
    throw new Error('useFeatureContext must be used within FeatureProvider');
  }
  return context;
}
```

## 9. Constants and Configuration (Principle 9)

### ✅ Centralized Configuration
```typescript
// lib/constants/config.ts
export const FEATURE_CONFIG = {
  // API configuration
  API_TIMEOUT: 30000,
  RETRY_COUNT: 3,
  CACHE_TIME: 5 * 60 * 1000,

  // UI configuration
  PAGE_SIZE: 20,
  DEBOUNCE_DELAY: 300,

  // Validation rules
  NAME_MAX_LENGTH: 100,
  DESCRIPTION_MAX_LENGTH: 500,

  // Initial states
  INITIAL_FORM_DATA: {
    name: '',
    description: '',
    status: 'draft',
  },

  INITIAL_VIEW_STATE: {
    zoom: 10,
    center: [0, 0],
  },
} as const;
```

## 10. Implementation Checklist

When implementing a new feature, ensure all 10 principles are followed:

- [ ] **Principle 1**: Custom hooks for logic separation
- [ ] **Principle 2**: Error handling with ErrorScreen and refetch
- [ ] **Principle 3**: Loading states with LoadingScreen
- [ ] **Principle 4**: Memoization for expensive operations
- [ ] **Principle 5**: Complete TypeScript type coverage
- [ ] **Principle 6**: Component decomposition by responsibility
- [ ] **Principle 7**: Declarative UI patterns
- [ ] **Principle 8**: Centralized data management
- [ ] **Principle 9**: Externalized constants and config
- [ ] **Principle 10**: Context/Store for shared state

## Example Implementation Workflow

```
1. Define types and interfaces (Principle 5)
2. Create constants and configuration (Principle 9)
3. Implement custom hooks:
   - use-[feature]-query.svelte.ts (Principles 1, 8)
   - use-[feature]-form.svelte.ts (Principles 1, 4)
   - use-[feature]-actions.svelte.ts (Principles 1, 2)
4. Create reusable components:
   - LoadingScreen.svelte (Principle 3)
   - ErrorScreen.svelte (Principle 2)
   - Feature-specific components (Principle 6)
5. Wire everything in main component (Principle 7)
6. Add context for shared state if needed (Principle 10)
7. Optimize with memoization where necessary (Principle 4)
```
