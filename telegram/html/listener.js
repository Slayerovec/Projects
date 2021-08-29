window.addEventListener('message', (event) => {
	var telegram = event.data
	var minNumber = 0
    var maxNumber = 5
    var btn = document.getElementById("accBtn");
    var btn2 = document.getElementById("closeBtn");
    var span = document.getElementsByClassName("close")[0];
    var modal = document.getElementById("myModal");
    var message;
    var reciever;
    var price;

    if (telegram.action == "open") {
        $("body").show();
        menu()
    } else 	if (telegram.action == 'close') {
        $("body").hide();
        $('.telegram_content').empty();
        menu()
    } else if (telegram.action == "open_telegram") {
        $("body").show();
        open_telegram()
        menu()
    } else if (telegram.action == "new_telegram") {
        if (telegram.name != null){
            $("body").show();
            new_telegram()
            menu()
        } else {
           $.post('http://telegram/reopen', JSON.stringify({}));
        }
	} else if (telegram.action == "telegrams") {
		$("body").show();
		menu()
		if (telegram.current == 'recieved'){
            if (telegram.values != 'done'){
                $('.telegram_content').empty();
                $('.telegram_content').html('<p>No telegrams to display.</p>');
            } else {
                senders()
            }
        } else {
            if (telegram.values != 'done'){
                $('.telegram_content').empty();
                $('.telegram_content').html('<p>No telegrams to display.</p>');
            } else {
                recievers()
            }
		}
	}


    function open_telegram(){
        $('.telegram_content').empty();
        document.getElementById("telegram_container").setAttribute("style", "background-image: url(" + "img/TextRead-Empty.jpg" + ")");
       if (telegram.data.sender != null){

           $('.telegram_content').append('<span class="telegram_message">' + telegram.data.message + '</span>');
           $('.telegram_content').append('<span class="telegram_sender">' + telegram.data.sender + '<span style="font-weight: bold; padding-left:20px; padding-right:20px;"> To - > </span>' + telegram.data.reciever +'</span>');

       } else {

          $('.telegram_content').append('<p class="telegram_sender">HALABALA</p>');
          $('.telegram_content').append('<p class="telegram_message">HALABALA</p>');
       }
    }

    function new_telegram(){
        $('.telegram_content').empty();
        document.getElementById("telegram_container").setAttribute("style", "background-image: url(" + "img/TextRead-Empty.jpg" + ")");

        $('.telegram_content').append('<span class="telegram_sender_new" style="padding-top:20px">' + telegram.name + '<span style="font-weight: bold; padding-left:20px; padding-right:20px;"> To - > </span> <textarea id="reciever" class="textarea1" placeholder="Jméno příjemce." maxLength="20"></textarea></span>');
        $('.telegram_content').append('<span><textarea id="message" class="telegram_message" placeholder="Zpráva...." maxLength="500" style="width:640px;height:220px;resize:none;border: 2px solid transparent;background: inherit !important;font-family: ' + 'Go 2 Old Western' + ';text-align: left;"></textarea></span>');
    }

    function menu() {
        if (telegram.action != "open_telegram" && telegram.action != "new_telegram") {
            $('.telegram_content').empty();
            document.getElementById("telegram_container").setAttribute("style", "background-image: url(" + "img/Menu-Empty.jpg" + ")");
        }
        if (telegram.action != null) {
            if (telegram.action != 'close' && telegram.action == "open") {
                $('ul').empty();
                $('.telegrams_open_menu_button').prepend('<li ><a class="telegram_close_button" href="#">Zavřít</a></li>');
                $('.telegrams_open_menu_button').prepend('<li ><a class="telegram_new_button" href="#">Nový Telegram</a></li>');
                $('.telegrams_open_menu_button').prepend('<li ><a class="telegram_sended_button" href="#">Odeslané telegramy</a></li>');
                $('.telegrams_open_menu_button').prepend('<li ><a class="telegram_telegrams_button" href="#">Přijaté telegramy</a></li>');

                } else if (telegram.action == "telegrams") {

                $('ul').empty();
                $('.telegrams_menu_button').prepend('<li class="inline"><a class="telegram_close_button" href="#">Zavřít</a></li>');
                $('.telegrams_menu_button').prepend('<li class="inline"><a class="next_button" href="#">></a>');
                $('.telegrams_menu_button').prepend('<li class="inline"><a class="back_button" href="#"><</a>');
                $('.telegrams_menu_button').prepend('<li class="inline"><a class="reopen_button" href="#">Zpět</a></li>');

                } else if (telegram.action == "open_telegram") {

                $('ul').empty();
                $('.telegrams_menu_button').prepend('<li class="inline"><a class="reopen_button" href="#">Zpět</a></li>');
                $('.telegrams_menu_button').prepend('<li class="inline"><a class="next_button" href="#">></a>');
                $('.telegrams_menu_button').prepend('<li class="inline"><a class="back_button" href="#"><</a>');
                $('.telegrams_menu_button').prepend('<li class="inline"><a class="telegram_delete_button" href="#">Smazat</a></li>');

                } else if (telegram.action == "new_telegram") {

                $('ul').empty();
                $('.telegrams_menu_button').prepend('<li class="inline"><a class="reopen_button" href="#">Zpět</a></li>');
                $('.telegrams_menu_button').prepend('<li class="inline"><a class="next_button" href="#">></a>');
                $('.telegrams_menu_button').prepend('<li class="inline"><a class="back_button" href="#"><</a>');
                $('.telegrams_menu_button').prepend('<li class="inline"><a class="new_telegram_button" href="#">Odeslat</a></li>');
            }
        }
    }

    function senders() {
        $('.telegram_content').empty();
        for (i = minNumber; i < maxNumber; i++) {
           if (telegram.data[i] == null) {
            $('.telegram_content').append('<p >No telegrams to display.</p>');
                break;
            } else {
                info = telegram.data[i]
                if (telegram.data[i].isRead != 0) {
                    $('.telegram_content').append('<p><a id =' + i + ' data="senders" class="open_telegram" style="color:black" href="#">' + info.sender + '</a></p>');
                } else {
                    $('.telegram_content').append('<p><a id =' + i + ' data="senders" class="open_telegram" style="color:white" href="#">' + info.sender + '</a></p>');
                }
            }
        }
    }

    function recievers() {
        $('.telegram_content').empty();
        for (i = minNumber; i < maxNumber; i++) {
           if (telegram.data[i] == null) {
            $('.telegram_content').append('<p >No telegrams to display.</p>');
            break;
            } else {
                info = telegram.data[i]
                if (telegram.data[i].isRead != 0) {
                    $('.telegram_content').append('<p><a id =' + i + ' data="recievers" class="open_telegram" style="color:black" href="#">' + info.reciever + '</a></p>');
                } else {
                    $('.telegram_content').append('<p><a id =' + i + ' data="recievers" class="open_telegram" style="color:white" href="#">' + info.reciever + '</a></p>');
                }
            }
        }
    }


    $(".open_telegram").unbind().click(function(){
        id = Number(this.getAttribute('id'))
        data = this.getAttribute('data')
        telegramId = id
        isRead = true
        telegramDbId = 0
        if (telegram.data[id].isRead == 0 && data != 'recievers'){
            isRead = false
            telegramDbId = telegram.data[id].id
        }

        $.post('http://telegram/open_telegram', JSON.stringify({telegramId, isRead, telegramDbId}));
    });

    $(".telegram_telegrams_button").unbind().click(function(){
        $.post('http://telegram/telegrams', JSON.stringify({}));
    });

    $(".reopen_button").unbind().click(function(){
    document.getElementById("telegram_container").setAttribute("style", "background-image: url(" + "img/Menu-Empty.jpg" + ")");
        $.post('http://telegram/reopen', JSON.stringify({}));
    });

    $(".telegram_sended_button").unbind().click(function(){
        $.post('http://telegram/sended', JSON.stringify({}));
    });

    $(".telegram_new_button").unbind().click(function(){
        $.post('http://telegram/new', JSON.stringify({}));
    });

    $(".telegram_close_button").unbind().click(function(){
        $.post('http://telegram/close', JSON.stringify({}));
    });

    $(".telegram_new_button").unbind().click(function(){
        $.post('http://telegram/new', JSON.stringify({}));
    });

    $(".new_telegram_button").unbind().click(function(){
        reciever = document.getElementById("reciever").value;
        message = document.getElementById("message").value;
        length = message.length;
        if (reciever.length != 0 && message.length != 0){
            popUp(length)
        } else {
            popUp(0)
        }
    });

    function popUp(length){
        document.getElementById("modal-body").setAttribute("style", "left:40px");
        if (length != 0){
            price = (length * 0.01)
            $('h2').html('<span style="color:black">Znaky:</span> ' + length + ' <br> <span style="color:black">Cena:</span> ' + price + '$</span>');
            document.getElementById("accBtn").innerHTML = "Platím!";
            modal.style.display = "block";
            btn2.style.display = "inline";
        } else {
            document.getElementById("modal-body").setAttribute("style", "left:80px");
            $('h2').html('<span style="color:black">Nevyplnil si nějaké políčko!</span>');
            document.getElementById("accBtn").innerHTML = "Okáčko fixuju!";
            modal.style.display = "block";
            btn2.style.display = "none";
        }
    }

    function close(){
        modal.style.display = "none";
    }

    window.onclick = function(event) {
      if (event.target == modal) {
        close()
      }
    }

    span.onclick = function() {
      close()
    }

    btn.onclick = function() {
        data = this.getAttribute('data')
         if (data == 'accept' && reciever.length != 0 && message.length != 0){
              $.post('http://telegram/new_post', JSON.stringify({reciever, message, price}));
              document.getElementById("reciever").value = "";
              document.getElementById("message").value = "";
              close()
         } else {
              close()
         }
    }

    btn2.onclick = function() {
        data = this.getAttribute('data')
         if (data == 'accept' && reciever.length != 0 && message.length != 0){
              $.post('http://telegram/new_post', JSON.stringify({reciever, message, price}));
              document.getElementById("reciever").value = "";
              document.getElementById("message").value = "";
              close()
         } else {
              close()
         }
    }

    $(".telegram_delete_button").unbind().click(function(){
        $.post('http://telegram/delete', JSON.stringify({}));
    });

    $(".telegram_back_button").unbind().click(function(){
        $.post('http://telegram/back', JSON.stringify({}));
    });

    $(".telegram_next_button").unbind().click(function(){
        $.post('http://telegram/next', JSON.stringify({}));
    });

    $(".back_button").unbind().click(function(){
        if (telegram.action != 'open_telegram'){
            if (minNumber != 0 && maxNumber != 5){
               minNumber = minNumber - 5
               maxNumber = maxNumber - 5
               if (telegram.current == 'recieved') {
                senders()
               } else {
                recievers()
               }
            }
        } else if (telegram.action == 'open_telegram') {
            $.post('http://telegram/back', JSON.stringify({}));
        }
    });

    $(".next_button").unbind().click(function(){
        if (telegram.action != 'open_telegram'){
            minNumber = minNumber + 5
            maxNumber = maxNumber + 5
           if (telegram.current == 'recieved') {
            senders()
           } else {
            recievers()
           }
         } else if (telegram.action == 'open_telegram') {
            $.post('http://telegram/next', JSON.stringify({}));
        }
    });
});
