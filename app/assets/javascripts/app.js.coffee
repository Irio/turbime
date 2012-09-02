App = window.App =
  Common:
    init: ->
      @flash()
    finish: ->

    flash: ->
      setTimeout (->
        $(".flash").slideDown "slow"
      ), 100
      unless $(".flash a").length
        setTimeout (->
          $(".flash").slideUp "slow"
        ), 16000
      $(window).click ->
        $(".flash").slideUp()
