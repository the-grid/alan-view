# (WIP) Alan's View

a.k.a AI's View or Terminator's View, is pure canvas library to
overlay measurement data on top of analysed images.

![Terminator's view](http://www.perivision.net/wordpress/wp-content/uploads/2011/04/bikescan.jpg)

# Using

Having some properties/features extracted from a given image:

```coffeescript
props =
  src: 'http://foo.com/bar.png'
  cover:
    colors: ...
    saliency: ...
    histogram: ...
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

It is also possible to hide layers:

```coffeescript
view = new AlanView
  canvas: document.getElementById 'some-canvas'
  maxWidth: 700
  maxHeight: 700
  noSaliency: true
  noCircle: true

view.draw props
```
