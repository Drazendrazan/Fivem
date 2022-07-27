var randomvar = false;
window.addEventListener("message", function (event) {
  switch (event.data.action) {
    case "updateStatusHud":
      $("body").css("display", event.data.show ? "block" : "none");
      if (event.data.isCar == true) {
        if (!randomvar) {
          $(".statusHud").addClass("statusHudCar");
          $("#varStress").css("margin-left", "130px");
          $("#varOxygen").css("margin-left", "90px");
          $("#varThirst").css("margin-left", "60px");
          $("#varHunger").css("margin-left", "55px");
          $("#varArmor").css("margin-left", "65px");
          $("#varHealth").css("margin-left", "95px");
          randomvar = true;
        }
      } else {
        if (randomvar) {
          $(".statusHud").removeClass("statusHudCar");
          $("#varHealth").css("margin-left", "0px");
          $("#varArmor").css("margin-left", "0px");
          $("#varHunger").css("margin-left", "0px");
          $("#varThirst").css("margin-left", "0px");
          $("#varOxygen").css("margin-left", "0px");
          $("#varStress").css("margin-left", "0px");
          randomvar = false;
        }
      }
      widthHeightSplit(event.data.health, $("#circleSetHealth"));
      widthHeightSplit(event.data.armour, $("#circleSetArmour"));
      widthHeightSplit(event.data.hunger, $("#circleSetHunger"));
      widthHeightSplit(event.data.thirst, $("#circleSetThirst"));
      widthHeightSplit(event.data.oxygen, $("#circleSetOxygen"));
      widthHeightSplit(event.data.stress, $("#circleSetStress"));
  }
});

function widthHeightSplit(value, ele) {
  let height = 30.0;
  let eleHeight = (value / 100) * height;
  let leftOverHeight = height - eleHeight;

  ele.css("height", eleHeight + "px");
  ele.css("top", leftOverHeight + "px");
}
