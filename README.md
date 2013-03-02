Sass attributes v0.1
======================

Ever need your css to talk to your javascript? Needed to pass breakpoint values to javascript? Wanted to add some very basic interactivity via css? Wished you could set html attributes in css? Do something like https://github.com/ahume/selector-queries without having to set something in html?

Previously you would needed to read your css at run time, parse it in someway with javascript, and do the work. But maybe there is another way - maybe you could get css (via preprocessors) to speak a little bit of javascript? What if Sass not only output css but also some simple javascipt?

Sass attributes is a proof of concept to see if this could be done and it turns out it can! Its kinda like how we can create a something like CAS (http://www.xanthir.com/blog/b4K_0) with a css preprocessor.

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

outputs

```js
var sassStylesSelectors = {
  "h1": {
    "mq": "max-width: 700px",
    "data_attributes": {
      "data-dropdown": "true"
    }
  },
  "h5.class-name": {
    "mq": "max-width: 700px",
    "data_attributes": {
      "data-link-to": "#element"
    }
  }
};
```

From there you can include the **style.sass.js** file via a script tag in html (or via script loader, etc) and process the variables as you wish. A quick (jQuery dependent) app.js file is included to show how this could work.

It is a pain that we have to set the selector again but in future versions of sass we should be able to access the selectors that mixins are called in (https://github.com/nex3/sass/issues/286). This will make add attributes to elements alot more intutive.