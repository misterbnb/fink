(function() {
  this.Fink = (function() {
    function Fink() {}

    Fink.report = function(el, kind, id) {
      var imgSrc;
      imgSrc = $(el).attr('src');
      return $.ajax({
        url: "/fink/reports",
        type: 'post',
        data: {
          url: imgSrc,
          kind: kind,
          id: id
        }
      });
    };

    return Fink;

  })();

}).call(this);
