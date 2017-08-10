// Active highlighting
$('#Introduction').waypoint(function() {
    document.getElementById('nav-introduction').className = "active";
    document.getElementById('nav-portfolio').className    = "non-active";
    document.getElementById('nav-contact').className      = "non-active";
}, {
    offset: '50%'
});
$('#Introduction').waypoint(function() {
    document.getElementById('nav-introduction').className = "active";
    document.getElementById('nav-portfolio').className    = "non-active";
    document.getElementById('nav-contact').className      = "non-active";
}, {
    offset: '-49%'
});

$('#Portfolio').waypoint(function() {
    document.getElementById('nav-introduction').className = "non-active";
    document.getElementById('nav-portfolio').className    = "active";
    document.getElementById('nav-contact').className      = "non-active";
}, {
    offset: '50%'
});
$('#Portfolio').waypoint(function() {
    document.getElementById('nav-introduction').className = "non-active";
    document.getElementById('nav-portfolio').className    = "active";
    document.getElementById('nav-contact').className      = "non-active";
}, {
    offset: '-49%'
});

$('#Contact').waypoint(function() {
    document.getElementById('nav-introduction').className = "non-active";
    document.getElementById('nav-portfolio').className    = "non-active";
    document.getElementById('nav-contact').className      = "active";
}, {
    offset: ' 50%'
});
$('#Contact').waypoint(function() {
    document.getElementById('nav-introduction').className = "non-active";
    document.getElementById('nav-portfolio').className    = "non-active";
    document.getElementById('nav-contact').className      = "active";
}, {
    offset: '-49%'
});

// Smooth scrolling
$(function() {
  $('a[href*=#]:not([href=#myCarousel])').click(function() {
    $(document.activeElement).blur(); // removes focus from everything
    if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') && location.hostname == this.hostname) {
      var target = $(this.hash);
      target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
      if (target.length) {
        $('html,body').animate({
          scrollTop: target.offset().top
        }, 1000);
        return false;
      }
    }
  });
});
