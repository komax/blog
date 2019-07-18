---
---


class Animal
  constructor: (@name) ->

  alive: ->
    false

class Parrot extends Animal
  constructor: ->
    super("Parrot")

  dead: ->
    not @alive()

Animal::rip = true
parrot = new Parrot()
console.log("This parrot is no more") if parrot.rip

arr = [1, 2]
a = arr.splice(0, 2)

#console.log arr
#alert "hello world"
[] 

console.log "foobar"
#console.log a
[1, 2]

$(document).ready ->
    console.log("document is ready")
    $('div.jumbotron').click ->
        console.log "I am clicked"
        $(this).before '<div class="div"></div>'
        return
    return