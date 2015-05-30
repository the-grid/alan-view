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
  maxWidth: 500
  maxHeight: 300

view.draw props
```

Should give something like:

![Result](http://i.imgur.com/dEGIYr4.png)

It is also possible to hide layers:

```coffeescript
view = new AlanView
  canvas: document.getElementById 'some-canvas'
  maxWidth: 500
  maxHeight: 300
  noCircle: true
  noSceneFading: true
  noColors: true

view.draw props
```

Those are the options available:

- `noSaliency`: hides the salient region bounding box
  - `noPolygon`: hides the polygon around the salient region
  - `noCircle`: hides the circle around the salient region
- `noFaces`: hides faces bounding boxes
- `noScene`: hides scene bounding box
  - `noSceneFading`: hides the fading bounding box around scene
- `noLines`: hides rows/columns bounding boxes
- `noColors`: hides the color palette

# Information displayed

![Carl](http://i.imgur.com/CLk0nia.png)

- Color palettes: 5 circles at top-left
- Salient region: white bounding box
- Salient polygon: white shape with no opacity
- Salient circle: white circle
- Scene region: green bounding box
- Lines (columns/rows): red bounding boxes around scene region
