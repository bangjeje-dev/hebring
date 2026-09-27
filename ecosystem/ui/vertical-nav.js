/**
 * Vertical Navigation Enhancement
 * 
 * Provides progressive enhancement for the HEBRING Vertical Navigation component.
 * Toggles the `hidden` attribute on nested lists based on `aria-expanded` state.
 */

document.addEventListener('DOMContentLoaded', () => {
  const triggers = document.querySelectorAll('.hb-vertical-nav__link[aria-expanded][aria-controls]');
  
  triggers.forEach(trigger => {
    trigger.addEventListener('click', (e) => {
      e.preventDefault();
      
      const targetId = trigger.getAttribute('aria-controls');
      const targetList = document.getElementById(targetId);
      
      if (!targetList) return;
      
      const isExpanded = trigger.getAttribute('aria-expanded') === 'true';
      
      if (isExpanded) {
        trigger.setAttribute('aria-expanded', 'false');
        targetList.setAttribute('hidden', '');
      } else {
        trigger.setAttribute('aria-expanded', 'true');
        targetList.removeAttribute('hidden');
      }
    });
  });
});
