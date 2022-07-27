$(document).ready(function () {
  // Listen for NUI Events
  var lastT = 0;
  var red = false;
  var yellow = false;
  var lastSpeed = null;
  var lastFuel = null;

  function throttle(callback, limit) {
    var wait = false;
    return function () {
      if (!wait) {
        callback.apply(null, arguments);
        wait = true;
        setTimeout(function () {
          wait = false;
        }, limit);
      }
    };
  }

  window.addEventListener(
    "message",
    throttle(function (event) {
      var item = event.data;
      if (item.showHud) {
        if (!$(".full-screen").is(":visible")) {
          $(".full-screen").show();
          $(".vehicle").removeClass("hide");
          $(".wrap").removeClass("lower");
          $(".outline").show();
          $(".bottom").show();
        }

        if (lastT !== item.direction) {
          $(".direction")
            .find(".image")
            .attr(
              "style",
              "transform: translate3d(" + item.direction + "px, 0px, 0px)"
            );
          lastT = item.direction;
        }
        if (lastFuel !== item.fuel) {
          $(".fuelamount").text(item.fuel);
          setProgressFuel(item.fuel, ".progress-fuel");
          lastFuel = item.fuel;
        }

        if (lastSpeed !== item.mph) {
          $(".speedamount").text(item.mph);
          if (item.mph <= 205) {
            setProgressSpeed(item.mph, ".progress-speed");
            if (red === true) {
              $(".speedamount").css("color", "white");
              red = false;
            }
          } else {
            if (red === false) {
              setProgressSpeed(205, ".progress-speed");
              $(".speedamount").css("color", "#f03c3c");
              red = true;
            }
          }
          lastSpeed = item.mph;
        }

        $(".street-main-txt").text(item.mainstreet);
        $(".street-secondary-txt").text(item.secondstreet);

        if (item.belt == true) {
          if ($("#belt_status").is(":visible")) {
            $("#belt_status").fadeOut();
          }
        } else {
          if (!$("#belt_status").is(":visible")) {
            $("#belt_status").fadeIn();
          }
        }

        if (item.engine == 3) {
          if ($("#engine_status").is(":visible")) {
            $("#engine_status").fadeOut();
          }
        } else if (item.engine == 2) {
          if (!$("#engine_status").is(":visible")) {
            $("#engine_status").attr("src", "engine1.png");
            $("#engine_status").fadeIn();
          }
        } else if (item.engine == 1) {
          if (
            !$("#engine_status").is(":visible") ||
            $("#engine_status").src == "engine1.png"
          ) {
            $("#engine_status").attr("src", "engine2.png");
            $("#engine_status").fadeIn();
          }
        }
      }

      if (!item.showHud) {
        $(".full-screen").hide(100);
        $(".outline").hide();
        $(".bottom").hide();
      }
    }, 100)
  );
});

function setProgressSpeed(value, element) {
  var circle = document.querySelector(element);
  var radius = circle.r.baseVal.value;
  var circumference = radius * 2 * Math.PI;
  var html = $(element).parent().parent().find("span");
  var percent = (value * 100) / 200;

  circle.style.strokeDasharray = `${circumference} ${circumference}`;
  circle.style.strokeDashoffset = `${circumference}`;

  const offset = circumference - ((-percent * 73) / 100 / 100) * circumference;
  circle.style.strokeDashoffset = -offset;

  var predkosc = Math.floor(value * 1.8);
  if (predkosc == 81 || predkosc == 131) {
    predkosc = predkosc - 1;
  }

  html.text(predkosc);
}

function setProgressFuel(percent, element) {
  var circle = document.querySelector(element);
  var radius = circle.r.baseVal.value;
  var circumference = radius * 2 * Math.PI;
  var html = $(element).parent().parent().find("span");

  circle.style.strokeDasharray = `${circumference} ${circumference}`;
  circle.style.strokeDashoffset = `${circumference}`;

  const offset = circumference - ((-percent * 73) / 100 / 100) * circumference;
  circle.style.strokeDashoffset = -offset;

  html.text(Math.round(percent));
}
