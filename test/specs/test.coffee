# global describe, it
# jslint node: true

jsdom = require('jsdom').jsdom
doc = jsdom('')
window = doc.createWindow()

"use strict"
(->
  describe 'Initializing the clock', () ->
    describe 'element setup', () ->
      it 'should append elements for the image stacks', () ->
        someVar = true
        expect(someVar).to.equal true
)()
