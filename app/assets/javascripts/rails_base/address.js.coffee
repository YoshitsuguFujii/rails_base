$ ->
  addressClassName = 'zipcode-address-link'
  $(document).on "blur", ".#{addressClassName}" , (event) ->
    zip_code = $(@).val()
    if zip_code
      dfd = Rb.commonAjaxRequest("/rails_base/address/#{zip_code}", "GET")
      dfd.done (data) =>
        $prefClass = $(".#{$(@).data("prefClass") || "zipcode-link-prefecture"}")
        $addrClass = $(".#{$(@).data("addrClass") || "zipcode-link-address"}")
        if data? && data.object?
          $prefClass.find('option').filter( ->
            $(@).text() == data.object.prefecture
          ).prop('selected', true);
          $addrClass.val(data.object.city + data.object.town)
        else
          $prefClass.val('')
          $addrClass.val("")
