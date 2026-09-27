/* ecosystem/templates/admin-dashboard/assets/admin.js */

document.addEventListener('DOMContentLoaded', () => {
  const sidebar = document.getElementById('admin-sidebar');
  const toggleBtn = document.getElementById('mobile-toggle-btn');
  
  if (toggleBtn && sidebar) {
    toggleBtn.addEventListener('click', () => {
      const isExpanded = toggleBtn.getAttribute('aria-expanded') === 'true';
      toggleBtn.setAttribute('aria-expanded', !isExpanded);
      sidebar.classList.toggle('is-open');
    });
  }
});
