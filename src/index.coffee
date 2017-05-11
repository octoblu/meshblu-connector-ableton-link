{EventEmitter}  = require 'events'
debug           = require('debug')('meshblu-connector-ableton-link:index')
abletonlink     = require 'abletonlink'
_               = require 'lodash'
class Connector extends EventEmitter
  constructor: ->
    @lastUpdate = {}
    @link = new abletonlink()
    @link.startUpdate 100, @handleStartUpdate
    @link.on 'tempo', @handleTempoChange
    @link.on 'numPeers', @handlePeerChange

  handleStartUpdate: (beat, phase, bpm) =>
    data = {
      beat: beat
      phase: phase
      bpm: bpm
    }
    return if _.isEqual data, @lastUpdate
    console.log data
    @emit 'message', {
      devices: ['*']
      data: data
    }

  handleTempoChange: (tempo) =>
    console.log tempo
    @emit 'message', {
      devices: ['*']
      data:
        tempo: tempo
    }

  handlePeerChange: (numPeers) =>
    console.log numPeers
    @emit 'message', {
      devices: ['*']
      data:
        numPeers: numPeers
    }

  handleConfigChange: () =>
    return

  isOnline: (callback) =>
    callback null, running: true

  close: (callback) =>
    debug 'on close'
    callback()

  onConfig: (device={}) =>
    { @options } = device
    debug 'on config', @options
    @handleConfigChange()

  start: (device, callback) =>
    debug 'started'
    @onConfig device
    callback()

module.exports = Connector
