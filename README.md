# Alan's View

a.k.a AI's View or Terminator's View.

![Terminator's view](http://www.perivision.net/wordpress/wp-content/uploads/2011/04/bikescan.jpg)

# Using

Having some properties/features extracted from a given image (see The
Grid's [API](https://github.com/the-grd/apidocs),  [Caliper](https://github.com/the-grid/caliper) and [Data Helper](https://github.com/the-grid/data-helper)):

```coffeescript
props =
  src: 'http://foo.com/bar.png'
  cover:
    colors: ...
    saliency: ...
    histogram: ...
  metadata:
    grid: ...
```

We can setup `AlanView` to draw those features into a given canvas:

```coffeescript
view = new AlanView
  canvas: document.getElementById 'some-canvas'
  maxWidth: 700
  maxHeight: 700

view.draw props
```

Should give something like:

![Result](http://i.imgur.com/nTBkab2.png)
