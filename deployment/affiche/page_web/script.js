/**
 * Au survol de la mascotte Zarafa, on ajoute la classe .bounce
 * qui déclenche un petit rebond !
 */
document.addEventListener('DOMContentLoaded', () => {
    const zarafaImg = document.querySelector('.zarafa');
    zarafaImg.addEventListener('mouseover', () => {
      zarafaImg.classList.add('bounce');
    });
    
    // Quand l’animation de rebond se termine, on retire la classe
    zarafaImg.addEventListener('animationend', () => {
      zarafaImg.classList.remove('bounce');
    });
  });