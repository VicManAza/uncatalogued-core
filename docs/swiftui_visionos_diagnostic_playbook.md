# SwiftUI + visionOS Diagnostic Playbook (unCATALOGUED)

This playbook is designed to diagnose the exact classes of failures you listed:

- `Invalid redeclaration of 'UncataloguedApp'`
- `'ImmersiveSpaceModel' is ambiguous`
- `Ambiguous use` errors (especially `init(name:)`)
- Multiple app entry points (`@main`) in one target

## 1) Critical Errors (How to classify quickly)

1. **Multiple app entry points**
   - Symptom: `Invalid redeclaration of UncataloguedApp` or build-target bootstrapping errors.
   - Root cause pattern: more than one `@main ... : App` in the same target.

2. **Ambiguous model/type name**
   - Symptom: `'ImmersiveSpaceModel' is ambiguous for type lookup`.
   - Root cause pattern: duplicate type declarations with same name in same module/target, or same symbol imported from different modules without qualification.

3. **Ambiguous initializer call**
   - Symptom: `Ambiguous use of init(name:)`.
   - Root cause pattern: duplicate/overloaded `init(name:)` with equivalent signatures, or type inference unresolved because of duplicate type names.

## 2) Root-Cause Checklist

- [ ] Exactly one `@main` app entry point exists in each executable target.
- [ ] `UncataloguedApp` is declared once in the active target.
- [ ] `ImmersiveSpaceModel` appears once per target/module namespace.
- [ ] If multiple modules expose `ImmersiveSpaceModel`, usage is module-qualified.
- [ ] `@StateObject` dependencies are created once and injected deterministically.
- [ ] No placeholder initializers remain (e.g., `<#ChapterEngine#>`).

## 3) File Conflict / Duplicate Detection

Run:

```bash
./scripts/swift_conflict_check.sh .
```

This scanner reports:

- All `@main` app declarations.
- Duplicate type declarations (`class/struct/enum/actor/protocol`).
- `ImmersiveSpaceModel` + `init(name:)` references.
- Inline `@StateObject` constructions.
- Basic app-init wiring patterns.

## 4) Architecture Issues to watch

1. **Mixed ownership of objects**
   - Anti-pattern: constructing shared coordinators both as inline `@StateObject` and again in `init()`.
   - Fix: define ownership at App root and inject references once.

2. **Circular coordinator dependencies**
   - `InteractionCoordinator` depending on `ChapterEngine` and `SceneCoordinator` is fine, but ensure those are stable singleton-like instances for app lifetime.

3. **visionOS immersion flow drift**
   - Keep immersive state (`ImmersionStyle`, space open/close flags) centralized in one model to avoid desync between `WindowGroup` and `ImmersiveSpace` triggers.

## 5) Step-by-step Fix Plan

1. Remove duplicate `UncataloguedApp` declarations and keep one `@main` per app target.
2. Remove/rename duplicate `ImmersiveSpaceModel` declarations.
3. If symbols come from multiple modules, qualify references (e.g., `MyModule.ImmersiveSpaceModel`).
4. Resolve `init(name:)` ambiguity by:
   - deleting duplicate initializers, or
   - using explicit argument labels/types, and
   - explicit type annotation at call site.
5. Refactor `@StateObject` creation:
   - Create `ChapterEngine`, `SceneCoordinator`, and `InteractionCoordinator` exactly once.
   - Pass concrete dependencies into `InteractionCoordinator` with real instances.
6. Rebuild and re-run scanner.

## 6) Confidence Rubric

- **High confidence**: scanner + compiler both confirm duplicate symbols are resolved.
- **Medium confidence**: scanner clean but compile not run in target environment.
- **Low confidence**: only static review with incomplete file set.

---

## Note on current repository state

At the time this playbook was added, this repository did not include Swift source files to directly validate the errors. The scanner and checklist are prepared so the same diagnostics can be run as soon as app files are present.
