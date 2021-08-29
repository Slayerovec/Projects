window.addEventListener('message', (event) => {
    var data = event.data;
    var pref = 'https://menuRestaurant/';
    var closeS = document.getElementsByClassName("close")[0];
    var restaurant = data.restaurant;

    if (data.action == "open"){
        open()
    }

    if (data.action == "hide"){
        open()
    }

    if (data.action == "close"){
        close()
    }

    function open(){
        $("body").show();
        $('.img').empty();
        $('.img').prepend('<img src="' + restaurant.Img + '">');
    }

    function close(){
        console.log('1')
        $("body").hide();
        $('.img').empty();
    }

    closeS.onclick = function(){
      $.post(pref + 'close', JSON.stringify({}));
     }

});