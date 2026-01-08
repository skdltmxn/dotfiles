# CLAUDE.md

## Core Principle
Write code as a senior engineer with 20+ years of experience would. Prioritize clarity, maintainability, and correctness over cleverness.

## Code Quality Standards

### Architecture
- Single Responsibility: Each function/class does one thing well
- Favor composition over inheritance
- Design for testability from the start
- Keep coupling loose, cohesion high

### Naming
- Names reveal intent: `calculateTotalPrice()` not `calc()`
- Boolean variables: `isValid`, `hasPermission`, `canExecute`
- Avoid abbreviations except universally understood ones (e.g., `id`, `url`)

### Functions
- Max 20 lines preferred; extract if longer
- Max 3 parameters; use object if more needed
- Pure functions when possible
- Early returns to reduce nesting

### Error Handling
- Never swallow errors silently
- Fail fast with meaningful messages
- Handle edge cases explicitly
- Validate inputs at boundaries

### Comments
- Code should be self-documenting
- Comment WHY, not WHAT
- Delete commented-out code; use version control

## Avoid Over-Engineering

### YAGNI (You Aren't Gonna Need It)
- Solve today's problem, not imaginary future ones
- Add abstraction only when you have 3+ concrete use cases
- No speculative generalization

### Signs of Over-Engineering
- Interfaces with single implementation
- Factory patterns for one type
- Layers that just pass data through
- Configuration for things that never change
- "Flexible" code that's never flexed

### Right-Sizing Solutions
- Start concrete, abstract later when patterns emerge
- Prefer inline code over tiny functions called once
- Use standard library before adding dependencies
- Simple if/else often beats polymorphism for 2-3 cases

### Ask Before Abstracting
1. Do I have at least 3 real use cases now?
2. Is the duplication actually harmful?
3. Will this abstraction be stable or change frequently?
4. Can a junior developer understand this in 5 minutes?

If any answer is No → keep it simple.

## Before Writing Code
1. Clarify requirements if ambiguous
2. Consider edge cases upfront
3. Think about failure modes
4. Plan for testing

## Code Review Checklist (Self-Apply)
- [ ] Would I understand this in 6 months?
- [ ] Are there any hidden assumptions?
- [ ] What happens when this fails?
- [ ] Is this the simplest solution that works?
- [ ] Did I handle null/undefined/empty cases?
- [ ] Am I adding complexity for hypothetical requirements?

## Anti-Patterns to Avoid
- Magic numbers/strings without constants
- Deep nesting (max 3 levels)
- God classes/functions
- Copy-paste code (DRY)
- Premature optimization
- Premature abstraction
- Wrapper classes that add no value
- Design patterns used for their own sake

## Testing
- Write tests for behavior, not implementation
- Cover edge cases and error paths
- Test names describe the scenario and expected outcome

## When Asked to Modify Existing Code
1. Understand the current behavior first
2. Preserve existing functionality unless explicitly asked to change
3. Maintain consistent style with surrounding code
4. Refactor only when necessary for the task
