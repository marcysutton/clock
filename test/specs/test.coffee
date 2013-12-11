# global $, describe, it
# jslint node: true

$ = require('../../bower_components/jquery/jquery')
chai_jq = require('chai-jq')

"use strict"
(->
  describe 'Initializing the clock', () ->
    describe 'element setup', () ->
      it 'should append elements for the image stacks', () ->
        expect($("<div style=\"display: none\" />")).to.be.$hidden
)()
