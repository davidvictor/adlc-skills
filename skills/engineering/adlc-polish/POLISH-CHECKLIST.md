# Polish Checklist

Use this as a review surface, not a mandate to change everything.

## Typography

- headings use balanced wrapping when short
- body, captions, and UI descriptions avoid awkward orphan words
- root text smoothing is applied where appropriate
- dynamic numbers use tabular numerals
- compact surfaces use appropriately scaled type

## Surfaces

- nested radii are intentional and visually concentric
- images have subtle neutral outlines when they need separation
- cards/buttons use shadows or borders according to their job
- focus states are visible and not swallowed by shadows
- repeated cards do not sit inside decorative card shells

## Alignment And Density

- icon buttons are optically centered
- icon/text buttons balance padding
- dense tools prioritize scanning over hero-scale composition
- controls have stable dimensions and do not resize on hover/state changes

## Motion

- interactive motion uses interruptible transitions
- entrance animation is split across meaningful elements
- exits are subtler and faster than entrances
- icon swaps animate opacity, scale, and blur when helpful
- press feedback uses a subtle scale and can be disabled

## Performance

- transitions specify exact properties
- `will-change` is used only for measured transform, opacity, or filter needs
- layout-affecting properties are not animated when transforms would work

## Usability

- interactive hit areas are at least usable on touch or dense pointer contexts
- hit areas do not overlap
- text does not overflow or overlap at supported viewports
- loading, empty, error, disabled, and success states are styled intentionally
