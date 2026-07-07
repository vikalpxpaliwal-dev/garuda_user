# Garuda User App — UI & Responsiveness Review

**Reviewer lens:** Senior Flutter architecture (layout, responsiveness, accessibility, design-system consistency, performance).

**Scope:** All presentation pages under `lib/features/**/presentation/` plus shared widgets in `lib/core/widgets/`.

**Date:** July 2026

---

## Executive summary

The app has a strong visual identity (premium orange palette, glassmorphic auth, mesh gradients, card-based listings). The main problems are **not visual taste** — they are **architectural UI debt**:

| Area | Severity | Summary |
|------|----------|---------|
| Design system adoption | High | `AppText`, `AppSpacingTheme`, and `TextTheme` exist but are almost unused; 200+ inline `TextStyle`s |
| Responsiveness | High | Hard-coded `maxWidth: 420` on every shell page; fixed `crossAxisCount: 2`; no breakpoints |
| Accessibility | High | Font sizes as low as **8px**; no text-scaling strategy; tiny tap targets in places |
| Keyboard / inset handling | High | Auth pages set `resizeToAvoidBottomInset: false` — fields hide behind keyboard |
| Dark mode | Medium | `ThemeMode.system` enabled but UI hardcodes `AppColors.white` / `AppColors.ink` everywhere |
| Performance | Medium | Duplicated `BackdropFilter` + `RadialGradient` stacks; auth backgrounds use uncached `Image.network` |
| Maintainability | Medium | 12 presentation files > 300 lines; repeated page chrome copy-pasted per feature |

**What is working well:**
- Consistent `CustomScrollView` + `CommonSliverAppBar` pattern on Home / Search / Profile
- `ConstrainedBox(maxWidth: 420)` gives a polished phone-column feel on narrow devices
- Search listing cards and detail page have good information hierarchy
- `cached_network_image` on search images (after recent fix)
- Bottom nav shell (`AppShellScaffold`) is clean and thumb-friendly

---

## Page-by-page findings

### Splash (`splash_page.dart`)

| Issue | Detail |
|-------|--------|
| Fixed logo box | `180×180` container does not scale on tablets or very small phones |
| No loading indicator | If `AppStarted` is slow, user sees only animation with no feedback |
| Hardcoded typography | `fontSize: 28`, `11` — bypasses theme |

**Responsive risk:** Low (short screen).

---

### Auth — Login (`login_page.dart`)

| Issue | Detail |
|-------|--------|
| **Keyboard overlap** | `resizeToAvoidBottomInset: false` — password field can sit under keyboard on small phones |
| Uncached hero image | Full-screen `Image.network` Unsplash URL on every open |
| Glass blur cost | `BackdropFilter(sigmaX: 16)` on login card — expensive on low-end Android |
| Duplicate layout | Same background + glass card pattern repeated in signup/forgot/otp/reset |
| Inline styles | ~15 `TextStyle` blocks; no `AppText` / theme |

**Responsive risk:** High on phones with keyboard open (iPhone SE, small Android).

---

### Auth — Signup (`signup_page.dart`)

| Issue | Detail |
|-------|--------|
| Long form in one column | Name, email, phone, password, photo — scroll works but no section grouping |
| No `resizeToAvoidBottomInset` | Defaults to `true` (better than login) but inconsistent with other auth pages |
| Placeholder photo URL | Hardcoded `https://example.com/profile.jpg` — unrelated to UI but affects preview |
| 383 lines | Should share `AuthScaffold` with login |

**Responsive risk:** Medium — form length + keyboard on small screens.

---

### Auth — Forgot / OTP / Reset

| Issue | Detail |
|-------|--------|
| Same keyboard bug | All use `resizeToAvoidBottomInset: false` |
| Copy-pasted chrome | Background image, gradient, glass card duplicated 4× |
| OTP fields | Fixed sizing — may not adapt to accessibility text scale |

---

### Home (`home_page.dart`)

| Issue | Detail |
|-------|--------|
| Good scroll pattern | `RefreshIndicator` + `CustomScrollView` ✓ |
| `maxWidth: 420` | Content column centered — fine on phone, wasted space on tablet |
| Error state uses `context.spacing` | **Only page that uses spacing extension consistently** |
| Hero banners | `AspectRatio(1.48)` — scales width but not tuned for landscape |

