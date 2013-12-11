# global $, describe, it, expect
# jslint node: true

$ = require('../../bower_components/jquery/jquery')
chai_jq = require('chai-jq')
chai.use(chai_jq)

"use strict"
(->
  describe 'Initializing the clock', () ->
    describe 'element setup', () ->
      it 'should append elements for the image stacks', () ->
        expect($("<div class=\"hodala\" />")).to.have.$class 'hodala'
)()
