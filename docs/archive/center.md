# Center (`hb-center`)

The `hb-center` is a foundational layout primitive designed as an opinionated pattern for centering its content both horizontally and vertically using native CSS Flexbox.

---

## 1. Purpose & Layout Intent

The primary purpose of `hb-center` is to provide a reliable, single-class layout pattern for absolute centering. Instead of requiring developers to memorize or combine multiple alignment utility classes, `hb-center` encodes the specific intent: *"Whatever is inside this container must be perfectly centered."*

It is strictly a layout container and provides no visual component identity (like backgrounds or borders).

---

## 2. Basic Usage and Example

```html
<div class="hb-center">
  <p>This text is perfectly centered within the available space.</p>
</div>
```

---

## 3. CSS Behavior: What `hb-center` Does

The implementation is intentionally minimal and uses exactly three declarations:

```css
.hb-center {
  display: flex;
  align-items: center;
  justify-content: center;
}
```

It establishes a Flexbox context and explicitly aligns the content to the center of both the cross-axis (`align-items`) and the main-axis (`justify-content`).

---

## 4. What `hb-center` Intentionally Does Not Do

To maintain its purity as a layout primitive, `hb-center` explicitly **avoids** defining:
- Spacing (`gap`, `margin`, `padding`).
- Explicit dimensions (`width`, `height`, `min-height`, `max-width`, etc.).
- Flex wrapping or direction behavior (`flex-wrap`, `flex-direction`).
- Visual styling (`colors`, `borders`, `shadows`).
- Typography (`text-align`).
- Modifiers, responsive variants, or child selectors.

### Crucial Note on Vertical Centering & Height

**`hb-center` does not create a height automatically.** 

By design, it does not impose `height: 100%`, `min-height: 100vh`, or any explicit block-size. Vertical centering only becomes visually meaningful when the `.hb-center` element has available block-size inherited from its surrounding layout context, parent container, or application-specific CSS. If the container only has as much height as its content, vertical centering will appear to do nothing because there is no extra space to distribute.

---

## 5. Distinctions from Other Layout Primitives

Understanding when to use `hb-center` versus other primitives is key to HEBRING's architecture.

### Difference between `hb-center` and `hb-flex`
- **`hb-flex`**: Defines a *neutral* Flexbox context without additional layout opinions. It merely applies `display: flex;`.
- **`hb-center`**: Defines an *opinionated* centering pattern. It is intentionally a higher-level abstraction than `hb-flex`. The existence of `hb-center` prevents the need to bloat `hb-flex` with alignment APIs in this structural layer.

### Difference between `hb-center` and other primitives
- **`hb-container`**: Defines a content width boundary. It centers the *container itself* horizontally on the page via margins, but does not center its children.
- **`hb-stack`**: Defines a vertical relationship between children with a default gap.
- **`hb-cluster`**: Defines a horizontal grouping relationship with wrapping.
- **`hb-grid`**: Defines a two-dimensional CSS Grid context.
- **`hb-center`**: Strictly centers its content within its own available space.
