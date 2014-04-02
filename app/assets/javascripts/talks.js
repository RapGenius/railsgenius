(function($, document, window, undefined) {
  var setup_annotation_click_handlers = function() {
    var $abstract = $('.talk-abstract')

    $abstract.on('click', 'a[data-id]', function() {
      var $annotation_referent = $(this)

      $.get(this.href, function(content) {
        $('.annotation-tooltip').remove()

        var $content = $(content)

        $content.appendTo($('body')).css({
          position: 'absolute',
          top: $annotation_referent.position().top + 'px',
          left: "-10000px"
        }).focus()

        $content.css({left: ($abstract.position().left - $content.outerWidth() - 50) + "px"})
      })

      return false
    })
  }

  $(setup_annotation_click_handlers)
  $(document).on('page:load', setup_annotation_click_handlers)
})(jQuery, document, window)