**Responsive risk:** Low on phone; medium on tablet (narrow column in wide screen).

---

### Search (`search_page.dart` + widgets)

| Issue | Detail |
|-------|--------|
| Filter panel height | `SearchFilterPanel` is a tall `Column` (~550 lines) inside page scroll — works but heavy on small screens when filter open |
| Micro labels | `fontSize: 9` subtitle ("VERIFIED LISTINGS…") — unreadable with system large text |
| Fixed grids in filter | `crossAxisCount: 2` for radio options — cramped labels overflow on narrow widths |
| Listing card typography | Price `22`, labels `8–10` — inconsistent scale |
| Lazy list ✓ | `SliverList.builder` for results (good recent fix) |
| FAB overlap | Wishlist FAB can overlap last card — needs bottom padding when visible |

**Responsive risk:** Medium — filter panel + tiny text.

---

### Search detail (`search_listing_detail_page.dart` — 791 lines)

| Issue | Detail |
|-------|--------|
| Fixed hero height | `height: 380` — too tall on small phones, too short feel on tall phones |
| No max content width | Full-bleed on tablet — text lines become very long |
| Grid gallery | `crossAxisCount: 2` fixed — should be 3–4 on tablet |
| Monolithic file | Header, properties, media, wishlist UI in one file |
| Mixed colors | `Color(0xFFF7F7F7)` hardcoded instead of `colorScheme.surface` |

**Responsive risk:** Medium–high on small height devices.

---

### Profile (`profile_page.dart` + 7 part widgets)

| Issue | Detail |
|-------|--------|
| God-page state | 6+ `Set`/selection fields, 5 bloc listeners, tab + journey state in one widget |
| Bottom FAB stack | `Positioned(right: 16, bottom: 18)` + `padding: bottom: 120` — magic numbers |
| Micro typography epidemic | `fontSize: 8`, `8.5`, `9` across wishlist, tracking, visits widgets |
| No empty-state consistency | Each panel rolls its own empty UI |
| Largest widgets | `profile_tracking_cart.dart` (586), `profile_shared_widgets.dart` (583) |

**Responsive risk:** High — dense UI + small text + overlapping FABs.

---

### Edit profile (`edit_profile_page.dart`)

| Issue | Detail |
|-------|--------|
| `extendBodyBehindAppBar: true` | Content can sit under status bar if scroll position wrong |
| Form not width-constrained | Unlike auth pages, no `maxWidth: 420` — stretches on tablet |
| Glass / gradient background | Duplicated premium background pattern again |

---

### Shell (`app_shell_scaffold.dart`)

| Issue | Detail |
|-------|--------|
| Custom bottom nav | Works on phone; on tablet/desktop should consider `NavigationRail` |
| Label size `10` | Below readable minimum for accessibility |
| No selected-state semantics | Screen readers get limited nav context |

---

### Shared (`common_sliver_app_bar.dart`)

| Issue | Detail |
|-------|--------|
| Blur on every tab | `BackdropFilter` on pinned app bar — 3 tabs × constant blur = GPU cost |
| Fixed `toolbarHeight: 56` | Fine, but doesn't account for accessibility text scale in title |

---

## Cross-cutting issues (what you are doing wrong)

### 1. Design system exists but is ignored

You built the right primitives:

```
lib/core/theme/app_spacing_theme.dart   ← used in ~2 places
lib/core/theme/app_radius_theme.dart    ← barely used
lib/core/widgets/app_text.dart          ← used 3 times total
lib/core/constants/app_constants.dart   ← maxContentWidth: 1080 defined, never used
```

**Reality:** Almost every widget uses raw `TextStyle(fontSize: 8–22)` and `EdgeInsets.fromLTRB(18, …)`.

**Fix direction:** One source of truth for typography, spacing, and content width.

---

### 2. “Responsive” = phone column only

`BoxConstraints(maxWidth: 420)` appears on:
- Home, Search, Profile, Login, Signup, Forgot, OTP, Reset

