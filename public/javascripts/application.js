$('ul#track_listing a[href*="browse"]').livequery('click', function(event) {
  event.preventDefault();
  var elem = $(this);
  $.get(this.href,
    function(html) {
      html = $(html);
      html.removeAttr('id');
      removeOtherLists(elem);
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

function removeOtherLists(elem) {
  var allLists = $('ul#track_listing ul');
  var keepLists = elem.parents('ul');
  var toRemove = allLists.filter(function(i) { return $.inArray(allLists[i], keepLists) == -1; });
  toRemove.remove();
}
