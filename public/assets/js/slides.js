// Fade away Introduction
$(window).scroll(function () {
    var scrollTop = $(window).scrollTop();
    var height = $(window).height();
    height = height * 0.75; //fade from 0%=1 to 75%=0
    $('.introduction-content').css({
        'opacity': ((height - scrollTop) / height)
    });
});

// Fade away down arrow
$(window).scroll(function () {
    var scrollTop = $(window).scrollTop();
    var height = $(window).height();
    height = height * 0.25; //fade from 0%=0.7 to 25%=0
    $('.down-arrow').css({
        'opacity': (((height - scrollTop) / height) * 0.7)
    });
});