This is a **fixed mockup width**, not responsive design:
- **Tablet / foldable:** huge empty margins, no use of `AppConstants.maxContentWidth` (1080)
- **Landscape phone:** same narrow column, wasted horizontal space
- **No `LayoutBuilder` / breakpoints** anywhere in presentation layer

---

### 3. Accessibility failures

| Problem | Examples |
|---------|----------|
| Text below 11sp | `fontSize: 8`, `8.2`, `8.5`, `9` in profile + search |
| No text-scale clamping | System "Large text" will overflow fixed-height rows |
| Low contrast micro-labels | `AppColors.mutedText` at 8–9sp on soft background |
| Missing semantics | Icon-only buttons (filter, wishlist, nav) lack labels |

WCAG recommends **minimum 12sp** for body; labels under **10sp** fail on most devices.

---

### 4. Keyboard & safe area

```dart
// login_page.dart, forgot, otp, reset
resizeToAvoidBottomInset: false  // ← actively fights the keyboard
```

On a 5.4" phone with keyboard open, the login button and lower fields are often **not visible** without manual scroll — and scroll is fighting inset resize.

---

### 5. Dark mode is decorative only

`GarudaApp` sets `themeMode: ThemeMode.system`, but presentation code uses:
- `AppColors.white`, `AppColors.ink`, `AppColors.softBackground` directly
- `Colors.white` / `Colors.black` in auth glass cards

**Result:** Dark mode surfaces flip but content stays "light-theme colors" — broken contrast.

---

### 6. Performance patterns

| Pattern | Count | Impact |
|---------|-------|--------|
| `RadialGradient` background stacks | 5+ pages | Repaint on scroll |
| `BackdropFilter` blur | App bar + auth cards | GPU-heavy on Mali/Adreno low-end |
| `Image.network` auth backgrounds | 4 pages | Slow first paint, no cache |
| `CustomPainter` listing artwork | 3 variants | OK as fallback, but runs when images fail |

---

### 7. File size / composition

| File | Lines | Recommendation |
|------|-------|----------------|
| `search_listing_detail_page.dart` | 791 | Split header / properties / gallery |
| `profile_page.dart` | 643 | Extract FAB + listener wiring |
| `profile_tracking_cart.dart` | 586 | Extract payment step widgets |
| `search_filter_panel.dart` | 554 | Already has mapper; split form fields |

---

## Recommended target architecture

```
lib/core/widgets/
  app_page_shell.dart          ← mesh gradient + scroll + max-width
  app_content_width.dart       ← breakpoint-aware constraints
  app_mesh_background.dart     ← single gradient implementation
  auth_flow_scaffold.dart      ← shared auth background + glass card

lib/core/theme/
  app_text_styles.dart         ← caption, microLabel, price, sectionTitle
  app_breakpoints.dart         ← compact / medium / expanded
```

**Breakpoint sketch:**

| Width | Layout |
|-------|--------|
| `< 600` | `maxWidth: 420`, single column, bottom nav |
| `600–900` | `maxWidth: 600`, 2-column grids where appropriate |
| `> 900` | `maxWidth: 1080`, optional `NavigationRail`, 3-column grids |

---

## Phase-wise fix prompts

Copy-paste each prompt into a new agent session. Complete phases in order.

---

### Phase 1 — Shared layout shell (foundation)

**Goals:** Eliminate duplicated page chrome; centralize content width.

#### Prompt 1.1 — Create `AppPageShell` and `AppContentWidth`
```
Create lib/core/widgets/app_page_shell.dart and lib/core/widgets/app_content_width.dart.

AppContentWidth:
- Use LayoutBuilder + breakpoints (compact <600, medium <900, expanded >=900).
- compact: maxWidth 420; medium: 560; expanded: min(screenWidth * 0.85, AppConstants.maxContentWidth).
- Expose static EdgeInsets pagePadding(BuildContext).

AppPageShell:
- Optional mesh gradient background (reuse existing radial gradient colors from home_page).
- Child: CustomScrollView with slivers OR plain child.
- Wraps content in Center > AppContentWidth > Padding.
- Parameters: showAppBar (CommonSliverAppBar), onRefresh, slivers vs child.

Migrate home_page.dart, search_page.dart, and profile_page.dart to use AppPageShell.
Remove duplicate gradient Stack blocks from those three files.
Do not change business logic or bloc wiring.
```

