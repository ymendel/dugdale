$('ul#track_listing a[href*="browse"]').livequery('click', function(event) {
  event.preventDefault();
  var elem = $(this);
  $.get(this.href,
    function(html) {
      html = $(html);
      html.removeAttr('id');
      elem.parent('li').after(html);
    }
  );
});

$('ul#track_listing a[href*="show"]').livequery('click', function(event) {
  event.preventDefault();
  var elem = $(this);
  $.get(this.href,
   function(html) {
     html = $(html);
     html = html.find('li').parent();
     elem.parent('li').after(html);
   }
 );
});
