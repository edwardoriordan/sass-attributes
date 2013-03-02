jQuery(document).ready(function($) {

  _.each(sassStylesSelectors, function(value, key, list) {
    var selector = key;
    var mq = key.mq;
    _.each(value.data_attributes, function(value, key, list) {
      $(selector).attr(key, value);
    }) 
  });
  
});