#### Prompt 1.2 — Create `AppMeshBackground`
```
Extract the duplicated two-layer RadialGradient background (used in home, search, profile, splash)
into lib/core/widgets/app_mesh_background.dart as a const-friendly StatelessWidget.
Replace inline copies in all pages. Keep visual appearance identical.
```

**Exit criteria:** Home, Search, Profile use shared shell; no duplicate gradient stacks in those files.

---

### Phase 2 — Typography & spacing tokens

**Goals:** Replace inline micro-fonts; respect text scaling.

#### Prompt 2.1 — Extend theme text roles
```
Add to lib/core/theme/ (or extend app_theme.dart):
- AppTextVariant: sectionTitle, price, caption, microLabel (min 11sp base).
- Map microLabel to 11sp minimum, not 8sp.

Extend AppText widget to support new variants and optional letterSpacing.

Create a lint-friendly helper: context.text.sectionTitle, etc. via extension on BuildContext.

Replace inline TextStyle in search_listing_card.dart and search_page.dart header
with AppText / theme roles. Remove any fontSize below 11.
```

#### Prompt 2.2 — Adopt spacing theme
```
Replace hard-coded EdgeInsets.fromLTRB(18, …) on home, search, profile pages
with context.spacing.screenPadding and context.spacing.md/lg tokens.
Do not change visual spacing by more than 2px.
```

**Exit criteria:** No `fontSize: 8|9` in search_listing_card or search_page; spacing uses theme on 3 main tabs.

---

### Phase 3 — Keyboard, safe area, and auth UX

**Goals:** Fix keyboard overlap; unify auth layout.

#### Prompt 3.1 — Fix auth keyboard handling
```
On login_page, forgot_password_page, otp_verification_page, reset_password_page:
- Remove resizeToAvoidBottomInset: false (or set true).
- Ensure SingleChildScrollView + SafeArea wraps all form content.
- Add padding bottom: MediaQuery.viewInsets.bottom when keyboard is open.
- Verify on small viewport (iPhone SE size) that Continue button stays reachable.

Do not change bloc logic or navigation.
```

#### Prompt 3.2 — Extract `AuthFlowScaffold`
```
Create lib/features/auth/presentation/widgets/auth_flow_scaffold.dart:
- Shared background (use cached_network_image or asset for background, not raw Image.network).
- Gradient overlay, SafeArea, scrollable child slot, optional glass card wrapper.
- max width via AppContentWidth.

Refactor login, signup, forgot, otp, reset to use AuthFlowScaffold.
Target: each auth page file under 200 lines.
```

**Exit criteria:** All auth forms scroll above keyboard; auth pages share one scaffold widget.

---

### Phase 4 — Responsive grids and breakpoints

**Goals:** Adapt layouts for width, not just center a phone column.

#### Prompt 4.1 — Responsive filter and gallery grids
```
Add lib/core/utils/responsive_grid.dart with:
  int gridCrossAxisCount(BuildContext, {int compact=2, int medium=3, int expanded=4})

Apply to:
- search_filter_panel.dart radio grids
- search_listing_detail_page.dart visual documentation grid

Use LayoutBuilder or breakpoint helper from AppContentWidth.
```

#### Prompt 4.2 — Detail page responsive hero
```
In search_listing_detail_page.dart:
- Replace fixed height: 380 with AspectRatio (16/10) or maxHeight: 42% of screen height.
- Wrap detail body text sections in AppContentWidth (expanded: two-column properties where sensible).
- Split file into parts: detail_header.dart, detail_properties.dart, detail_gallery.dart (keep under 300 lines each).
```

**Exit criteria:** Gallery shows 3 columns on tablet width; detail hero scales with screen height.

---

### Phase 5 — Profile density & FAB layout

**Goals:** Reduce clutter; fix overlap magic numbers.

#### Prompt 5.1 — Profile FAB and bottom inset
```
On profile_page.dart:
- Replace hard-coded bottom: 120 padding with calculation:
  bottomNavHeight + fabHeight + context.spacing.lg.
- Use Scaffold.floatingActionButton or bottomSheet pattern instead of Stack Positioned FABs if possible.
- Ensure last list item is not hidden behind FAB on smallest supported phone.
```

