jQuery(document).ready(function($) {

  $.each(sassStylesSelectors, function(key, value) {
    var selector = key;
    var mq = key.mq;

    var $selectorElem = $(selector);
    $.each(value.data_attributes, function(key, value) {
      $selectorElem.attr(key, value);
    }) 
  });

  $.each(sassStylesVariables, function(key, value) {
    console.log('Sass: var ' + key + ' = ' + value);
  });
  
});