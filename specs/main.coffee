'use strict'

React = require 'react/addons'
TestUtils = React.addons.TestUtils

AlanView = require 'src/main'

describe 'AlanView', ->

  mountPoint = null
  emitEvent = null
  editor = null
  props =
    id: 'image-editor-item-id'
    className: 'image-editor'
    showMeta: false
    maxWidth: 700
    maxHeight: 700
    item:
      type: 'image'
      cover:
        width: 100
        height: 100
        src: "foo.jpg"

  beforeEach ->
    mountPoint = document.getElementById 'test-container'
    emitEvent = sinon.stub()
    props.emitEvent = emitEvent
    component = React.createElement AlanView, props
    editor = React.render component, mountPoint

  afterEach ->
    React.unmountComponentAtNode mountPoint

  describe 'measurements visualization', ->

    canvas = null
    context = null
    # Checks that all pixels are "close enough"
    expectPixel = (pixel, expected) ->
      # deep.equal doesn't work with image data (not normal array)
      for exp, i in expected
        pix = pixel[i]
        expect(pix).to.exist
        # PhantomJS and browser colors can be off by one :-/
        expect(pix).to.be.closeTo exp, 1

    beforeEach ->
      canvas = editor.refs.measurements.getDOMNode()
      context = canvas.getContext '2d'
      editor.setProps {showMeta: true}


    describe 'with an image with saliency polygon', ->

      item =
        type: 'image'
        cover:
          width: 150
          height: 151
          saliency:
            # Must be CCW for Phantom
            polygon: [[10,10], [10,100], [100,10]]

      beforeEach ->
        editor.setProps {item}

      it 'should set canvas size', ->
        canvas = editor.refs.measurements.getDOMNode()
        expect(canvas.width).to.equal item.cover.width
        expect(canvas.height).to.equal item.cover.height

      it 'shouldn\'t draw inside saliency polygon', ->
        pixel = context.getImageData(20, 20, 1, 1).data
        expectPixel pixel, [0, 0, 0, 0]

      it 'should fade outside saliency polygon viz', ->
        pixel = context.getImageData(100, 100, 1, 1).data
        expectPixel pixel, [255, 255, 255, 64]

    describe 'with an image with faces', ->

      item =
        type: 'image'
        cover:
          width: 150
          height: 152
          faces: [
            {x:10, y:10, width:20, height:20}
            {x:110, y:10, width:20, height:20}
          ]

      beforeEach ->
        editor.setProps {item}

      it 'should set canvas size', ->
        canvas = editor.refs.measurements.getDOMNode()
        expect(canvas.width).to.equal item.cover.width
        expect(canvas.height).to.equal item.cover.height

      it 'should draw face 0 viz', ->
        pixel = context.getImageData(20, 20, 1, 1).data
        expectPixel pixel, [0, 0, 155, 127]

      it 'should draw face 1 viz', ->
        pixel = context.getImageData(120, 20, 1, 1).data
        expectPixel pixel, [0, 0, 155, 127]

      it 'shouldn\'t draw between faces', ->
        pixel = context.getImageData(50, 30, 1, 1).data
        expectPixel pixel, [0, 0, 0, 0]

    describe 'with an image with colors', ->

      item =
        type: 'image'
        cover:
          width: 150
          height: 153
          colors: [
            [255, 0, 0]
            [0, 255, 0]
          ]

      beforeEach ->
        editor.setProps {item}

      it 'should set canvas size', ->
        canvas = editor.refs.measurements.getDOMNode()
        expect(canvas.width).to.equal item.cover.width
        expect(canvas.height).to.equal item.cover.height

      it 'should draw color 0 viz', ->
        pixel = context.getImageData(20, 20, 1, 1).data
        expectPixel pixel, [255, 0, 0, 255]

      it 'should draw color 1 viz', ->
        pixel = context.getImageData(60, 20, 1, 1).data
        expectPixel pixel, [0, 255, 0, 255]

      it 'shouldn\'t draw outside colors', ->
        pixel = context.getImageData(60, 100, 1, 1).data
        expectPixel pixel, [0, 0, 0, 0]
