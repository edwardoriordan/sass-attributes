Sass attributes v0.1
======================

Ever needed your css to talk to your javascript?

Previously to communicate between your css and your js you needed to parse your css with javascript at run time. Sass attributes does it another way. It enables you to write sass which outputs javascript files. It lets sass speak not only css but also a little bit of js (just enough to order a coffee or ask for the bill).

It is inspired by the desire
* to set basic attribute values on html in your css (like CAS - http://www.xanthir.com/blog/b4K_0)
* to be able to add basic interactive and toggle state in CSS without having to use form elements (like the checkbox hack - http://css-tricks.com/the-checkbox-hack)
* do something like https://github.com/ahume/selector-queries in a declartive way just using css

It works by creating some sass functions which output javascript objects in a **style.sass.js** file in the javascript path set in your compass config.rb file.

This is still very much a work in progress and isn't a gem yet.

### Variables

You can set variables via sass with add-variable()

```sass
@include add-variable('myCoolColor', $color);
@include add-variable('myValue', '5px');
@include add-variable('myNumber', $number);
@include add-variable('myString', $string);
```

which outputs the following in your **style.sass.js** file

```js
var sassStylesVariables = {
  "myValue": "5px",
  "myNumber": "540",
  "myCoolColor": "#f7f7f7",
  "myString": "dsfadfdsf"
};
```

### Data Attributes

Sass

```sass
@include add-selector-attributes('h1', 'data-dropdown, true');
@include add-selector-attributes('h5.class-name', 'data-link-to, #element');
```

which outputs the following in your **style.sass.js** file

```js
var sassStylesSelectors = {
  "h1": {
    "data_attributes": {
      "data-dropdown": "true"
    }
  },
  "h5.class-name": {
    "data_attributes": {
      "data-link-to": "#element"
    }
  }
};
```

Sass attributes will include a javascript plugin that is used to parse these objects and set data attributes (not exactly hard!). From there the idea is then to use javascript plugins that use data attributes as their hooks into the dom (like how bootstrap or foundation work).

Currently it is a big pain point that we have to set the selector as an arg rather then infering it from the context. In future versions of sass, however, we should be able to access the selectors that mixins are called in (https://github.com/nex3/sass/issues/286).