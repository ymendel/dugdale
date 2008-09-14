$('ul#track_listing a[href^="/music/browse"]').livequery('click', function(event) {
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

$('ul#track_listing a[href^="/music/show"]').livequery('click', function(event) {
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

$('ul#track_listing a[href^="/playlist/enqueue"]').livequery('click', function(event) {
  event.preventDefault();
  $.get(this.href);
});

function removeOtherLists(elem) {
  var allLists  = $('ul#track_listing ul');
  var keepLists = elem.parents('ul');
  var toRemove  = allLists.not(keepLists);
  toRemove.remove();
}