#### Prompt 5.2 — Profile typography pass
```
In profile_wishlist_panel, profile_tracking_cart, profile_visits_primary, profile_shared_widgets:
- Replace all fontSize 8–10 with theme caption/microLabel (min 11sp).
- Increase tap targets to minimum 44×44 for selectable chips and icon buttons.
- Add Semantics labels to icon-only actions.
```

**Exit criteria:** No font below 11sp in profile widgets; FAB does not cover content.

---

### Phase 6 — Performance & images

**Goals:** Faster first paint; less GPU blur.

#### Prompt 6.1 — Reduce BackdropFilter cost
```
CommonSliverAppBar: replace BackdropFilter blur with semi-opaque solid color
(AppColors.softBackground at 0.92 alpha) unless running on iOS where blur is cheap.
Alternatively use blur only when scroll offset > 0.

Auth glass cards: reduce sigma from 16 to 8, or use solid frosted white at 0.85 alpha on Android.
```

#### Prompt 6.2 — Auth background images
```
Replace Image.network Unsplash backgrounds in auth pages with:
- bundled asset under assets/images/ (preferred), OR
- CachedNetworkImage with memCacheWidth.

Prefetch auth background in splash or first auth route.
```

**Exit criteria:** Auth screens paint without network dependency; scroll jank reduced on mid-range Android.

---

### Phase 7 — Dark mode correctness

**Goals:** Make `ThemeMode.system` actually work.

#### Prompt 7.1 — ColorScheme migration
```
Audit presentation layer for hardcoded AppColors.white, AppColors.ink, Color(0xFFF7F7F7).
Replace with Theme.of(context).colorScheme.surface / onSurface / surfaceContainerHighest.

Priority files: search_listing_detail_page, search_listing_card, profile panels, auth glass cards.
Keep brand orange from AppColors.deepOrange (primary accent is fine to keep static).

Test in Android dark mode and iOS dark mode.
```

**Exit criteria:** Home, Search, Profile, Detail readable in dark mode without white flash cards on dark background.

---

### Phase 8 — Accessibility & polish

**Goals:** Production-quality a11y.

#### Prompt 8.1 — Text scaling strategy
```
Add lib/core/widgets/app_scaled_text.dart or MediaQuery wrapper:
- Clamp textScaler to max 1.3 for micro labels if needed to prevent overflow,
  OR allow full scale and make layouts flexible (preferred: flexible).

Fix overflow errors when textScaleFactor = 1.5 on:
- search listing card price row
- profile journey card badges
- filter panel radio grid labels
```

#### Prompt 8.2 — Widget tests for layout
```
Add flutter test golden or pump tests:
- Login page at 320×568 (compact)
- Search results at 390×844
- Profile at tablet 800×1280
Assert: no RenderFlex overflow, key CTAs visible.
```

**Exit criteria:** `flutter test` layout tests pass at 3 viewport sizes; no overflow at textScale 1.3.

---

## Quick wins (do today, < 2 hours)

1. **Remove `resizeToAvoidBottomInset: false`** from all auth pages.
2. **Bump `fontSize: 8/9` → `11`** in search listing card and profile shared widgets.
3. **Add `padding: EdgeInsets.only(bottom: 80)`** to search results sliver when FAB visible.
4. **Use `AppConstants.maxContentWidth`** instead of magic `420` via a one-line helper.
5. **Replace auth `Image.network`** with a local asset.

---

## Metrics to track after fixes

| Metric | Current (est.) | Target |
|--------|----------------|--------|
| Files with `fontSize: [89]` | 15+ files | 0 |
| Pages using `AppPageShell` | 0 | 6+ |
| `AppText` usage vs raw `Text` | ~3 vs 200+ | 80% themed |
| Auth keyboard overlap reports | Common on small phones | None |
| Dark mode contrast failures | Many | WCAG AA on primary screens |
| Presentation files > 400 lines | 10 | ≤ 4 |

---

## Related docs

- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) — bloc lifecycle, navigation, testing
- [ARCHITECTURE_REVIEW.md](ARCHITECTURE_REVIEW.md) — backend/data layer phases (already completed)
