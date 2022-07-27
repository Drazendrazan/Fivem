function SetSpeed(val){
    if (isNaN(val)) {
        $('#svg #bar').css({strokeDashoffset: (-565)});
        $('#svg #bar2').css({strokeDashoffset: (706)});
    }
    else{
        var speed = val;
        val = (val + val/2)*1.1;
        $('#svg #bar').css({strokeDashoffset: (-565 + (val))});
        $('#svg #bar2').css({strokeDashoffset: (706 + (val - val/4))});

        $("#speed").html(speed);
    }
}

var gas_level = 0;
function SetGas(val){
    if (isNaN(val)) {
     val = 100; 
    }
    else{
        gas_level = val;
        val = val*2.5;
        val= 250-val;
        $('.gas-value').css({width: (250 - val)+"px"});
        $('.gas-value2').css({width: (250 - (250 - val))+"px"});
        
    }
}

function SetOil(val){
    if (isNaN(val)) {
     val = 100; 
    }
    else{
        if(val <= 25)
            $('.oil-icon').css({color: "#ffffff"});
        val = val*2.5;
        val= 250-val;
            $('.oil-value').css({width: (250 - val)+"px"});
        $('.oil-value2').css({width: (250 - (250 - val))+"px"});

    }
}

function seatbetBlink(bool){
    if (bool == true)
        $(".seatbelt").css("animation", "blink-seatbelt 0.5s infinite ease-in backwards");
    else
        $(".seatbelt").css("animation", "none");
}

function rightBlink(bool){
    if (bool == true){
        $(".fa-angle-left").css("animation", "none");
        $(".fa-angle-right").css("animation", "blink 0.5s infinite ease-in backwards");
    }
    else{
        $(".fa-angle-right").css("animation", "none");
        $(".fa-angle-left").css("animation", "none");
    }
}

function leftBlink(bool){
    if (bool == true){
        $(".fa-angle-left").css("animation", "blink 0.5s infinite ease-in backwards");
        $(".fa-angle-right").css("animation", "none");
    }
    else{
        $(".fa-angle-right").css("animation", "none");
        $(".fa-angle-left").css("animation", "none");
    }
}

function bothBlink(bool){
    $(".fa-angle-right").css("animation", "none");
    $(".fa-angle-left").css("animation", "none");
    if (bool == true){
        $(".fa-angle-right").css("animation", "blink 0.5s infinite ease-in backwards");
        $(".fa-angle-left").css("animation", "blink 0.5s infinite ease-in backwards");
    }
    else
    {
        $(".fa-angle-right").css("animation", "none");
        $(".fa-angle-left").css("animation", "none");
    }
}

function damagedVehicle(damage){
    if (damage <= 80)
    {
        $(".fa-car").css("color", "rgb(255, 166, 0)");
    }
    if (damage <= 75)
    {
        $(".fa-car-battery").css("color", "rgb(255, 166, 0)");
        $(".fa-car").css("color", "rgb(255, 166, 0)");
    }
    if (damage <= 60)
    {
        $(".fa-car-battery").css("color", "rgb(255, 166, 0)");
        $(".fa-car").css("color", "rgb(255, 51, 51)");
    }
    if (damage <= 40)
    {
        $(".fa-car-battery").css("color", "rgb(255, 51, 51)");
        $(".fa-car").css("color", "rgb(255, 51, 51)");
    }
}

function SwitchMode(mode){
    if( mode == "eco_pro"){
        $('#svg #bar').css({stroke: "#1eb8ff"});
        $('#svg #bar2').css({stroke: "#1eb8ff"});
        $('.gas-value').css("background-color", "#1eb8ff");
        $('.gas-value2').css("background-color", "#1eb8ff34");
        $('.gas-icon').css({color: "#1eb8ff34"});
        $('.mode').css({color: "#1eb8ff"});
        $('.mode').html("ECO PRO");
        if (gas_level <= 25)
            $('.gas-icon').css({color: "#1eb8ff"});
    }else if(mode == "normal"){
        $('#svg #bar').css({stroke: "#c2702e"});
        $('#svg #bar2').css({stroke: "#c2702e"});
        $('.gas-value').css("background-color", "#c2702e");
        $('.gas-value2').css("background-color", "#c2702e34");
        $('.gas-icon').css({color: "#c2702e34"});
        $('.mode').css({color: "#c2702e"});
        $('.mode').html("NORMAL");
        if (gas_level <= 25)
            $('.gas-icon').css({color: "#c2702e"});
    }else if(mode == "sport"){
        $('#svg #bar').css({stroke: "#860000"});
        $('#svg #bar2').css({stroke: "#860000"});
        $('.gas-value').css("background-color", "#860000");
        $('.gas-value2').css("background-color", "#86000054");
        $('.gas-icon').css({color: "#86000054"});
        $('.mode').css({color: "#860000"});
        $('.mode').html("SPORT");
        if (gas_level <= 25)
            $('.gas-icon').css({color: "#860000"});
    }else if(mode == "none"){
        $('#svg #bar').css({stroke: "#ffffff34"});
        $('#svg #bar2').css({stroke: "#ffffff34"});
        $('.gas-value').css("background-color", "#ffffff34");
        $('.gas-value2').css("background-color", "#ffffff34");
        $('.gas-icon').css({color: "#ffffff34"});
        $('.fa-car').css({color: "#ffffff34"});
        $('.fa-car-battery').css({color: "#ffffff34"});
        $('.mode').css({color: "#ffffff34"});
        $('.mode').html("STOPPED");
        if (gas_level <= 25)
            $('.gas-icon').css({color: "#ffffff34"});
    }
}

$(document).ready(function(){
    $(".speedometer").hide();
    $(".board").hide();
    $(".oil").hide();
    $(".gas").hide();
    $(".mode").hide();
    window.addEventListener("message", function(event){
        if(event.data.displayhud == true){
            $(".speedometer").show();
            $(".board").show();
            $(".oil").show();
            $(".gas").show();
            $(".mode").show();
            SetSpeed(event.data.speed);
            SetGas(event.data.gas);
            damagedVehicle(event.data.health);
            SetOil(event.data.oil);
            SwitchMode(event.data.mode);
        }
        else{
            $(".speedometer").hide();
            $(".board").hide();
            $(".oil").hide();
            $(".gas").hide();
            $(".mode").hide();
        }
        
        if(event.data.left_blink == true)
        leftBlink(event.data.left_blink);

        if(event.data.right_blink == true)
        rightBlink(event.data.right_blink);

        if(event.data.both_blink == true)
        bothBlink(event.data.both_blink);
        
        if(event.data.left_blink == false)
        leftBlink(event.data.left_blink);

        if(event.data.right_blink == false)
        rightBlink(event.data.right_blink);

        if(event.data.both_blink == false)
        bothBlink(event.data.both_blink);

        if(event.data.seatbelt_blink == true)
        seatbetBlink(event.data.seatbelt_blink);

        if(event.data.seatbelt_blink == false)
        seatbetBlink(event.data.seatbelt_blink);

    });
});

